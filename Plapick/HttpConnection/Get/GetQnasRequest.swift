//
//  GetQnasRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/20.
//

import UIKit


protocol GetQnasRequestProtocol {
    func response(qnaList: [Qna]?, getQnas status: String)
}


// GET
// 픽 리스트 가져오기
class GetQnasRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: GetQnasRequestProtocol?
    let apiUrl = API_URL + "/get/qnas"
    
    
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
            delegate?.response(qnaList: nil, getQnas: "ERR_URL_ENCODE")
            return
        }
        
        let httpUrl = encodedUrlString
        guard let url = URL(string: httpUrl) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_URL") }
            delegate?.response(qnaList: nil, getQnas: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, res, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(qnaList: nil, getQnas: "ERR_SERVER")
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(qnaList: nil, getQnas: "ERR_RESPONSE")
                return
            }
            
            if response.statusCode != 200 {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(qnaList: nil, getQnas: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(qnaList: nil, getQnas: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(qnaList: nil, getQnas: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.requestErrorAlert(title: status) }
                self.delegate?.response(qnaList: nil, getQnas: status)
                return
            }
            
            // MARK: Response
            do {
                let response = try JSONDecoder().decode(QnasRequestResult.self, from: data)
                
                let resQnaList = response.result
                
                var qnaList: [Qna] = []
                
                for resQna in resQnaList {
                    let qna = Qna(id: resQna.q_id, uId: resQna.q_u_id, title: resQna.q_title, content: resQna.q_content, answer: resQna.q_answer, status: resQna.q_status, createdDate: resQna.q_created_date, updatedDate: resQna.q_updated_date, answeredDate: resQna.q_answered_date)
                    qnaList.append(qna)
                }
                
                self.delegate?.response(qnaList: qnaList, getQnas: "OK")
                
            } catch {
                if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(qnaList: nil, getQnas: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
    
    
    // MARK: Init
    override init() {
        super.init()
    }
}

