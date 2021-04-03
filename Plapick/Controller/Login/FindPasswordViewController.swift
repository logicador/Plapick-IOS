//
//  FindPasswordViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/21.
//

import UIKit


class FindPasswordViewController: UIViewController {
    
    // MARK: Property
    let identifiedEmailRequest = IdentifiedEmailRequest()
    let identifiedEmailCodeRequest = IdentifiedEmailCodeRequest()
    let identifiedPhoneRequest = IdentifiedPhoneRequest()
    let identifiedPhoneCodeRequest = IdentifiedPhoneCodeRequest()
    var ieId: Int?
    var emailTimeSec: Int = 180
    var emailTimer: Timer?
    var ipId: Int?
    var phoneTimeSec: Int = 180
    var phoneTimer: Timer?
    var scrollViewBottomCons: NSLayoutConstraint?
    
    
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
    
    // MARK: View - Email - IdentifiedCode
    lazy var emailIdentifiedCodeContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var emailIdentifiedCodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증코드 6자리 입력"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var emailIdentifiedCodeTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "3:00"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var emailIdentifiedCodeTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var emailIdentifiedCodeTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var emailIdentifiedCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증코드 입력 완료", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = LINE_WIDTH
        button.backgroundColor = .systemGray6
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(emailIdentifiedCodeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Phone
    lazy var phoneNumberTitleContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var phoneNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대폰 인증"
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var phoneNumberContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var phoneNumberTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var phoneNumberTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.keyboardType = .numberPad
        tf.placeholder = "숫자만 입력"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var sendIdentifiedCodePhoneNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증문자 전송", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = LINE_WIDTH
        button.backgroundColor = .systemGray6
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(sendIdentifiedCodePhoneNumberTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Phone - IdentifiedCode
    lazy var phoneIdentifiedCodeContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var phoneIdentifiedCodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증코드 6자리 입력"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var phoneIdentifiedCodeTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "3:00"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var phoneIdentifiedCodeTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var phoneIdentifiedCodeTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.keyboardType = .numberPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var phoneIdentifiedCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증코드 입력 완료", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = LINE_WIDTH
        button.backgroundColor = .systemGray6
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(phoneIdentifiedCodeTapped), for: .touchUpInside)
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
        
        navigationItem.title = "비밀번호 찾기"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        configureView()
        
        setThemeColor()
        
        hideKeyboardWhenTappedAround()
        
        identifiedEmailRequest.delegate = self
        identifiedEmailCodeRequest.delegate = self
        identifiedPhoneRequest.delegate = self
        identifiedPhoneCodeRequest.delegate = self
    }
    
    
    // MARK: ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        emailTimer?.invalidate()
        emailTimer = nil
        
        phoneTimer?.invalidate()
        phoneTimer = nil
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        emailTextContainerView.layer.borderColor = UIColor.separator.cgColor
        sendIdentifiedCodeEmailButton.layer.borderColor = UIColor.separator.cgColor
        
        emailIdentifiedCodeTextContainerView.layer.borderColor = UIColor.separator.cgColor
        emailIdentifiedCodeButton.layer.borderColor = UIColor.separator.cgColor
        
        phoneNumberTextContainerView.layer.borderColor = UIColor.separator.cgColor
        sendIdentifiedCodePhoneNumberButton.layer.borderColor = UIColor.separator.cgColor
        
        phoneIdentifiedCodeTextContainerView.layer.borderColor = UIColor.separator.cgColor
        phoneIdentifiedCodeButton.layer.borderColor = UIColor.separator.cgColor
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
        
        // MARK: ConfigureView - Email - IdentifiedCode
        stackView.addArrangedSubview(emailIdentifiedCodeContainerView)
        emailIdentifiedCodeContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        emailIdentifiedCodeContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        emailIdentifiedCodeContainerView.addSubview(emailIdentifiedCodeTitleLabel)
        emailIdentifiedCodeTitleLabel.topAnchor.constraint(equalTo: emailIdentifiedCodeContainerView.topAnchor, constant: SPACE).isActive = true
        emailIdentifiedCodeTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        emailIdentifiedCodeTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        emailIdentifiedCodeTitleLabel.addSubview(emailIdentifiedCodeTimerLabel)
        emailIdentifiedCodeTimerLabel.centerYAnchor.constraint(equalTo: emailIdentifiedCodeTitleLabel.centerYAnchor).isActive = true
        emailIdentifiedCodeTimerLabel.trailingAnchor.constraint(equalTo: emailIdentifiedCodeTitleLabel.trailingAnchor).isActive = true
        
        emailIdentifiedCodeContainerView.addSubview(emailIdentifiedCodeTextContainerView)
        emailIdentifiedCodeTextContainerView.topAnchor.constraint(equalTo: emailIdentifiedCodeTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        emailIdentifiedCodeTextContainerView.centerXAnchor.constraint(equalTo: emailIdentifiedCodeContainerView.centerXAnchor).isActive = true
        emailIdentifiedCodeTextContainerView.widthAnchor.constraint(equalTo: emailIdentifiedCodeContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        emailIdentifiedCodeTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true

        emailIdentifiedCodeTextContainerView.addSubview(emailIdentifiedCodeTextField)
        emailIdentifiedCodeTextField.topAnchor.constraint(equalTo: emailIdentifiedCodeTextContainerView.topAnchor).isActive = true
        emailIdentifiedCodeTextField.leadingAnchor.constraint(equalTo: emailIdentifiedCodeTextContainerView.leadingAnchor, constant: 15).isActive = true
        emailIdentifiedCodeTextField.trailingAnchor.constraint(equalTo: emailIdentifiedCodeTextContainerView.trailingAnchor, constant: -15).isActive = true
        emailIdentifiedCodeTextField.bottomAnchor.constraint(equalTo: emailIdentifiedCodeTextContainerView.bottomAnchor).isActive = true
        
        emailIdentifiedCodeContainerView.addSubview(emailIdentifiedCodeButton)
        emailIdentifiedCodeButton.topAnchor.constraint(equalTo: emailIdentifiedCodeTextContainerView.bottomAnchor, constant: SPACE_XS).isActive = true
        emailIdentifiedCodeButton.centerXAnchor.constraint(equalTo: emailIdentifiedCodeContainerView.centerXAnchor).isActive = true
        emailIdentifiedCodeButton.widthAnchor.constraint(equalTo: emailIdentifiedCodeContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        emailIdentifiedCodeButton.bottomAnchor.constraint(equalTo: emailIdentifiedCodeContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Phone
        stackView.addArrangedSubview(phoneNumberTitleContainerView)
        phoneNumberTitleContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        phoneNumberTitleContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        phoneNumberTitleContainerView.addSubview(phoneNumberTitleLabel)
        phoneNumberTitleLabel.topAnchor.constraint(equalTo: phoneNumberTitleContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        phoneNumberTitleLabel.leadingAnchor.constraint(equalTo: phoneNumberTitleContainerView.leadingAnchor).isActive = true
        phoneNumberTitleLabel.trailingAnchor.constraint(equalTo: phoneNumberTitleContainerView.trailingAnchor).isActive = true
        phoneNumberTitleLabel.bottomAnchor.constraint(equalTo: phoneNumberTitleContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        stackView.addArrangedSubview(phoneNumberContainerView)
        phoneNumberContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        phoneNumberContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        phoneNumberContainerView.addSubview(phoneNumberTextContainerView)
        phoneNumberTextContainerView.topAnchor.constraint(equalTo: phoneNumberContainerView.topAnchor).isActive = true
        phoneNumberTextContainerView.leadingAnchor.constraint(equalTo: phoneNumberContainerView.leadingAnchor).isActive = true
        phoneNumberTextContainerView.trailingAnchor.constraint(equalTo: phoneNumberContainerView.trailingAnchor).isActive = true
        phoneNumberTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true
        
        phoneNumberTextContainerView.addSubview(phoneNumberTextField)
        phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberTextContainerView.topAnchor).isActive = true
        phoneNumberTextField.leadingAnchor.constraint(equalTo: phoneNumberTextContainerView.leadingAnchor, constant: 15).isActive = true
        phoneNumberTextField.trailingAnchor.constraint(equalTo: phoneNumberTextContainerView.trailingAnchor, constant: -15).isActive = true
        phoneNumberTextField.bottomAnchor.constraint(equalTo: phoneNumberTextContainerView.bottomAnchor).isActive = true
        
        phoneNumberContainerView.addSubview(sendIdentifiedCodePhoneNumberButton)
        sendIdentifiedCodePhoneNumberButton.topAnchor.constraint(equalTo: phoneNumberTextContainerView.bottomAnchor, constant: SPACE_XS).isActive = true
        sendIdentifiedCodePhoneNumberButton.leadingAnchor.constraint(equalTo: phoneNumberContainerView.leadingAnchor).isActive = true
        sendIdentifiedCodePhoneNumberButton.trailingAnchor.constraint(equalTo: phoneNumberContainerView.trailingAnchor).isActive = true
        sendIdentifiedCodePhoneNumberButton.bottomAnchor.constraint(equalTo: phoneNumberContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Phone - IdentifiedCode
        stackView.addArrangedSubview(phoneIdentifiedCodeContainerView)
        phoneIdentifiedCodeContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        phoneIdentifiedCodeContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        phoneIdentifiedCodeContainerView.addSubview(phoneIdentifiedCodeTitleLabel)
        phoneIdentifiedCodeTitleLabel.topAnchor.constraint(equalTo: phoneIdentifiedCodeContainerView.topAnchor, constant: SPACE).isActive = true
        phoneIdentifiedCodeTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        phoneIdentifiedCodeTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        phoneIdentifiedCodeTitleLabel.addSubview(phoneIdentifiedCodeTimerLabel)
        phoneIdentifiedCodeTimerLabel.centerYAnchor.constraint(equalTo: phoneIdentifiedCodeTitleLabel.centerYAnchor).isActive = true
        phoneIdentifiedCodeTimerLabel.trailingAnchor.constraint(equalTo: phoneIdentifiedCodeTitleLabel.trailingAnchor).isActive = true
        
        phoneIdentifiedCodeContainerView.addSubview(phoneIdentifiedCodeTextContainerView)
        phoneIdentifiedCodeTextContainerView.topAnchor.constraint(equalTo: phoneIdentifiedCodeTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        phoneIdentifiedCodeTextContainerView.centerXAnchor.constraint(equalTo: phoneIdentifiedCodeContainerView.centerXAnchor).isActive = true
        phoneIdentifiedCodeTextContainerView.widthAnchor.constraint(equalTo: phoneIdentifiedCodeContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        phoneIdentifiedCodeTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true

        phoneIdentifiedCodeTextContainerView.addSubview(phoneIdentifiedCodeTextField)
        phoneIdentifiedCodeTextField.topAnchor.constraint(equalTo: phoneIdentifiedCodeTextContainerView.topAnchor).isActive = true
        phoneIdentifiedCodeTextField.leadingAnchor.constraint(equalTo: phoneIdentifiedCodeTextContainerView.leadingAnchor, constant: 15).isActive = true
        phoneIdentifiedCodeTextField.trailingAnchor.constraint(equalTo: phoneIdentifiedCodeTextContainerView.trailingAnchor, constant: -15).isActive = true
        phoneIdentifiedCodeTextField.bottomAnchor.constraint(equalTo: phoneIdentifiedCodeTextContainerView.bottomAnchor).isActive = true
        
        phoneIdentifiedCodeContainerView.addSubview(phoneIdentifiedCodeButton)
        phoneIdentifiedCodeButton.topAnchor.constraint(equalTo: phoneIdentifiedCodeTextContainerView.bottomAnchor, constant: SPACE_XS).isActive = true
        phoneIdentifiedCodeButton.centerXAnchor.constraint(equalTo: phoneIdentifiedCodeContainerView.centerXAnchor).isActive = true
        phoneIdentifiedCodeButton.widthAnchor.constraint(equalTo: phoneIdentifiedCodeContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        phoneIdentifiedCodeButton.bottomAnchor.constraint(equalTo: phoneIdentifiedCodeContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardShow(notification: NSNotification) {
        if phoneNumberTextField.isFirstResponder || phoneIdentifiedCodeTextField.isFirstResponder {
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
        
        identifiedEmailRequest.fetch(vc: self, paramDict: ["mode": "FIND", "email": email])
    }
    
    @objc func emailIdentifiedCodeTapped() {
        dismissKeyboard()
        
        guard let ieId = self.ieId else { return }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let code = emailIdentifiedCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
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
    
    @objc func sendIdentifiedCodePhoneNumberTapped() {
        dismissKeyboard()
        
        guard let phoneNumber = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let phoneNumberRegEx = "[0-9]{10,11}"
        let phoneNumberTest = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegEx)
        
        if !phoneNumberTest.evaluate(with: phoneNumber) {
            let alert = UIAlertController(title: nil, message: "휴대폰 번호가 올바르지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        
        identifiedPhoneRequest.fetch(vc: self, paramDict: ["email": email, "phoneNumber": phoneNumber])
    }
    
    @objc func phoneIdentifiedCodeTapped() {
        dismissKeyboard()
        
        guard let ipId = self.ipId else { return }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let phoneNumber = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let code = phoneIdentifiedCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let codeRegEx = "[0-9]{6}"
        let codeTest = NSPredicate(format:"SELF MATCHES %@", codeRegEx)
        
        if !codeTest.evaluate(with: code) {
            let alert = UIAlertController(title: nil, message: "인증코드 형식이 올바르지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        identifiedPhoneCodeRequest.fetch(vc: self, paramDict: ["mode": "RESET", "email": email, "ipId": String(ipId), "phoneNumber": phoneNumber, "code": code])
    }
}


// MARK: HTTP - IdentifiedEmail
extension FindPasswordViewController: IdentifiedEmailRequestProtocol {
    func response(ieId: Int?, identifiedEmail status: String) {
        print("[HTTP RES]", identifiedEmailRequest.apiUrl, status)
        
        if status == "OK" {
            guard let ieId = ieId else { return }
            self.ieId = ieId
            
            emailTextField.isEnabled = false
            sendIdentifiedCodeEmailButton.isEnabled = false
            
            emailIdentifiedCodeContainerView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.emailIdentifiedCodeContainerView.alpha = 1
            })
            
            emailTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                DispatchQueue.main.async {
                    self.emailTimeSec -= 1
                    if self.emailTimeSec < 0 {
                        self.emailTextField.isEnabled = true
                        self.sendIdentifiedCodeEmailButton.isEnabled = true
                        
                        self.emailTimer?.invalidate()
                        self.emailTimer = nil
                        self.emailTimeSec = 180
                        self.emailIdentifiedCodeTextField.text = ""
                        self.emailIdentifiedCodeTimerLabel.text = "3:00"
                        self.emailIdentifiedCodeContainerView.isHidden = true
                        self.emailIdentifiedCodeContainerView.alpha = 0
                        
                    } else {
                        self.emailIdentifiedCodeTimerLabel.text = "\(self.emailTimeSec / 60):\(String(format: "%02d", self.emailTimeSec % 60))"
                    }
                }
            })
            
            let alert = UIAlertController(title: nil, message: "입력하신 이메일 주소로 인증코드 6자리를 전송했습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            
        } else if status == "NO_EXISTS_USER" {
            let alert = UIAlertController(title: nil, message: "가입되지 않은 이메일입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        }
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}

// MARK: HTTP - IdentifiedEmailCode
extension FindPasswordViewController: IdentifiedEmailCodeRequestProtocol {
    func response(identifiedEmailCode status: String) {
        print("[HTTP RES]", identifiedEmailCodeRequest.apiUrl, status)
        
        if status == "OK" {
            emailTimer?.invalidate()
            emailTimer = nil
            emailIdentifiedCodeTextField.isEnabled = false
            emailIdentifiedCodeButton.isEnabled = false
            emailIdentifiedCodeTimerLabel.isHidden = true
            
            phoneNumberTitleContainerView.isHidden = false
            phoneNumberContainerView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.phoneNumberContainerView.alpha = 1
                self.phoneNumberTitleContainerView.alpha = 1
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

// MARK: HTTP - IdentifiedPhone
extension FindPasswordViewController: IdentifiedPhoneRequestProtocol {
    func response(ipId: Int?, identifiedPhone status: String) {
        print("[HTTP RES]", identifiedPhoneRequest.apiUrl, status)
        
        if status == "OK" {
            guard let ipId = ipId else { return }
            self.ipId = ipId
            
            phoneNumberTextField.isEnabled = false
            sendIdentifiedCodePhoneNumberButton.isEnabled = false
            
            phoneIdentifiedCodeContainerView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.phoneIdentifiedCodeContainerView.alpha = 1
            })
            
            phoneTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                DispatchQueue.main.async {
                    self.phoneTimeSec -= 1
                    if self.phoneTimeSec < 0 {
                        self.phoneNumberTextField.isEnabled = true
                        self.sendIdentifiedCodePhoneNumberButton.isEnabled = true
                        
                        self.phoneTimer?.invalidate()
                        self.phoneTimer = nil
                        self.phoneTimeSec = 180
                        self.phoneIdentifiedCodeTextField.text = ""
                        self.phoneIdentifiedCodeTimerLabel.text = "3:00"
                        self.phoneIdentifiedCodeContainerView.isHidden = true
                        self.phoneIdentifiedCodeContainerView.alpha = 0
                        
                    } else {
                        self.phoneIdentifiedCodeTimerLabel.text = "\(self.phoneTimeSec / 60):\(String(format: "%02d", self.phoneTimeSec % 60))"
                    }
                }
            })
            
            let alert = UIAlertController(title: nil, message: "입력하신 휴대폰으로 인증코드 6자리를 전송했습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            
        } else if status == "NO_EXISTS_USER" {
            let alert = UIAlertController(title: nil, message: "이메일과 일치하는 휴대폰 번호가 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        } else if status == "SEND_FAILED" {
            let alert = UIAlertController(title: nil, message: "인증코드 전송을 실패하였습니다. 휴대폰번호를 다시 확인해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        }
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}

// MARK: HTTP - IdentifiedPhoneCode
extension FindPasswordViewController: IdentifiedPhoneCodeRequestProtocol {
    func response(rpcId: Int?, checksum: String?, identifiedPhoneCode status: String) {
        print("[HTTP RES]", identifiedPhoneCodeRequest.apiUrl, status)
        
        if status == "OK" {
            guard let rpcId = rpcId else { return }
            guard let checksum = checksum else { return }
            guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let phoneNumber = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            phoneTimer?.invalidate()
            phoneTimer = nil
            phoneIdentifiedCodeTextField.isEnabled = false
            phoneIdentifiedCodeButton.isEnabled = false
            phoneIdentifiedCodeTimerLabel.isHidden = true
            
            let alert = UIAlertController(title: nil, message: "휴대폰 인증이 완료되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                let editPasswordVC = EditPasswordViewController()
                editPasswordVC.rpcId = rpcId
                editPasswordVC.phoneNumber = phoneNumber
                editPasswordVC.email = email
                editPasswordVC.checksum = checksum
                self.present(UINavigationController(rootViewController: editPasswordVC), animated: true, completion: nil)
            }))
            present(alert, animated: true)
            
        } else if status == "WRONG_CODE" {
            let alert = UIAlertController(title: nil, message: "인증코드가 유효하지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        }
    }
}
