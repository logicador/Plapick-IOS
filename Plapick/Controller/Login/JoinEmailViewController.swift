//
//  JoinEmailViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/18.
//

import UIKit


class JoinEmailViewController: UIViewController {
    
    // MARK: Property
    let identifiedEmailRequest = IdentifiedEmailRequest()
    let identifiedEmailCodeRequest = IdentifiedEmailCodeRequest()
    var ieId: Int?
    var timeSec: Int = 180
    var timer: Timer?
    var scrollViewBottomCons: NSLayoutConstraint?
    var phoneNumber: String?
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
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
    
    // MARK: View - Email
    lazy var emailTitleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 인증"
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var emailContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    lazy var sendIdentifiedCodeEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증메일 전송", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = LINE_WIDTH
        button.backgroundColor = .systemGray6
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(sendIdentifiedCodeEmailTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - IdentifiedCode
    lazy var identifiedCodeContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var identifiedCodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증코드 6자리 입력"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var identifiedCodeTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "3:00"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var identifiedCodeTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var identifiedCodeTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var identifiedCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증코드 입력 완료", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = LINE_WIDTH
        button.backgroundColor = .systemGray6
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(identifiedCodeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Password
    lazy var passwordTitleContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var passwordContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        tf.autocorrectionType = .no
        tf.textContentType = .newPassword
        tf.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var passwordInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호는 8자 이상 입력해주세요."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordConfirmTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var passwordConfirmTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var passwordConfirmTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no
        tf.textContentType = .newPassword
        tf.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var passwordConfirmInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "확인용 비밀번호를 입력해주세요."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        navigationItem.title = "회원가입"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        configureView()
        
        setThemeColor()
        
        hideKeyboardWhenTappedAround()
        
        identifiedEmailRequest.delegate = self
        identifiedEmailCodeRequest.delegate = self
    }
    
    
    // MARK: ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        emailTextContainerView.layer.borderColor = UIColor.separator.cgColor
        sendIdentifiedCodeEmailButton.layer.borderColor = UIColor.separator.cgColor
        
        identifiedCodeTextContainerView.layer.borderColor = UIColor.separator.cgColor
        identifiedCodeButton.layer.borderColor = UIColor.separator.cgColor
        
        passwordTextContainerView.layer.borderColor = UIColor.separator.cgColor
        passwordConfirmTextContainerView.layer.borderColor = UIColor.separator.cgColor
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollViewBottomCons = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomCons?.isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Email
        stackView.addArrangedSubview(emailTitleContainerView)
        emailTitleContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        emailTitleContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        emailTitleContainerView.addSubview(emailTitleLabel)
        emailTitleLabel.topAnchor.constraint(equalTo: emailTitleContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        emailTitleLabel.leadingAnchor.constraint(equalTo: emailTitleContainerView.leadingAnchor).isActive = true
        emailTitleLabel.trailingAnchor.constraint(equalTo: emailTitleContainerView.trailingAnchor).isActive = true
        emailTitleLabel.bottomAnchor.constraint(equalTo: emailTitleContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        stackView.addArrangedSubview(emailContainerView)
        emailContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        emailContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        emailContainerView.addSubview(emailTextContainerView)
        emailTextContainerView.topAnchor.constraint(equalTo: emailContainerView.topAnchor).isActive = true
        emailTextContainerView.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor).isActive = true
        emailTextContainerView.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor).isActive = true
        emailTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true
        
        emailTextContainerView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: emailTextContainerView.topAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: emailTextContainerView.leadingAnchor, constant: 15).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: emailTextContainerView.trailingAnchor, constant: -15).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: emailTextContainerView.bottomAnchor).isActive = true
        
        emailContainerView.addSubview(sendIdentifiedCodeEmailButton)
        sendIdentifiedCodeEmailButton.topAnchor.constraint(equalTo: emailTextContainerView.bottomAnchor, constant: SPACE_XS).isActive = true
        sendIdentifiedCodeEmailButton.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor).isActive = true
        sendIdentifiedCodeEmailButton.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor).isActive = true
        sendIdentifiedCodeEmailButton.bottomAnchor.constraint(equalTo: emailContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - IdentifiedCode
        stackView.addArrangedSubview(identifiedCodeContainerView)
        identifiedCodeContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        identifiedCodeContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        identifiedCodeContainerView.addSubview(identifiedCodeTitleLabel)
        identifiedCodeTitleLabel.topAnchor.constraint(equalTo: identifiedCodeContainerView.topAnchor, constant: SPACE).isActive = true
        identifiedCodeTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        identifiedCodeTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        identifiedCodeTitleLabel.addSubview(identifiedCodeTimerLabel)
        identifiedCodeTimerLabel.centerYAnchor.constraint(equalTo: identifiedCodeTitleLabel.centerYAnchor).isActive = true
        identifiedCodeTimerLabel.trailingAnchor.constraint(equalTo: identifiedCodeTitleLabel.trailingAnchor).isActive = true
        
        identifiedCodeContainerView.addSubview(identifiedCodeTextContainerView)
        identifiedCodeTextContainerView.topAnchor.constraint(equalTo: identifiedCodeTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        identifiedCodeTextContainerView.centerXAnchor.constraint(equalTo: identifiedCodeContainerView.centerXAnchor).isActive = true
        identifiedCodeTextContainerView.widthAnchor.constraint(equalTo: identifiedCodeContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        identifiedCodeTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true

        identifiedCodeTextContainerView.addSubview(identifiedCodeTextField)
        identifiedCodeTextField.topAnchor.constraint(equalTo: identifiedCodeTextContainerView.topAnchor).isActive = true
        identifiedCodeTextField.leadingAnchor.constraint(equalTo: identifiedCodeTextContainerView.leadingAnchor, constant: 15).isActive = true
        identifiedCodeTextField.trailingAnchor.constraint(equalTo: identifiedCodeTextContainerView.trailingAnchor, constant: -15).isActive = true
        identifiedCodeTextField.bottomAnchor.constraint(equalTo: identifiedCodeTextContainerView.bottomAnchor).isActive = true
        
        identifiedCodeContainerView.addSubview(identifiedCodeButton)
        identifiedCodeButton.topAnchor.constraint(equalTo: identifiedCodeTextContainerView.bottomAnchor, constant: SPACE_XS).isActive = true
        identifiedCodeButton.centerXAnchor.constraint(equalTo: identifiedCodeContainerView.centerXAnchor).isActive = true
        identifiedCodeButton.widthAnchor.constraint(equalTo: identifiedCodeContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        identifiedCodeButton.bottomAnchor.constraint(equalTo: identifiedCodeContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Password
        stackView.addArrangedSubview(passwordTitleContainerView)
        passwordTitleContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        passwordTitleContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true

        passwordTitleContainerView.addSubview(passwordTitleLabel)
        passwordTitleLabel.topAnchor.constraint(equalTo: passwordTitleContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        passwordTitleLabel.leadingAnchor.constraint(equalTo: passwordTitleContainerView.leadingAnchor).isActive = true
        passwordTitleLabel.trailingAnchor.constraint(equalTo: passwordTitleContainerView.trailingAnchor).isActive = true
        passwordTitleLabel.bottomAnchor.constraint(equalTo: passwordTitleContainerView.bottomAnchor, constant: -SPACE).isActive = true

        stackView.addArrangedSubview(passwordContainerView)
        passwordContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        passwordContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true

        passwordContainerView.addSubview(passwordTextContainerView)
        passwordTextContainerView.topAnchor.constraint(equalTo: passwordContainerView.topAnchor).isActive = true
        passwordTextContainerView.centerXAnchor.constraint(equalTo: passwordContainerView.centerXAnchor).isActive = true
        passwordTextContainerView.widthAnchor.constraint(equalTo: passwordContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        passwordTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true

        passwordTextContainerView.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: passwordTextContainerView.topAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: passwordTextContainerView.leadingAnchor, constant: 15).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: passwordTextContainerView.trailingAnchor, constant: -15).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: passwordTextContainerView.bottomAnchor).isActive = true

        passwordContainerView.addSubview(passwordInfoLabel)
        passwordInfoLabel.topAnchor.constraint(equalTo: passwordTextContainerView.bottomAnchor, constant: SPACE_XXS).isActive = true
        passwordInfoLabel.centerXAnchor.constraint(equalTo: passwordContainerView.centerXAnchor).isActive = true
        passwordInfoLabel.widthAnchor.constraint(equalTo: passwordContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true

        passwordContainerView.addSubview(passwordConfirmTitleLabel)
        passwordConfirmTitleLabel.topAnchor.constraint(equalTo: passwordInfoLabel.bottomAnchor, constant: SPACE).isActive = true
        passwordConfirmTitleLabel.centerXAnchor.constraint(equalTo: passwordContainerView.centerXAnchor).isActive = true
        passwordConfirmTitleLabel.widthAnchor.constraint(equalTo: passwordContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true

        passwordContainerView.addSubview(passwordConfirmTextContainerView)
        passwordConfirmTextContainerView.topAnchor.constraint(equalTo: passwordConfirmTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        passwordConfirmTextContainerView.centerXAnchor.constraint(equalTo: passwordContainerView.centerXAnchor).isActive = true
        passwordConfirmTextContainerView.widthAnchor.constraint(equalTo: passwordContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        passwordConfirmTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true

        passwordConfirmTextContainerView.addSubview(passwordConfirmTextField)
        passwordConfirmTextField.topAnchor.constraint(equalTo: passwordConfirmTextContainerView.topAnchor).isActive = true
        passwordConfirmTextField.leadingAnchor.constraint(equalTo: passwordConfirmTextContainerView.leadingAnchor, constant: 15).isActive = true
        passwordConfirmTextField.trailingAnchor.constraint(equalTo: passwordConfirmTextContainerView.trailingAnchor, constant: -15).isActive = true
        passwordConfirmTextField.bottomAnchor.constraint(equalTo: passwordConfirmTextContainerView.bottomAnchor).isActive = true

        passwordContainerView.addSubview(passwordConfirmInfoLabel)
        passwordConfirmInfoLabel.topAnchor.constraint(equalTo: passwordConfirmTextContainerView.bottomAnchor, constant: SPACE_XXS).isActive = true
        passwordConfirmInfoLabel.centerXAnchor.constraint(equalTo: passwordContainerView.centerXAnchor).isActive = true
        passwordConfirmInfoLabel.widthAnchor.constraint(equalTo: passwordContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        passwordConfirmInfoLabel.bottomAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func keyboardShow(notification: NSNotification) {
        if passwordTextField.isFirstResponder || passwordConfirmTextField.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
                scrollViewBottomCons?.isActive = false
                scrollViewBottomCons = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height)
                scrollViewBottomCons?.isActive = true
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    @objc func keyboardHide(notification: NSNotification) {
        scrollViewBottomCons?.isActive = false
        scrollViewBottomCons = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomCons?.isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func sendIdentifiedCodeEmailTapped() {
        dismissKeyboard()
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if !emailTest.evaluate(with: email) {
            let alert = UIAlertController(title: nil, message: "이메일 형식이 올바르지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        
        identifiedEmailRequest.fetch(vc: self, paramDict: ["mode": "JOIN", "email": email])
    }
    
    @objc func identifiedCodeTapped() {
        dismissKeyboard()
        
        guard let ieId = self.ieId else { return }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let code = identifiedCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let codeRegEx = "[A-Z0-9a-z]{6}"
        let codeTest = NSPredicate(format:"SELF MATCHES %@", codeRegEx)
        
        if !codeTest.evaluate(with: code) {
            let alert = UIAlertController(title: nil, message: "인증코드 형식이 올바르지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        identifiedEmailCodeRequest.fetch(vc: self, paramDict: ["ieId": String(ieId), "email": email, "code": code])
    }
    
    @objc func passwordChanged() {
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let passwordConfirm = passwordConfirmTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if password.count < 8 {
            passwordInfoLabel.text = "비밀번호는 8자 이상 입력해주세요."
            passwordInfoLabel.textColor = .systemRed
        } else {
            passwordInfoLabel.text = "비밀번호가 입력되었습니다."
            passwordInfoLabel.textColor = .systemGreen
        }
        
        if passwordConfirm.isEmpty {
            passwordConfirmInfoLabel.text = "확인용 비밀번호를 입력해주세요."
            passwordConfirmInfoLabel.textColor = .systemRed
        } else if passwordConfirm != password {
            passwordConfirmInfoLabel.text = "비밀번호가 일치하지 않습니다."
            passwordConfirmInfoLabel.textColor = .systemRed
        } else {
            passwordConfirmInfoLabel.text = "비밀번호가 일치합니다."
            passwordConfirmInfoLabel.textColor = .systemGreen
        }
        
        if passwordInfoLabel.textColor == .systemGreen && passwordConfirmInfoLabel.textColor == .systemGreen {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextTapped))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func nextTapped() {
        dismissKeyboard()
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let joinProfileVC = JoinProfileViewController()
        joinProfileVC.userType = "EMAIL"
        joinProfileVC.phoneNumber = phoneNumber
        joinProfileVC.email = email
        joinProfileVC.password = password
        navigationController?.pushViewController(joinProfileVC, animated: true)
    }
}


// MARK: HTTP - IdentifiedEmail
extension JoinEmailViewController: IdentifiedEmailRequestProtocol {
    func response(ieId: Int?, identifiedEmail status: String) {
        print("[HTTP RES]", identifiedEmailRequest.apiUrl, status)
        
        if status == "OK" {
            guard let ieId = ieId else { return }
            self.ieId = ieId
            
            emailTextField.isEnabled = false
            sendIdentifiedCodeEmailButton.isEnabled = false
            
            identifiedCodeContainerView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.identifiedCodeContainerView.alpha = 1
            })
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                DispatchQueue.main.async {
                    self.timeSec -= 1
                    if self.timeSec < 0 {
                        self.emailTextField.isEnabled = true
                        self.sendIdentifiedCodeEmailButton.isEnabled = true
                        
                        self.timer?.invalidate()
                        self.timer = nil
                        self.timeSec = 180
                        self.identifiedCodeTextField.text = ""
                        self.identifiedCodeTimerLabel.text = "3:00"
                        self.identifiedCodeContainerView.isHidden = true
                        self.identifiedCodeContainerView.alpha = 0
                        
                    } else {
                        self.identifiedCodeTimerLabel.text = "\(self.timeSec / 60):\(String(format: "%02d", self.timeSec % 60))"
                    }
                }
            })
            
            let alert = UIAlertController(title: nil, message: "입력하신 이메일 주소로 인증코드 6자리를 전송했습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            
        } else if status == "EXISTS_EMAIL" {
            let alert = UIAlertController(title: nil, message: "이미 사용중인 이메일입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        }
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}

// MARK: HTTP - IdentifiedEmailCode
extension JoinEmailViewController: IdentifiedEmailCodeRequestProtocol {
    func response(identifiedEmailCode status: String) {
        print("[HTTP RES]", identifiedEmailCodeRequest.apiUrl, status)
        
        if status == "OK" {
            timer?.invalidate()
            timer = nil
            identifiedCodeTextField.isEnabled = false
            identifiedCodeButton.isEnabled = false
            identifiedCodeTimerLabel.isHidden = true
            
            passwordTitleContainerView.isHidden = false
            passwordContainerView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.passwordContainerView.alpha = 1
                self.passwordTitleContainerView.alpha = 1
            })
            
            let alert = UIAlertController(title: nil, message: "이메일 인증이 완료되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            
        } else if status == "WRONG_CODE" {
            let alert = UIAlertController(title: nil, message: "인증코드가 유효하지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        }
    }
}
