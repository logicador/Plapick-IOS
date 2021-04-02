//
//  GetKakaoPlaceCntRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/25.
//

import UIKit


protocol GetKakaoPlaceCntRequestProtocol {
    func response(kakaoPlaceCntList: [KakaoPlaceCnt]?, getKakaoPlaceCnt status: String)
}


// 카카오 플레이스를 가져온 후 카운트도 가져오는 Request
// 카카오 플레이스 id로 DB 조회후 카운트 가져옴
class GetKakaoPlaceCntRequest: HttpRequest {
    
    var delegate: GetKakaoPlaceCntRequestProtocol?
    let apiUrl = API_URL + "/get/kakao/place/cnt"
    
    func fetch(vc: UIViewController, isShowAlert: Bool = true, paramDict: [String: String]) {
        print("[HTTP REQ]", apiUrl, paramDict)
        
        if !vc.isNetworkAvailable() {
            if isShowAlert { vc.showNetworkAlert() }
            return
        }
        
        let paramString = makeParamString(paramDict: paramDict)
        
        let urlString = "\(apiUrl)?\(paramString)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL_ENCODE") }
            delegate?.response(kakaoPlaceCntList: nil, getKakaoPlaceCnt: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(kakaoPlaceCntList: nil, getKakaoPlaceCnt: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(kakaoPlaceCntList: nil, getKakaoPlaceCnt: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(kakaoPlaceCntList: nil, getKakaoPlaceCnt: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(kakaoPlaceCntList: nil, getKakaoPlaceCnt: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(kakaoPlaceCntList: nil, getKakaoPlaceCnt: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(kakaoPlaceCntList: nil, getKakaoPlaceCnt: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(kakaoPlaceCntList: nil, getKakaoPlaceCnt: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(GetKakaoPlaceCntRequestResponse.self, from: data)
                
                let kakaoPlaceCntList = response.result
                
                self.delegate?.response(kakaoPlaceCntList: kakaoPlaceCntList, getKakaoPlaceCnt: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(kakaoPlaceCntList: nil, getKakaoPlaceCnt: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct GetKakaoPlaceCntRequestResponse: Codable {
    var result: [KakaoPlaceCnt]
}
