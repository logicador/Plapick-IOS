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

struct GetPersonalRequestResult: Codable {
    var result: PersonalResultResponse
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
    var u_profile_image: String? = ""
//    var u_like_cnt: Int
//    var u_follower_cnt: Int
//    var u_following_cnt: Int
//    var u_news_cnt: Int
//    var u_my_news_cnt: Int
    var u_status: String? = ""
    var u_last_login_platform: String? = ""
    var u_is_logined: String? = ""
    var u_created_date: String? = ""
    var u_updated_date: String? = ""
    var u_connected_date: String
    
    var newsCnt: Int? = 0
    var myNewsCnt: Int? = 0
    var myLikePickCnt: Int? = 0
    var myLikePlaceCnt: Int? = 0
    
    var isNewsUser: String? = "N"
    
    var pickCnt: Int? = 0
//    var newsCnt: Int? = 0
}


struct PlaceResultResponse: Codable {
    var p_id: Int
    var p_k_id: Int
    var p_name: String? = ""
    var p_category_name: String? = ""
    var p_category_group_code: String? = ""
    var p_category_group_name: String? = ""
    var p_address: String? = ""
    var p_road_address: String? = ""
    var p_latitude: String? = ""
    var p_longitude: String? = ""
    var p_phone: String? = ""
    var p_like_cnt: Int
    var p_pick_cnt: Int
    var p_comment_cnt: Int
    var p_ploc_code: String? = ""
    var p_cloc_code: String? = ""
    var mostPicks: String? = ""
    
    var address_name: String? = ""
    var category_group_code: String? = ""
    var category_group_name: String? = ""
    var category_name: String? = ""
    var phone: String? = ""
    var place_name: String? = ""
    var place_url: String? = ""
    var road_address_name: String? = ""
    var x: String? = ""
    var y: String? = ""
    
    var isLike: String? = "N"
    var isComment: String? = "N"
}


struct PickResultResponse: Codable {
    var pi_id: Int
    var pi_u_id: Int
    var pi_p_id: Int
    var pi_message: String? = ""
    var pi_like_cnt: Int
    var pi_comment_cnt: Int
    var pi_created_date: String
    var pi_updated_date: String
    
    var p_id: Int
    var p_k_id: Int
    var p_name: String? = ""
    var p_category_name: String? = ""
    var p_category_group_code: String? = ""
    var p_category_group_name: String? = ""
    var p_address: String? = ""
    var p_road_address: String? = ""
    var p_latitude: String? = ""
    var p_longitude: String? = ""
    var p_phone: String? = ""
    var p_like_cnt: Int
    var p_pick_cnt: Int
    var p_comment_cnt: Int
    var p_ploc_code: String? = ""
    var p_cloc_code: String? = ""
    
    var u_id: Int
    var u_nick_name: String
    var u_profile_image: String? = ""
//    var u_like_cnt: Int
//    var u_follower_cnt: Int
//    var u_following_cnt: Int
//    var u_news_cnt: Int
//    var u_my_news_cnt: Int
    var u_connected_date: String
}


struct PushNotificationDeviceResultResponse: Codable {
    var pnd_is_allowed_news: String
//    var pnd_is_allowed_follow: String
    var pnd_is_allowed_my_pick_comment: String
    var pnd_is_allowed_recommended_place: String
    var pnd_is_allowed_ad: String
    var pnd_is_allowed_event_notice: String
}

struct VersionResultResponse: Codable {
    var versionCode: Int
    var versionName: String
}

struct PersonalResultResponse: Codable {
    var type: String
    var email: String
    var name: String
}
