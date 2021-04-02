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


class App {
    
    // MARK: Property
    var userDefaults = UserDefaults.standard
    
    // 로그인 여부
    func isLogined() -> Bool {
        return self.userDefaults.bool(forKey: "isLogined")
    }
    
    // 로그인 정보 저장 여부
    func isSaveLoginInfo() -> Bool {
        return self.userDefaults.bool(forKey: "isSaveLoginInfo")
    }
    func setIsSaveLoginInfo(isSave: Bool) {
        userDefaults.set(isSave, forKey: "isSaveLoginInfo")
    }
    
    // 저장된 로그인 이메일
    func getLoginEmail() -> String {
        return self.userDefaults.string(forKey: "loginEmail") ?? ""
    }
    func setLoginEmail(email: String) {
        userDefaults.set(email, forKey: "loginEmail")
    }
    
    // 저장된 로그인 비밀번호
    func getLoginPassword() -> String {
        return self.userDefaults.string(forKey: "loginPassword") ?? ""
    }
    func setLoginPassword(password: String) {
        userDefaults.set(password, forKey: "loginPassword")
    }
    
    // 알림 허용 다시 보지 않기 여부
    func getIsDontLookAgainAccessAlarm() -> Bool {
        return userDefaults.bool(forKey: "isDontLookAgainAccessAlarm")
    }
    func setIsDontLookAgainAccessAlarm(isDontLookAgain: Bool) {
        userDefaults.set(isDontLookAgain, forKey: "isDontLookAgainAccessAlarm")
    }
    
    // 로그인된 사용자 아이디 가져오기
    func getUserId() -> Int {
        return userDefaults.integer(forKey: "u_id")
    }
    // 로그인된 사용자 닉네임 가져오기
    func getUserNickName() -> String {
        return userDefaults.string(forKey: "u_nickname") ?? ""
    }
    func setUserNickname(nickname: String) {
        userDefaults.set(nickname, forKey: "u_nickname")
    }
    // 로그인된 사용자 프로필 이미지 가져오기
    func getUserProfileImage() -> String {
        return userDefaults.string(forKey: "u_profile_image") ?? ""
    }
    func setUserProfileImage(profileImage: String) {
        userDefaults.set(profileImage, forKey: "u_profile_image")
    }
    // 로그인된 사용자 게시물 개수 가져오기
    func getUserPostsCnt() -> Int {
        return userDefaults.integer(forKey: "u_posts_cnt")
    }
    // 로그인된 사용자 플레이스 개수 가져오기
    func getUserPlaceCnt() -> Int {
        return userDefaults.integer(forKey: "u_place_cnt")
    }
    // 로그인된 사용자 팔로워 개수 가져오기
    func getUserFollowerCnt() -> Int {
        return userDefaults.integer(forKey: "u_follower_cnt")
    }
    // 로그인된 사용자 팔로잉 개수 가져오기
    func getUserFollowingCnt() -> Int {
        return userDefaults.integer(forKey: "u_following_cnt")
    }
    
    // 앱 버전 정보
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
    
    // 로그인된 사용자 가져오기
    func getUser() -> User {
        let u_id = userDefaults.integer(forKey: "u_id")
        let u_type = userDefaults.string(forKey: "u_type") ?? ""
        let u_phone_number = userDefaults.string(forKey: "u_phone_number") ?? ""
        let u_social_id = userDefaults.string(forKey: "u_social_id") ?? ""
        let u_nickname = userDefaults.string(forKey: "u_nickname") ?? ""
        let u_email = userDefaults.string(forKey: "u_email") ?? ""
        let u_password = userDefaults.string(forKey: "u_password") ?? ""
        let u_profile_image = userDefaults.string(forKey: "u_profile_image") ?? ""
        let u_status = userDefaults.string(forKey: "u_status") ?? ""
        let u_last_login_platform = userDefaults.string(forKey: "u_last_login_platform") ?? ""
        let u_is_logined = userDefaults.string(forKey: "u_is_logined") ?? "Y"
        let u_device = userDefaults.string(forKey: "u_device") ?? ""
        
        let u_is_allowed_push_ad = userDefaults.string(forKey: "u_is_allowed_push_ad") ?? "Y"
        let u_is_allowed_push_posts_comment = userDefaults.string(forKey: "u_is_allowed_push_posts_comment") ?? "Y"
        let u_is_allowed_push_followed = userDefaults.string(forKey: "u_is_allowed_push_followed") ?? "Y"
        let u_is_allowed_push_re_comment = userDefaults.string(forKey: "u_is_allowed_push_re_comment") ?? "Y"
        
        let u_created_date: String = userDefaults.string(forKey: "u_created_date") ?? ""
        let u_updated_date: String = userDefaults.string(forKey: "u_updated_date") ?? ""
        let u_connected_date: String = userDefaults.string(forKey: "u_connected_date") ?? ""
        
        let u_follower_cnt = userDefaults.integer(forKey: "u_follower_cnt")
        let u_following_cnt = userDefaults.integer(forKey: "u_following_cnt")
        let u_posts_cnt = userDefaults.integer(forKey: "u_posts_cnt")
        let u_place_cnt = userDefaults.integer(forKey: "u_place_cnt")
        let u_like_pick_cnt = userDefaults.integer(forKey: "u_like_pick_cnt")
        let u_like_place_cnt = userDefaults.integer(forKey: "u_like_place_cnt")
        let u_is_follow: String = userDefaults.string(forKey: "u_is_follow") ?? "N"
        let u_is_blocked: String = userDefaults.string(forKey: "u_is_blocked") ?? "N"
        
        let user = User(u_id: u_id, u_type: u_type, u_phone_number: u_phone_number, u_social_id: u_social_id, u_nickname: u_nickname, u_email: u_email, u_password: u_password, u_profile_image: u_profile_image, u_status: u_status, u_last_login_platform: u_last_login_platform, u_is_logined: u_is_logined, u_device: u_device, u_is_allowed_push_ad: u_is_allowed_push_ad, u_is_allowed_push_posts_comment: u_is_allowed_push_posts_comment, u_is_allowed_push_followed: u_is_allowed_push_followed, u_is_allowed_push_re_comment: u_is_allowed_push_re_comment, u_created_date: u_created_date, u_updated_date: u_updated_date, u_connected_date: u_connected_date, u_is_follow: u_is_follow, u_is_blocked: u_is_blocked, u_follower_cnt: u_follower_cnt, u_following_cnt: u_following_cnt, u_posts_cnt: u_posts_cnt, u_place_cnt: u_place_cnt, u_like_pick_cnt: u_like_pick_cnt, u_like_place_cnt: u_like_place_cnt)
        return user
    }
    
    // 로그인
    func login(user: User) {
        userDefaults.set(true, forKey: "isLogined")
        
        userDefaults.set(user.u_id, forKey: "u_id")
        userDefaults.set(user.u_type, forKey: "u_type")
        userDefaults.set(user.u_phone_number, forKey: "u_phone_number")
        userDefaults.set(user.u_social_id, forKey: "u_social_id")
        userDefaults.set(user.u_nickname, forKey: "u_nickname")
        userDefaults.set(user.u_email, forKey: "u_email")
        userDefaults.set(user.u_password, forKey: "u_password")
        userDefaults.set(user.u_profile_image, forKey: "u_profile_image")
        userDefaults.set(user.u_status, forKey: "u_status")
        userDefaults.set(user.u_last_login_platform, forKey: "u_last_login_platform")
        userDefaults.set(user.u_is_logined, forKey: "u_is_logined")
        userDefaults.set(user.u_device, forKey: "u_device")
        
        userDefaults.set(user.u_is_allowed_push_ad, forKey: "u_is_allowed_push_ad")
        userDefaults.set(user.u_is_allowed_push_posts_comment, forKey: "u_is_allowed_push_posts_comment")
        userDefaults.set(user.u_is_allowed_push_followed, forKey: "u_is_allowed_push_followed")
        userDefaults.set(user.u_is_allowed_push_re_comment, forKey: "u_is_allowed_push_re_comment")
        
        userDefaults.set(user.u_created_date, forKey: "u_created_date")
        userDefaults.set(user.u_updated_date, forKey: "u_updated_date")
        userDefaults.set(user.u_connected_date, forKey: "u_connected_date")
        
        userDefaults.set(user.u_follower_cnt, forKey: "u_follower_cnt")
        userDefaults.set(user.u_following_cnt, forKey: "u_following_cnt")
        userDefaults.set(user.u_posts_cnt, forKey: "u_posts_cnt")
        userDefaults.set(user.u_place_cnt, forKey: "u_place_cnt")
        userDefaults.set(user.u_like_pick_cnt, forKey: "u_like_pick_cnt")
        userDefaults.set(user.u_like_place_cnt, forKey: "u_like_place_cnt")
        userDefaults.set(user.u_is_follow, forKey: "u_is_follow")
        userDefaults.set(user.u_is_blocked, forKey: "u_is_blocked")
    }
    
    // 로그아웃
    func logout() {
        userDefaults.set(false, forKey: "isLogined")
        
        userDefaults.removeObject(forKey: "u_id")
        userDefaults.removeObject(forKey: "u_type")
        userDefaults.removeObject(forKey: "u_phone_number")
        userDefaults.removeObject(forKey: "u_social_id")
        userDefaults.removeObject(forKey: "u_nickname")
        userDefaults.removeObject(forKey: "u_email")
        userDefaults.removeObject(forKey: "u_password")
        userDefaults.removeObject(forKey: "u_profile_image")
        userDefaults.removeObject(forKey: "u_status")
        userDefaults.removeObject(forKey: "u_last_login_platform")
        userDefaults.removeObject(forKey: "u_is_logined")
        userDefaults.removeObject(forKey: "u_device")
        
        userDefaults.removeObject(forKey: "u_is_allowed_push_ad")
        userDefaults.removeObject(forKey: "u_is_allowed_push_posts_comment")
        userDefaults.removeObject(forKey: "u_is_allowed_push_followed")
        userDefaults.removeObject(forKey: "u_is_allowed_push_re_comment")
        
        userDefaults.removeObject(forKey: "u_created_date")
        userDefaults.removeObject(forKey: "u_updated_date")
        userDefaults.removeObject(forKey: "u_connected_date")
        
        userDefaults.removeObject(forKey: "u_follower_cnt")
        userDefaults.removeObject(forKey: "u_following_cnt")
        userDefaults.removeObject(forKey: "u_posts_cnt")
        userDefaults.removeObject(forKey: "u_place_cnt")
        userDefaults.removeObject(forKey: "u_like_pick_cnt")
        userDefaults.removeObject(forKey: "u_like_place_cnt")
        userDefaults.removeObject(forKey: "u_is_follow")
        userDefaults.removeObject(forKey: "u_is_blocked")
        
        userDefaults.removeObject(forKey: "recentPlaceList")
        userDefaults.removeObject(forKey: "recentUserList")
        
        userDefaults.removeObject(forKey: "isAgreePosting")
    }
}
