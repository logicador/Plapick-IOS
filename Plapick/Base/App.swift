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
import SDWebImage


protocol AppProtocol {
    func pushNotification(isAllowed: Bool)
    func photoGallary(isAllowed: Bool)
}


class App {
    
    // MARK: Property
    var delegate: AppProtocol?
    var userDefaults = UserDefaults.standard
    
    func getCategoryName(categoryName: String, replaceStr: String = "-") -> String {
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
        let status = userDefaults.string(forKey: "uStatus") ?? ""
        let lastLoginPlatform = userDefaults.string(forKey: "uLastLoginPlatform") ?? ""
        let isLogined = userDefaults.string(forKey: "uIsLogined") ?? ""
        let createdDate = userDefaults.string(forKey: "uCreatedDate") ?? ""
        let updatedDate = userDefaults.string(forKey: "uUpdatedDate") ?? ""
        let connectedDate = userDefaults.string(forKey: "uConnectedDate") ?? ""
        
        let followerCnt = userDefaults.integer(forKey: "uFollowerCnt")
        let followingCnt = userDefaults.integer(forKey: "uFollowingCnt")
        let pickCnt = userDefaults.integer(forKey: "uPickCnt")
        let likePickCnt = userDefaults.integer(forKey: "uLikePickCnt")
        let likePlaceCnt = userDefaults.integer(forKey: "uLikePlaceCnt")
        
        return User(id: id, type: type, socialId: socialId, name: name, nickName: nickName, email: email, password: password, profileImage: profileImage, status: status, lastLoginPlatform: lastLoginPlatform, isLogined: isLogined, createdDate: createdDate, updatedDate: updatedDate, connectedDate: connectedDate, isFollow: "N", followerCnt: followerCnt, followingCnt: followingCnt, pickCnt: pickCnt, likePickCnt: likePickCnt, likePlaceCnt: likePlaceCnt)
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
        userDefaults.set(user.status, forKey: "uStatus")
        userDefaults.set(user.lastLoginPlatform, forKey: "uLastLoginPlatform")
        userDefaults.set(user.isLogined, forKey: "uIsLogined")
        userDefaults.set(user.createdDate, forKey: "uCreatedDate")
        userDefaults.set(user.updatedDate, forKey: "uUpdatedDate")
        userDefaults.set(user.connectedDate, forKey: "uConnectedDate")
        
        userDefaults.set(user.followerCnt, forKey: "uFollowerCnt")
        userDefaults.set(user.followingCnt, forKey: "uFollowingCnt")
        userDefaults.set(user.pickCnt, forKey: "uPickCnt")
        userDefaults.set(user.likePickCnt, forKey: "uLikePickCnt")
        userDefaults.set(user.likePlaceCnt, forKey: "uLikePlaceCnt")
    }
    
    func logout() {
        userDefaults.set(false, forKey: "isLogined")
//        userDefaults.removeObject(forKey: "uId")
//        userDefaults.removeObject(forKey: "uType")
//        userDefaults.removeObject(forKey: "uSocialId")
//        userDefaults.removeObject(forKey: "uName")
//        userDefaults.removeObject(forKey: "uNickName")
//        userDefaults.removeObject(forKey: "uEmail")
//        userDefaults.removeObject(forKey: "uPassword")
//        userDefaults.removeObject(forKey: "uProfileImage")
//        userDefaults.removeObject(forKey: "uStatus")
//        userDefaults.removeObject(forKey: "uLastLoginPlatform")
//        userDefaults.removeObject(forKey: "uIsLogined")
//        userDefaults.removeObject(forKey: "uCreatedDate")
//        userDefaults.removeObject(forKey: "uUpdatedDate")
//        userDefaults.removeObject(forKey: "uConnectedDate")
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
    
    func getCurVersionCode() -> Int {
        return userDefaults.integer(forKey: "curVersionCode")
    }
    func setCurVersionCode(curVersionCode: Int) {
        userDefaults.set(curVersionCode, forKey: "curVersionCode")
    }
    
    func getCurVersionName() -> String {
        return userDefaults.string(forKey: "curVersionName") ?? ""
    }
    func setCurVersionName(curVersionName: String) {
        userDefaults.set(curVersionName, forKey: "curVersionName")
    }
    
    func getNewVersionCode() -> Int {
        return userDefaults.integer(forKey: "newVersionCode")
    }
    func setNewVersionCode(newVersionCode: Int) {
        userDefaults.set(newVersionCode, forKey: "newVersionCode")
    }
    
    func getNewVersionName() -> String {
        return userDefaults.string(forKey: "newVersionName") ?? ""
    }
    func setNewVersionName(newVersionName: String) {
        userDefaults.set(newVersionName, forKey: "newVersionName")
    }
    
    func getPushNotification(key: String) -> String {
        return userDefaults.string(forKey: key) ?? "Y"
    }
    func setPushNotification(key: String, value: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func getLatitude() -> String {
        return userDefaults.string(forKey: "latitude") ?? DEFAULT_LATITUDE
    }
    func setLatitude(latitude: String) {
        userDefaults.set(latitude, forKey: "latitude")
    }
    
    func getLongitude() -> String {
        return userDefaults.string(forKey: "longitude") ?? DEFAULT_LONGITUDE
    }
    func setLongitude(longitude: String) {
        userDefaults.set(longitude, forKey: "longitude")
    }
    
    func getRecentPlaceList() -> [Place] {
        guard let obj = userDefaults.object(forKey: "recentPlaceList") as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let recentPlaceList = try? decoder.decode(Array<Place>.self, from: obj) else { return [] }
        return recentPlaceList
    }
    func addRecentPlace(place: Place) {
        var recentPlaceList: [Place] = getRecentPlaceList()
        
        // 이미 마지막 인덱스에 있으면
        if recentPlaceList.count > 0 && recentPlaceList[recentPlaceList.count - 1].id == place.id { return }
        
        // 중복되었을 경우 기존 플레이스 제거
        for (i, recentPlace) in recentPlaceList.enumerated() {
            if recentPlace.id == place.id {
                recentPlaceList.remove(at: i)
                break
            }
        }
        
        recentPlaceList.append(place)
        
        // 최대 10개까지 저장 첫번째(오래된) 플레이스 제거
        if recentPlaceList.count > 10 { recentPlaceList.remove(at: 0) }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(recentPlaceList) {
            userDefaults.set(encoded, forKey: "recentPlaceList")
        }
    }
    func removeAllRecentPlaceList() {
        userDefaults.removeObject(forKey: "recentPlaceList")
    }
    
    func getRecentUserList() -> [User] {
        guard let obj = userDefaults.object(forKey: "recentUserList") as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let recentUserList = try? decoder.decode(Array<User>.self, from: obj) else { return [] }
        return recentUserList
    }
    func addRecentUser(user: User) {
        var recentUserList: [User] = getRecentUserList()
        
        // 이미 마지막 인덱스에 있으면
        if recentUserList.count > 0 && recentUserList[recentUserList.count - 1].id == user.id { return }
        
        // 중복되었을 경우 기존 유저 제거
        for (i, recentUser) in recentUserList.enumerated() {
            if recentUser.id == user.id {
                recentUserList.remove(at: i)
                break
            }
        }
        
        recentUserList.append(user)
        
        // 최대 10개까지 저장 첫번째(오래된) 유저 제거
        if recentUserList.count > 10 { recentUserList.remove(at: 0) }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(recentUserList) {
            userDefaults.set(encoded, forKey: "recentUserList")
        }
    }
    func removeAllRecentUserList() {
        userDefaults.removeObject(forKey: "recentUserList")
    }
}
