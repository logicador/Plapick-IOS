//
//  LoginRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


protocol AddPushNotificationDeviceRequestProtocol {
    func response(addPushNotificationDevice status: String)
}


// POST
// 푸시 알림 기기 추가
class AddPushNotificationDeviceRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: AddPushNotificationDeviceRequestProtocol?
    let apiUrl = API_URL + "/add/push/notification/device"
    
    
    // MARK: Fetch
    func fetch(vc: UIViewController? = nil, isShowAlert: Bool = true, paramDict: [String: String]) {
        print("[HTTP REQ]", apiUrl, paramDict)
        
        if let vc = vc {
            if !vc.isNetworkAvailable() {
                if isShowAlert { vc.showNetworkAlert() }
                return
            }
        }
        
        let paramString = makeParamString(paramDict: paramDict)
        
        // For POST method
        guard let paramData = paramString.data(using: .utf8) else {
            if isShowAlert { vc?.requestErrorAlert(title: "ERR_PARAM_DATA")}
            delegate?.response(addPushNotificationDevice: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc?.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(addPushNotificationDevice: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc?.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(addPushNotificationDevice: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc?.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(addPushNotificationDevice: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc?.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(addPushNotificationDevice: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc?.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(addPushNotificationDevice: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc?.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(addPushNotificationDevice: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc?.requestErrorAlert(title: status) }
                self.delegate?.response(addPushNotificationDevice: status)
                return
            }
            
            // MARK: Response
            self.delegate?.response(addPushNotificationDevice: "OK")
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}
