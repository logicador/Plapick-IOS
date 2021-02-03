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

public let DEFAULT_LATITUDE: String = "37.501286"
public let DEFAULT_LONGITUDE: String = "126.986836"

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

public let NO_DATA_SPACE: CGFloat = SPACE_XXXL

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

public let MOST_PICKS_MAX_COUNT: Int = 10

public let KOR_CHAR_LIST: [Character] = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ", "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ", "ㄳ", "ㄵ", "ㄶ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ"]

let LOCATIONS: [ParentLocation] = [
    ParentLocation(code: "101", name: "서울특별시", mName: "서울시", sName: "서울", childLocationList: [
        ChildLocation(code: "101010", name: "강남구", sName: "강남"),
        ChildLocation(code: "101020", name: "강동구", sName: "강동"),
        ChildLocation(code: "101030", name: "강북구", sName: "강북"),
        ChildLocation(code: "101040", name: "강서구", sName: "강서"),
        ChildLocation(code: "101050", name: "관악구", sName: "관악"),
        ChildLocation(code: "101060", name: "광진구", sName: "광진"),
        ChildLocation(code: "101070", name: "구로구", sName: "구로"),
        ChildLocation(code: "101080", name: "금천구", sName: "금천"),
        ChildLocation(code: "101090", name: "노원구", sName: "노원"),
        ChildLocation(code: "101100", name: "도봉구", sName: "도봉"),
        ChildLocation(code: "101110", name: "동대문구", sName: "동대문"),
        ChildLocation(code: "101120", name: "동작구", sName: "동작"),
        ChildLocation(code: "101130", name: "마포구", sName: "마포"),
        ChildLocation(code: "101140", name: "서대문구", sName: "서대문"),
        ChildLocation(code: "101150", name: "서초구", sName: "서초"),
        ChildLocation(code: "101160", name: "성동구", sName: "성동"),
        ChildLocation(code: "101170", name: "성북구", sName: "성북"),
        ChildLocation(code: "101180", name: "송파구", sName: "송파"),
        ChildLocation(code: "101190", name: "양천구", sName: "양천"),
        ChildLocation(code: "101200", name: "영등포구", sName: "영등포"),
        ChildLocation(code: "101210", name: "용산구", sName: "용산"),
        ChildLocation(code: "101220", name: "은평구", sName: "은평"),
        ChildLocation(code: "101230", name: "종로구", sName: "종로"),
        ChildLocation(code: "101240", name: "중구", sName: "중구"),
        ChildLocation(code: "101250", name: "중랑구", sName: "중랑")
    ]),
    ParentLocation(code: "102", name: "경기도", mName: "경기시", sName: "경기", childLocationList: [
        ChildLocation(code: "102010", name: "가평군", sName: "가평"),
        ChildLocation(code: "102020", name: "고양시", sName: "고양"),
        ChildLocation(code: "102060", name: "과천시", sName: "과천"),
        ChildLocation(code: "102070", name: "광명시", sName: "광명"),
        ChildLocation(code: "102080", name: "광주시", sName: "광주"),
        ChildLocation(code: "102090", name: "구리시", sName: "구리"),
        ChildLocation(code: "102100", name: "군포시", sName: "군포"),
        ChildLocation(code: "102110", name: "김포시", sName: "김포"),
        ChildLocation(code: "102120", name: "남양주시", sName: "남양주"),
        ChildLocation(code: "102130", name: "동두천시", sName: "동두천"),
        ChildLocation(code: "102140", name: "부천시", sName: "부천"),
        ChildLocation(code: "102180", name: "성남시", sName: "성남"),
        ChildLocation(code: "102220", name: "수원시", sName: "수원"),
        ChildLocation(code: "102270", name: "시흥시", sName: "시흥"),
        ChildLocation(code: "102280", name: "안산시", sName: "안산"),
        ChildLocation(code: "102310", name: "안성시", sName: "안성"),
        ChildLocation(code: "102320", name: "안양시", sName: "안양"),
        ChildLocation(code: "102350", name: "양주시", sName: "양주"),
        ChildLocation(code: "102360", name: "양평군", sName: "양평"),
        ChildLocation(code: "102370", name: "여주시", sName: "여주"),
        ChildLocation(code: "102380", name: "연천군", sName: "연천"),
        ChildLocation(code: "102390", name: "오산시", sName: "오산"),
        ChildLocation(code: "102400", name: "용인시", sName: "용인"),
        ChildLocation(code: "102440", name: "의왕시", sName: "의왕"),
        ChildLocation(code: "102450", name: "의정부시", sName: "의정부"),
        ChildLocation(code: "102460", name: "이천시", sName: "이천"),
        ChildLocation(code: "102470", name: "파주시", sName: "파주"),
        ChildLocation(code: "102480", name: "평택시", sName: "평택"),
        ChildLocation(code: "102490", name: "포천시", sName: "포천"),
        ChildLocation(code: "102500", name: "하남시", sName: "하남"),
        ChildLocation(code: "102510", name: "화성시", sName: "화성")
    ]),
    ParentLocation(code: "103", name: "광주광역시", mName: "광주시", sName: "광주", childLocationList: [
        ChildLocation(code: "103010", name: "광산구", sName: "광산"),
        ChildLocation(code: "103020", name: "남구", sName: "남구"),
        ChildLocation(code: "103030", name: "동구", sName: "동구"),
        ChildLocation(code: "103040", name: "북구", sName: "북구"),
        ChildLocation(code: "103050", name: "서구", sName: "서구")
    ]),
    ParentLocation(code: "104", name: "대구광역시", mName: "대구시", sName: "대구", childLocationList: [
        ChildLocation(code: "104010", name: "남구", sName: "남구"),
        ChildLocation(code: "104020", name: "달서구", sName: "달서"),
        ChildLocation(code: "104030", name: "달성군", sName: "달성"),
        ChildLocation(code: "104040", name: "동구", sName: "동구"),
        ChildLocation(code: "104050", name: "북구", sName: "북구"),
        ChildLocation(code: "104060", name: "서구", sName: "서구"),
        ChildLocation(code: "104070", name: "수성구", sName: "수성"),
        ChildLocation(code: "104080", name: "중구", sName: "중구")
    ]),
    ParentLocation(code: "105", name: "대전광역시", mName: "대전시", sName: "대전", childLocationList: [
        ChildLocation(code: "105010", name: "대덕구", sName: "대덕"),
        ChildLocation(code: "105020", name: "동구", sName: "동구"),
        ChildLocation(code: "105030", name: "서구", sName: "서구"),
        ChildLocation(code: "105040", name: "유성구", sName: "유성"),
        ChildLocation(code: "105050", name: "중구", sName: "중구")
    ]),
    ParentLocation(code: "106", name: "부산광역시", mName: "부산시", sName: "부산", childLocationList: [
        ChildLocation(code: "106010", name: "강서구", sName: "강서"),
        ChildLocation(code: "106020", name: "금정구", sName: "금정"),
        ChildLocation(code: "106030", name: "기장군", sName: "기장"),
        ChildLocation(code: "106040", name: "남구", sName: "남구"),
        ChildLocation(code: "106050", name: "동구", sName: "동구"),
        ChildLocation(code: "106060", name: "동래구", sName: "동래"),
        ChildLocation(code: "106070", name: "부산진구", sName: "부산진"),
        ChildLocation(code: "106080", name: "북구", sName: "북구"),
        ChildLocation(code: "106090", name: "사상구", sName: "사상"),
        ChildLocation(code: "106100", name: "사하구", sName: "사하"),
        ChildLocation(code: "106110", name: "서구", sName: "서구"),
        ChildLocation(code: "106120", name: "수영구", sName: "수영"),
        ChildLocation(code: "106130", name: "연제구", sName: "연제"),
        ChildLocation(code: "106140", name: "영도구", sName: "영도"),
        ChildLocation(code: "106150", name: "중구", sName: "중구"),
        ChildLocation(code: "106160", name: "해운대구", sName: "해운대")
    ]),
    ParentLocation(code: "107", name: "울산광역시", mName: "울산시", sName: "울산", childLocationList: [
        ChildLocation(code: "107010", name: "남구", sName: "남구"),
        ChildLocation(code: "107020", name: "동구", sName: "동구"),
        ChildLocation(code: "107030", name: "북구", sName: "북구"),
        ChildLocation(code: "107040", name: "울주군", sName: "울주"),
        ChildLocation(code: "107050", name: "중구", sName: "중구")
    ]),
    ParentLocation(code: "108", name: "인천광역시", mName: "인천시", sName: "인천", childLocationList: [
        ChildLocation(code: "108010", name: "강화군", sName: "강화"),
        ChildLocation(code: "108020", name: "계양구", sName: "계양"),
        ChildLocation(code: "108030", name: "남구", sName: "남구"),
        ChildLocation(code: "108040", name: "남동구", sName: "남동"),
        ChildLocation(code: "108050", name: "동구", sName: "동구"),
        ChildLocation(code: "108060", name: "부평구", sName: "부평"),
        ChildLocation(code: "108070", name: "서구", sName: "서구"),
        ChildLocation(code: "108080", name: "연수구", sName: "연수"),
        ChildLocation(code: "108090", name: "옹진군", sName: "옹진"),
        ChildLocation(code: "108100", name: "중구", sName: "중구")
    ]),
    ParentLocation(code: "109", name: "강원도", mName: "강원시", sName: "강원", childLocationList: [
        ChildLocation(code: "109010", name: "강릉시", sName: "강릉"),
        ChildLocation(code: "109020", name: "고성군", sName: "고성"),
        ChildLocation(code: "109030", name: "동해시", sName: "동해"),
        ChildLocation(code: "109040", name: "삼척시", sName: "삼척"),
        ChildLocation(code: "109050", name: "속초시", sName: "속초"),
        ChildLocation(code: "109060", name: "양구군", sName: "양구"),
        ChildLocation(code: "109070", name: "양양군", sName: "양양"),
        ChildLocation(code: "109080", name: "영월군", sName: "영월"),
        ChildLocation(code: "109090", name: "원주시", sName: "원주"),
        ChildLocation(code: "109100", name: "인제군", sName: "인제"),
        ChildLocation(code: "109110", name: "정선군", sName: "정선"),
        ChildLocation(code: "109120", name: "철원군", sName: "철원"),
        ChildLocation(code: "109130", name: "춘천시", sName: "춘천"),
        ChildLocation(code: "109140", name: "태백시", sName: "태백"),
        ChildLocation(code: "109150", name: "평창군", sName: "평창"),
        ChildLocation(code: "109160", name: "홍천군", sName: "홍천"),
        ChildLocation(code: "109170", name: "화천군", sName: "화천"),
        ChildLocation(code: "109180", name: "횡성군", sName: "횡성")
    ]),
    ParentLocation(code: "110", name: "경상남도", mName: "경남시", sName: "경남", childLocationList: [
        ChildLocation(code: "110010", name: "거제시", sName: "거제"),
        ChildLocation(code: "110020", name: "거창군", sName: "거창"),
        ChildLocation(code: "110030", name: "고성군", sName: "고성"),
        ChildLocation(code: "110040", name: "김해시", sName: "김해"),
        ChildLocation(code: "110050", name: "남해군", sName: "남해"),
        ChildLocation(code: "110070", name: "밀양시", sName: "밀양"),
        ChildLocation(code: "110080", name: "사천시", sName: "사천"),
        ChildLocation(code: "110090", name: "산청군", sName: "산청"),
        ChildLocation(code: "110100", name: "양산시", sName: "양산"),
        ChildLocation(code: "110110", name: "의령군", sName: "의령"),
        ChildLocation(code: "110120", name: "진주시", sName: "진주"),
        ChildLocation(code: "110140", name: "창녕군", sName: "창녕"),
        ChildLocation(code: "110150", name: "창원시", sName: "창원"),
        ChildLocation(code: "110160", name: "통영시", sName: "통영"),
        ChildLocation(code: "110170", name: "하동군", sName: "하동"),
        ChildLocation(code: "110180", name: "함안군", sName: "함안"),
        ChildLocation(code: "110190", name: "함양군", sName: "함양"),
        ChildLocation(code: "110200", name: "합천군", sName: "합천")
    ]),
    ParentLocation(code: "111", name: "경상북도", mName: "경북시", sName: "경북", childLocationList: [
        ChildLocation(code: "111010", name: "경산시", sName: "경산"),
        ChildLocation(code: "111020", name: "경주시", sName: "경주"),
        ChildLocation(code: "111030", name: "고령군", sName: "고령"),
        ChildLocation(code: "111040", name: "구미시", sName: "구미"),
        ChildLocation(code: "111050", name: "군위군", sName: "군위"),
        ChildLocation(code: "111060", name: "김천시", sName: "김천"),
        ChildLocation(code: "111070", name: "문경시", sName: "문경"),
        ChildLocation(code: "111080", name: "봉화군", sName: "봉화"),
        ChildLocation(code: "111090", name: "상주시", sName: "상주"),
        ChildLocation(code: "111100", name: "성주군", sName: "성주"),
        ChildLocation(code: "111110", name: "안동시", sName: "안동"),
        ChildLocation(code: "111120", name: "영덕군", sName: "영덕"),
        ChildLocation(code: "111130", name: "영양군", sName: "영양"),
        ChildLocation(code: "111140", name: "영주시", sName: "영주"),
        ChildLocation(code: "111150", name: "영천시", sName: "영천"),
        ChildLocation(code: "111160", name: "예천군", sName: "예천"),
        ChildLocation(code: "111170", name: "울릉군", sName: "울릉"),
        ChildLocation(code: "111180", name: "울진군", sName: "울진"),
        ChildLocation(code: "111190", name: "의성군", sName: "의성"),
        ChildLocation(code: "111200", name: "청도군", sName: "청도"),
        ChildLocation(code: "111210", name: "청송군", sName: "청송"),
        ChildLocation(code: "111220", name: "칠곡군", sName: "칠곡"),
        ChildLocation(code: "111230", name: "포항시", sName: "포항")
    ]),
    ParentLocation(code: "112", name: "전라남도", mName: "전남시", sName: "전남", childLocationList: [
        ChildLocation(code: "112010", name: "강진군", sName: "강진"),
        ChildLocation(code: "112020", name: "고흥군", sName: "고흥"),
        ChildLocation(code: "112030", name: "곡성군", sName: "곡성"),
        ChildLocation(code: "112040", name: "광양시", sName: "광양"),
        ChildLocation(code: "112050", name: "구례군", sName: "구례"),
        ChildLocation(code: "112060", name: "나주시", sName: "나주"),
        ChildLocation(code: "112070", name: "담양군", sName: "담양"),
        ChildLocation(code: "112080", name: "목포시", sName: "목포"),
        ChildLocation(code: "112090", name: "무안군", sName: "무안"),
        ChildLocation(code: "112100", name: "보성군", sName: "보성"),
        ChildLocation(code: "112110", name: "순천시", sName: "순천"),
        ChildLocation(code: "112120", name: "신안군", sName: "신안"),
        ChildLocation(code: "112130", name: "여수시", sName: "여수"),
        ChildLocation(code: "112140", name: "영광군", sName: "영광"),
        ChildLocation(code: "112150", name: "영암군", sName: "영암"),
        ChildLocation(code: "112160", name: "완도군", sName: "완도"),
        ChildLocation(code: "112170", name: "장성군", sName: "장성"),
        ChildLocation(code: "112180", name: "장흥군", sName: "장흥"),
        ChildLocation(code: "112190", name: "진도군", sName: "진도"),
        ChildLocation(code: "112200", name: "함평군", sName: "함평"),
        ChildLocation(code: "112210", name: "해남군", sName: "해남"),
        ChildLocation(code: "112220", name: "화순군", sName: "화순")
    ]),
    ParentLocation(code: "113", name: "전라북도", mName: "전북시", sName: "전북", childLocationList: [
        ChildLocation(code: "113010", name: "고창군", sName: "고창"),
        ChildLocation(code: "113020", name: "군산시", sName: "군산"),
        ChildLocation(code: "113030", name: "김제시", sName: "김제"),
        ChildLocation(code: "113040", name: "남원시", sName: "남원"),
        ChildLocation(code: "113050", name: "무주군", sName: "무주"),
        ChildLocation(code: "113060", name: "부안군", sName: "부안"),
        ChildLocation(code: "113070", name: "순창군", sName: "순창"),
        ChildLocation(code: "113080", name: "완주군", sName: "완주"),
        ChildLocation(code: "113090", name: "익산시", sName: "익산"),
        ChildLocation(code: "113100", name: "임실군", sName: "임실"),
        ChildLocation(code: "113110", name: "장수군", sName: "장수"),
        ChildLocation(code: "113120", name: "전주시", sName: "전주"),
        ChildLocation(code: "113150", name: "정읍시", sName: "정읍"),
        ChildLocation(code: "113160", name: "진안군", sName: "진안")
    ]),
    ParentLocation(code: "114", name: "충청북도", mName: "충북시", sName: "충북", childLocationList: [
        ChildLocation(code: "114010", name: "괴산군", sName: "괴산군"),
        ChildLocation(code: "114020", name: "단양군", sName: "단양군"),
        ChildLocation(code: "114030", name: "보은군", sName: "보은군"),
        ChildLocation(code: "114040", name: "영동군", sName: "영동군"),
        ChildLocation(code: "114050", name: "옥천군", sName: "옥천군"),
        ChildLocation(code: "114060", name: "음성군", sName: "음성군"),
        ChildLocation(code: "114070", name: "제천시", sName: "제천시"),
        ChildLocation(code: "114080", name: "증평군", sName: "증평군"),
        ChildLocation(code: "114090", name: "진천군", sName: "진천군"),
        ChildLocation(code: "114100", name: "청원군", sName: "청원군"),
        ChildLocation(code: "114110", name: "청주시", sName: "청주시"),
        ChildLocation(code: "114140", name: "충주시", sName: "충주시")
    ]),
    ParentLocation(code: "115", name: "충청남도", mName: "충남시", sName: "충남", childLocationList: [
        ChildLocation(code: "115010", name: "계룡시", sName: "계룡"),
        ChildLocation(code: "115020", name: "공주시", sName: "공주"),
        ChildLocation(code: "115030", name: "금산군", sName: "금산"),
        ChildLocation(code: "115040", name: "논산시", sName: "논산"),
        ChildLocation(code: "115050", name: "당진시", sName: "당진"),
        ChildLocation(code: "115060", name: "보령시", sName: "보령"),
        ChildLocation(code: "115070", name: "부여군", sName: "부여"),
        ChildLocation(code: "115080", name: "서산시", sName: "서산"),
        ChildLocation(code: "115090", name: "서천군", sName: "서천"),
        ChildLocation(code: "115100", name: "아산시", sName: "아산"),
        ChildLocation(code: "115110", name: "연기군", sName: "연기"),
        ChildLocation(code: "115120", name: "예산군", sName: "예산"),
        ChildLocation(code: "115130", name: "천안시", sName: "천안"),
        ChildLocation(code: "115140", name: "청양군", sName: "청양"),
        ChildLocation(code: "115150", name: "태안군", sName: "태안"),
        ChildLocation(code: "115160", name: "홍성군", sName: "홍성")
    ]),
    ParentLocation(code: "116", name: "제주도", mName: "제주시", sName: "제주", childLocationList: [
        ChildLocation(code: "116030", name: "서귀포시", sName: "서귀포"),
        ChildLocation(code: "116040", name: "제주시", sName: "제주")
    ]),
    ParentLocation(code: "118", name: "세종시", mName: "세종시", sName: "세종", childLocationList: [
        ChildLocation(code: "118010", name: "세종시", sName: "세종")
    ])
]
