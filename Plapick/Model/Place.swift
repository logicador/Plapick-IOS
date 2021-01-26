//
//  Place.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import Foundation


struct Place: Codable {
    var id: Int
    var kId: Int
    var name: String? = ""
    var categoryName: String? = ""
    var categoryGroupName: String? = ""
    var categoryGroupCode: String? = ""
    var address: String? = ""
    var roadAddress: String? = ""
    var latitude: String? = ""
    var longitude: String? = ""
    var phone: String? = ""
    var likeCnt: Int
    var pickCnt: Int
    var commentCnt: Int
    var plocCode: String? = ""
    var clocCode: String? = ""
    var mostPickList: [MostPick]? = []
    
    var isLike: String = "N"
    var isComment: String = "N"
}
