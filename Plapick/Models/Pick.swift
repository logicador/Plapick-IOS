//
//  Pick.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/06.
//

import Foundation


struct Pick: Codable {
    var id: Int
    var uId: Int = 0
    var uNickName: String = ""
    var pId: Int = 0
    var message: String = ""
    var photoUrl: String = ""
    var likeCnt: Int = 0
    var commentCnt: Int = 0
    var createdDate: String = ""
    var updatedDate: String = ""
}
