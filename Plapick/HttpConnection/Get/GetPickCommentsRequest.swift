//
//  GetPickCommentsRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/25.
//

import UIKit


protocol GetPickCommentsRequestProtocol {
    func response(pickCommentList: [PickComment]?, getPickComments status: String)
}


// GET
// 픽 리스트 가져오기
class GetPickCommentsRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetPickCommentsRequestProtocol?
    let apiUrl = API_URL + "/get/pick/comments"
    
    
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
            delegate?.response(pickCommentList: nil, getPickComments: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(pickCommentList: nil, getPickComments: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(pickCommentList: nil, getPickComments: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(pickCommentList: nil, getPickComments: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(pickCommentList: nil, getPickComments: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(pickCommentList: nil, getPickComments: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(pickCommentList: nil, getPickComments: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(pickCommentList: nil, getPickComments: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PickCommentsRequestResult.self, from: data)
                let resPickCommentList = response.result
                
                var pickCommentList: [PickComment] = []
                
                for resPickComment in resPickCommentList {
                    let user = User(id: resPickComment.mcpi_u_id, nickName: resPickComment.u_nick_name, profileImage: resPickComment.u_profile_image, connectedDate: resPickComment.u_connected_date, isFollow: resPickComment.isFollow, followerCnt: resPickComment.followerCnt, followingCnt: resPickComment.followingCnt, pickCnt: resPickComment.pickCnt, likePickCnt: resPickComment.likePickCnt, likePlaceCnt: resPickComment.likePlaceCnt)
                    let pickComment = PickComment(id: resPickComment.mcpi_id, piId: resPickComment.mcpi_pi_id, comment: resPickComment.mcpi_comment, createdDate: resPickComment.mcpi_created_date, updatedDate: resPickComment.mcpi_updated_date, user: user)
                    
                    pickCommentList.append(pickComment)
                }
                
                self.delegate?.response(pickCommentList: pickCommentList, getPickComments: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(pickCommentList: nil, getPickComments: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}

