//
//  JoinProfileViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/18.
//

import UIKit
import PhotosUI


class JoinProfileViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var userType: String?
    var phoneNumber: String?
    var socialId: String?
    var email: String?
    var password: String?
    let checkNicknameRequest = CheckNicknameRequest()
    let uploadImageRequest = UploadImageRequest()
    let joinRequest = JoinRequest()
    let editProfileImageRequest = EditProfileImageRequest()
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profiletitleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필"
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 60
        iv.layer.borderWidth = LINE_WIDTH
        iv.backgroundColor = .systemGray6
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var profileIconImageView: UIImageView = {
        let image = UIImage(systemName: "photo")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var addImageView: UIImageView = {
        let image = UIImage(systemName: "plus.circle.fill")
        let iv = UIImageView(image: image)
        iv.layer.cornerRadius = 15
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var nicknameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nicknameTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.addTarget(self, action: #selector(nicknameChanged), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var nicknameInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "2-12자, 영어, 한글, 숫자, 특수문자 . 또는 _"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입 완료", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = LINE_WIDTH
        button.backgroundColor = .systemGray6
        button.isEnabled = false
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(joinTapped), for: .touchUpInside)
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
        
        navigationItem.title = "회원가입"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        hideKeyboardWhenTappedAround()
        
        checkNicknameRequest.delegate = self
        uploadImageRequest.delegate = self
        joinRequest.delegate = self
        editProfileImageRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        profileImageView.layer.borderColor = UIColor.separator.cgColor
        
        addImageView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        profileIconImageView.tintColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        nicknameTextContainerView.layer.borderColor = UIColor.separator.cgColor
        
        joinButton.layer.borderColor = UIColor.separator.cgColor
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        containerView.addSubview(profiletitleLabel)
        profiletitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_XXL).isActive = true
        profiletitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        profiletitleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        containerView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: profiletitleLabel.bottomAnchor, constant: SPACE).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        profileImageView.addSubview(profileIconImageView)
        profileIconImageView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        profileIconImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        profileIconImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileIconImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        containerView.addSubview(addImageView)
        addImageView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor).isActive = true
        addImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        
        containerView.addSubview(nicknameTitleLabel)
        nicknameTitleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: SPACE).isActive = true
        nicknameTitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        nicknameTitleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true

        containerView.addSubview(nicknameTextContainerView)
        nicknameTextContainerView.topAnchor.constraint(equalTo: nicknameTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        nicknameTextContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        nicknameTextContainerView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        nicknameTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true

        nicknameTextContainerView.addSubview(nicknameTextField)
        nicknameTextField.topAnchor.constraint(equalTo: nicknameTextContainerView.topAnchor).isActive = true
        nicknameTextField.leadingAnchor.constraint(equalTo: nicknameTextContainerView.leadingAnchor, constant: 15).isActive = true
        nicknameTextField.trailingAnchor.constraint(equalTo: nicknameTextContainerView.trailingAnchor, constant: -15).isActive = true
        nicknameTextField.bottomAnchor.constraint(equalTo: nicknameTextContainerView.bottomAnchor).isActive = true
        
        containerView.addSubview(nicknameInfoLabel)
        nicknameInfoLabel.topAnchor.constraint(equalTo: nicknameTextContainerView.bottomAnchor, constant: SPACE_XXS).isActive = true
        nicknameInfoLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        nicknameInfoLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        containerView.addSubview(joinButton)
        joinButton.topAnchor.constraint(equalTo: nicknameInfoLabel.bottomAnchor, constant: SPACE).isActive = true
        joinButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        joinButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        joinButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func imageTapped() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
            DispatchQueue.main.async {
                if status == .limited || status == .authorized {
                    var configuration = PHPickerConfiguration()
                    configuration.selectionLimit = 1
                    configuration.filter = .any(of: [.images])
                    let picker = PHPickerViewController(configuration: configuration)
                    picker.delegate = self
                    self.present(picker, animated: true, completion: nil)
                    
                } else {
                    self.requestSettingAlert(title: "앨범 액세스 허용하기", message: "프로필 이미지 업로드를 위해 앨범에 접근합니다.")
                }
            }
        }
    }
    
    @objc func nicknameChanged() {
        guard let nickname = nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let nicknameRegEx = "[a-zA-Z0-9가-힣._]{2,12}"
        let nicknameTest = NSPredicate(format:"SELF MATCHES %@", nicknameRegEx)
        
        if !nicknameTest.evaluate(with: nickname) {
            nicknameInfoLabel.text = "2-12자, 영어, 한글, 숫자, 특수문자 . 또는 _"
            nicknameInfoLabel.textColor = .systemRed
            joinButton.isEnabled = false
            return
        }
        
        if nickname.prefix(1) == "." || nickname.prefix(1) == "_" {
            nicknameInfoLabel.text = ". 또는 _ 로 시작할 수 없습니다."
            nicknameInfoLabel.textColor = .systemRed
            joinButton.isEnabled = false
            return
        }
        
        nicknameInfoLabel.text = "사용 가능한 닉네임 형식입니다."
        nicknameInfoLabel.textColor = .systemGreen
        joinButton.isEnabled = true
    }
    
    @objc func joinTapped() {
        guard let nickname = nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        checkNicknameRequest.fetch(vc: self, paramDict: ["nickname": nickname])
    }
}


// MARK: PHPicker
extension JoinProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
            DispatchQueue.main.async {
                let resImage = image as! UIImage
                self.profileImageView.image = resImage
                self.profileIconImageView.isHidden = true
            }
        })
    }
}

// MARK: HTTP - CheckNickname
extension JoinProfileViewController: CheckNicknameRequestProtocol {
    func response(checkNickname status: String) {
        print("[HTTP RES]", checkNicknameRequest.apiUrl, status)
        
        if status == "OK" {
            guard let userType = self.userType else { return }
            guard let phoneNumber = self.phoneNumber else { return }
            guard let nickname = nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            joinRequest.fetch(vc: self, paramDict: ["userType": userType, "phoneNumber": phoneNumber, "socialId": socialId ?? "", "email": email ?? "", "password": password ?? "", "nickname": nickname])
            
        } else if status == "EXISTS_NICKNAME" {
            nicknameInfoLabel.text = "이미 사용중인 닉네임입니다."
            nicknameInfoLabel.textColor = .systemRed
            joinButton.isEnabled = false
            
            let alert = UIAlertController(title: nil, message: "이미 사용중인 닉네임입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        }
    }
}

// MARK: HTTP - Join
extension JoinProfileViewController: JoinRequestProtocol {
    func response(user: User?, join status: String) {
        print("[HTTP RES]", joinRequest.apiUrl, status)
        
        if status == "OK" {
            guard let user = user else { return }
            app.login(user: user)
            
            if let image = profileImageView.image {
                showIndicator(idv: indicatorView, bov: blurOverlayView)
                uploadImageRequest.fetch(vc: self, image: image)
                
            } else {
                changeRootViewController(rootViewController: MainViewController())
            }
            
        } else if status == "EXISTS_NICKNAME" {
            let alert = UIAlertController(title: nil, message: "이미 사용중인 닉네임입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        } else if status == "EXISTS_EMAIL" {
            let alert = UIAlertController(title: nil, message: "이미 사용중인 이메일입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                self.changeRootViewController(rootViewController: LoginViewController())
            }))
            present(alert, animated: true)
        } else if status == "EXISTS_SOCIAL_ID" {
            let alert = UIAlertController(title: nil, message: "이미 가입이 완료된 사용자입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                self.changeRootViewController(rootViewController: LoginViewController())
            }))
            present(alert, animated: true)
        }
    }
}

// MARK: HTTP - UploadImage
extension JoinProfileViewController: UploadImageRequestProtocol {
    func response(imageName: Int?, uploadImage status: String) {
        print("[HTTP RES]", uploadImageRequest.apiUrl, status)
        
        if status == "OK" {
            guard let imageName = imageName else { return }
            editProfileImageRequest.fetch(vc: self, paramDict: ["profileImage": "/images/users/\(app.getUserId())/\(imageName).jpg"])
        }
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}

// MARK: HTTP - EditProfileImage
extension JoinProfileViewController: EditProfileImageRequestProtocol {
    func response(profileImage status: String) {
        print("[HTTP RES]", editProfileImageRequest.apiUrl, status)
        
        if status == "OK" {
            changeRootViewController(rootViewController: MainViewController())
        }
    }
}
