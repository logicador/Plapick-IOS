//
//  LogoutRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/12.
//

import Foundation
import UIKit


// MARK: Protocol
protocol LogoutRequestProtocol {
    func response(status: String)
}


class LogoutRequest {
    
    // MARK: Properties
    var delegate: LogoutRequestProtocol?
    let apiUrl = API_URL + "/logout"
    
    
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
    func fetch(vc: UIViewController? = nil) {
        let url = URL(string: apiUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, resp, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_SERVER", message: "서버오류가 발생했습니다.") }
                    self.delegate?.response(status: "ERR_SERVER")
                    return
                }
                
                if let _ = data {
                    // /webapi/logout 은 status가 OK 말고는 없음. data가 있다는건 status가 무조건 OK라는 의미
                    self.delegate?.response(status: "OK")
                    
                } else {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA", message: "데이터 응답 오류가 발생했습니다.") }
                    self.delegate?.response(status: "ERR_DATA")
                }
            }
        })
        task.resume()
    }
}
