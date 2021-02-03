//
//  HttpResponse.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/24.
//

import Foundation


// MARK: REQ - Int
struct IntRequestResult: Codable {
    var result: Int
}

// MARK: REQ - String
struct StringRequestResult: Codable {
    var result: String
}

// MARK: REQ - User
struct UserRequestResult: Codable {
    var result: UserResultResponse
}
struct UsersRequestResult: Codable {
    var result: [UserResultResponse]
}

// MARK: REQ - Place
struct PlaceRequestResult: Codable {
    var result: PlaceResultResponse
}
struct PlacesRequestResult: Codable {
    var result: [PlaceResultResponse]
}
struct KakaoPlacesRequestResult: Codable {
    var result: [KakaoPlaceResultResponse]
}

// MARK: REQ - Pick
struct PickRequestResult: Codable {
    var result: PickResultResponse
}
struct PicksRequestResult: Codable {
    var result: [PickResultResponse]
}

// MARK: REQ - Comment
struct CommentsRequestResult: Codable {
    var result: [CommentResultResponse]
}

// MARK: REQ - PushNotificationDevice
struct PushNotificationDeviceRequestResult: Codable {
    var result: PushNotificationDeviceResultResponse
}

// MARK: REQ - Version
struct GetVersionRequestResult: Codable {
    var result: VersionResultResponse
}


// MARK: RES - User
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
    
    var uFollowerCnt: Int = 0
    var uPickCnt: Int = 0
    var uIsFollow: String? = "N"
}

// MARK: RES - Place
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

struct KakaoPlaceResultResponse: Codable {
    var id: String
    var place_name: String
    var category_name: String
    var category_group_code: String
    var category_group_name: String
    var address_name: String
    var road_address_name: String
    var phone: String
    var x: String
    var y: String
}

// MARK: RES - Pick
struct PickResultResponse: Codable {
    var pi_id: Int
    var pi_u_id: Int
    var pi_p_id: Int
    var pi_message: String? = ""
    var pi_created_date: String
    var pi_updated_date: String
    
    var piLikeCnt: Int = 0
    var piCommentCnt: Int = 0
    var piIsLike: String? = "N"
    
    // Place
//    var p_id: Int
//    var p_k_id: Int
//    var p_name: String
//    var p_category_name: String
//    var p_category_group_code: String
//    var p_category_group_name: String
//    var p_address: String
//    var p_road_address: String
//    var p_latitude: String
//    var p_longitude: String
//    var p_phone: String
//    var p_ploc_code: String
//    var p_cloc_code: String
    
    // User
//    var u_id: Int
//    var u_nick_name: String
//    var u_profile_image: String
//    var u_connected_date: String
}

// MARK: RES - PushNotificationDevice
struct PushNotificationDeviceResultResponse: Codable {
    var pnd_is_allowed_follow: String
    var pnd_is_allowed_my_pick_comment: String
    var pnd_is_allowed_recommended_place: String
    var pnd_is_allowed_ad: String
    var pnd_is_allowed_event_notice: String
}

// MARK: RES - Version
struct VersionResultResponse: Codable {
    var versionCode: Int
    var versionName: String
}

//struct PlaceInfoResultResponse: Codable {
//    var place: PlaceResultResponse
//    var pickList: [PickResultResponse]
//    var commentList: [PlaceCommentResultResponse]
//}

// MARK: RES - Comment
struct CommentResultResponse: Codable {
    var id: Int
    var u_id: Int
    var p_id: Int? = 0
    var pi_id: Int? = 0
    var comment: String
    var created_date: String
    var updated_date: String
    
    var u_nick_name: String
    var u_profile_image: String
}

// MARK: RES - KakaoPlace
