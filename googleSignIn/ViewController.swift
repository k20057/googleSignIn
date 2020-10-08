import UIKit
import AVKit
import Alamofire
import PromiseKit
import GCDWebServer
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate{
    
    var code = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        let loginurl = "https://accounts.google.com/o/oauth2/auth?response_type=code&scope=https://www.googleapis.com/auth/drive&client_id=559343420733-4su2m8cc9hm18glcoghtdmgqu9e8c3dq.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A8080"
        if let url = URL(string: loginurl){
            let web = SFSafariViewController(url: url)
            web.delegate = self
            present(web, animated: true, completion: nil)
        }
        
        let server = GCDWebServer()
        
        server.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self) { (request) in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                self.dismiss(animated: true, completion: nil)
                
            })
            self.code = request.query?["code"] ?? ""
            return nil
        }
        server.start(withPort: 8080, bonjourName: nil)
    }
    
    @IBAction func cloud(_ sender: Any) {
        firstly {
            get_access_token()
        }.then{ access_token in
            self.get_file(access_token)
        }.done{ googleData in
            let data = self.storyboard?.instantiateViewController(identifier: "googleTVC") as! GoogleTVC
            data.googleData = googleData
            self.navigationController?.pushViewController(data, animated: true)
        }.catch{ error in
            print(error.localizedDescription)
        }
    }
    
    func get_access_token() -> Promise<String>{
        return Promise { seal in
            var access_token = ""
            let parameters = ["code":"\(code)",
                "client_id":"559343420733-4su2m8cc9hm18glcoghtdmgqu9e8c3dq.apps.googleusercontent.com",
                "redirect_uri":"http://localhost:8080",
                "grant_type":"authorization_code"]
            
            AF.request("https://www.googleapis.com/oauth2/v3/token",
                       method: .post,
                       parameters: parameters).validate().responseJSON{
                        (response) in
                        switch response.result {
                        case .success(let value):
                            if let JSON = value as? [String: Any] {
                                access_token = JSON["access_token"] as! String
                                print("access_token",access_token)
                                seal.resolve(.fulfilled(access_token))
                            }
                        case .failure(let error):
                            print("error is ",error)
                            seal.reject(error)
                            break
                            // error handling
                        }
            }
            
        }
    }

    func get_file(_ access_token: String) -> Promise<GoogleData>{
         return Promise { seal in
            let parameters = [
                "access_token":"\(access_token)",
                "q":"trashed = false and mimeType = 'video/quicktime' or mimeType = 'video/mp4' and 'ming710125@gmail.com' in owners",
                "fields":"files(id, name, thumbnailLink)"]

            AF.request("https://www.googleapis.com/drive/v3/files", parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        let files = JSON["files"] as! [[String: Any]]
                        var googleData = GoogleData()
                        for values in files{
                            googleData.names.append(values["name"] as? String ?? "")
                            googleData.ids.append(values["id"] as? String ?? "")
                            googleData.thumbnailLinks.append(values["thumbnailLink"] as? String ?? "")
                        }
                        seal.resolve(.fulfilled(googleData))
                    }
                case .failure(let error):
                    print("error is ",error)
                    seal.reject(error)
                    // error handling
                }
            }
        }

    }
    
}

//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if error != nil{
//            print(error!)
//            return
//        }else{
//            print(user.userID!)
//            print(user.profile.email!)
//            print(user.profile.imageURL(withDimension: 400)!)
//        }
//    }

//    func toggleAuthUI() {
//        if let _ = GIDSignIn.sharedInstance()?.currentUser?.authentication {
//            // Signed in
//            signInButton.isHidden = true
//            signOutButton.isHidden = false
//            btListFile.isHidden = false
//        } else {
//            //not Signed in
//            signInButton.isHidden = false
//            signOutButton.isHidden = true
//            btListFile.isHidden = true
//            statusText.text = "Google Sign in\niOS Demo"
//        }
//    }
