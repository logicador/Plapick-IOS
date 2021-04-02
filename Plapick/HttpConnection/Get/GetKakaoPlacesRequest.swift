//
//  LoginRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


protocol GetKakaoPlacesRequestProtocol {
    func response(kakaoPlaceList: [KakaoPlace]?, isEnd: Bool?, getKakaoPlaces status: String)
}


// 카카오 플레이스 요청 Request
// 카카오쪽 api에 직접 요청
class GetKakaoPlacesRequest: HttpRequest {
    
    var delegate: GetKakaoPlacesRequestProtocol?
    let apiUrl = "https://dapi.kakao.com/v2/local/search/keyword.json"
    
    func fetch(vc: UIViewController, isShowAlert: Bool = true, query: String, page: Int) {
        print("[HTTP REQ]", apiUrl, "query:", query, "page:", page)
        
        if !vc.isNetworkAvailable() {
            if isShowAlert { vc.showNetworkAlert() }
            return
        }
        
        // For GET method
        let urlString = "\(apiUrl)?query=\(query)&page=\(page)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL_ENCODE") }
            delegate?.response(kakaoPlaceList: nil, isEnd: nil, getKakaoPlaces: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(kakaoPlaceList: nil, isEnd: nil, getKakaoPlaces: "ERR_URL")
            return
        }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("KakaoAK \(KAKAO_PLACE_KEY)", forHTTPHeaderField: "Authorization")
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
    
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(kakaoPlaceList: nil, isEnd: nil, getKakaoPlaces: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(kakaoPlaceList: nil, isEnd: nil, getKakaoPlaces: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(kakaoPlaceList: nil, isEnd: nil, getKakaoPlaces: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(kakaoPlaceList: nil, isEnd: nil, getKakaoPlaces: "ERR_DATA")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(GetKakaoPlacesRequestResponse.self, from: data)

                let kakaoPlaceList: [KakaoPlace] = response.documents
                let isEnd = response.meta.is_end

                self.delegate?.response(kakaoPlaceList: kakaoPlaceList, isEnd: isEnd, getKakaoPlaces: "OK")

            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(kakaoPlaceList: nil, isEnd: nil, getKakaoPlaces: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct GetKakaoPlacesRequestResponse: Codable {
    var documents: [KakaoPlace]
    var meta: GetKakaoPlacesRequestMeta
}
struct GetKakaoPlacesRequestMeta: Codable {
    var is_end: Bool
}
