//
//  GetPostsRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/24.
//

import UIKit


protocol GetPostsRequestProtocol {
    func response(postsList: [Posts]?, mode: String?, getPosts status: String)
}


// 게시물 가져오는 Request
class GetPostsRequest: HttpRequest {
    
    var delegate: GetPostsRequestProtocol?
    let apiUrl = API_URL + "/get/posts"
    
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
            delegate?.response(postsList: nil, mode: nil, getPosts: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(postsList: nil, mode: nil, getPosts: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(postsList: nil, mode: nil, getPosts: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(postsList: nil, mode: nil, getPosts: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(postsList: nil, mode: nil, getPosts: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(postsList: nil, mode: nil, getPosts: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(postsList: nil, mode: nil, getPosts: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(postsList: nil, mode: nil, getPosts: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(GetPostsRequestResponse.self, from: data)
                
                let postsList = response.result
                let mode = response.mode
                
                self.delegate?.response(postsList: postsList, mode: mode, getPosts: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(postsList: nil, mode: nil, getPosts: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct GetPostsRequestResponse: Codable {
    var result: [Posts]
    var mode: String
}
