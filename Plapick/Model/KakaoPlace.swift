//
//  KakaoPlace.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/03.
//

import Foundation


struct KakaoPlace: Codable {
    var address_name: String
    var category_group_code: String
    var category_group_name: String
    var category_name: String
    var id: String
    var phone: String
    var place_name: String
    var road_address_name: String
    var x: String
    var y: String
    
    var p_like_cnt: Int? = 0
    var p_comment_cnt: Int? = 0
    var p_posts_cnt: Int? = 0
}
