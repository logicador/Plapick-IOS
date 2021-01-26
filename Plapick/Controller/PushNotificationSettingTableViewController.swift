//
//  PushNotificationSettingTableViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/17.
//

import UIKit


class PushNotificationSettingTableViewController: UITableViewController {
    
    // MARK: Properties
    var app = App()
    var settingPushNotificationList: [SettingPushNotification] = [
        SettingPushNotification(title: "내 픽에 새로운 댓글 등록", isOn: false, action: "MY_PICK_COMMENT"),
        SettingPushNotification(title: "플레이스 맞춤 추천", isOn: false, action: "RECOMMENDED_PLACE"),
        SettingPushNotification(title: "광고 / 마케팅", isOn: false, action: "AD"),
        SettingPushNotification(title: "이벤트 및 공지사항", isOn: false, action: "EVENT_NOTICE")
    ]
    let setPushNotificationRequest = SetPushNotificationRequest()
    let getPushNotificationRequest = GetPushNotificationRequest()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "푸시 알림 설정"
        
        tableView.register(SettingPushNotificationTVCell.self, forCellReuseIdentifier: "SettingPushNotificationTVCell")
        tableView.separatorInset.left = 0
        
        adjustColors()
        
        getPushNotificationRequest.delegate = self
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(vc: self)
            return
        }
        
        getPushNotificationRequest.fetch(vc: self, deviceToken: app.getPndId())
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .tertiarySystemGroupedBackground
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingPushNotificationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPushNotificationTVCell", for: indexPath) as! SettingPushNotificationTVCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.settingPushNotification = settingPushNotificationList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}


// MARK: Extensions
extension PushNotificationSettingTableViewController: SettingPushNotificationTVCellProtocol {
    func switching(action: String, isAllowed: String) {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(vc: self)
            return
        }
        
        if isAllowed == "Y" { app.checkPushNotificationAvailable(vc: self) }
        setPushNotificationRequest.fetch(action: action, isAllowed: isAllowed, deviceToken: app.getPndId())
    }
}


extension PushNotificationSettingTableViewController: GetPushNotificationRequestProtocol {
    func response(pushNotification: PushNotification?, status: String) {
        if status == "OK" {
            if let pushNotification = pushNotification {
                settingPushNotificationList[0].isOn = pushNotification.isAllowedMyPickComment
                settingPushNotificationList[1].isOn = pushNotification.isAllowedRecommendedPlace
                settingPushNotificationList[2].isOn = pushNotification.isAllowedAd
                settingPushNotificationList[3].isOn = pushNotification.isAllowedEventNotice
                tableView.reloadData()
            }
        }
    }
}

