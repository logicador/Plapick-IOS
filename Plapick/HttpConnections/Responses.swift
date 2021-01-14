//
//  Responses.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/14.
//

import Foundation


// MARK: PlaceList
struct PlaceListResultResponse: Codable {
    var result: [PlaceResponse]
}
struct PlaceResponse: Codable {
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
    var pi_u_id: Int
    var pi_p_id: Int
    var pi_message: String
    var pi_like_cnt: Int
    var pi_comment_cnt: Int
    var pi_created_date: String
    var pi_updated_date: String
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
