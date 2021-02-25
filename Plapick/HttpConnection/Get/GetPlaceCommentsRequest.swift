//
//  GetPlaceCommentsRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/23.
//

import UIKit


protocol GetPlaceCommentsRequestProtocol {
    func response(placeCommentList: [PlaceComment]?, getPlaceComments status: String)
}


// GET
// 픽 리스트 가져오기
class GetPlaceCommentsRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetPlaceCommentsRequestProtocol?
    let apiUrl = API_URL + "/get/place/comments"
    
    
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
            delegate?.response(placeCommentList: nil, getPlaceComments: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(placeCommentList: nil, getPlaceComments: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(placeCommentList: nil, getPlaceComments: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(placeCommentList: nil, getPlaceComments: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(placeCommentList: nil, getPlaceComments: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(placeCommentList: nil, getPlaceComments: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(placeCommentList: nil, getPlaceComments: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(placeCommentList: nil, getPlaceComments: status)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PlaceCommentsRequestResult.self, from: data)
                let resPlaceCommentList = response.result
                
                var placeCommentList: [PlaceComment] = []
                
                for resPlaceComment in resPlaceCommentList {
                    let user = User(id: resPlaceComment.mcp_u_id, nickName: resPlaceComment.u_nick_name, profileImage: resPlaceComment.u_profile_image, connectedDate: resPlaceComment.u_connected_date, isFollow: resPlaceComment.isFollow, followerCnt: resPlaceComment.followerCnt, followingCnt: resPlaceComment.followingCnt, pickCnt: resPlaceComment.pickCnt, likePickCnt: resPlaceComment.likePickCnt, likePlaceCnt: resPlaceComment.likePlaceCnt)
                    let placeComment = PlaceComment(id: resPlaceComment.mcp_id, pId: resPlaceComment.mcp_p_id, comment: resPlaceComment.mcp_comment, createdDate: resPlaceComment.mcp_created_date, updatedDate: resPlaceComment.mcp_updated_date, user: user)
                    
                    placeCommentList.append(placeComment)
                }
                
                self.delegate?.response(placeCommentList: placeCommentList, getPlaceComments: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(placeCommentList: nil, getPlaceComments: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}
