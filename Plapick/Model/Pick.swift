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
    var pId: Int
    var uId: Int
    var message: String? = ""
    var likeCnt: Int
    var commentCnt: Int
    var createdDate: String
    var updatedDate: String
}
