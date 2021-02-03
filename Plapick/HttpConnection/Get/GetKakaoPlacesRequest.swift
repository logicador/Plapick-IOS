//
//  LoginRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


protocol GetKakaoPlacesRequestProtocol {
    func response(kakaoPlaceList: [KakaoPlace]?, getKakaoPlaces status: String)
}


// GET
// 카카오 플레이스 가져오기
class GetKakaoPlacesRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: GetKakaoPlacesRequestProtocol?
    let apiUrl = API_URL + "/get/kakao/places"
    
    
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
            delegate?.response(kakaoPlaceList: nil, getKakaoPlaces: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(kakaoPlaceList: nil, getKakaoPlaces: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(kakaoPlaceList: nil, getKakaoPlaces: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(kakaoPlaceList: nil, getKakaoPlaces: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(kakaoPlaceList: nil, getKakaoPlaces: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(kakaoPlaceList: nil, getKakaoPlaces: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(kakaoPlaceList: nil, getKakaoPlaces: "ERR_STATUS_DECODE")
                return
            }
            print("[HTTP RES]", self.apiUrl, status)
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(kakaoPlaceList: nil, getKakaoPlaces: status)
                return
            }
            
            // MARK: Response
            do {
                let response = try JSONDecoder().decode(KakaoPlacesRequestResult.self, from: data)
                let resKakaoPlaceList = response.result
                
                var kakaoPlaceList: [KakaoPlace] = []
                for resKakaoPlace in resKakaoPlaceList {
                    let kakaoPlace = KakaoPlace(id: resKakaoPlace.id, placeName: resKakaoPlace.place_name, categoryName: resKakaoPlace.category_name, categoryGroupCode: resKakaoPlace.category_group_code, categoryGroupName: resKakaoPlace.category_group_name, addressName: resKakaoPlace.address_name, roadAddressName: resKakaoPlace.road_address_name, phone: resKakaoPlace.phone, latitude: resKakaoPlace.y, longitude: resKakaoPlace.x)
                    kakaoPlaceList.append(kakaoPlace)
                }
                self.delegate?.response(kakaoPlaceList: kakaoPlaceList, getKakaoPlaces: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(kakaoPlaceList: nil, getKakaoPlaces: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}
