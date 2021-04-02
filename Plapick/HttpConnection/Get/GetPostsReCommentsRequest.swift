//
//  GetPostsReCommentsRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/31.
//

import UIKit


protocol GetPostsReCommentsRequestProtocol {
    func response(postsReCommentList: [PostsReComment]?, getPostsReComments status: String)
}


class GetPostsReCommentsRequest: HttpRequest {
    
    var delegate: GetPostsReCommentsRequestProtocol?
    let apiUrl = API_URL + "/get/posts/re/comments"
    
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
            delegate?.response(postsReCommentList: nil, getPostsReComments: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(postsReCommentList: nil, getPostsReComments: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(postsReCommentList: nil, getPostsReComments: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(postsReCommentList: nil, getPostsReComments: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(postsReCommentList: nil, getPostsReComments: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(postsReCommentList: nil, getPostsReComments: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(postsReCommentList: nil, getPostsReComments: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(postsReCommentList: nil, getPostsReComments: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(GetPostsReCommentsRequestResponse.self, from: data)
                
                let postsReCommentList = response.result
                
                self.delegate?.response(postsReCommentList: postsReCommentList, getPostsReComments: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(postsReCommentList: nil, getPostsReComments: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct GetPostsReCommentsRequestResponse: Codable {
    var result: [PostsReComment]
}
