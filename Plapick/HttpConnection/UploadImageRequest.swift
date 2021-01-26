//
//  UploadImageRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/14.
//

import Foundation
import Alamofire


protocol UploadImageRequestProtocol {
    func response(imageName: Int?, status: String)
}


class UploadImageRequest {
    
    // MARK: Properties
    var delegate: UploadImageRequestProtocol?
    let apiUrl = API_URL + "/upload/image"
    
    
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
    func fetch(vc: UIViewController? = nil, imageData: Data) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
        
        }, to: apiUrl).responseJSON { response in
            DispatchQueue.main.async {
                var imageName: Int? = nil
                
                switch response.result {
                
                case .success:
                    if let data = response.data {
                        let status = self.getStatus(data: data)
                        if status != "OK" {
                            if let vc = vc { vc.requestErrorAlert(title: status, message: "응답오류가 발생했습니다.") }
                            self.delegate?.response(imageName: imageName, status: status)
                            return
                        }
                        
                        do {
                            let response = try JSONDecoder().decode(UploadImageResultResponse.self, from: data)
                            imageName = response.result
                            self.delegate?.response(imageName: imageName, status: "OK")
                            
                        } catch {
                            print(error.localizedDescription)
                            if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                            self.delegate?.response(imageName: imageName, status: "ERR_DATA_DECODE")
                        }
                        
                    } else {
                        if let vc = vc { vc.requestErrorAlert(title: "ERR_DATA", message: "데이터 응답 오류가 발생했습니다.") }
                        self.delegate?.response(imageName: imageName, status: "ERR_DATA")
                    }
                    
                case .failure:
                    if let vc = vc { vc.requestErrorAlert(title: "ERR_SERVER", message: "서버오류가 발생했습니다.") }
                    self.delegate?.response(imageName: imageName, status: "ERR_SERVER")
                }
            }
        }
    }
}
