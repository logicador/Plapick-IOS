//
//  Qna.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/06.
//

import Foundation


struct Qna: Codable {
    var id: Int
    var uId: Int
    var title: String
    var content: String
    var answer: String? = ""
    var status: String
    var createdDate: String
    var updatedDate: String
    var answeredDate: String
}
