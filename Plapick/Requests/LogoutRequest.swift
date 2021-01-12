//
//  LogoutRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/12.
//

import Foundation
import UIKit


// MARK: Protocol
protocol LogoutRequestProtocol {
    func configureLogout()
}


// MARK: Responses
//struct LogoutRequestResponse: Codable {
//    var status: String
//}


class LogoutRequest {
    
    // MARK: Properties
    var delegate: LogoutRequestProtocol?
    var parentViewController: UIViewController?
    let apiUrl = API_URL + "/logout"
    
    
    // MARK: Init
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }
    
    
    // MARK: Fetch
    func fetch() {
        var urlRequest = URLRequest(url: URL(string: apiUrl)!)
        urlRequest.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, resp, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "ERR_DATA_TASK", message: "에러가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                    self.parentViewController!.present(alert, animated: true)
//                    (self.parentViewController as! AccountViewController).hideIndicator()
                }
                return
            }
            
            if let data = data {
//                do {
                    let dataDict: [String: Any] = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let status = dataDict["status"] as! String
                    
                    if status != "OK" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: status, message: "에러가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                            self.parentViewController!.present(alert, animated: true)
//                            (self.parentViewController as! AccountViewController).hideIndicator()
                        }
                        return
                    }
                    
//                    let response = try JSONDecoder().decode(LogoutRequestResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.configureLogout()
                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        let alert = UIAlertController(title: "ERR_DECODE", message: "에러가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
//                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
//                        self.parentViewController!.present(alert, animated: true)
//                        (self.parentViewController as! AccountViewController).hideIndicator()
//                    }
//                }
            }
        })
        task.resume()
    }
}
