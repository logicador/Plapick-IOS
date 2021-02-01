//
//  HttpResponse.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/24.
//

import Foundation


// MARK: Request
struct IdRequestResult: Codable {
    var result: Int
}

struct StringRequestResult: Codable {
    var result: String
}

struct UserRequestResult: Codable {
    var result: UserResultResponse
}
struct UsersRequestResult: Codable {
    var result: [UserResultResponse]
}

struct PlaceRequestResult: Codable {
    var result: PlaceResultResponse
}
struct PlacesRequestResult: Codable {
    var result: [PlaceResultResponse]
}

struct PickRequestResult: Codable {
    var result: PickResultResponse
}
struct PicksRequestResult: Codable {
    var result: [PickResultResponse]
}

struct PushNotificationDeviceRequestResult: Codable {
    var result: PushNotificationDeviceResultResponse
}

struct GetVersionRequestResult: Codable {
    var result: VersionResultResponse
}


// MARK: Response
struct UserResultResponse: Codable {
    var u_id: Int
    var u_type: String? = ""
    var u_social_id: String? = ""
    var u_name: String? = ""
    var u_nick_name: String
    var u_email: String? = ""
    var u_password: String? = ""
    var u_profile_image: String
    var u_status: String? = ""
    var u_last_login_platform: String? = ""
    var u_is_logined: String? = ""
    var u_created_date: String? = ""
    var u_updated_date: String? = ""
    var u_connected_date: String
    
    var followerCnt: Int = 0
    
    var isFollow: String? = "N"
    
    var pickCnt: Int = 0
}


struct PlaceResultResponse: Codable {
    var p_id: Int
    var p_k_id: Int
    var p_name: String
    var p_category_name: String
    var p_category_group_code: String
    var p_category_group_name: String
    var p_address: String
    var p_road_address: String
    var p_latitude: String
    var p_longitude: String
    var p_phone: String
    var p_ploc_code: String
    var p_cloc_code: String
    
    var pMostPicks: String? = ""
    var pLikeCnt: Int = 0
    var pCommentCnt: Int = 0
    var pPickCnt: Int = 0
    
    var pIsLike: String? = "N"
}


struct PickResultResponse: Codable {
    var pi_id: Int
    var pi_u_id: Int
    var pi_p_id: Int
    var pi_message: String? = ""
    var pi_created_date: String
    var pi_updated_date: String
    
    var piLikeCnt: Int = 0
    var piCommentCnt: Int = 0
    
    // Place
    var p_id: Int
    var p_k_id: Int
    var p_name: String
    var p_category_name: String
    var p_category_group_code: String
    var p_category_group_name: String
    var p_address: String
    var p_road_address: String
    var p_latitude: String
    var p_longitude: String
    var p_phone: String
    var p_ploc_code: String
    var p_cloc_code: String
    
    // User
    var u_id: Int
    var u_nick_name: String
    var u_profile_image: String
    var u_connected_date: String
}


struct PushNotificationDeviceResultResponse: Codable {
    var pnd_is_allowed_follow: String
    var pnd_is_allowed_my_pick_comment: String
    var pnd_is_allowed_recommended_place: String
    var pnd_is_allowed_ad: String
    var pnd_is_allowed_event_notice: String
}

struct VersionResultResponse: Codable {
    var versionCode: Int
    var versionName: String
}
