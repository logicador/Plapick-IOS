//
//  FindEmailViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/21.
//

import UIKit


class FindEmailViewController: UIViewController {
    
    // MARK: Property
    let identifiedPhoneRequest = IdentifiedPhoneRequest()
    let identifiedPhoneCodeRequest = IdentifiedPhoneCodeRequest()
    let findEmailRequest = FindEmailRequest()
    var ipId: Int?
    var timeSec: Int = 180
    var timer: Timer?
    
    
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
    
    // MARK: View - Phone
    lazy var phoneNumberTitleContainerView: UIView = {
        let view = UIView()
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
        tf.keyboardType = .numberPad
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
    
    // MARK: View - Result
    lazy var resultContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var resultTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 찾기 결과"
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var resultStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
        
        navigationItem.title = "이메일 찾기"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        configureView()
        
        setThemeColor()
        
        hideKeyboardWhenTappedAround()
        
        identifiedPhoneRequest.delegate = self
        identifiedPhoneCodeRequest.delegate = self
        findEmailRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        phoneNumberTextContainerView.layer.borderColor = UIColor.separator.cgColor
        sendIdentifiedCodePhoneNumberButton.layer.borderColor = UIColor.separator.cgColor
        
        identifiedCodeTextContainerView.layer.borderColor = UIColor.separator.cgColor
        identifiedCodeButton.layer.borderColor = UIColor.separator.cgColor
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
        
        // MARK: ConfigureView - Result
        stackView.addArrangedSubview(resultContainerView)
        resultContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        resultContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        resultContainerView.addSubview(resultTitleLabel)
        resultTitleLabel.topAnchor.constraint(equalTo: resultContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        resultTitleLabel.leadingAnchor.constraint(equalTo: resultContainerView.leadingAnchor).isActive = true
        resultTitleLabel.trailingAnchor.constraint(equalTo: resultContainerView.trailingAnchor).isActive = true
        
        resultContainerView.addSubview(resultStackView)
        resultStackView.topAnchor.constraint(equalTo: resultTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        resultStackView.leadingAnchor.constraint(equalTo: resultContainerView.leadingAnchor).isActive = true
        resultStackView.trailingAnchor.constraint(equalTo: resultContainerView.trailingAnchor).isActive = true
        resultStackView.bottomAnchor.constraint(equalTo: resultContainerView.bottomAnchor, constant: -SPACE_XL).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendIdentifiedCodePhoneNumberTapped() {
        dismissKeyboard()
        
        guard let phoneNumber = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let phoneNumberRegEx = "[0-9]{10,11}"
        let phoneNumberTest = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegEx)
        
        if !phoneNumberTest.evaluate(with: phoneNumber) {
            let alert = UIAlertController(title: nil, message: "휴대폰 번호가 올바르지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        
        identifiedPhoneRequest.fetch(vc: self, paramDict: ["phoneNumber": phoneNumber])
    }
    
    @objc func identifiedCodeTapped() {
        dismissKeyboard()
        
        guard let ipId = self.ipId else { return }
        guard let phoneNumber = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let code = identifiedCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let codeRegEx = "[0-9]{6}"
        let codeTest = NSPredicate(format:"SELF MATCHES %@", codeRegEx)
        
        if !codeTest.evaluate(with: code) {
            let alert = UIAlertController(title: nil, message: "인증코드 형식이 올바르지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        identifiedPhoneCodeRequest.fetch(vc: self, paramDict: ["mode": "FIND", "ipId": String(ipId), "phoneNumber": phoneNumber, "code": code])
    }
}


// MARK: HTTP - IdentifiedPhone
extension FindEmailViewController: IdentifiedPhoneRequestProtocol {
    func response(ipId: Int?, identifiedPhone status: String) {
        print("[HTTP RES]", identifiedPhoneRequest.apiUrl, status)
        
        if status == "OK" {
            guard let ipId = ipId else { return }
            self.ipId = ipId
            
            phoneNumberTextField.isEnabled = false
            sendIdentifiedCodePhoneNumberButton.isEnabled = false
            
            identifiedCodeContainerView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.identifiedCodeContainerView.alpha = 1
            })
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                DispatchQueue.main.async {
                    self.timeSec -= 1
                    if self.timeSec < 0 {
                        self.phoneNumberTextField.isEnabled = true
                        self.sendIdentifiedCodePhoneNumberButton.isEnabled = true
                        
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
            
            let alert = UIAlertController(title: nil, message: "입력하신 휴대폰으로 인증코드 6자리를 전송했습니다.", preferredStyle: .alert)
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
extension FindEmailViewController: IdentifiedPhoneCodeRequestProtocol {
    func response(rpcId: Int?, checksum: String?, identifiedPhoneCode status: String) {
        print("[HTTP RES]", identifiedPhoneCodeRequest.apiUrl, status)
        
        if status == "OK" {
            timer?.invalidate()
            timer = nil
            identifiedCodeTextField.isEnabled = false
            identifiedCodeButton.isEnabled = false
            identifiedCodeTimerLabel.isHidden = true
            
            let alert = UIAlertController(title: nil, message: "휴대폰 인증이 완료되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                guard let phoneNumber = self.phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                self.findEmailRequest.fetch(vc: self, paramDict: ["phoneNumber": phoneNumber])
            }))
            present(alert, animated: true)
            
        } else if status == "WRONG_CODE" {
            let alert = UIAlertController(title: nil, message: "인증코드가 유효하지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        }
    }
}

// MARK: HTTP - FindEmail
extension FindEmailViewController: FindEmailRequestProtocol {
    func response(userList: [User]?, findEmail status: String) {
        print("[HTTP RES]", findEmailRequest.apiUrl, status)
        
        if status == "OK" {
            guard let userList = userList else { return }
            
            resultContainerView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.resultContainerView.alpha = 1
            })
            
            for user in userList {
                let ferv = FindEmailResultView()
                ferv.user = user
                
                resultStackView.addArrangedSubview(ferv)
                ferv.leadingAnchor.constraint(equalTo: resultStackView.leadingAnchor).isActive = true
                ferv.trailingAnchor.constraint(equalTo: resultStackView.trailingAnchor).isActive = true
            }
        }
    }
}
