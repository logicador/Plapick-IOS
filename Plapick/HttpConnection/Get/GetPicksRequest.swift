//
//  GetPicksRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import UIKit


protocol GetPicksRequestProtocol {
    func response(pickList: [Pick]?, getPicks status: String)
}


// GET
// 픽 리스트 가져오기
class GetPicksRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: GetPicksRequestProtocol?
    let apiUrl = API_URL + "/get/picks"
    
    
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
            delegate?.response(pickList: nil, getPicks: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(pickList: nil, getPicks: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(pickList: nil, getPicks: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(pickList: nil, getPicks: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(pickList: nil, getPicks: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(pickList: nil, getPicks: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(pickList: nil, getPicks: "ERR_STATUS_DECODE")
                return
            }
            print("[HTTP RES]", self.apiUrl, status)
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(pickList: nil, getPicks: status)
                return
            }
            
            // MARK: Response
            do {
                let response = try JSONDecoder().decode(PicksRequestResult.self, from: data)
                let resPickList = response.result
                
                var pickList: [Pick] = []
                for resPick in resPickList {

                    let user = User(id: resPick.u_id, nickName: resPick.u_nick_name, profileImage: resPick.u_profile_image ?? "", connectedDate: resPick.u_connected_date)

                    let place = Place(id: resPick.p_id, kId: resPick.p_k_id, name: resPick.p_name, categoryName: resPick.p_category_name, categoryGroupName: resPick.p_category_group_name, categoryGroupCode: resPick.p_category_group_code, address: resPick.p_address, roadAddress: resPick.p_road_address, latitude: resPick.p_latitude, longitude: resPick.p_longitude, phone: resPick.p_phone, likeCnt: resPick.p_like_cnt, pickCnt: resPick.p_pick_cnt, commentCnt: resPick.p_comment_cnt, plocCode: resPick.p_ploc_code, clocCode: resPick.p_cloc_code)

                    let pick = Pick(user: user, place: place, id: resPick.pi_id, pId: resPick.pi_p_id, uId: resPick.pi_u_id, message: resPick.pi_message, likeCnt: resPick.pi_like_cnt, commentCnt: resPick.pi_comment_cnt, createdDate: resPick.pi_created_date, updatedDate: resPick.pi_updated_date)

                    pickList.append(pick)
                }
                
                self.delegate?.response(pickList: pickList, getPicks: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(pickList: nil, getPicks: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}