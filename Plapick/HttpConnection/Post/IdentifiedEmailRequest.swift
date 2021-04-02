//
//  IdentifiedEmailRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/18.
//

import UIKit


protocol IdentifiedEmailRequestProtocol {
    func response(ieId: Int?, identifiedEmail status: String)
}


// 이메일 인증코드 전송 요청 Request
// 인증 테이블의 ieId 반환
// mode JOIN(회원가입 이메일 확인용), FIND(비밀번호 찾기용)
class IdentifiedEmailRequest: HttpRequest {
    
    var delegate: IdentifiedEmailRequestProtocol?
    let apiUrl = API_URL + "/identified/email"
    
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
            delegate?.response(ieId: nil, identifiedEmail: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(ieId: nil, identifiedEmail: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(ieId: nil, identifiedEmail: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(ieId: nil, identifiedEmail: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(ieId: nil, identifiedEmail: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(ieId: nil, identifiedEmail: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(ieId: nil, identifiedEmail: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if status != "EXISTS_EMAIL" && status != "NO_EXISTS_USER" {
                    if isShowAlert { vc.requestErrorAlert(title: status) }
                }
                self.delegate?.response(ieId: nil, identifiedEmail: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(IdentifiedEmailRequestResponse.self, from: data)
                
                let ieId = response.result
                
                self.delegate?.response(ieId: ieId, identifiedEmail: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(ieId: nil, identifiedEmail: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct IdentifiedEmailRequestResponse: Codable {
    var result: Int
}

