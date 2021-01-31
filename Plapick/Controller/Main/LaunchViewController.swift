//
//  LaunchViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/10.
//

import UIKit


class LaunchViewController: UIViewController {
    
    // MARK: Property
    var app = App()
    let loginRequest = LoginRequest()
    let getVersionRequest = GetVersionRequest()
    let getPushNotificationDeviceRequest = GetPushNotificationDeviceRequest()
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo.png")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PLAPICK"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureView()
        
        loginRequest.delegate = self
        getVersionRequest.delegate = self
        getPushNotificationDeviceRequest.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            if self.app.isLogined() {
                let user = self.app.getUser()
                guard let type = user.type else {
                    self.changeRootViewController(rootViewController: LoginViewController())
                    return
                }
                guard let socialId = user.socialId else {
                    self.changeRootViewController(rootViewController: LoginViewController())
                    return
                }
                
                self.loginRequest.fetch(vc: self, paramDict: ["type": type, "socialId": socialId])
            } else {
                self.changeRootViewController(rootViewController: LoginViewController())
            }
        }
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        containerView.addSubview(logoImageView)
        logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: SPACE).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
}


// MARK: Extension - Login
extension LaunchViewController: LoginRequestProtocol {
    func response(user: User?, login status: String) {
        if status == "OK" {
            if let user = user {
                app.login(user: user)
                
                getVersionRequest.fetch(vc: self, isShowAlert: false, paramDict: [:])
            }
        }
    }
}

// MARK: Extension - GetVersion
extension LaunchViewController: GetVersionRequestProtocol {
    func response(versionCode: Int?, versionName: String?, getVersion status: String) {
        if status == "OK" {
            guard let versionCode = versionCode else { return }
            guard let versionName = versionName else { return }
            
            app.setNewVersionCode(newVersionCode: versionCode)
            app.setNewVersionName(newVersionName: versionName)
            
            guard let infoDictionary = Bundle.main.infoDictionary else { return }
            let code = infoDictionary["CFBundleVersion"] as? String
            let name = infoDictionary["CFBundleShortVersionString"] as? String
            if let versionCode = code {
                if let curVersionCode = Int(versionCode) {
                    app.setCurVersionCode(curVersionCode: curVersionCode)
                }
            }
            if let curVersionName = name {
                app.setCurVersionName(curVersionName: curVersionName)
            }
            
            let pndId = app.getPndId()
            if pndId.isEmpty {
                changeRootViewController(rootViewController: UINavigationController(rootViewController: MainViewController()))
            } else {
                getPushNotificationDeviceRequest.fetch(vc: self, isShowAlert: false, paramDict: ["pndId": pndId])
            }
        }
    }
}

// MARK: Extension - GetPushNotificationDevice
extension LaunchViewController: GetPushNotificationDeviceRequestProtocol {
    func response(isAllowedFollow: String?, isAllowedMyPickComment: String?, isAllowedRecommendedPlace: String?, isAllowedAd: String?, isAllowedEventNotice: String?, getPushNotificationDevice status: String) {
        
        app.setPushNotification(key: "FOLLOW", value: isAllowedFollow ?? "Y")
        app.setPushNotification(key: "MY_PICK_COMMENT", value: isAllowedMyPickComment ?? "Y")
        app.setPushNotification(key: "RECOMMENDED_PLACE", value: isAllowedRecommendedPlace ?? "Y")
        app.setPushNotification(key: "AD", value: isAllowedAd ?? "Y")
        app.setPushNotification(key: "EVENT_NOTICE", value: isAllowedEventNotice ?? "Y")
        
        changeRootViewController(rootViewController: UINavigationController(rootViewController: MainViewController()))
    }
}
