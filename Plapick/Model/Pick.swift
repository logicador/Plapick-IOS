//
//  Pick.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/06.
//

import Foundation


struct Pick: Codable {
    var id: Int
    var uId: Int
    var pId: Int
    var message: String? = ""
    var createdDate: String
    var updatedDate: String
    
    var isLike: String
    var likeCnt: Int
    var commentCnt: Int
    
    var user: User
    var place: Place
}
