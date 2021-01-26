//
//  VersionRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/14.
//

import Foundation
import UIKit


// MARK: Protocol
protocol VersionRequestProtocol {
    func response(version: String?, build: Int?, status: String)
}


class VersionRequest {
    
    // MARK: Properties
    var delegate: VersionRequestProtocol?
    let apiUrl = API_URL + "/get/version?platform=IOS"
    
    
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
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, resp, error) in
            DispatchQueue.main.async {
                var version: String? = nil
                var build: Int? = nil
                
                if let _ = error {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_SERVER", message: "서버오류가 발생했습니다.") }
                    self.delegate?.response(version: version, build: build, status: "ERR_SERVER")
                    return
                }
                
                if let data = data {
                    let status = self.getStatus(data: data)
                    if status != "OK" {
                        if let vc = vc { vc.requestErrorAlert(title: status, message: "응답오류가 발생했습니다.") }
                        self.delegate?.response(version: version, build: build, status: status)
                        return
                    }
                    
                    do {
                        let response = try JSONDecoder().decode(VersionResultResponse.self, from: data)
                        version = response.result.version
                        build = response.result.build
                        self.delegate?.response(version: version, build: build, status: "OK")
                        
                    } catch {
                        if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                        self.delegate?.response(version: version, build: build, status: "ERR_DATA_DECODE")
                    }
                    
                } else {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA", message: "데이터 응답 오류가 발생했습니다.") }
                    self.delegate?.response(version: version, build: build, status: "ERR_DATA")
                }
            }
        })
        task.resume()
    }
}


