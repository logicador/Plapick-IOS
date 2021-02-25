//
//  AddUserDeviceRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/26.
//

import UIKit


protocol AddUserDeviceRequestProtocol {
    func response(addUserDevice status: String)
}


// POST
// 푸시 알림 기기 추가
class AddUserDeviceRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: AddUserDeviceRequestProtocol?
    let apiUrl = API_URL + "/add/user/device"
    
    
    // MARK: Fetch
    func fetch(paramDict: [String: String]) {
        print("[HTTP REQ]", apiUrl, paramDict)
        
        let paramString = makeParamString(paramDict: paramDict)
        
        // For POST method
        guard let paramData = paramString.data(using: .utf8) else {
            delegate?.response(addUserDevice: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            delegate?.response(addUserDevice: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                self.delegate?.response(addUserDevice: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                self.delegate?.response(addUserDevice: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                self.delegate?.response(addUserDevice: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                self.delegate?.response(addUserDevice: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                self.delegate?.response(addUserDevice: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                self.delegate?.response(addUserDevice: status)
                return
            }
            
            self.delegate?.response(addUserDevice: "OK")
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}

