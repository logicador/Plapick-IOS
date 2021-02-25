//
//  UloadImageRequest.swift
//  PetrueMockUp
//
//  Created by 서원영 on 2021/01/22.
//

import Foundation
import Alamofire


protocol UploadImageRequestProtocol {
    func response(imageName: Int?, uploadImage status: String)
}


// POST
// 이미지 업로드
class UploadImageRequest: HttpRequest {
    
    // MARK: Properties
    var delegate: UploadImageRequestProtocol?
    let apiUrl = API_URL + "/upload/image"
    
    
    func fetch(vc: UIViewController, isShowAlert: Bool = true, image: UIImage?) {
        print("[HTTP REQ]", apiUrl)
        
        if !vc.isNetworkAvailable() {
            if isShowAlert { vc.showNetworkAlert() }
            return
        }
        
        guard let image = image else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_IMAGE") }
            delegate?.response(imageName: nil, uploadImage: "ERR_IMAGE")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: COMPRESS_IMAGE_QUALITY) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_IMAGE_COMPRESS") }
            delegate?.response(imageName: nil, uploadImage: "ERR_IMAGE_COMPRESS")
            return
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(PLAPICK_IOS_APP_KEY.utf8), withName: "plapickKey")
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
        
        }, to: apiUrl).responseJSON { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                        self.delegate?.response(imageName: nil, uploadImage: "ERR_DATA")
                        return
                    }
                    
                    guard let status = self.getStatusCode(data: data) else {
                        if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                        self.delegate?.response(imageName: nil, uploadImage: "ERR_STATUS_DECODE")
                        return
                    }
                    
                    if status != "OK" {
                        if isShowAlert { vc.requestErrorAlert(title: status) }
                        self.delegate?.response(imageName: nil, uploadImage: status)
                        return
                    }
                    
                    do {
                        let response = try JSONDecoder().decode(IntRequestResult.self, from: data)
                        self.delegate?.response(imageName: response.result, uploadImage: status)
                        
                    } catch {
                        if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA_DECODE") }
                        self.delegate?.response(imageName: nil, uploadImage: "ERR_DATA_DECODE")
                    }
                    
                case .failure:
                    if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                    self.delegate?.response(imageName: nil, uploadImage: "ERR_SERVER")
                }
            }
        }
    }
}
