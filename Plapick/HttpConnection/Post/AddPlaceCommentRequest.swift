//
//  AddPlaceCommentRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/23.
//

import UIKit


protocol AddPlaceCommentRequestProtocol {
    func response(placeComment: PlaceComment?, addPlaceComment status: String)
}


class AddPlaceCommentRequest: HttpRequest {
    
    var delegate: AddPlaceCommentRequestProtocol?
    let apiUrl = API_URL + "/add/place/comment"
    
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
            delegate?.response(placeComment: nil, addPlaceComment: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(placeComment: nil, addPlaceComment: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(placeComment: nil, addPlaceComment: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(placeComment: nil, addPlaceComment: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(placeComment: nil, addPlaceComment: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(placeComment: nil, addPlaceComment: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(placeComment: nil, addPlaceComment: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(placeComment: nil, addPlaceComment: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AddPlaceCommentRequestResponse.self, from: data)
                
                let placeComment = response.result
                
                self.delegate?.response(placeComment: placeComment, addPlaceComment: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(placeComment: nil, addPlaceComment: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct AddPlaceCommentRequestResponse: Codable {
    var result: PlaceComment
}
