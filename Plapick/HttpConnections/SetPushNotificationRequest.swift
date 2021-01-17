//
//  SetPushNotificationRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/17.
//

import Foundation
import UIKit


// MARK: Protocol
protocol SetPushNotificationRequestProtocol {
    func response(action: String, status: String)
}


class SetPushNotificationRequest {
    
    // MARK: Properties
    var delegate: SetPushNotificationRequestProtocol?
    let apiUrl = API_URL + "/set/push/notification"
    
    
    // MARK: GetStatus
    func getStatus(data: Data) -> String {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let dict = jsonObject as? [String: Any]
            if let dict = dict {
                let status = dict["status"] as? String
                if let status = status { return status }
            }
            return "ERR_STATUS_DECODE"
        } catch { return "ERR_STATUS_DECODE" }
    }
    
    
    // MARK: Fetch
    func fetch(action: String, isAllowed: String, deviceToken: String) {
        let paramString = "action=" + action + "&isAllowed=" + isAllowed + "&deviceId=" + deviceToken
        let paramData = paramString.data(using: String.Encoding.utf8)
        
        let url = URL(string: apiUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = paramData
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, resp, error) in
            DispatchQueue.main.async {
                if let _ = error {
//                    if let vc = vc { vc.requestErrorAlert(title: "ERR_SERVER", message: "서버오류가 발생했습니다.") }
                    self.delegate?.response(action: action, status: "ERR_SERVER")
                    return
                }
                
                if let data = data {
                    let status = self.getStatus(data: data)
                    if status != "OK" {
//                        if let vc = vc { vc.requestErrorAlert(title: status, message: "응답오류가 발생했습니다.") }
                        self.delegate?.response(action: action, status: status)
                        return
                    }
                    
                    self.delegate?.response(action: action, status: "OK")
                    
                } else {
//                    if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA", message: "데이터 응답 오류가 발생했습니다.") }
                    self.delegate?.response(action: action, status: "ERR_DATA")
                }
            }
        })
        task.resume()
    }
}
