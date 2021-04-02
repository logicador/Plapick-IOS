//
//  AddPostsCommentRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/31.
//

import UIKit


protocol AddPostsCommentRequestProtocol {
    func response(postsComment: PostsComment?, addPostsComment status: String)
}

class AddPostsCommentRequest: HttpRequest {
    
    var delegate: AddPostsCommentRequestProtocol?
    let apiUrl = API_URL + "/add/posts/comment"
    
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
            delegate?.response(postsComment: nil, addPostsComment: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(postsComment: nil, addPostsComment: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(postsComment: nil, addPostsComment: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(postsComment: nil, addPostsComment: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(postsComment: nil, addPostsComment: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(postsComment: nil, addPostsComment: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(postsComment: nil, addPostsComment: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(postsComment: nil, addPostsComment: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AddPostsCommentRequestResponse.self, from: data)
                
                let postsComment = response.result
                
                self.delegate?.response(postsComment: postsComment, addPostsComment: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(postsComment: nil, addPostsComment: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct AddPostsCommentRequestResponse: Codable {
    var result: PostsComment
}
