//
//  LoginRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import Foundation
import UIKit


// MARK: Protocol
protocol LoginRequestProtocol {
    func configureLogin(user: User)
}


// MARK: Responses
struct LoginRequestResponse: Codable {
    var status: String
    var result: LoginRequestResult
}
struct LoginRequestResult: Codable {
    var user: LoginRequestUser
}
struct LoginRequestUser: Codable {
    var u_id: Int
    var u_type: String
    var u_social_id: String
    var u_name: String
    var u_nick_name: String
    var u_email: String
    var u_profile_image: String = ""
    var u_status: String
    var u_created_date: String
    var u_updated_date: String
}


class LoginRequest {
    
    // MARK: Properties
    var delegate: LoginRequestProtocol?
    var parentViewController: UIViewController?
    let apiUrl = API_URL + "/login"
    
    
    // MARK: Init
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }
    
    
    // MARK: Fetch
    func fetch(paramList: [Param]) {
        var paramString = ""
        if paramList.count > 0 {
            for (i, param) in paramList.enumerated() {
                if param.key == "" || param.value == "" { continue }
                if i > 0 { paramString += "&" }
                paramString += param.key + "=" + param.value
            }
        }
        
        let paramData = paramString.data(using: .utf8)
        
        var urlRequest = URLRequest(url: URL(string: apiUrl)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = paramData
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, resp, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "ERR_DATA_TASK", message: "에러가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                    self.parentViewController!.present(alert, animated: true)
                    if self.parentViewController is LoginViewController {
                        (self.parentViewController as! LoginViewController).hideIndicator()
                    }
                }
                return
            }
            
            if let data = data {
                do {
                    let dataDict: [String: Any] = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let status = dataDict["status"] as! String
                    
                    if status != "OK" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: status, message: "에러가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                            self.parentViewController!.present(alert, animated: true)
                            if self.parentViewController is LoginViewController {
                                (self.parentViewController as! LoginViewController).hideIndicator()
                            }
                        }
                        return
                    }
                    
                    let response = try JSONDecoder().decode(LoginRequestResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        let user = response.result.user
                        self.delegate?.configureLogin(user: User(id: user.u_id, type: user.u_type, socialId: user.u_social_id, name: user.u_name, nickName: user.u_nick_name, email: user.u_email, profileImageUrl: user.u_profile_image, status: user.u_status, createdDate: user.u_created_date, updatedDate: user.u_updated_date))
                    }
                } catch {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "ERR_DECODE", message: "에러가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                        self.parentViewController!.present(alert, animated: true)
                        if self.parentViewController is LoginViewController {
                            (self.parentViewController as! LoginViewController).hideIndicator()
                        }
                    }
                }
            }
        })
        task.resume()
    }
}
