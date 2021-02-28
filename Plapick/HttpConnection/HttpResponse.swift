//
//  HttpResponse.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/24.
//

import Foundation


struct IntRequestResult: Codable {
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
struct KakaoPlacesRequestResult: Codable {
    var result: [KakaoPlaceResultResponse]
}

struct PickRequestResult: Codable {
    var result: PickResultResponse
}
struct PicksRequestResult: Codable {
    var result: [PickResultResponse]
}

struct VersionRequestResult: Codable {
    var result: VersionResultResponse
}

struct QnaRequestResult: Codable {
    var result: QnaResultResponse
}
struct QnasRequestResult: Codable {
    var result: [QnaResultResponse]
}

struct PlaceCommentsRequestResult: Codable {
    var result: [PlaceCommentResultResponse]
}

struct PickCommentsRequestResult: Codable {
    var result: [PickCommentResultResponse]
}


struct UserResultResponse: Codable {
    var u_id: Int
    var u_type: String? = ""
    var u_social_id: String? = ""
    var u_name: String? = ""
    var u_nick_name: String
    var u_email: String? = ""
    var u_password: String? = ""
    var u_profile_image: String? = ""
    var u_status: String? = ""
    var u_last_login_platform: String? = ""
    var u_is_logined: String? = ""
    
    var u_device: String? = ""
    var u_is_allowed_follow: String? = "Y"
    var u_is_allowed_my_pick_comment: String? = "Y"
    var u_is_allowed_recommended_place: String? = "Y"
    var u_is_allowed_ad: String? = "Y"
    var u_is_allowed_event_notice: String? = "Y"
    
    var u_created_date: String? = ""
    var u_updated_date: String? = ""
    var u_connected_date: String
    
    var isFollow: String
    var followerCnt: Int
    var followingCnt: Int
    var pickCnt: Int
    var likePickCnt: Int
    var likePlaceCnt: Int
    var isBlocked: String
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
    
    var picks: String
    var isLike: String
    var likeCnt: Int
    var commentCnt: Int
    var pickCnt: Int
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

struct PickResultResponse: Codable {
    var pi_id: Int
    var pi_u_id: Int
    var pi_p_id: Int
    var pi_message: String? = ""
    var pi_created_date: String
    var pi_updated_date: String
    
    var u_id: Int
    var u_nick_name: String
    var u_profile_image: String? = ""
    var u_connected_date: String
    
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
    
    var isLike: String
    var likeCnt: Int
    var commentCnt: Int
    var isBlocked: String
    
    var uIsFollow: String
    var uFollowerCnt: Int
    var uFollowingCnt: Int
    var uPickCnt: Int
    var uLikePickCnt: Int
    var uLikePlaceCnt: Int
    var uIsBlocked: String
    
    var pPicks: String
    var pIsLike: String
    var pLikeCnt: Int
    var pCommentCnt: Int
    var pPickCnt: Int
}

struct VersionResultResponse: Codable {
    var versionCode: Int
    var versionName: String
}

struct QnaResultResponse: Codable {
    var q_id: Int
    var q_u_id: Int
    var q_title: String
    var q_content: String
    var q_answer: String? = ""
    var q_status: String
    var q_created_date: String
    var q_updated_date: String
    var q_answered_date: String
}

struct PlaceCommentResultResponse: Codable {
    var mcp_id: Int
    var mcp_u_id: Int
    var mcp_p_id: Int
    var mcp_comment: String
    var mcp_created_date: String
    var mcp_updated_date: String
    
    var u_nick_name: String
    var u_profile_image: String
    var u_connected_date: String
    
    var isFollow: String
    var followerCnt: Int
    var followingCnt: Int
    var pickCnt: Int
    var likePickCnt: Int
    var likePlaceCnt: Int
    var isBlocked: String
}

struct PickCommentResultResponse: Codable {
    var mcpi_id: Int
    var mcpi_u_id: Int
    var mcpi_pi_id: Int
    var mcpi_comment: String
    var mcpi_created_date: String
    var mcpi_updated_date: String
    
    var u_nick_name: String
    var u_profile_image: String
    var u_connected_date: String
    
    var isFollow: String
    var followerCnt: Int
    var followingCnt: Int
    var pickCnt: Int
    var likePickCnt: Int
    var likePlaceCnt: Int
    var isBlocked: String
}
