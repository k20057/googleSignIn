
import Foundation
import UIKit
import AVKit
var access_token = ""
func showSimpleAlert(message: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "確認", style: .default)
    alertController.addAction(cancel)
    /* 呼叫present()才會跳出Alert Controller */
    viewController.present(alertController, animated: true, completion:nil)
}

func executePostTask(_ url_server: URL, _ requestParam: String,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    var request = URLRequest(url: url_server)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    // 不使用暫存數據
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = requestParam.data(using: String.Encoding.utf8)
    // 創建一個訪問的會議及單獨溝通的空間
    let sessionData = URLSession.shared
    // 建立連線資料，放入請求資訊，completionHandler代表「當請求完後要接續處理的事情」，由此func的建構式來置入
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}

func executeGetTask(_ url_server: URL,_ access_token: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    var request = URLRequest(url: url_server)
    request.setValue("Bearer "+access_token, forHTTPHeaderField: "Authorization")
    
    // 不使用暫存數據
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
//    request.httpBody = requestParam.data(using: String.Encoding.utf8)
    // 創建一個訪問的會議及單獨溝通的空間
    let sessionData = URLSession.shared
    // 建立連線資料，放入請求資訊，completionHandler代表「當請求完後要接續處理的事情」，由此func的建構式來置入
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}

func executeGetUrlTask(_ url_server: URL,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    var request = URLRequest(url: url_server)
    // 不使用暫存數據
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData

    // 創建一個訪問的會議及單獨溝通的空間
    let sessionData = URLSession.shared
    // 建立連線資料，放入請求資訊，completionHandler代表「當請求完後要接續處理的事情」，由此func的建構式來置入
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
    
}

func executePutTask(_ url_server: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    // requestParam值為Any就必須使用JSONSerialization.data()，而非JSONEncoder.encode()
    let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
    // 宣告請求，並且為其設定相關數值
    var request = URLRequest(url: url_server)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "PUT"
    // 不使用暫存數據
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    // 存入請求時須附帶的資料
    request.httpBody = jsonData
    // 創建一個訪問的會議及單獨溝通的空間
    let sessionData = URLSession.shared
    // 建立連線資料，放入請求資訊，completionHandler代表「當請求完後要接續處理的事情」，由此func的建構式來置入
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}


