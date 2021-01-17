//
//  PushNotification.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/17.
//

import Foundation


struct PushNotification: Codable {
    var isAllowedMyPickComment: Bool
    var isAllowedRecommendedPlace: Bool
    var isAllowedAd: Bool
    var isAllowedEventNotice: Bool
}
