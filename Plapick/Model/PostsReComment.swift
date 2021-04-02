//
//  PostsReComment.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/31.
//

import Foundation


struct PostsReComment: Codable {
    var porc_id: Int
    var porc_po_id: Int
    var porc_poc_id: Int
    var porc_u_id: Int
    var porc_target_u_id: Int? = nil
    var porc_comment: String
    var porc_created_date: String
    var porc_updated_date: String
    
    var u_nickname: String
    var u_profile_image: String? = ""
    
    var porc_target_u_nickname: String? = ""
}
