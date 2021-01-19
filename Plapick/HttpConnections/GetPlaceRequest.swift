//
//  GetPlaceRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/18.
//

import Foundation
import UIKit


// MARK: Protocol
protocol GetPlaceRequestProtocol {
    func response(place: Place?, status: String)
}


class GetPlaceRequest {
    
    // MARK: Properties
    var delegate: GetPlaceRequestProtocol?
    let apiUrl = API_URL + "/get/place"
    
    
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
    func fetch(vc: UIViewController? = nil, pId: Int) {
        let urlString = apiUrl + "?pId=" + String(pId)
        
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, resp, error) in
            DispatchQueue.main.async {
                var place: Place? = nil
                
                if let _ = error {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_SERVER", message: "서버오류가 발생했습니다.") }
                    self.delegate?.response(place: place, status: "ERR_SERVER")
                    return
                }
                
                if let data = data {
                    let status = self.getStatus(data: data)
                    if status != "OK" {
                        if let vc = vc { vc.requestErrorAlert(title: status, message: "응답오류가 발생했습니다.") }
                        self.delegate?.response(place: place, status: status)
                        return
                    }
                    
                    do {
                        let response = try JSONDecoder().decode(PlaceResultResponse.self, from: data)
                        let resPlace = response.result
                        
                        let id = resPlace.p_id
                        let kId = resPlace.p_k_id
                        let name = resPlace.p_name
                        let address = resPlace.p_address
                        let roadAddress = resPlace.p_road_address
                        let visibleAddress = (roadAddress == "") ? address : roadAddress
                        let categoryName = resPlace.p_category_name
                        let categoryGroupName = resPlace.p_category_group_name
                        let categoryGroupCode = resPlace.p_category_group_code
                        
                        let categorySplited = categoryName.split(separator: ">")
                        let category = String(categorySplited.last ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        let phone = resPlace.p_phone
                        let lat = Double(resPlace.p_latitude)
                        let lng = Double(resPlace.p_longitude)
                        let likeCnt = resPlace.p_like_cnt
                        let pickCnt = resPlace.p_pick_cnt
                        
                        place = Place(id: id, kId: kId, name: name, visibleAddress: visibleAddress, address: address, roadAddress: roadAddress, category: category, categoryName: categoryName, categoryGroupName: categoryGroupName, categoryGroupCode: categoryGroupCode, phone: phone, lat: lat!, lng: lng!, likeCnt: likeCnt, pickCnt: pickCnt)
                        self.delegate?.response(place: place, status: "OK")
                        
                    } catch {
                        if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                        self.delegate?.response(place: place, status: "ERR_DATA_DECODE")
                    }
                    
                } else {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA", message: "데이터 응답 오류가 발생했습니다.") }
                    self.delegate?.response(place: place, status: "ERR_DATA")
                }
            }
        })
        task.resume()
    }
}
