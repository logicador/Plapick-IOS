//
//  IdentifiedPhoneNumberRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/21.
//

import UIKit


protocol IdentifiedPhoneRequestProtocol {
    func response(ipId: Int?, identifiedPhone status: String)
}


// 휴대폰 문자 인증코드 전송 요청 Request
// 인증 테이블의 ipId 반환
class IdentifiedPhoneRequest: HttpRequest {
    
    var delegate: IdentifiedPhoneRequestProtocol?
    let apiUrl = API_URL + "/identified/phone"
    
    func fetch(vc: UIViewController, isShowAlert: Bool = true, paramDict: [String: String]) {
        print("[HTTP REQ]", apiUrl, paramDict)
        
        if !vc.isNetworkAvailable() {
            if isShowAlert { vc.showNetworkAlert() }
            return
        }
        
        let paramString = makeParamString(paramDict: paramDict)
        
        // For POST method
        guard let paramData = paramString.data(using: .utf8) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_PARAM_DATA")}
            delegate?.response(ipId: nil, identifiedPhone: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(ipId: nil, identifiedPhone: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(ipId: nil, identifiedPhone: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(ipId: nil, identifiedPhone: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(ipId: nil, identifiedPhone: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(ipId: nil, identifiedPhone: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(ipId: nil, identifiedPhone: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if status != "NO_EXISTS_USER" && status != "SEND_FAILED" {
                    if isShowAlert { vc.requestErrorAlert(title: status) }
                }
                self.delegate?.response(ipId: nil, identifiedPhone: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(IdentifiedPhoneRequestResponse.self, from: data)
                
                let ipId = response.result
                
                self.delegate?.response(ipId: ipId, identifiedPhone: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(ipId: nil, identifiedPhone: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct IdentifiedPhoneRequestResponse: Codable {
    var result: Int
}
