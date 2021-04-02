//
//  Place.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import Foundation


struct Place: Codable {
    var p_id: Int
    var p_k_id: Int
    var p_name: String
    var p_category_name: String
    var p_category_group_code: String
    var p_category_group_name: String
    var p_address: String
    var p_road_address: String
    var p_latitude: String
    var p_longitude: String
    var p_phone: String
    var p_ploc_code: String
    var p_cloc_code: String
    
    var p_is_like: String
    
    var p_like_cnt: Int
    var p_comment_cnt: Int
    var p_posts_cnt: Int
    
    var postsList: [Posts]? = []
}
