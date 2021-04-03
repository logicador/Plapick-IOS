//
//  EditPasswordViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/21.
//

import UIKit


class EditPasswordViewController: UIViewController {
    
    // MARK: Property
    var rpcId: Int?
    var phoneNumber: String?
    var email: String?
    var checksum: String?
    let editPasswordRequest = EditPasswordRequest()
    
    
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
    
    lazy var passwordTitleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 비밀번호"
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var passwordContainerView: UIView = {
        let view = UIView()
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
    
    lazy var changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setTitle("비밀번호 재설정 완료", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = LINE_WIDTH
        button.backgroundColor = .systemGray6
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(changePasswordTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "비밀번호 재설정"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        hideKeyboardWhenTappedAround()
        
        editPasswordRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        passwordTextContainerView.layer.borderColor = UIColor.separator.cgColor
        passwordConfirmTextContainerView.layer.borderColor = UIColor.separator.cgColor
        changePasswordButton.layer.borderColor = UIColor.separator.cgColor
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
        
        passwordContainerView.addSubview(changePasswordButton)
        changePasswordButton.topAnchor.constraint(equalTo: passwordConfirmInfoLabel.bottomAnchor, constant: SPACE).isActive = true
        changePasswordButton.centerXAnchor.constraint(equalTo: passwordContainerView.centerXAnchor).isActive = true
        changePasswordButton.widthAnchor.constraint(equalTo: passwordContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        changePasswordButton.bottomAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
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
            changePasswordButton.isEnabled = true
        } else {
            changePasswordButton.isEnabled = false
        }
    }
    
    @objc func changePasswordTapped() {
        dismissKeyboard()
        
        guard let rpcId = self.rpcId else { return }
        guard let phoneNumber = self.phoneNumber else { return }
        guard let email = self.email else { return }
        guard let checksum = self.checksum else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        editPasswordRequest.fetch(vc: self, paramDict: ["password": password, "rpcId": String(rpcId), "phoneNumber": phoneNumber, "email": email, "checksum": checksum])
    }
}


// MARK: HTTP - EditPassword
extension EditPasswordViewController: EditPasswordRequestProtocol {
    func response(editPassword status: String) {
        print("[HTTP RES]", editPasswordRequest.apiUrl, status)
        
        if status == "OK" {
            let alert = UIAlertController(title: nil, message: "비밀번호 변경이 완료되었습니다.\n새로운 비밀번호로 로그인해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                self.changeRootViewController(rootViewController: UINavigationController(rootViewController: LoginViewController()))
            }))
            present(alert, animated: true)
        } else if status == "WRONG_CHECKSUM" {
            let alert = UIAlertController(title: nil, message: "비밀번호를 변경할 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        }
    }
}
