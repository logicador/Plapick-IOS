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
    func searchPlaces(placeList: [Place])
}


// MARK: Responses
struct SearchPlacesRequestResponse: Codable {
    var status: String
    var result: SearchPlacesRequestResult
}
struct SearchPlacesRequestResult: Codable {
    var placeList: [SearchPlacesRequestPlace]
}
struct SearchPlacesRequestPlace: Codable {
//    var p_id: Int? = 0
    var address_name: String
    var category_group_code: String
    var category_group_name: String
    var category_name: String
    var distance: String
    var id: String
    var phone: String
    var place_name: String
    var place_url: String
    var road_address_name: String
    var x: String
    var y: String
    var p_id: Int
    var p_like_cnt: Int
    var p_pick_cnt: Int
}


class SearchPlacesRequest {
    
    // MARK: Properties
    var parentViewController: UIViewController?
    var delegate: SearchPlacesRequestProtocol?
    let apiUrl = API_URL + "/get/places"
    
    
    // MARK: Init
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }
    
    
    // MARK: Fetch
    func fetch(paramList: [Param]) {
        var urlString = apiUrl
        
        if paramList.count > 0 {
            for (i, param) in paramList.enumerated() {
                if i == 0 {
                    urlString += "?" + param.key + "=" + param.value
                } else {
                    urlString += "&" + param.key + "=" + param.value
                }
            }
        }
        
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedUrlString)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, resp, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "ERR_DATA_TASK", message: "에러가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                    self.parentViewController!.present(alert, animated: true)
                }
                return
            }
            
            if let data = data {
                do {
                    let dataDict: [String: Any] = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let status = dataDict["status"] as! String
                    
                    if status != "OK" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: status, message: "에러가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                            self.parentViewController!.present(alert, animated: true)
                        }
                        return
                    }
                    
                    let response = try JSONDecoder().decode(SearchPlacesRequestResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        let searchRequestPlaceList = response.result.placeList
                        
                        var placeList: [Place] = []
                        for searchRequestPlace in searchRequestPlaceList {
                            // id가 0이라면 등록되지 않은 place임
                            let id = searchRequestPlace.p_id
                            let kId = searchRequestPlace.id
                            let name = searchRequestPlace.place_name
                            let address = searchRequestPlace.address_name
                            let roadAddress = searchRequestPlace.road_address_name
                            let visibleAddress = (roadAddress == "") ? address : roadAddress
                            let categoryName = searchRequestPlace.category_name
                            let categoryGroupName = searchRequestPlace.category_group_name
                            let categoryGroupCode = searchRequestPlace.category_group_code
                            
                            let categorySplited = categoryName.split(separator: ">")
                            let category = String(categorySplited.last ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            let phone = searchRequestPlace.phone
                            let lat = round(Double(searchRequestPlace.y)! * 1000000) / 1000000
                            let lng = round(Double(searchRequestPlace.x)! * 1000000) / 1000000
                            let likeCnt = searchRequestPlace.p_like_cnt
                            let pickCnt = searchRequestPlace.p_pick_cnt
                            
                            let place = Place(id: id, kId: kId, name: name, visibleAddress: visibleAddress, address: address, roadAddress: roadAddress, category: category, categoryName: categoryName, categoryGroupName: categoryGroupName, categoryGroupCode: categoryGroupCode, phone: phone, lat: lat, lng: lng, likeCnt: likeCnt, pickCnt: pickCnt)
                            placeList.append(place)
                        }
                        
                        self.delegate?.searchPlaces(placeList: placeList)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "ERR_DECODE", message: "에러가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                        self.parentViewController!.present(alert, animated: true)
                    }
                }
            }
        })
        task.resume()
    }
}
