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
    var status: String? = ""
    var lastLoginPlatform: String? = ""
    var isLogined: String? = ""
    var createdDate: String? = ""
    var updatedDate: String? = ""
    var connectedDate: String
    
    var followerCnt: Int = 0
//    var followingCnt: Int? = 0
//    var myLikePickCnt: Int? = 0
//    var myLikePlaceCnt: Int? = 0
    
    var isFollow: String? = "N"
    
    var pickCnt: Int = 0
}
