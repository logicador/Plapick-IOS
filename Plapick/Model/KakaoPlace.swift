//
//  KakaoPlace.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/03.
//

import Foundation


struct KakaoPlace: Codable {
    var id: String
    var placeName: String
    var categoryName: String
    var categoryGroupCode: String
    var categoryGroupName: String
    var addressName: String
    var roadAddressName: String
    var phone: String
    var latitude: String
    var longitude: String
}
