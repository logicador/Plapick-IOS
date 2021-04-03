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
    let app = App()
    var userType: String?
    var socialId: String?
    var email: String?
    let loginRequest = LoginRequest()
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var logoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var logoTextImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "LogoText")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Email
    lazy var emailContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var emailTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var passwordTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // MARK: View - Email - Save
    lazy var saveContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var saveImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var saveLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 정보 저장"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Email - Find
    lazy var findPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비밀번호 찾기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(findPasswordTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var findDotImageView: UIImageView = {
        let image = UIImage(systemName: "circle.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var findEmailbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이메일 찾기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(findEmailTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Email - Buttons
    lazy var emailLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이메일 로그인", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = LINE_WIDTH
        button.backgroundColor = .systemGray6
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(emailLoginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var emailJoinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이메일 회원가입", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = LINE_WIDTH
        button.backgroundColor = .systemGray6
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(emailJoinTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Social
    lazy var socialContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var socialTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "간편 로그인"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var kakaoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("카카오 로그인", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 6
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.backgroundColor = UIColor(hexString: "#FEE501")
        button.tintColor = UIColor(hexString: "#181600")
        button.addTarget(self, action: #selector(kakaoLoginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var kakaoImageView: UIImageView = {
        let image = UIImage(systemName: "message.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(hexString: "#181600")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var appleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apple로 로그인", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 6
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var appleImageView: UIImageView = {
        let image = UIImage(systemName: "applelogo")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Policy
    lazy var policyContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var agreementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("서비스 이용약관", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(agreementTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var policyDotImageView: UIImageView = {
        let image = UIImage(systemName: "circle.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var privacyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("개인정보 처리방침", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
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
        vev.alpha = 0.2
        vev.translatesAutoresizingMaskIntoConstraints = false
        return vev
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "로그인"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        hideKeyboardWhenTappedAround()
        
        loginRequest.delegate = self
        
        // TODO: 로그인 정보 저장 확인
        let isSaveLoginInfo = app.isSaveLoginInfo()
        if isSaveLoginInfo {
            saveImageView.image = UIImage(systemName: "checkmark.square")
            saveImageView.tintColor = .mainColor
            saveLabel.textColor = .mainColor
            
            emailTextField.text = app.getLoginEmail()
            passwordTextField.text = app.getLoginPassword()
            
        } else {
            saveImageView.image = UIImage(systemName: "square")
            saveImageView.tintColor = .systemGray3
            saveLabel.textColor = .systemGray3
        }
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        emailTextContainerView.layer.borderColor = UIColor.separator.cgColor
        passwordTextContainerView.layer.borderColor = UIColor.separator.cgColor
        
        emailLoginButton.layer.borderColor = UIColor.separator.cgColor
        emailJoinButton.layer.borderColor = UIColor.separator.cgColor
        
        appleButton.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .white : .black
        appleButton.tintColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        appleImageView.tintColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(logoContainerView)
        logoContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        logoContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        logoContainerView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4).isActive = true
        
        logoContainerView.addSubview(logoTextImageView)
        logoTextImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor).isActive = true
        logoTextImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor).isActive = true
        logoTextImageView.widthAnchor.constraint(equalTo: logoContainerView.widthAnchor, multiplier: 0.3).isActive = true
        
        // MARK: ConfigureView - Email
        stackView.addArrangedSubview(emailContainerView)
        emailContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        emailContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        emailContainerView.addSubview(emailTitleLabel)
        emailTitleLabel.topAnchor.constraint(equalTo: emailContainerView.topAnchor).isActive = true
        emailTitleLabel.centerXAnchor.constraint(equalTo: emailContainerView.centerXAnchor).isActive = true
        emailTitleLabel.widthAnchor.constraint(equalTo: emailContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        emailContainerView.addSubview(emailTextContainerView)
        emailTextContainerView.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        emailTextContainerView.centerXAnchor.constraint(equalTo: emailContainerView.centerXAnchor).isActive = true
        emailTextContainerView.widthAnchor.constraint(equalTo: emailContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        emailTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true
        
        emailTextContainerView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: emailTextContainerView.topAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: emailTextContainerView.leadingAnchor, constant: 15).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: emailTextContainerView.trailingAnchor, constant: -15).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: emailTextContainerView.bottomAnchor).isActive = true
        
        emailContainerView.addSubview(passwordTitleLabel)
        passwordTitleLabel.topAnchor.constraint(equalTo: emailTextContainerView.bottomAnchor, constant: SPACE).isActive = true
        passwordTitleLabel.centerXAnchor.constraint(equalTo: emailContainerView.centerXAnchor).isActive = true
        passwordTitleLabel.widthAnchor.constraint(equalTo: emailContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        emailContainerView.addSubview(passwordTextContainerView)
        passwordTextContainerView.topAnchor.constraint(equalTo: passwordTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        passwordTextContainerView.centerXAnchor.constraint(equalTo: emailContainerView.centerXAnchor).isActive = true
        passwordTextContainerView.widthAnchor.constraint(equalTo: emailContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        passwordTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true
        
        passwordTextContainerView.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: passwordTextContainerView.topAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: passwordTextContainerView.leadingAnchor, constant: 15).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: passwordTextContainerView.trailingAnchor, constant: -15).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: passwordTextContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Email - Save
        emailContainerView.addSubview(saveContainerView)
        saveContainerView.topAnchor.constraint(equalTo: passwordTextContainerView.bottomAnchor).isActive = true
        saveContainerView.leadingAnchor.constraint(equalTo: passwordTextContainerView.leadingAnchor).isActive = true
        
        saveContainerView.addSubview(saveImageView)
        saveImageView.topAnchor.constraint(equalTo: saveContainerView.topAnchor, constant: SPACE).isActive = true
        saveImageView.leadingAnchor.constraint(equalTo: saveContainerView.leadingAnchor).isActive = true
        saveImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        saveImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        saveImageView.bottomAnchor.constraint(equalTo: saveContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        saveContainerView.addSubview(saveLabel)
        saveLabel.centerYAnchor.constraint(equalTo: saveImageView.centerYAnchor).isActive = true
        saveLabel.leadingAnchor.constraint(equalTo: saveImageView.trailingAnchor, constant: SPACE_XXS).isActive = true
        saveLabel.trailingAnchor.constraint(equalTo: saveContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Email - Find
        emailContainerView.addSubview(findPasswordButton)
        findPasswordButton.centerYAnchor.constraint(equalTo: saveImageView.centerYAnchor).isActive = true
        findPasswordButton.trailingAnchor.constraint(equalTo: passwordTextContainerView.trailingAnchor).isActive = true
        
        emailContainerView.addSubview(findDotImageView)
        findDotImageView.centerYAnchor.constraint(equalTo: saveImageView.centerYAnchor).isActive = true
        findDotImageView.trailingAnchor.constraint(equalTo: findPasswordButton.leadingAnchor, constant: -SPACE_XXS).isActive = true
        findDotImageView.widthAnchor.constraint(equalToConstant: 4).isActive = true
        findDotImageView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        emailContainerView.addSubview(findEmailbutton)
        findEmailbutton.centerYAnchor.constraint(equalTo: saveImageView.centerYAnchor).isActive = true
        findEmailbutton.trailingAnchor.constraint(equalTo: findDotImageView.leadingAnchor, constant: -SPACE_XXS).isActive = true
        
        // MARK: ConfigureView - Email - Buttons
        emailContainerView.addSubview(emailLoginButton)
        emailLoginButton.topAnchor.constraint(equalTo: saveContainerView.bottomAnchor).isActive = true
        emailLoginButton.centerXAnchor.constraint(equalTo: emailContainerView.centerXAnchor).isActive = true
        emailLoginButton.widthAnchor.constraint(equalTo: emailContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        emailContainerView.addSubview(emailJoinButton)
        emailJoinButton.topAnchor.constraint(equalTo: emailLoginButton.bottomAnchor, constant: SPACE_XS).isActive = true
        emailJoinButton.centerXAnchor.constraint(equalTo: emailContainerView.centerXAnchor).isActive = true
        emailJoinButton.widthAnchor.constraint(equalTo: emailContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        emailJoinButton.bottomAnchor.constraint(equalTo: emailContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Social
        stackView.addArrangedSubview(socialContainerView)
        socialContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        socialContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        socialContainerView.addSubview(socialTitleLabel)
        socialTitleLabel.topAnchor.constraint(equalTo: socialContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        socialTitleLabel.centerXAnchor.constraint(equalTo: socialContainerView.centerXAnchor).isActive = true
        socialTitleLabel.widthAnchor.constraint(equalTo: socialContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true

        socialContainerView.addSubview(kakaoButton)
        kakaoButton.centerXAnchor.constraint(equalTo: socialContainerView.centerXAnchor).isActive = true
        kakaoButton.topAnchor.constraint(equalTo: socialTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        kakaoButton.widthAnchor.constraint(equalTo: socialContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true

        kakaoButton.addSubview(kakaoImageView)
        kakaoImageView.centerYAnchor.constraint(equalTo: kakaoButton.centerYAnchor).isActive = true
        kakaoImageView.leadingAnchor.constraint(equalTo: kakaoButton.leadingAnchor, constant: SPACE).isActive = true
        kakaoImageView.widthAnchor.constraint(equalTo: kakaoButton.heightAnchor, multiplier: 0.4).isActive = true
        kakaoImageView.heightAnchor.constraint(equalTo: kakaoButton.heightAnchor, multiplier: 0.4).isActive = true

        socialContainerView.addSubview(appleButton)
        appleButton.centerXAnchor.constraint(equalTo: socialContainerView.centerXAnchor).isActive = true
        appleButton.topAnchor.constraint(equalTo: kakaoButton.bottomAnchor, constant: SPACE_XS).isActive = true
        appleButton.widthAnchor.constraint(equalTo: socialContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        appleButton.bottomAnchor.constraint(equalTo: socialContainerView.bottomAnchor).isActive = true

        appleButton.addSubview(appleImageView)
        appleImageView.centerYAnchor.constraint(equalTo: appleButton.centerYAnchor).isActive = true
        appleImageView.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: SPACE).isActive = true
        appleImageView.widthAnchor.constraint(equalTo: appleButton.heightAnchor, multiplier: 0.4).isActive = true
        appleImageView.heightAnchor.constraint(equalTo: appleButton.heightAnchor, multiplier: 0.4).isActive = true
        
        // MARK: ConfigureView - Policy
        stackView.addArrangedSubview(policyContainerView)
        policyContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        policyContainerView.addSubview(agreementButton)
        agreementButton.topAnchor.constraint(equalTo: policyContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        agreementButton.leadingAnchor.constraint(equalTo: policyContainerView.leadingAnchor).isActive = true
        agreementButton.bottomAnchor.constraint(equalTo: policyContainerView.bottomAnchor).isActive = true
        
        policyContainerView.addSubview(policyDotImageView)
        policyDotImageView.centerYAnchor.constraint(equalTo: agreementButton.centerYAnchor).isActive = true
        policyDotImageView.leadingAnchor.constraint(equalTo: agreementButton.trailingAnchor, constant: SPACE_XXS).isActive = true
        policyDotImageView.widthAnchor.constraint(equalToConstant: 4).isActive = true
        policyDotImageView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        policyContainerView.addSubview(privacyButton)
        privacyButton.centerYAnchor.constraint(equalTo: agreementButton.centerYAnchor).isActive = true
        privacyButton.leadingAnchor.constraint(equalTo: policyDotImageView.trailingAnchor, constant: SPACE_XXS).isActive = true
        privacyButton.trailingAnchor.constraint(equalTo: policyContainerView.trailingAnchor).isActive = true
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
        
        self.socialId = socialId
        self.email = email
        self.userType = "APPLE"
        
        loginRequest.fetch(vc: self, paramDict: ["userType": "KAKAO", "socialId": socialId, "email": email])
    }
    
    
    // MARK: Function - @OBJC
    @objc func saveTapped() {
        dismissKeyboard()
        
        let isSaveLoginInfo = !app.isSaveLoginInfo()
        if isSaveLoginInfo {
            saveImageView.image = UIImage(systemName: "checkmark.square")
            saveImageView.tintColor = .mainColor
            saveLabel.textColor = .mainColor
        } else {
            saveImageView.tintColor = .systemGray3
            saveLabel.textColor = .systemGray3
            saveImageView.image = UIImage(systemName: "square")
        }
        
        app.setIsSaveLoginInfo(isSave: isSaveLoginInfo)
    }
    
    @objc func findPasswordTapped() {
        present(UINavigationController(rootViewController: FindPasswordViewController()), animated: true, completion: nil)
        
//        let editPasswordVC = EditPasswordViewController()
//        editPasswordVC.rpcId = 2103211700140657
//        editPasswordVC.phoneNumber = "01051009234"
//        editPasswordVC.email = "logicador@gmail.com"
//        editPasswordVC.checksum = "ELXPHUUJ"
//        self.present(UINavigationController(rootViewController: editPasswordVC), animated: true, completion: nil)
    }
    
    @objc func findEmailTapped() {
        present(UINavigationController(rootViewController: FindEmailViewController()), animated: true, completion: nil)
    }
    
    @objc func emailLoginTapped() {
        dismissKeyboard()
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if email.isEmpty || password.isEmpty { return }
        
        app.setLoginEmail(email: email)
        app.setLoginPassword(password: password)
        
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        loginRequest.fetch(vc: self, paramDict: ["userType": "EMAIL", "email": email, "password": password])
    }
    
    @objc func emailJoinTapped() {
        dismissKeyboard()
        
        let joinAgreeVC = JoinAgreeViewController()
        joinAgreeVC.userType = "EMAIL"
        navigationController?.pushViewController(joinAgreeVC, animated: true)
    }
    
    @objc func appleLoginTapped() {
        dismissKeyboard()
        
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @objc func kakaoLoginTapped() {
        dismissKeyboard()
        
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            // KAKAO App Login
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let _ = error {
                    self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
//                    self.showLoginFailedAlert(message: "사용자에 의해 카카오 로그인이 취소되었습니다.")
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
//                    self.showLoginFailedAlert(message: "사용자에 의해 카카오 로그인이 취소되었습니다.")
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
    
    @objc func agreementTapped() {
        dismissKeyboard()
        
        let termsVC = TermsViewController()
        termsVC.path = "agreement"
        navigationController?.pushViewController(termsVC, animated: true)
    }
    
    @objc func privacyTapped() {
        dismissKeyboard()
        
        let termsVC = TermsViewController()
        termsVC.path = "privacy"
        navigationController?.pushViewController(termsVC, animated: true)
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
            
            self.socialId = socialId
            self.email = email
            self.userType = "APPLE"
            
            loginRequest.fetch(vc: self, paramDict: ["userType": "APPLE", "socialId": socialId, "email": email])
            
        default:
            hideIndicator(idv: indicatorView, bov: blurOverlayView)
            showLoginFailedAlert(message: "사용자 정보를 가져올 수 없습니다.")
            break
        }
    }
    
    // 애플 로그인 취소 혹은 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
//        showLoginFailedAlert(message: "사용자에 의해 애플 로그인이 취소되었습니다.")
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
            changeRootViewController(rootViewController: MainViewController())
        
        } else if status == "LOGIN_FAILED" {
            let alert = UIAlertController(title: nil, message: "이메일 또는 비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
            
        } else if status == "JOIN_CONTINUE" {
            guard let userType = self.userType else { return }
            guard let socialId = self.socialId else { return }
            guard let email = self.email else { return }
            
            let joinAgreeVC = JoinAgreeViewController()
            joinAgreeVC.userType = userType
            joinAgreeVC.socialId = socialId
            joinAgreeVC.email = email
            navigationController?.pushViewController(joinAgreeVC, animated: true)
            
        } else if status == "LEAVE_USER" {
            let alert = UIAlertController(title: nil, message: "이미 탈퇴한 사용자입니다.\n\n문의메일\n info.plapick@gmail.com", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
            
        } else if status == "BLOCK_USER" {
            let alert = UIAlertController(title: nil, message: "이용이 제한된 사용자입니다\n\n문의메일\n info.plapick@gmail.com", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
    }
}
