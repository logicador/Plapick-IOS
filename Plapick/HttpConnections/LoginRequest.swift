//
//  LoginRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import Foundation
import UIKit


// MARK: Protocol
protocol LoginRequestProtocol {
    func response(user: User?, status: String)
}


class LoginRequest {
    
    // MARK: Properties
    var delegate: LoginRequestProtocol?
    let apiUrl = API_URL + "/login"
    
    
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
                var user: User? = nil
                
                if let _ = error {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_SERVER", message: "서버오류가 발생했습니다.") }
                    self.delegate?.response(user: user, status: "ERR_SERVER")
                    return
                }
                
                if let data = data {
                    let status = self.getStatus(data: data)
                    if status != "OK" {
                        if let vc = vc { vc.requestErrorAlert(title: status, message: "응답오류가 발생했습니다.") }
                        self.delegate?.response(user: user, status: status)
                        return
                    }
                    
                    do {
                        let response = try JSONDecoder().decode(UserProfileResultResponse.self, from: data)
                        let resUser = response.result
                        
                        user = User(id: resUser.u_id, type: resUser.u_type, socialId: resUser.u_social_id, name: resUser.u_name, nickName: resUser.u_nick_name, email: resUser.u_email, profileImageUrl: resUser.u_profile_image, likeCnt: resUser.u_like_cnt, followerCnt: resUser.u_follower_cnt, followingCnt: resUser.u_following_cnt, status: resUser.u_status, createdDate: resUser.u_created_date, updatedDate: resUser.u_updated_date)
                        
                        self.delegate?.response(user: user, status: "OK")
                        
                    } catch {
                        if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                        self.delegate?.response(user: user, status: "ERR_DATA_DECODE")
                    }
                    
                } else {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA", message: "데이터 응답 오류가 발생했습니다.") }
                    self.delegate?.response(user: user, status: "ERR_DATA")
                }
            }
        })
        task.resume()
    }
}
