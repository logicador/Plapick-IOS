//
//  LaunchViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/10.
//

import UIKit


class LaunchViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let loginRequest = LoginRequest()
    
    
    // MARK: View
    lazy var logoTextImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "LogoText")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureView()
        
        setThemeColor()
        
        loginRequest.delegate = self
        
        if isNetworkAvailable() {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                if self.app.isLogined() {
                    let user = self.app.getUser()

                    self.loginRequest.fetch(vc: self, paramDict: ["userType": user.u_type ?? "", "email": user.u_email ?? "", "password": user.u_password ?? "", "socialId": user.u_social_id ?? ""])

                } else { self.changeRootViewController(rootViewController: UINavigationController(rootViewController: LoginViewController())) }
                
                // MARK: For DEV_DEBUG
    //            self.changeRootViewController(rootViewController: UINavigationController(rootViewController: LoginViewController()))
            }
            
        } else {
            showNetworkAlert()
        }
        
        
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(logoTextImageView)
        logoTextImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoTextImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoTextImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
    }
}


// MARK: HTTP - Login
extension LaunchViewController: LoginRequestProtocol {
    func response(user: User?, login status: String) {
        print("[HTTP RES]", loginRequest.apiUrl, status)
        
        if status == "OK" {
            guard let user = user else { return }
            app.login(user: user)
            changeRootViewController(rootViewController: MainViewController())
            
        } else if status == "LEAVE_USER" {
            let alert = UIAlertController(title: nil, message: "이미 탈퇴한 사용자입니다.\n\n문의메일\n info.plapick@gmail.com", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
            
        } else if status == "BLOCK_USER" {
            let alert = UIAlertController(title: nil, message: "이미 탈퇴한 사용자입니다.\n\n문의메일\n info.plapick@gmail.com", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
    }
}
