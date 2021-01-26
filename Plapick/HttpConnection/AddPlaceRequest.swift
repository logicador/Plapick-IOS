//
//  AddPlaceRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


// MARK: Protocol
protocol AddPlaceRequestProtocol {
    func response(place: Place?, addPlace status: String)
}


// POST
class AddPlaceRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: AddPlaceRequestProtocol?
    let apiUrl = API_URL + "/add/place"
    
    
    // MARK: Fetch
    func fetch(vc: UIViewController? = nil, isShowAlert: Bool = true, paramDict: [String: String]) {
        print("[HTTP REQ]", apiUrl, paramDict)
        
        let paramString = makeParamString(paramDict: paramDict)
        
        // For POST method
        guard let paramData = paramString.data(using: .utf8) else {
            if isShowAlert { vc?.requestErrorAlert(title: "ERR_PARAM_DATA")}
            self.delegate?.response(place: nil, addPlace: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc?.requestErrorAlert(title: "ERR_URL") }
            self.delegate?.response(place: nil, addPlace: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc?.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(place: nil, addPlace: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc?.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(place: nil, addPlace: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc?.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(place: nil, addPlace: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc?.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(place: nil, addPlace: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc?.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(place: nil, addPlace: "ERR_STATUS_DECODE")
                return
            }
            print("[HTTP RES]", self.apiUrl, status)
            
            if status != "OK" {
                if isShowAlert { vc?.requestErrorAlert(title: status) }
                self.delegate?.response(place: nil, addPlace: status)
                return
            }
            
            // MARK: Response
            do {
                let response = try JSONDecoder().decode(PlaceRequestResult.self, from: data)
                let resPlace = response.result
                
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
                
                let place = Place(id: resPlace.p_id, kId: resPlace.p_k_id, name: resPlace.p_name, categoryName: resPlace.p_category_name, categoryGroupName: resPlace.p_category_group_name, categoryGroupCode: resPlace.p_category_group_code, address: resPlace.p_address, roadAddress: resPlace.p_road_address, latitude: resPlace.p_latitude, longitude: resPlace.p_longitude, phone: resPlace.p_phone, likeCnt: resPlace.p_like_cnt, pickCnt: resPlace.p_pick_cnt, commentCnt: resPlace.p_comment_cnt, plocCode: resPlace.p_ploc_code, clocCode: resPlace.p_cloc_code, mostPickList: mostPickList, isLike: resPlace.isLike, isComment: resPlace.isComment)
                
                self.delegate?.response(place: place, addPlace: "OK")
                
            } catch {
                if isShowAlert { vc?.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(place: nil, addPlace: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}
