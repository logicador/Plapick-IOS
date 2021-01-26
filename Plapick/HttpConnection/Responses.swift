//
//  Responses.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/14.
//

import Foundation


// MARK: PlaceList
struct PlaceListResultResponse: Codable {
    var result: [KakaoPlaceResponse]
}
struct KakaoPlaceResponse: Codable {
    var address_name: String
    var category_group_code: String
    var category_group_name: String
    var category_name: String
    var distance: String
    var id: String
    var phone: String
    var place_name: String
    var place_url: String
    var road_address_name: String
    var x: String
    var y: String
    var p_id: Int
    var p_like_cnt: Int
    var p_pick_cnt: Int
}

// MARK: Place
//struct PlaceResultResponse: Codable {
//    var result: PlaceResponse
//}
struct PlaceResponse: Codable {
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
    var p_like_cnt: Int
    var p_pick_cnt: Int
    var p_ploc_code: String
    var p_cloc_code: String
}


// MARK: UserProfile
struct UserProfileResultResponse: Codable {
    var result: UserProfileResponse
}
struct UserProfileResponse: Codable {
    var u_id: Int
    var u_type: String
    var u_social_id: String
    var u_name: String
    var u_nick_name: String
    var u_email: String
    var u_profile_image: String
    var u_like_cnt: Int
    var u_follower_cnt: Int
    var u_following_cnt: Int
    var u_status: String
    var u_created_date: String
    var u_updated_date: String
}

// MARK: PickList
struct PickListResultResponse: Codable {
    var result: [PickResponse]
}
struct PickResponse: Codable {
    var pi_id: Int
    var pi_p_id: Int
    var pi_message: String
    var pi_like_cnt: Int
    var pi_comment_cnt: Int
    var pi_created_date: String
    var pi_updated_date: String
    var u_id: Int
    var u_type: String
    var u_social_id: String
    var u_name: String
    var u_nick_name: String
    var u_email: String
    var u_profile_image: String
    var u_like_cnt: Int
    var u_follower_cnt: Int
    var u_following_cnt: Int
    var u_status: String
    var u_created_date: String
    var u_updated_date: String
}


// MARK: UploadImage
struct UploadImageResultResponse: Codable {
    var result: Int
}


// MARK Version
struct VersionResultResponse: Codable {
    var result: VersionResponse
}
struct VersionResponse: Codable {
    var version: String
    var build: Int
}


// MARK: PushNotification
struct PushNotificationResultResponse: Codable {
    var result: PushNotificationResponse
}
struct PushNotificationResponse: Codable {
    var pnd_is_allowed_my_pick_comment: String
    var pnd_is_allowed_recommended_place: String
    var pnd_is_allowed_ad: String
    var pnd_is_allowed_event_notice: String
}
