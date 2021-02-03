//
//  Comment.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/01.
//

import Foundation


struct Comment: Codable {
    var id: Int
    var uId: Int
    var pId: Int? = 0
    var piId: Int? = 0
    var comment: String
    var createdDate: String
    var updatedDate: String
    
    var nickName: String
    var profileImage: String
}
