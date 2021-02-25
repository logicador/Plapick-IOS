//
//  AddPlaceRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


protocol AddPlaceRequestProtocol {
    func response(place: Place?, addPlace status: String)
}


// POST
// 플레이스 추가
class AddPlaceRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: AddPlaceRequestProtocol?
    let apiUrl = API_URL + "/add/place"
    
    
    // MARK: Fetch
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
            delegate?.response(place: nil, addPlace: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(place: nil, addPlace: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(place: nil, addPlace: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(place: nil, addPlace: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(place: nil, addPlace: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(place: nil, addPlace: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(place: nil, addPlace: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(place: nil, addPlace: status)
                return
            }
            
            // MARK: Response
            do {
                let response = try JSONDecoder().decode(PlaceRequestResult.self, from: data)
                
                let resPlace = response.result
                
                var pickImageList: [String] = []
                
                let picks = resPlace.picks
                
                if !picks.isEmpty {
                    let splittedPicks = picks.split(separator: "|")
                    for splittedPick in splittedPicks {
                        let splitted = splittedPick.split(separator: ":")
                        let piId = splitted[0]
                        let uId = splitted[1]
                        let image = "\(IMAGE_URL)/users/\(uId)/\(piId).jpg"
                        pickImageList.append(image)
                        
                        if pickImageList.count == 10 { break } // 10개까지
                    }
                }
                
                let place = Place(id: resPlace.p_id, kId: resPlace.p_k_id, name: resPlace.p_name, categoryName: resPlace.p_category_name, categoryGroupName: resPlace.p_category_group_name, categoryGroupCode: resPlace.p_category_group_code, address: resPlace.p_address, roadAddress: resPlace.p_road_address, latitude: resPlace.p_latitude, longitude: resPlace.p_longitude, phone: resPlace.p_phone, plocCode: resPlace.p_ploc_code, clocCode: resPlace.p_cloc_code, pickImageList: pickImageList, isLike: resPlace.isLike, likeCnt: resPlace.likeCnt, commentCnt: resPlace.commentCnt, pickCnt: resPlace.pickCnt)
                
                self.delegate?.response(place: place, addPlace: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
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
