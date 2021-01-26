//
//  LoginRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


// MARK: Protocol
protocol GetKakaoPlacesRequestProtocol {
    func response(placeList: [Place]?, getKakaoPlaces status: String)
}


// GET
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
            self.delegate?.response(placeList: nil, getKakaoPlaces: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            self.delegate?.response(placeList: nil, getKakaoPlaces: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(placeList: nil, getKakaoPlaces: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(placeList: nil, getKakaoPlaces: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(placeList: nil, getKakaoPlaces: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(placeList: nil, getKakaoPlaces: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(placeList: nil, getKakaoPlaces: "ERR_STATUS_DECODE")
                return
            }
            print("[HTTP RES]", self.apiUrl, status)
            
            if status != "OK" {
                if status == "LOGIN_FAILED" {
                    if isShowAlert { vc.requestErrorAlert(title: "로그인 실패", message: "사용자를 찾을 수 없습니다. 로그인 정보를 다시 확인해주세요.") }
                } else {
                    if isShowAlert { vc.requestErrorAlert(title: status) }
                }
                self.delegate?.response(placeList: nil, getKakaoPlaces: status)
                return
            }
            
            // MARK: Response
            do {
                let response = try JSONDecoder().decode(PlacesRequestResult.self, from: data)
                let resPlaceList = response.result
                
                var placeList: [Place] = []
                for resPlace in resPlaceList {
                    var mostPickList: [MostPick] = []
                    if let mostPicks = resPlace.mostPicks {
                        let splittedMostPickList = mostPicks.split(separator: "|")
                        for splittedMostPick in splittedMostPickList {
                            let splitted = splittedMostPick.split(separator: ":")
                            if splitted.count != 6 { continue }
                            guard let id = Int(splitted[0]) else { continue }
                            guard let likeCnt = Int(splitted[1]) else { continue }
                            guard let commentCnt = Int(splitted[2]) else { continue }
                            guard let uId = Int(splitted[3]) else { continue }
                            let uNickName = String(splitted[4])
                            let uProfileImage = String(splitted[5])
                            let mostPick = MostPick(id: id, likeCnt: likeCnt, commentCnt: commentCnt, uId: uId, uNickName: uNickName, uProfileImage: uProfileImage)
                            mostPickList.append(mostPick)
                        }
                    }
                    
                    let place = Place(id: resPlace.p_id, kId: resPlace.p_k_id, name: resPlace.place_name, categoryName: resPlace.category_name, categoryGroupName: resPlace.category_group_name, categoryGroupCode: resPlace.category_group_code, address: resPlace.address_name, roadAddress: resPlace.road_address_name, latitude: resPlace.y, longitude: resPlace.x, phone: resPlace.phone, likeCnt: resPlace.p_like_cnt, pickCnt: resPlace.p_pick_cnt, commentCnt: resPlace.p_comment_cnt, mostPickList: mostPickList, isLike: resPlace.isLike, isComment: resPlace.isComment)
                    
                    placeList.append(place)
                }
                
                self.delegate?.response(placeList: placeList, getKakaoPlaces: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(placeList: nil, getKakaoPlaces: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}
