//
//  Place.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import Foundation


struct Place: Codable {
    var id: Int
    var kId: String
    var name: String
    var visibleAddress: String
    var address: String
    var roadAddress: String
    var category: String
    var categoryName: String
    var categoryGroupName: String
    var categoryGroupCode: String
    var phone: String
    var lat: Double
    var lng: Double
    var hotPickList: [Pick] = []
    var likeCnt: Int = 0
    var pickCnt: Int = 0
}
