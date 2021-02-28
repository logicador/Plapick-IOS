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
        label.font = .boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureView()
        
        loginRequest.delegate = self
//        getVersionRequest.delegate = self
//        getPushNotificationDeviceRequest.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            if self.app.isLogined() {
                let user = self.app.getUser()
                
                guard let socialId = user.socialId else {
                    self.changeRootViewController(rootViewController: LoginViewController())
                    return
                }
                
                guard let type = user.type else {
                    self.changeRootViewController(rootViewController: LoginViewController())
                    return
                }
                
                self.loginRequest.fetch(vc: self, paramDict: ["type": type, "socialId": socialId])
                
            } else { self.changeRootViewController(rootViewController: LoginViewController()) }
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


// MARK: HTTP - Login
extension LaunchViewController: LoginRequestProtocol {
    func response(user: User?, login status: String) {
        print("[HTTP RES]", loginRequest.apiUrl, status)
        
        if status == "OK" {
            guard let user = user else { return }
            app.login(user: user)
            changeRootViewController(rootViewController: UINavigationController(rootViewController: MainViewController()))
        }
    }
}
