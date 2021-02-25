//
//  PickComments.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/25.
//

import Foundation


struct PickComment: Codable {
    var id: Int
    var piId: Int
    var comment: String
    var createdDate: String
    var updatedDate: String
    
    var user: User
}
