//
//  User.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/11.
//

import Foundation


struct User: Codable {
    var id: Int
    var type: String? = ""
    var socialId: String? = ""
    var name: String? = ""
    var nickName: String
    var email: String? = ""
    var password: String? = ""
    var profileImage: String
//    var likeCnt: Int
//    var followerCnt: Int
//    var followingCnt: Int
//    var newsCnt: Int
//    var myNewsCnt: Int
    var status: String? = ""
    var lastLoginPlatform: String? = ""
    var isLogined: String? = ""
    var createdDate: String? = ""
    var updatedDate: String? = ""
    var connectedDate: String
    
    var newsCnt: Int? = 0
    var myNewsCnt: Int? = 0
    var myLikePickCnt: Int? = 0
    var myLikePlaceCnt: Int? = 0
    
    var isNewsUser: String? = "N"
    
    var pickCnt: Int? = 0
//    var newsCnt: Int? = 0
}
