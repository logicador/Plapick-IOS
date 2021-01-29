//
//  App.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import Foundation
import SystemConfiguration
import UIKit
import Photos
import CoreLocation


protocol AppProtocol {
    func pushNotification(isAllowed: Bool)
    func photoGallary(isAllowed: Bool)
}


class App {
    
    // MARK: Property
    var delegate: AppProtocol?
    var userDefaults = UserDefaults.standard
    
    
    // MARK: Init
    init() {
    }
    
    func showNetworkAlert(vc: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "네트워크 오류", message: "네트워크가 연결중인지 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
            alert.addAction(UIAlertAction(title: "다시시도", style: UIAlertAction.Style.default, handler: { (_) in
                vc.changeRootViewController(rootViewController: LaunchViewController())
            }))
            vc.present(alert, animated: true)
        }
    }
    
    func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func checkPushNotificationAvailable(vc: UIViewController) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (isAllowed, error) in DispatchQueue.main.async {
            if let _ = error {
                vc.requestSettingAlert(title: "알림 액세스 허용하기", message: "'플레픽'에서 알림을 보내고자 합니다.")
                self.delegate?.pushNotification(isAllowed: false)
                return
            }
            
            if isAllowed {
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                vc.requestSettingAlert(title: "알림 액세스 허용하기", message: "'플레픽'에서 알림을 보내고자 합니다.")
            }
            
            self.delegate?.pushNotification(isAllowed: isAllowed)
        }})
    }
    
    func checkPhotoGallaryAvailable(vc: UIViewController) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined || status == .denied {
            PHPhotoLibrary.requestAuthorization({ (status) in DispatchQueue.main.async {
                if status == .notDetermined || status == .denied {
                    vc.requestSettingAlert(title: "앨범 액세스 허용하기", message: "'플레픽'에서 앨범에 접근하고자 합니다.")
                    return
                }
                self.delegate?.photoGallary(isAllowed: true)
            }})
            return
        }
        delegate?.photoGallary(isAllowed: true)
    }
    
//    func getUrlImage(urlString: String) -> UIImage {
//        let url = URL(string: urlString)
//        if let url = url {
//            do {
//                let data = try Data(contentsOf: url)
//                let image = UIImage(data: data)
//                if let image = image {
//                    return image
//                } else { return UIImage() }
//            } catch { return UIImage() }
//        } else { return UIImage() }
//    }
//    
//    func getPickImage(uId: Int, piId: Int) -> UIImage {
//        return getUrlImage(urlString: "\(IMAGE_URL)/users/\(uId)/\(piId).jpg")
//    }
    
    func getCategoryString(categoryName: String, replaceStr: String = "-") -> String {
        if categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return replaceStr
        }
        
        if let splittedCategoryName = categoryName.split(separator: ">").last {
            let str = String(splittedCategoryName).trimmingCharacters(in: .whitespacesAndNewlines)
            if str.isEmpty {
                return replaceStr
            } else {
                return str
            }
        }
        
        return replaceStr
    }
    
    func getPickUrl(id: Int, uId: Int) -> String {
        return "\(IMAGE_URL)/users/\(uId)/\(id).jpg"
    }
    
    func isLogined() -> Bool {
        return self.userDefaults.bool(forKey: "isLogined")
    }
    
    func getUser() -> User {
        let id = userDefaults.integer(forKey: "uId")
        let type = userDefaults.string(forKey: "uType") ?? ""
        let socialId = userDefaults.string(forKey: "uSocialId") ?? ""
        let name = userDefaults.string(forKey: "uName") ?? ""
        let nickName = userDefaults.string(forKey: "uNickName") ?? ""
        let email = userDefaults.string(forKey: "uEmail") ?? ""
        let password = userDefaults.string(forKey: "uPassword") ?? ""
        let profileImage = userDefaults.string(forKey: "uProfileImage") ?? ""
//        let likeCnt = userDefaults.integer(forKey: "uLikeCnt")
//        let followerCnt = userDefaults.integer(forKey: "uFollowerCnt")
//        let followingCnt = userDefaults.integer(forKey: "uFollowingCnt")
//        let newsCnt = userDefaults.integer(forKey: "uNewsCnt")
//        let myNewsCnt = userDefaults.integer(forKey: "uMyNewsCnt")
        let status = userDefaults.string(forKey: "uStatus") ?? ""
        let lastLoginPlatform = userDefaults.string(forKey: "uLastLoginPlatform") ?? ""
        let isLogined = userDefaults.string(forKey: "uIsLogined") ?? ""
        let createdDate = userDefaults.string(forKey: "uCreatedDate") ?? ""
        let updatedDate = userDefaults.string(forKey: "uUpdatedDate") ?? ""
        let connectedDate = userDefaults.string(forKey: "uConnectedDate") ?? ""
        
        return User(id: id, type: type, socialId: socialId, name: name, nickName: nickName, email: email, password: password, profileImage: profileImage, status: status, lastLoginPlatform: lastLoginPlatform, isLogined: isLogined, createdDate: createdDate, updatedDate: updatedDate, connectedDate: connectedDate)
    }
    
    func login(user: User) {
        userDefaults.set(true, forKey: "isLogined")
        userDefaults.set(user.id, forKey: "uId")
        userDefaults.set(user.type, forKey: "uType")
        userDefaults.set(user.socialId, forKey: "uSocialId")
        userDefaults.set(user.name, forKey: "uName")
        userDefaults.set(user.nickName, forKey: "uNickName")
        userDefaults.set(user.email, forKey: "uEmail")
        userDefaults.set(user.password, forKey: "uPassword")
        userDefaults.set(user.profileImage, forKey: "uProfileImage")
//        userDefaults.set(user.likeCnt, forKey: "uLikeCnt")
//        userDefaults.set(user.followerCnt, forKey: "uFollowerCnt")
//        userDefaults.set(user.followingCnt, forKey: "uFollowingCnt")
//        userDefaults.set(user.newsCnt, forKey: "uNewsCnt")
//        userDefaults.set(user.myNewsCnt, forKey: "uMyNewsCnt")
        userDefaults.set(user.status, forKey: "uStatus")
        userDefaults.set(user.lastLoginPlatform, forKey: "uLastLoginPlatform")
        userDefaults.set(user.isLogined, forKey: "uIsLogined")
        userDefaults.set(user.createdDate, forKey: "uCreatedDate")
        userDefaults.set(user.updatedDate, forKey: "uUpdatedDate")
        userDefaults.set(user.connectedDate, forKey: "uConnectedDate")
    }
    
    func logout() {
        userDefaults.set(false, forKey: "isLogined")
        userDefaults.removeObject(forKey: "uId")
        userDefaults.removeObject(forKey: "uType")
        userDefaults.removeObject(forKey: "uSocialId")
        userDefaults.removeObject(forKey: "uName")
        userDefaults.removeObject(forKey: "uNickName")
        userDefaults.removeObject(forKey: "uEmail")
        userDefaults.removeObject(forKey: "uPassword")
        userDefaults.removeObject(forKey: "uProfileImage")
//        userDefaults.removeObject(forKey: "uLikeCnt")
//        userDefaults.removeObject(forKey: "uFollowerCnt")
//        userDefaults.removeObject(forKey: "uFollowingCnt")
//        userDefaults.removeObject(forKey: "uNewsCnt")
//        userDefaults.removeObject(forKey: "uMyNewsCnt")
        userDefaults.removeObject(forKey: "uStatus")
        userDefaults.removeObject(forKey: "uLastLoginPlatform")
        userDefaults.removeObject(forKey: "uIsLogined")
        userDefaults.removeObject(forKey: "uCreatedDate")
        userDefaults.removeObject(forKey: "uUpdatedDate")
        userDefaults.removeObject(forKey: "uConnectedDate")
    }
    
    func getNickName() -> String {
        return userDefaults.string(forKey: "uNickName") ?? ""
    }
    func setNickName(nickName: String) {
        userDefaults.set(nickName, forKey: "uNickName")
    }
    
    func getProfileImage() -> String {
        return userDefaults.string(forKey: "uProfileImage") ?? ""
    }
    func setProfileImage(profileImage: String) {
        userDefaults.set(profileImage, forKey: "uProfileImage")
    }
    
    func getPndId() -> String {
        return userDefaults.string(forKey: "pndId") ?? ""
    }
    func setPndId(pndId: String) {
        userDefaults.set(pndId, forKey: "pndId")
    }
    
    func getUId() -> Int {
        return userDefaults.integer(forKey: "uId")
    }
}
