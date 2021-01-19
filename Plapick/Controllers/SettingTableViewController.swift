//
//  SettingTableViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/12.
//

import UIKit


class SettingTableViewController: UITableViewController {
    
    // MARK: Properties
    var app = App()
    var logoutRequest = LogoutRequest()
    let settingMenuList: [SettingMenu] = [
        SettingMenu(title: "프로필 설정", icon: "person.circle", action: "PROFILE"),
        SettingMenu(title: "푸시 알림 설정", icon: "bell.circle", action: "PUSH_NOTIFICATION"),
        SettingMenu(title: "버전 정보", icon: "info.circle", action: "VERSION"),
        SettingMenu(title: "공지사항", icon: "mic.circle", action: "NOTICE"),
        SettingMenu(title: "고객센터", icon: "headphones.circle", action: "SERVICE")
//        SettingMenu(title: "플레픽 탈퇴", icon: "person.crop.circle.badge.xmark", action: "QUIT")
    ]
    var accountViewController: AccountViewController?
    var versionRequest = VersionRequest()
    var isVersionRequestTasking: Bool = false
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "설정"
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logout))
        
        tableView.register(SettingTVCell.self, forCellReuseIdentifier: "SettingTVCell")
        tableView.separatorInset.left = 0
        
        logoutRequest.delegate = self
        versionRequest.delegate = self
        
        adjustColors()
        
        app.delegate = self
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
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
    
//    @objc func backTapped() {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @objc func logout() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel))
        alert.addAction(UIAlertAction(title: "로그아웃", style: UIAlertAction.Style.destructive, handler: { (_) in
            self.logoutRequest.fetch(vc: self)
        }))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingMenuList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTVCell", for: indexPath) as! SettingTVCell
        cell.selectionStyle = .none
        cell.settingMenu = settingMenuList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if settingMenuList[indexPath.row].isHeader { return 40 }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        let action = settingMenuList[indexPath.row].action
        
        switch action {
        case "PROFILE":
            let profileSettingViewController = ProfileSettingViewController()
            profileSettingViewController.accountViewController = accountViewController
            navigationController?.pushViewController(profileSettingViewController, animated: true)
        
        case "VERSION":
            if isVersionRequestTasking { return }
            isVersionRequestTasking = true
            versionRequest.fetch(vc: self)
            
        case "SERVICE":
            let alert = UIAlertController(title: "고객센터", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
            alert.addAction(UIAlertAction(title: "문의하기", style: UIAlertAction.Style.default, handler: { (_) in
                
            }))
            alert.addAction(UIAlertAction(title: "이용약관", style: UIAlertAction.Style.default, handler: { (_) in
                let termsViewController = TermsViewController()
                termsViewController.termsUrl = PLAPICK_URL + "/mobile/terms/agreement"
                termsViewController.title = "플레픽 이용약관"
                let navigationController = UINavigationController(rootViewController: termsViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "개인정보 처리방침", style: UIAlertAction.Style.default, handler: { (_) in
                let termsViewController = TermsViewController()
                termsViewController.termsUrl = PLAPICK_URL + "/mobile/terms/privacy"
                termsViewController.title = "플레픽 개인정보 처리방침"
                let navigationController = UINavigationController(rootViewController: termsViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "계정 탈퇴", style: UIAlertAction.Style.destructive, handler: { (_) in
                
            }))
            present(alert, animated: true)
            
        case "PUSH_NOTIFICATION":
            app.checkPushNotificationAvailable(parentViewController: self)
            
        default:
            print("nothing to do")
        }
    }
}


// MARK: Extensions
extension SettingTableViewController: LogoutRequestProtocol {
    func response(status: String) {
        if status == "OK" {
            app.logout()
            changeRootViewController(rootViewController: LaunchViewController())
        }
    }
}


extension SettingTableViewController: VersionRequestProtocol {
    func response(version: String?, build: Int?, status: String) {
        isVersionRequestTasking = false
        
        if status == "OK" {
            guard let infoDictionary = Bundle.main.infoDictionary else { return }
            let _version = infoDictionary["CFBundleShortVersionString"] as? String
            let _build = infoDictionary["CFBundleVersion"] as? String
            
            guard let curVersion = _version else { return }
            guard let curBuild = _build else { return }
            
            if build == Int(curBuild) {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "ver " + curVersion, message: "현재 앱이 최신 버전입니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                    self.present(alert, animated: true)
                }
                
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "ver " + curVersion, message: "현재 앱의 버전이 낮습니다.\n최신버전으로 업데이트를 진행해주세요.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}


extension SettingTableViewController: AppProtocol {
    func photoGallary(isAllowed: Bool) { }
    
    func pushNotification(isAllowed: Bool) {
        if isAllowed {
            let pushNotificationSettingTableViewController = PushNotificationSettingTableViewController()
            self.navigationController?.pushViewController(pushNotificationSettingTableViewController, animated: true)
        }
    }
}
