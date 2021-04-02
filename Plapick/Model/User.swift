//
//  User.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import Foundation


struct User: Codable {
    var u_id: Int
    var u_type: String? = ""
    var u_phone_number: String? = ""
    var u_social_id: String? = ""
    var u_nickname: String
    var u_email: String? = ""
    var u_password: String? = ""
    var u_profile_image: String? = ""
    var u_status: String? = ""
    var u_last_login_platform: String? = ""
    var u_is_logined: String? = "Y"
    var u_device: String? = ""
    
    var u_is_allowed_push_ad: String? = "Y"
    var u_is_allowed_push_posts_comment: String? = "Y"
    var u_is_allowed_push_followed: String? = "Y"
    var u_is_allowed_push_re_comment: String? = "Y"
    
//    var u_is_allowed_follow: String? = "Y"
//    var u_is_allowed_my_pick_comment: String? = "Y"
//    var u_is_allowed_recommended_place: String? = "Y"
//    var u_is_allowed_ad: String? = "Y"
//    var u_is_allowed_event_notice: String? = "Y"
    
    var u_created_date: String? = ""
    var u_updated_date: String? = ""
    var u_connected_date: String? = ""
    
    var u_is_follow: String = "N"
    var u_is_blocked: String = "N"
    
    var u_follower_cnt: Int = 0
    var u_following_cnt: Int = 0
    var u_posts_cnt: Int = 0
    var u_place_cnt: Int = 0
    var u_like_pick_cnt: Int = 0
    var u_like_place_cnt: Int = 0
    
    // 폐기 예정
//    var id: Int
//    var type: String? = ""
//    var socialId: String? = ""
//    var name: String? = ""
//    var nickName: String
//    var email: String? = ""
//    var password: String? = ""
//    var profileImage: String? = ""
//    var status: String? = ""
//    var lastLoginPlatform: String? = ""
//    var isLogined: String? = ""
//
//    var device: String? = ""
//    var isAllowedFollow: String? = "Y"
//    var isAllowedMyPickComment: String? = "Y"
//    var isAllowedRecommendedPlace: String? = "Y"
//    var isAllowedAd: String? = "Y"
//    var isAllowedEventNotice: String? = "Y"
//
//    var createdDate: String? = ""
//    var updatedDate: String? = ""
//    var connectedDate: String
//
//    var isFollow: String
//    var followerCnt: Int
//    var followingCnt: Int
//    var pickCnt: Int
//    var likePickCnt: Int
//    var likePlaceCnt: Int
//    var isBlocked: String
}
