//
//  Qna.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/06.
//

import Foundation


struct Qna: Codable {
    var q_id: Int
    var q_u_id: Int
    var q_question: String
    var q_answer: String? = ""
    var q_status: String
    var q_created_date: String
    var q_updated_date: String
    var q_answered_date: String
}
