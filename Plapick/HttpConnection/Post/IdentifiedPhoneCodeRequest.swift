//
//  IdentifiedPhoneCodeRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/21.
//

import UIKit


protocol IdentifiedPhoneCodeRequestProtocol {
    func response(rpcId: Int?, checksum: String?, identifiedPhoneCode status: String)
}


// 휴대폰 문자 인증코드 전송 Request
// 비밀번호 찾기/변경을 위한 인증단계였다면 rpcId, checksum을 반환
// mode JOIN(회원가입 본인인증용), FIND(이메일 찾기용), RESET(비밀번호 찾기/변경)
class IdentifiedPhoneCodeRequest: HttpRequest {
    
    var delegate: IdentifiedPhoneCodeRequestProtocol?
    let apiUrl = API_URL + "/identified/phone/code"
    
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
            delegate?.response(rpcId: nil, checksum: nil, identifiedPhoneCode: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(rpcId: nil, checksum: nil, identifiedPhoneCode: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(rpcId: nil, checksum: nil, identifiedPhoneCode: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(rpcId: nil, checksum: nil, identifiedPhoneCode: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(rpcId: nil, checksum: nil, identifiedPhoneCode: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(rpcId: nil, checksum: nil, identifiedPhoneCode: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(rpcId: nil, checksum: nil, identifiedPhoneCode: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if status != "WRONG_CODE" {
                    if isShowAlert { vc.requestErrorAlert(title: status) }
                }
                self.delegate?.response(rpcId: nil, checksum: nil, identifiedPhoneCode: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(IdentifiedPhoneCodeRequestResponse.self, from: data)
                
                let rpcId = response.result.rpcId
                let checksum = response.result.checksum
                
                self.delegate?.response(rpcId: rpcId, checksum: checksum, identifiedPhoneCode: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(rpcId: nil, checksum: nil, identifiedPhoneCode: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct IdentifiedPhoneCodeRequestResponse: Codable {
    var result: IdentifiedPhoneCodeRequestResult
}
struct IdentifiedPhoneCodeRequestResult: Codable {
    var rpcId: Int?
    var checksum: String?
}
