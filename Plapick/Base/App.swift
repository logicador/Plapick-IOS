//
//  App.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import Foundation
import SystemConfiguration
import UIKit


class App {
    
    var userDefaults = UserDefaults.standard
    
    init() {
    }
    
    func showNetworkAlert(parentViewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "네트워크 오류", message: "네트워크가 연결중인지 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
            alert.addAction(UIAlertAction(title: "다시시도", style: UIAlertAction.Style.default, handler: { (_) in
                parentViewController.changeRootViewController(rootViewController: LaunchViewController())
            }))
            parentViewController.present(alert, animated: true)
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
    
    func isLogined() -> Bool {
        return self.userDefaults.bool(forKey: "isLogined")
    }
    
    func getUser() -> User {
        let uId = userDefaults.integer(forKey: "uId")
        let uType = userDefaults.string(forKey: "uType") ?? ""
        let uSocialId = userDefaults.string(forKey: "uSocialId") ?? ""
        let uName = userDefaults.string(forKey: "uName") ?? ""
        let uNickName = userDefaults.string(forKey: "uNickName") ?? ""
        let uEmail = userDefaults.string(forKey: "uEmail") ?? ""
        let uProfileImageUrl = userDefaults.string(forKey: "uProfileImageUrl") ?? ""
        let uLikeCnt = userDefaults.integer(forKey: "uLikeCnt")
        let uFollowerCnt = userDefaults.integer(forKey: "uFollowerCnt")
        let uFollowingCnt = userDefaults.integer(forKey: "uFollowingCnt")
        let uStatus = userDefaults.string(forKey: "uStatus") ?? ""
        let uCreatedDate = userDefaults.string(forKey: "uCreatedDate") ?? ""
        let uUpdatedDate = userDefaults.string(forKey: "uUpdatedDate") ?? ""
            
        return User(id: uId, type: uType, socialId: uSocialId, name: uName, nickName: uNickName, email: uEmail, profileImageUrl: uProfileImageUrl, likeCnt: uLikeCnt, followerCnt: uFollowerCnt, followingCnt: uFollowingCnt, status: uStatus, createdDate: uCreatedDate, updatedDate: uUpdatedDate)
    }
    
    func login(user: User) {
        userDefaults.set(true, forKey: "isLogined")
        userDefaults.set(user.id, forKey: "uId")
        userDefaults.set(user.type, forKey: "uType")
        userDefaults.set(user.socialId, forKey: "uSocialId")
        userDefaults.set(user.name, forKey: "uName")
        userDefaults.set(user.nickName, forKey: "uNickName")
        userDefaults.set(user.email, forKey: "uEmail")
        userDefaults.set(user.profileImageUrl, forKey: "uProfileImageUrl")
        userDefaults.set(user.likeCnt, forKey: "uLikeCnt")
        userDefaults.set(user.followerCnt, forKey: "uFollowerCnt")
        userDefaults.set(user.followingCnt, forKey: "uFollowingCnt")
        userDefaults.set(user.status, forKey: "uStatus")
        userDefaults.set(user.createdDate, forKey: "uCreatedDate")
        userDefaults.set(user.updatedDate, forKey: "uUpdatedDate")
    }
    
    func logout() {
        userDefaults.set(false, forKey: "isLogined")
        userDefaults.removeObject(forKey: "uId")
        userDefaults.removeObject(forKey: "uType")
        userDefaults.removeObject(forKey: "uSocialId")
        userDefaults.removeObject(forKey: "uName")
        userDefaults.removeObject(forKey: "uNickName")
        userDefaults.removeObject(forKey: "uEmail")
        userDefaults.removeObject(forKey: "uProfileImageUrl")
        userDefaults.removeObject(forKey: "uLikeCnt")
        userDefaults.removeObject(forKey: "uFollowerCnt")
        userDefaults.removeObject(forKey: "uFollowingCnt")
        userDefaults.removeObject(forKey: "uStatus")
        userDefaults.removeObject(forKey: "uCreatedDate")
        userDefaults.removeObject(forKey: "uUpdatedDate")
    }
    
    func setNickName(nickName: String) {
        userDefaults.set(nickName, forKey: "uNickName")
    }
    
    func setProfileImage(profileImageUrl: String) {
        userDefaults.set(profileImageUrl, forKey: "uProfileImageUrl")
    }
}
