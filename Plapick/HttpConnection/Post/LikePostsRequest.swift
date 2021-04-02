//
//  LikePostsRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/26.
//

import UIKit


protocol LikePostsRequestProtocol {
    func response(poId: Int?, isLike: String?, likePosts status: String)
}


// 게시물 등록 Request
// 게시물 poId 반환
class LikePostsRequest: HttpRequest {
    
    var delegate: LikePostsRequestProtocol?
    let apiUrl = API_URL + "/like/posts"
    
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
            delegate?.response(poId: nil, isLike: nil, likePosts: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(poId: nil, isLike: nil, likePosts: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(poId: nil, isLike: nil, likePosts: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(poId: nil, isLike: nil, likePosts: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(poId: nil, isLike: nil, likePosts: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(poId: nil, isLike: nil, likePosts: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(poId: nil, isLike: nil, likePosts: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(poId: nil, isLike: nil, likePosts: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(LikePostsRequestResponse.self, from: data)
                
                let poId = response.result.poId
                let isLike = response.result.isLike
                
                self.delegate?.response(poId: poId, isLike: isLike, likePosts: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(poId: nil, isLike: nil, likePosts: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct LikePostsRequestResponse: Codable {
    var result: LikePostsRequestResult
}
struct LikePostsRequestResult: Codable {
    var poId: Int
    var isLike: String
}
