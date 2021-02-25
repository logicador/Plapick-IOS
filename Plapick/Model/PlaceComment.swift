//
//  PlaceComment.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/23.
//

import Foundation


struct PlaceComment: Codable {
    var id: Int
    var pId: Int
    var comment: String
    var createdDate: String
    var updatedDate: String
    
    var user: User
}
