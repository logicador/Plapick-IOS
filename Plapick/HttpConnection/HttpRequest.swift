//
//  HttpRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/24.
//

import UIKit


class HttpRequest {
    
    // MARK: GetStatusCode
    func getStatusCode(data: Data) -> String? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = jsonObject as? [String: Any] else { return nil }
            guard let status = dict["status"] as? String else { return nil }
            return status
        } catch { return nil }
    }
    
    
    // MARK: MakeParams
    func makeParamString(paramDict: [String: String]) -> String {
        var paramString = "plapickKey=\(PLAPICK_IOS_APP_KEY)"
        for param in paramDict {
            if param.key == "" { continue }
            paramString += "&\(param.key)=\(param.value)"
        }
        return paramString
    }
    
    
    // MARK: GetPostRequest
    func getPostRequest(url: URL, paramData: Data) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = paramData
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        return urlRequest
    }
    
    
    // MARK: Init
    init() { }
}
