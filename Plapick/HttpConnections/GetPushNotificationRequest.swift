//
//  GetPushNotificationRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/17.
//

import Foundation
import UIKit


// MARK: Protocol
protocol GetPushNotificationRequestProtocol {
    func response(pushNotification: PushNotification?, status: String)
}


class GetPushNotificationRequest {
    
    // MARK: Properties
    var delegate: GetPushNotificationRequestProtocol?
    let apiUrl = API_URL + "/get/push/notification"
    
    
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
    func fetch(vc: UIViewController? = nil, deviceToken: String) {
        let urlString = apiUrl + "?deviceId=" + deviceToken
        
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, resp, error) in
            DispatchQueue.main.async {
                var pushNotification: PushNotification? = nil
                
                if let _ = error {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_SERVER", message: "서버오류가 발생했습니다.") }
                    self.delegate?.response(pushNotification: pushNotification, status: "ERR_SERVER")
                    return
                }
                
                if let data = data {
                    let status = self.getStatus(data: data)
                    if status != "OK" {
                        if let vc = vc { vc.requestErrorAlert(title: status, message: "응답오류가 발생했습니다.") }
                        self.delegate?.response(pushNotification: pushNotification, status: status)
                        return
                    }
                    
                    do {
                        let response = try JSONDecoder().decode(PushNotificationResultResponse.self, from: data)
                        let resPushNotification = response.result
                        let isAllowedMyPickComment = (resPushNotification.pnd_is_allowed_my_pick_comment == "Y" ? true : false)
                        let isAllowedRecommendedPlace = (resPushNotification.pnd_is_allowed_recommended_place == "Y" ? true : false)
                        let isAllowedAd = (resPushNotification.pnd_is_allowed_ad == "Y" ? true : false)
                        let isAllowedEventNotice = (resPushNotification.pnd_is_allowed_event_notice == "Y" ? true : false)
                        
                        pushNotification = PushNotification(isAllowedMyPickComment: isAllowedMyPickComment, isAllowedRecommendedPlace: isAllowedRecommendedPlace, isAllowedAd: isAllowedAd, isAllowedEventNotice: isAllowedEventNotice)
                        self.delegate?.response(pushNotification: pushNotification, status: "OK")
                        
                    } catch {
                        if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                        self.delegate?.response(pushNotification: pushNotification, status: "ERR_DATA_DECODE")
                    }
                    
                } else {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA", message: "데이터 응답 오류가 발생했습니다.") }
                    self.delegate?.response(pushNotification: pushNotification, status: "ERR_DATA")
                }
            }
        })
        task.resume()
    }
}
