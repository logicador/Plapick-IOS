//
//  PlaceComment.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/23.
//

import Foundation


struct PlaceComment: Codable {
    var pc_id: Int
    var pc_p_id: Int
    var pc_u_id: Int
    var pc_comment: String
    var pc_created_date: String
    var pc_updated_date: String
    
    var u_nickname: String
    var u_profile_image: String? = ""
}
