//
//  AddPushNotificationDeviceRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/17.
//

import Foundation


// MARK: Protocol
protocol AddPushNotificationDeviceRequestProtocol {
    func response(status: String)
}


class AddPushNotificationDeviceRequest {
    
    // MARK: Properties
    var delegate: AddPushNotificationDeviceRequestProtocol?
    let apiUrl = API_URL + "/add/push/notification/device"
    
    
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
    func fetch(deviceToken: String) {
        let paramString = "deviceId=" + deviceToken + "&device=IOS"
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
                    self.delegate?.response(status: "ERR_SERVER")
                    return
                }
                
                if let data = data {
                    let status = self.getStatus(data: data)
                    if status != "OK" {
                        self.delegate?.response(status: status)
                        return
                    }
                    
                    self.delegate?.response(status: "OK")
                    
                } else {
                    self.delegate?.response(status: "ERR_DATA")
                }
            }
        })
        task.resume()
    }
}
