//
//  LoginRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


// MARK: Protocol
protocol LoginRequestProtocol {
    func response(user: User?, login status: String)
}


// POST
class LoginRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: LoginRequestProtocol?
    let apiUrl = API_URL + "/login"
    
    
    // MARK: Fetch
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
            self.delegate?.response(user: nil, login: "ERR_PARAM_DATA")
            return
        }
        
        let httpUrl = apiUrl
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            self.delegate?.response(user: nil, login: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(user: nil, login: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(user: nil, login: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(user: nil, login: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(user: nil, login: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(user: nil, login: "ERR_STATUS_DECODE")
                return
            }
            print("[HTTP RES]", self.apiUrl, status)
            
            if status != "OK" {
                if status == "LOGIN_FAILED" {
                    if isShowAlert { vc.requestErrorAlert(title: "로그인 실패", message: "사용자를 찾을 수 없습니다. 로그인 정보를 다시 확인해주세요.") }
                } else {
                    if isShowAlert { vc.requestErrorAlert(title: status) }
                }
                self.delegate?.response(user: nil, login: status)
                return
            }
            
            // MARK: Response
            do {
                let response = try JSONDecoder().decode(LoginRequestResult.self, from: data)
                let resUser = response.result
                
                let user = User(id: resUser.u_id, type: resUser.u_type, socialId: resUser.u_social_id, name: resUser.u_name, nickName: resUser.u_nick_name, email: resUser.u_email, password: resUser.u_password, profileImage: resUser.u_profile_image, likeCnt: resUser.u_like_cnt, followerCnt: resUser.u_follower_cnt, followingCnt: resUser.u_following_cnt, status: resUser.u_status, lastLoginPlatform: resUser.u_last_login_platform, isLogined: resUser.u_is_logined, createdDate: resUser.u_created_date, updatedDate: resUser.u_updated_date, connectedDate: resUser.u_connected_date)
                
                self.delegate?.response(user: user, login: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(user: nil, login: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}
