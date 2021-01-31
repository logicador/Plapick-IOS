//
//  Pick.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/06.
//

import Foundation


struct Pick: Codable {
    var user: User? = nil
    var place: Place? = nil
    
    var id: Int
    var uId: Int
    var pId: Int
    var message: String
    var createdDate: String
    var updatedDate: String
    
    var likeCnt: Int? = 0
    var commentCnt: Int? = 0
}
