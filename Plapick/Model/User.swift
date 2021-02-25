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
    var profileImage: String? = ""
    var status: String? = ""
    var lastLoginPlatform: String? = ""
    var isLogined: String? = ""
    var createdDate: String? = ""
    var updatedDate: String? = ""
    var connectedDate: String
    
    var isFollow: String
    var followerCnt: Int
    var followingCnt: Int
    var pickCnt: Int
    var likePickCnt: Int
    var likePlaceCnt: Int
}
