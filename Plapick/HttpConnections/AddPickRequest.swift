//
//  AddPickRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/14.
//

import Foundation
import UIKit


// MARK: Protocol
protocol AddPickRequestProtocol {
    func response(status: String)
}


class AddPickRequest {
    
    // MARK: Properties
    var delegate: AddPickRequestProtocol?
    let apiUrl = API_URL + "/add/pick"
    
    
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
    
    
    // MARK: getPostParams
    func getPostParamData(paramList: [Param]) -> Data? {
        var paramString = ""
        if paramList.count > 0 {
            for (i, param) in paramList.enumerated() {
                if param.key == "" { continue }
                if i > 0 { paramString += "&" }
                paramString += param.key + "=" + param.value
            }
        }
        
        let paramData = paramString.data(using: .utf8)
        if let paramData = paramData { return paramData }
        else { return nil }
    }
    
    
    // MARK: Fetch
    func fetch(vc: UIViewController? = nil, paramList: [Param]) {
        let paramData = getPostParamData(paramList: paramList)
        
        let url = URL(string: apiUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = paramData
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, resp, error) in
            DispatchQueue.main.async {
                
                if let _ = error {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_SERVER", message: "서버오류가 발생했습니다.") }
                    self.delegate?.response(status: "ERR_SERVER")
                    return
                }
                
                if let data = data {
                    let status = self.getStatus(data: data)
                    if status != "OK" {
                        if let vc = vc { vc.requestErrorAlert(title: status, message: "응답오류가 발생했습니다.") }
                    }
                    
                    self.delegate?.response(status: status)
                    
                } else {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA", message: "데이터 응답 오류가 발생했습니다.") }
                    self.delegate?.response(status: "ERR_DATA")
                }
            }
        })
        task.resume()
    }
}