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
    var logoutRequest: LogoutRequest?
    let settingMenuList: [SettingMenu] = [
        SettingMenu(title: "", icon: "", isHeader: true),
        SettingMenu(title: "프로필 설정", icon: "person.circle"),
        SettingMenu(title: "푸시 알림 설정", icon: "bell.circle"),
        SettingMenu(title: "버전 정보", icon: "info.circle"),
//        SettingMenu(title: "공지사항", icon: "megaphone.circle"),
        SettingMenu(title: "고객센터", icon: "headphones.circle"),
        SettingMenu(title: "탈퇴하기", icon: "person.crop.circle.badge.xmark")
    ]
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "설정"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logout))
        
        tableView.register(SettingTVCell.self, forCellReuseIdentifier: "SettingTVCell")
        tableView.separatorInset.left = 0
        
        logoutRequest = LogoutRequest(parentViewController: self)
        logoutRequest?.delegate = self
        
        adjustColors()
        
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
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func logout() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel))
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (_) in
            self.logoutRequest?.fetch()
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
        if settingMenuList[indexPath.row].isHeader { return 40 }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingMenu = settingMenuList[indexPath.row]
        print(settingMenu)
    }
}


// MARK: Extensions
extension SettingTableViewController: LogoutRequestProtocol {
    func configureLogout() {
        app.logout()
        changeRootViewController(rootViewController: LaunchViewController())
    }
}
