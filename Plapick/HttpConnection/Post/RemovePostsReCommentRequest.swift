//
//  RemovePostsReCommentRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/31.
//

import UIKit


protocol RemovePostsReCommentRequestProtocol {
    func response(porcId: Int?, removePostsReComment status: String)
}


class RemovePostsReCommentRequest: HttpRequest {
    
    var delegate: RemovePostsReCommentRequestProtocol?
    let apiUrl = API_URL + "/remove/posts/re/comment"
    
    func fetch(vc: UIViewController, isShowAlert: Bool = true, paramDict: [String: String]) {
        print("[HTTP REQ]", apiUrl, paramDict)
        
        if !vc.isNetworkAvailable() {
            if isShowAlert { vc.showNetworkAlert() }
            return
        }
        
        let paramString = makeParamString(paramDict: paramDict)
        
        guard let paramData = paramString.data(using: .utf8) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_PARAM_DATA")}
            delegate?.response(porcId: nil, removePostsReComment: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(porcId: nil, removePostsReComment: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(porcId: nil, removePostsReComment: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(porcId: nil, removePostsReComment: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(porcId: nil, removePostsReComment: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(porcId: nil, removePostsReComment: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(porcId: nil, removePostsReComment: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(porcId: nil, removePostsReComment: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(RemovePostsReCommentRequestResponse.self, from: data)
                
                let porcId = response.result
                
                self.delegate?.response(porcId: porcId, removePostsReComment: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(porcId: nil, removePostsReComment: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct RemovePostsReCommentRequestResponse: Codable {
    var result: Int
}
