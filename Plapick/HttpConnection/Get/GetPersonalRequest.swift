//
//  GetPushNotificationDeviceRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


protocol GetPersonalRequestProtocol {
    func response(type: String?, email: String?, name: String?, getPersonal status: String)
}


// GET
// 개인정보 가져오기
class GetPersonalRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: GetPersonalRequestProtocol?
    let apiUrl = API_URL + "/get/personal"
    
    
    // MARK: Fetch
    func fetch(vc: UIViewController, isShowAlert: Bool = true, paramDict: [String: String]) {
        print("[HTTP REQ]", apiUrl, paramDict)
        
        if !vc.isNetworkAvailable() {
            if isShowAlert { vc.showNetworkAlert() }
            return
        }
        
        let paramString = makeParamString(paramDict: paramDict)
        
        // For GET method
        let urlString = "\(apiUrl)?\(paramString)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL_ENCODE") }
            delegate?.response(type: nil, email: nil, name: nil, getPersonal: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(type: nil, email: nil, name: nil, getPersonal: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(type: nil, email: nil, name: nil, getPersonal: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(type: nil, email: nil, name: nil, getPersonal: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(type: nil, email: nil, name: nil, getPersonal: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(type: nil, email: nil, name: nil, getPersonal: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(type: nil, email: nil, name: nil, getPersonal: "ERR_STATUS_DECODE")
                return
            }
            print("[HTTP RES]", self.apiUrl, status)
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(type: nil, email: nil, name: nil, getPersonal: status)
                return
            }
            
            // MARK: Response
            do {
                let response = try JSONDecoder().decode(GetPersonalRequestResult.self, from: data)
                let resPersonal = response.result
                
                self.delegate?.response(type: resPersonal.type, email: resPersonal.email, name: resPersonal.name, getPersonal: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(type: nil, email: nil, name: nil, getPersonal: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}
