//
//  PostsComment.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/31.
//

import Foundation


struct PostsComment: Codable {
    var poc_id: Int
    var poc_po_id: Int
    var poc_u_id: Int
    var poc_comment: String
    var poc_created_date: String
    var poc_updated_date: String
    
    var u_nickname: String
    var u_profile_image: String? = ""
    
    var poc_re_comment_cnt: Int
}
