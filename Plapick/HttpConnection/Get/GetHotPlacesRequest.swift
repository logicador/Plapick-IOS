//
//  LoginRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


protocol GetHotPlacesRequestProtocol {
    func response(placeList: [Place]?, getHotPlaces status: String)
}


// GET
// 인기 플레이스 리스트 가져오기
class GetHotPlacesRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: GetHotPlacesRequestProtocol?
    let apiUrl = API_URL + "/get/hot/places"
    
    
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
            delegate?.response(placeList: nil, getHotPlaces: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(placeList: nil, getHotPlaces: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(placeList: nil, getHotPlaces: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(placeList: nil, getHotPlaces: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(placeList: nil, getHotPlaces: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(placeList: nil, getHotPlaces: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(placeList: nil, getHotPlaces: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(placeList: nil, getHotPlaces: status)
                return
            }
            
            // MARK: Response
            do {
                let response = try JSONDecoder().decode(PlacesRequestResult.self, from: data)
                let resPlaceList = response.result
                
                var placeList: [Place] = []
                for resPlace in resPlaceList {
                    var mostPickList: [MostPick] = []
                    if let pMostPicks = resPlace.pMostPicks {
                        let splittedPMostPickList = pMostPicks.split(separator: "|")
                        for splittedPMostPick in splittedPMostPickList {
                            let splitted = splittedPMostPick.split(separator: ":")
                            if splitted.count != 4 { continue }
                            guard let id = Int(splitted[0]) else { continue }
//                            guard let likeCnt = Int(splitted[1]) else { continue }
//                            guard let commentCnt = Int(splitted[2]) else { continue }
                            guard let uId = Int(splitted[1]) else { continue }
                            let uNickName = String(splitted[2])
                            let uProfileImage = String(splitted[3])
                            let mostPick = MostPick(id: id, uId: uId, uNickName: uNickName, uProfileImage: uProfileImage)
                            mostPickList.append(mostPick)
                        }
                    }
                    
                    let place = Place(id: resPlace.p_id, kId: resPlace.p_k_id, name: resPlace.p_name, categoryName: resPlace.p_category_name, categoryGroupName: resPlace.p_category_group_name, categoryGroupCode: resPlace.p_category_group_code, address: resPlace.p_address, roadAddress: resPlace.p_road_address, latitude: resPlace.p_latitude, longitude: resPlace.p_longitude, phone: resPlace.p_phone, plocCode: resPlace.p_ploc_code, clocCode: resPlace.p_cloc_code, mostPickList: mostPickList, likeCnt: resPlace.pLikeCnt, commentCnt: resPlace.pCommentCnt, pickCnt: resPlace.pPickCnt)
                    
                    placeList.append(place)
                }
                
                self.delegate?.response(placeList: placeList, getHotPlaces: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(placeList: nil, getHotPlaces: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}
