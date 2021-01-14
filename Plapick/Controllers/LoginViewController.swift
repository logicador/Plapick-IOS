//
//  LoginViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/10.
//

import UIKit
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser


class LoginViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    var loginRequest = LoginRequest()
    
    
    // MARK: Views
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
    
    lazy var topContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var topContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var kakaoButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "kakao_login_large_wide.png")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kakaoLogin)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: ASAuthorizationAppleIDButton.ButtonType.signIn, style: ASAuthorizationAppleIDButton.Style.whiteOutline)
        button.addTarget(self, action: #selector(appleLogin), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(topContainerView)
        topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        
        topContainerView.addSubview(topContentView)
        topContentView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor).isActive = true
        topContentView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor).isActive = true
        topContentView.widthAnchor.constraint(equalTo: topContainerView.widthAnchor).isActive = true
        topContentView.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor).isActive = true
        
        topContentView.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: topContentView.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: topContentView.topAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        topContentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: topContentView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor).isActive = true
        
        view.addSubview(bottomContainerView)
        bottomContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor).isActive = true
        bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        bottomContainerView.addSubview(kakaoButton)
        kakaoButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        kakaoButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 40).isActive = true
        kakaoButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -40).isActive = true
        
        bottomContainerView.addSubview(appleButton)
        appleButton.topAnchor.constraint(equalTo: kakaoButton.bottomAnchor, constant: 10).isActive = true
        appleButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 40).isActive = true
        appleButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -40).isActive = true
        appleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        loginRequest.delegate = self
    }
    
    
    // MARK: Functions
    @objc func appleLogin() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func kakaoLogin() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if error != nil {
                    self.showLoginFailedAlert(message: "사용자에 의해 카카오 로그인이 취소되었습니다.")
                    return
                }
                UserApi.shared.me() { (user, error) in
                    if error != nil {
                        self.showLoginFailedAlert(message: "사용자의 정보를 가져올 수 없습니다.")
                        return
                    }
                    if let user = user {self.fetchKakaoLogin(user: user)}
                }
            }
        } else {
            AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if error != nil {
                    self.showLoginFailedAlert(message: "사용자에 의해 카카오 로그인이 취소되었습니다.")
                    return
                }
                UserApi.shared.me() { (user, error) in
                    if error != nil {
                        self.showLoginFailedAlert(message: "사용자의 정보를 가져올 수 없습니다.")
                        return
                    }
                    if let user = user { self.fetchKakaoLogin(user: user) }
                }
            }
        }
    }
    
    func showLoginFailedAlert(message: String) {
        let alert = UIAlertController(title: "로그인 실패", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
        self.present(alert, animated: true)
    }
    
    func showIndicator() {
        view.addSubview(overlayView)
        overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overlayView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        overlayView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        view.addSubview(indicatorView)
        indicatorView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true
        indicatorView.startAnimating()
    }
    
    func hideIndicator() {
        self.indicatorView.stopAnimating()
        self.indicatorView.removeView()
        self.overlayView.removeView()
    }
    
    func fetchKakaoLogin(user: KakaoSDKUser.User) {
        var socialId = ""
        var email = ""
        var name = ""
        var profileImage = ""
        
        socialId = String(user.id)
        if let kakaoAccount = user.kakaoAccount {
            email = kakaoAccount.email ?? ""
        }
        if let properties = user.properties {
            name = properties["nickname"] ?? ""
            profileImage = properties["profile_image"] ?? ""
        }
        
        var paramList: [Param] = []
        paramList.append(Param(key: "type", value: "KAKAO"))
        paramList.append(Param(key: "socialId", value: socialId))
        paramList.append(Param(key: "email", value: email))
        paramList.append(Param(key: "name", value: name))
        paramList.append(Param(key: "profileImage", value: profileImage))
        paramList.append(Param(key: "device", value: "IOS"))
        
        showIndicator()
        loginRequest.fetch(vc: self, paramList: paramList)
    }
}


// MARK: Extensions
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // 애플 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
            // 계정 정보 가져오기
            let socialId = appleIDCredential.user
            let email = appleIDCredential.email
            let name = (appleIDCredential.fullName?.familyName ?? "") + (appleIDCredential.fullName?.givenName ?? "")
            
            var paramList: [Param] = []
            paramList.append(Param(key: "type", value: "APPLE"))
            paramList.append(Param(key: "socialId", value: socialId))
            paramList.append(Param(key: "email", value: email ?? ""))
            paramList.append(Param(key: "name", value: name))
            paramList.append(Param(key: "device", value: "IOS"))
            
            showIndicator()
            loginRequest.fetch(vc: self, paramList: paramList)
            
        default:
            break
        }
    }
    
    // 애플 로그인 취소 혹은 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        showLoginFailedAlert(message: "사용자에 의해 애플 로그인이 취소되었습니다.")
    }
}


extension LoginViewController: LoginRequestProtocol {
    func response(user: User?, status: String) {
        hideIndicator()
        
        if status == "OK" {
            guard let user = user else { return }
            app.login(user: user)
            changeRootViewController(rootViewController: MainTabBarController())
        }
    }
}
