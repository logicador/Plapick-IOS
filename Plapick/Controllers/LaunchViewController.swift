//
//  LaunchViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/10.
//

import UIKit


class LaunchViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    var loginRequest = LoginRequest()
    
    
    // MARK: Views
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
        
        view.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        containerView.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        loginRequest.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
            if self.app.isLogined() {
                let user = self.app.getUser()
                var paramList: [Param] = []
                paramList.append(Param(key: "type", value: user.type))
                paramList.append(Param(key: "socialId", value: user.socialId))
                paramList.append(Param(key: "device", value: "IOS"))
                self.loginRequest.fetch(vc: self, paramList: paramList)
            } else {
                self.changeRootViewController(rootViewController: LoginViewController())
            }
        }
    }
    
}


// MARK: Extensions
extension LaunchViewController: LoginRequestProtocol {
    func response(user: User?, status: String) {
        if status == "OK" {
            guard let user = user else { return }
            app.login(user: user)
            let navigationController = UINavigationController(rootViewController: MainTabBarController())
            changeRootViewController(rootViewController: navigationController)
        }
    }
}
