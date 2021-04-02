//
//  UserComment.swift
//  Plapick
//
//  Created by 서원영 on 2021/04/01.
//

import Foundation


struct UserComment: Codable {
    var targetType: String
    var id: Int
    var targetId: Int
    var uId: Int
    var comment: String
    var createdDate: String
    var updatedDate: String
}
