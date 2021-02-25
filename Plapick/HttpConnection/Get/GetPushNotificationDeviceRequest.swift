//
//  GetPushNotificationDeviceRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


protocol GetPushNotificationDeviceRequestProtocol {
    func response(isAllowedFollow: String?, isAllowedMyPickComment: String?, isAllowedRecommendedPlace: String?, isAllowedAd: String?, isAllowedEventNotice: String?, getPushNotificationDevice status: String)
}


// GET
// 푸시 알림 가져오기
class GetPushNotificationDeviceRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: GetPushNotificationDeviceRequestProtocol?
    let apiUrl = API_URL + "/get/push/notification/device"
    
    
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
            delegate?.response(isAllowedFollow: nil, isAllowedMyPickComment: nil, isAllowedRecommendedPlace: nil, isAllowedAd: nil, isAllowedEventNotice: nil, getPushNotificationDevice: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(isAllowedFollow: nil, isAllowedMyPickComment: nil, isAllowedRecommendedPlace: nil, isAllowedAd: nil, isAllowedEventNotice: nil, getPushNotificationDevice: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(isAllowedFollow: nil, isAllowedMyPickComment: nil, isAllowedRecommendedPlace: nil, isAllowedAd: nil, isAllowedEventNotice: nil, getPushNotificationDevice: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(isAllowedFollow: nil, isAllowedMyPickComment: nil, isAllowedRecommendedPlace: nil, isAllowedAd: nil, isAllowedEventNotice: nil, getPushNotificationDevice: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(isAllowedFollow: nil, isAllowedMyPickComment: nil, isAllowedRecommendedPlace: nil, isAllowedAd: nil, isAllowedEventNotice: nil, getPushNotificationDevice: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(isAllowedFollow: nil, isAllowedMyPickComment: nil, isAllowedRecommendedPlace: nil, isAllowedAd: nil, isAllowedEventNotice: nil, getPushNotificationDevice: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(isAllowedFollow: nil, isAllowedMyPickComment: nil, isAllowedRecommendedPlace: nil, isAllowedAd: nil, isAllowedEventNotice: nil, getPushNotificationDevice: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(isAllowedFollow: nil, isAllowedMyPickComment: nil, isAllowedRecommendedPlace: nil, isAllowedAd: nil, isAllowedEventNotice: nil, getPushNotificationDevice: status)
                return
            }
            
            // MARK: Response
            do {
                let response = try JSONDecoder().decode(PushNotificationDeviceRequestResult.self, from: data)
                let resPushNotificationDevice = response.result
                
                self.delegate?.response(isAllowedFollow: resPushNotificationDevice.pnd_is_allowed_follow, isAllowedMyPickComment: resPushNotificationDevice.pnd_is_allowed_my_pick_comment, isAllowedRecommendedPlace: resPushNotificationDevice.pnd_is_allowed_recommended_place, isAllowedAd: resPushNotificationDevice.pnd_is_allowed_ad, isAllowedEventNotice: resPushNotificationDevice.pnd_is_allowed_event_notice, getPushNotificationDevice: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(isAllowedFollow: nil, isAllowedMyPickComment: nil, isAllowedRecommendedPlace: nil, isAllowedAd: nil, isAllowedEventNotice: nil, getPushNotificationDevice: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}
