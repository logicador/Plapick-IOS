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
    
    // MARK: Property
    var app = App()
    let loginRequest = LoginRequest()
    
    
    // MARK: View
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
    lazy var topContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var topWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - LoginButton
    lazy var kakaoButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "kakao_login_large_wide.png")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kakaoLoginTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        button.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Indicator
    lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    lazy var blurOverlayView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let vev = UIVisualEffectView(effect: blurEffect)
        vev.alpha = 0.3
        vev.translatesAutoresizingMaskIntoConstraints = false
        return vev
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureView()
        
        loginRequest.delegate = self
//        getVersionRequest.delegate = self
//        getPushNotificationDeviceRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(topContainerView)
        topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4).isActive = true
        
        topContainerView.addSubview(topWrapperView)
        topWrapperView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor).isActive = true
        topWrapperView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor).isActive = true
        topWrapperView.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor).isActive = true
        
        topWrapperView.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: topWrapperView.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: topWrapperView.topAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: topWrapperView.widthAnchor, multiplier: 0.2).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: topWrapperView.widthAnchor, multiplier: 0.2).isActive = true
        
        topWrapperView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: SPACE).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: topWrapperView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: topWrapperView.bottomAnchor).isActive = true
        
        view.addSubview(bottomContainerView)
        bottomContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor).isActive = true
        bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6).isActive = true
        bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - LoginButton
        bottomContainerView.addSubview(kakaoButton)
        kakaoButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        kakaoButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        kakaoButton.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, multiplier: 0.8).isActive = true
            
        bottomContainerView.addSubview(appleButton)
        appleButton.topAnchor.constraint(equalTo: kakaoButton.bottomAnchor, constant: SPACE_XS).isActive = true
        appleButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        appleButton.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, multiplier: 0.8).isActive = true
        appleButton.heightAnchor.constraint(equalTo: bottomContainerView.widthAnchor, multiplier: 0.12).isActive = true
    }
    
    func showLoginFailedAlert(message: String) {
        let alert = UIAlertController(title: "로그인 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        present(alert, animated: true)
    }
    
    func fetchKakaoLogin(user: KakaoSDKUser.User) {
        let socialId = String(user.id)
        
        guard let kakaoAccount = user.kakaoAccount else { return }
        let email = kakaoAccount.email ?? ""
        
        guard let properties = user.properties else { return }
        let name = properties["nickname"] ?? ""
        let profileImage = properties["profile_image"] ?? ""
        
        loginRequest.fetch(vc: self, paramDict: ["type": "KAKAO", "socialId": socialId, "email": email, "name": name, "profileImage": profileImage])
    }
    
    
    // MARK: Function - @OBJC
    @objc func appleLoginTapped() {
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func kakaoLoginTapped() {
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            // KAKAO App Login
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let _ = error {
                    self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                    self.showLoginFailedAlert(message: "사용자에 의해 카카오 로그인이 취소되었습니다.")
                    return
                }
                UserApi.shared.me() { (user, error) in
                    if let _ = error {
                        self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                        self.showLoginFailedAlert(message: "사용자 정보를 가져올 수 없습니다.")
                        return
                    }
                    guard let user = user else {
                        self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                        self.showLoginFailedAlert(message: "사용자 정보를 가져올 수 없습니다.")
                        return
                    }
                    self.fetchKakaoLogin(user: user)
                }
            }
            
        } else {
            // KAKAO Web Login
            AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let _ = error {
                    self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                    self.showLoginFailedAlert(message: "사용자에 의해 카카오 로그인이 취소되었습니다.")
                    return
                }
                UserApi.shared.me() { (user, error) in
                    if let _ = error {
                        self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                        self.showLoginFailedAlert(message: "사용자 정보를 가져올 수 없습니다.")
                        return
                    }
                    guard let user = user else {
                        self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                        self.showLoginFailedAlert(message: "사용자 정보를 가져올 수 없습니다.")
                        return
                    }
                    self.fetchKakaoLogin(user: user)
                }
            }
        }
    }
}


// MARK: Extension - ASAuthorization
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // 애플 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let socialId = appleIDCredential.user
            
            let email = appleIDCredential.email ?? ""
            
            var name = ""
            if let fullName = appleIDCredential.fullName { name = "\(fullName.familyName ?? "")\(fullName.givenName ?? "")" }
            
            loginRequest.fetch(vc: self, paramDict: ["type": "APPLE", "socialId": socialId, "email": email, "name": name])
            
        default:
            hideIndicator(idv: indicatorView, bov: blurOverlayView)
            showLoginFailedAlert(message: "사용자 정보를 가져올 수 없습니다.")
            break
        }
    }
    
    // 애플 로그인 취소 혹은 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
        showLoginFailedAlert(message: "사용자에 의해 애플 로그인이 취소되었습니다.")
    }
}

// MARK: HTTP - Login
extension LoginViewController: LoginRequestProtocol {
    func response(user: User?, login status: String) {
        print("[HTTP RES]", loginRequest.apiUrl, status)
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
        if status == "OK" {
            guard let user = user else { return }
            app.login(user: user)
            changeRootViewController(rootViewController: UINavigationController(rootViewController: MainViewController()))
        }
    }
}
