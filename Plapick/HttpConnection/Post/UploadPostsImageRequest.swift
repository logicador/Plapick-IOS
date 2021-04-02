//
//  UploadPostsImageRequest.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/23.
//

import UIKit
import Alamofire


protocol UploadPostsImageRequestProtocol {
    func response(uploadPostsImage status: String)
}


// 게시물 이미지 업로드 Request
// 게시물 poId와 order 보냄
class UploadPostsImageRequest: HttpRequest {
    
    var delegate: UploadPostsImageRequestProtocol?
    let apiUrl = API_URL + "/upload/posts/image"
    
    func fetch(vc: UIViewController, isShowAlert: Bool = true, image: UIImage, poId: Int, order: Int) {
        print("[HTTP REQ]", apiUrl)
        
        if !vc.isNetworkAvailable() {
            if isShowAlert { vc.showNetworkAlert() }
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: COMPRESS_IMAGE_QUALITY) else {
            if isShowAlert { vc.requestErrorAlert(title: "ERR_IMAGE_COMPRESS") }
            delegate?.response(uploadPostsImage: "ERR_IMAGE_COMPRESS")
            return
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(PLAPICK_IOS_APP_KEY.utf8), withName: "plapickKey")
            multipartFormData.append(Data(String(poId).utf8), withName: "poId")
            multipartFormData.append(Data(String(order).utf8), withName: "order")
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
        
        }, to: apiUrl).responseJSON { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        if isShowAlert { vc.requestErrorAlert(title: "ERR_DATA") }
                        self.delegate?.response(uploadPostsImage: "ERR_DATA")
                        return
                    }
                    
                    guard let status = self.getStatusCode(data: data) else {
                        if isShowAlert { vc.requestErrorAlert(title: "ERR_STATUS_DECODE") }
                        self.delegate?.response(uploadPostsImage: "ERR_STATUS_DECODE")
                        return
                    }
                    
                    if status != "OK" {
                        if isShowAlert { vc.requestErrorAlert(title: status) }
                        self.delegate?.response(uploadPostsImage: status)
                        return
                    }
                    
                    self.delegate?.response(uploadPostsImage: "OK")
                    
                case .failure:
                    if isShowAlert { vc.requestErrorAlert(title: "ERR_SERVER") }
                    self.delegate?.response(uploadPostsImage: "ERR_SERVER")
                }
            }
        }
    }
}
