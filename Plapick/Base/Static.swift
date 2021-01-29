//
//  Static.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/10.
//

import Foundation
import UIKit


public let PLAPICK_URL = "http://121.138.167.244:3001" // "http://logicador.asuscomm.com:3001" // "http://plapick.com"
public let IMAGE_URL = PLAPICK_URL + "/images"
public let API_URL = PLAPICK_URL + "/api"
public let KAKAO_NATIVE_APP_KEY = "746689b818804d4d3509d851a17a37c0"
public let PLAPICK_IOS_APP_KEY = "6ED2BE2B40D94EB535509B7C441C2B3F"

public let HTTP_TIMEOUT: TimeInterval = 10

public let COMPRESS_IMAGE_QUALITY: CGFloat = 0.2
public let LINE_WIDTH: CGFloat = 0.4
public let LINE_COLOR: UIColor = UIColor.separator

public let SPACE_XXXXXXL: CGFloat = 120
public let SPACE_XXXXXL: CGFloat = 90
public let SPACE_XXXXL: CGFloat = 70
public let SPACE_XXXL: CGFloat = 50
public let SPACE_XXL: CGFloat = 40
public let SPACE_XL: CGFloat = 30
public let SPACE_L: CGFloat = 25
public let SPACE: CGFloat = 20
public let SPACE_S: CGFloat = 15
public let SPACE_XS: CGFloat = 10
public let SPACE_XXS: CGFloat = 5
public let SPACE_XXXS: CGFloat = 4
public let SPACE_XXXXS: CGFloat = 3
public let SPACE_XXXXXS: CGFloat = 2
public let SPACE_XXXXXXS: CGFloat = 1

public let ICON_SIZE_XS: CGFloat = 18

public let CONTENTS_RATIO_XXXL: CGFloat = 0.98
public let CONTENTS_RATIO_XXL: CGFloat = 0.96
public let CONTENTS_RATIO_XL: CGFloat = 0.94
public let CONTENTS_RATIO_L: CGFloat = 0.92
public let CONTENTS_RATIO: CGFloat = 0.9
public let CONTENTS_RATIO_S: CGFloat = 0.88
public let CONTENTS_RATIO_XS: CGFloat = 0.86
public let CONTENTS_RATIO_XXS: CGFloat = 0.84
public let CONTENTS_RATIO_XXXS: CGFloat = 0.8
public let CONTENTS_RATIO_XXXXS: CGFloat = 0.76
public let CONTENTS_RATIO_XXXXXS: CGFloat = 0.72
public let CONTENTS_RATIO_XXXXXXS: CGFloat = 0.66

public let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height

//public let IMAGE_SLIDER_WIDTH: CGFloat = SCREEN_WIDTH // * 0.9
//public let IMAGE_SLIDER_HEIGHT: CGFloat = SCREEN_WIDTH * 0.7

public let KOR_CHAR_LIST: [Character] = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ", "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ", "ㄳ", "ㄵ", "ㄶ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ"]
