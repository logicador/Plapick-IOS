//
//  GetUsersRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


protocol GetUsersRequestProtocol {
    func response(userList: [User]?, getUsers status: String)
}


// GET
// 유저 정보 가져오기
class GetUsersRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: GetUsersRequestProtocol?
    let apiUrl = API_URL + "/get/users"
    
    
    // MARK: Fetch
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
            delegate?.response(userList: nil, getUsers: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(userList: nil, getUsers: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(userList: nil, getUsers: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(userList: nil, getUsers: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(userList: nil, getUsers: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(userList: nil, getUsers: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(userList: nil, getUsers: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(userList: nil, getUsers: status)
                return
            }
            
            // MARK: Response
            do {
                let response = try JSONDecoder().decode(UsersRequestResult.self, from: data)
                let resUserList = response.result
                
                var userList: [User] = []
                for resUser in resUserList {
                    let user = User(id: resUser.u_id, type: resUser.u_type, socialId: resUser.u_social_id, name: resUser.u_name, nickName: resUser.u_nick_name, email: resUser.u_email, password: resUser.u_password, profileImage: resUser.u_profile_image, status: resUser.u_status, lastLoginPlatform: resUser.u_last_login_platform, isLogined: resUser.u_is_logined, createdDate: resUser.u_created_date, updatedDate: resUser.u_updated_date, connectedDate: resUser.u_connected_date, isFollow: resUser.isFollow, followerCnt: resUser.followerCnt, followingCnt: resUser.followingCnt, pickCnt: resUser.pickCnt, likePickCnt: resUser.likePickCnt, likePlaceCnt: resUser.likePlaceCnt, isBlocked: resUser.isBlocked)
                    userList.append(user)
                }
                
                self.delegate?.response(userList: userList, getUsers: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(userList: nil, getUsers: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}
