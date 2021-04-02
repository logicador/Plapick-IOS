//
//  Posts.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/24.
//

import Foundation


struct Posts: Codable {
    var po_id: Int
    var po_u_id: Int
    var po_p_id: Int
    var po_message: String
    var po_created_date: String
    var po_updated_date: String
    
    var po_is_like: String
    
    var po_like_cnt: Int
    var po_comment_cnt: Int
    var po_re_comment_cnt: Int
    
    var poi: String
    
    var p_k_id: Int
    var p_name: String
    
    var u_nickname: String
    var u_profile_image: String? = ""
}
