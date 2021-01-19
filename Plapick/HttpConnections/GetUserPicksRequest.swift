//
//  GetUserPicksRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/13.
//

import Foundation
import UIKit


// MARK: Protocol
protocol GetUserPicksRequestProtocol {
    func response(pickList: [Pick]?, status: String)
}


class GetUserPicksRequest {
    
    // MARK: Properties
    var delegate: GetUserPicksRequestProtocol?
    let apiUrl = API_URL + "/get/user/picks"
    
    
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
    func fetch(vc: UIViewController? = nil, uId: Int) {
        let urlString = apiUrl + "?uId=" + String(uId)
        
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, resp, error) in
            DispatchQueue.main.async {
                var pickList: [Pick]? = nil
                
                if let _ = error {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_SERVER", message: "서버오류가 발생했습니다.") }
                    self.delegate?.response(pickList: pickList, status: "ERR_SERVER")
                    return
                }
                
                if let data = data {
                    let status = self.getStatus(data: data)
                    if status != "OK" {
                        if let vc = vc { vc.requestErrorAlert(title: status, message: "응답오류가 발생했습니다.") }
                        self.delegate?.response(pickList: pickList, status: status)
                        return
                    }
                    
                    do {
                        let response = try JSONDecoder().decode(PickListResultResponse.self, from: data)
                        let resPickList = response.result
                        pickList = []
                        for resPick in resPickList {
                            let id = resPick.pi_id
                            let uId = resPick.pi_u_id
                            let uNickName = resPick.u_nick_name
                            let pId = resPick.pi_p_id
                            let message = resPick.pi_message
                            let likeCnt = resPick.pi_like_cnt
                            let commentCnt = resPick.pi_comment_cnt
                            let createdDate = resPick.pi_created_date
                            let updatedDate = resPick.pi_updated_date
                            let photoUrl = IMAGE_URL + "/users/" + String(uId) + "/" + String(id) + ".jpg"
                            
                            let pick = Pick(id: id, uId: uId, uNickName: uNickName, pId: pId, message: message, photoUrl: photoUrl, likeCnt: likeCnt, commentCnt: commentCnt, createdDate: createdDate, updatedDate: updatedDate)
                            pickList?.append(pick)
                        }
                        self.delegate?.response(pickList: pickList, status: "OK")
                        
                    } catch {
                        if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                        self.delegate?.response(pickList: pickList, status: "ERR_DATA_DECODE")
                    }
                    
                } else {
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA", message: "데이터 응답 오류가 발생했습니다.") }
                    self.delegate?.response(pickList: pickList, status: "ERR_DATA")
                }
            }
        })
        task.resume()
    }
}
