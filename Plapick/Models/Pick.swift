//
//  Pick.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/06.
//

import Foundation


struct Pick: Codable {
    var id: Int
    var photoUrl: String = ""
    var text: String = ""
    var likeCnt: Int = 0
    var commentCnt: Int = 0
}
