//
//  SearchPlacesRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/06.
//

import Foundation
import UIKit


// MARK: Protocol
protocol SearchPlacesRequestProtocol {
    func response(placeList: [Place]?, status: String)
}


class SearchPlacesRequest {
    
    // MARK: Properties
    var delegate: SearchPlacesRequestProtocol?
    let apiUrl = API_URL + "/get/places"
    
    
    // MARK: GetStatus
    func getStatus(data: Data) -> String {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let dict = jsonObject as? [String: Any]
            if let dict = dict {
                let status = dict["status"] as? String
                if let status = status { return status }
            }
            return "ERR_STATUS_DECODE"
        } catch { return "ERR_STATUS_DECODE" }
    }
    
    
    // MARK: Fetch
    func fetch(vc: UIViewController? = nil, keyword: String) {
        let urlString = apiUrl + "?keyword=" + keyword
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: encodedUrlString)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, resp, error) in
            DispatchQueue.main.async {
                var placeList: [Place]? = nil
                
                if let _ = error {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_SERVER", message: "서버오류가 발생했습니다.") }
                    self.delegate?.response(placeList: placeList, status: "ERR_SERVER")
                    return
                }
                
                if let data = data {
                    let status = self.getStatus(data: data)
                    if status != "OK" {
                        if let vc = vc { vc.requestErrorAlert(title: status, message: "응답오류가 발생했습니다.") }
                        self.delegate?.response(placeList: placeList, status: status)
                        return
                    }
                        
                    do {
                        let response = try JSONDecoder().decode(PlaceListResultResponse.self, from: data)
                        
                        let resPlaceList = response.result
                        placeList = []
                        for resPlace in resPlaceList {
                            // id가 0이라면 등록되지 않은 place임
                            let id = resPlace.p_id
                            let kId = Int(resPlace.id)
                            let name = resPlace.place_name
                            let address = resPlace.address_name
                            let roadAddress = resPlace.road_address_name
                            let visibleAddress = (roadAddress == "") ? address : roadAddress
                            let categoryName = resPlace.category_name
                            let categoryGroupName = resPlace.category_group_name
                            let categoryGroupCode = resPlace.category_group_code
                            
                            let categorySplited = categoryName.split(separator: ">")
                            let category = String(categorySplited.last ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            let phone = resPlace.phone
                            let lat = round(Double(resPlace.y)! * 1000000) / 1000000
                            let lng = round(Double(resPlace.x)! * 1000000) / 1000000
                            let likeCnt = resPlace.p_like_cnt
                            let pickCnt = resPlace.p_pick_cnt
                            
//                            let place = Place(id: id, kId: kId!, name: name, visibleAddress: visibleAddress, address: address, roadAddress: roadAddress, category: category, categoryName: categoryName, categoryGroupName: categoryGroupName, categoryGroupCode: categoryGroupCode, phone: phone, lat: lat, lng: lng, likeCnt: likeCnt, pickCnt: pickCnt)
//                            placeList?.append(place)
                        }
                        
                        self.delegate?.response(placeList: placeList, status: "OK")
                        
                    } catch {
                        if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                        self.delegate?.response(placeList: placeList, status: "ERR_DATA_DECODE")
                    }
                    
                } else {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA", message: "데이터 응답 오류가 발생했습니다.") }
                    self.delegate?.response(placeList: placeList, status: "ERR_DATA")
                }
            }
        })
        task.resume()
    }
}
