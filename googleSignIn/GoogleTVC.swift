
import UIKit
import Alamofire
import AVKit

class GoogleTVC: UITableViewController {

    var googleData = GoogleData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
      
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("googleData.names.count",googleData.names.count)
        return googleData.names.count
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "googleTVCcell") as! GoogleTVCCell
        //print("googleData.names[indexPath.row]",googleData.names[indexPath.row])
        cell.googleName.text = googleData.names[indexPath.row]
        let thumbnailLink = googleData.thumbnailLinks[indexPath.row]
//        print("thumbnailLink",thumbnailLink)
        if thumbnailLink == "" {
            cell.googleImage.image = UIImage(named: "no-image")
        }else{
            let url = URL(string: thumbnailLink)
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.googleImage.image = image
                    }
                }
            }
            task.resume()
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = googleData.ids[indexPath.row]
        if let videoURL = URL(string: "https://drive.google.com/uc?export=download&id=\(id)") {
            playVideo(videoURL)
        }
    }
    
  func playVideo(_ videoURL: URL) {
         let player = AVPlayer(url: videoURL)
         let playerController = AVPlayerViewController()
         playerController.player = player
         present(playerController, animated: true, completion: nil)
         player.play()
     }

}
