//
//  ParentLocation.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/03.
//

import Foundation


struct ParentLocation: Codable {
    var code: String
    var name: String
    var mName: String
    var sName: String
    var childLocationList: [ChildLocation]
}
