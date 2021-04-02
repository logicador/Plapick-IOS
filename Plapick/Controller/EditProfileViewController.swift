//
//  EditProfileViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/29.
//

import UIKit
import PhotosUI


protocol EditProfileViewControllerProtocol {
    func editProfile()
}


class EditProfileViewController: UIViewController {
    
    // MARK: Property
    var delegate: EditProfileViewControllerProtocol?
    let app = App()
    var isUploadImage = false
    let uploadImageRequest = UploadImageRequest()
    let editProfileImageRequest = EditProfileImageRequest()
    let checkNicknameRequest = CheckNicknameRequest()
    let editNicknameRequest = EditNicknameRequest()
    
    
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
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        label.textColor = .systemGreen
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
        
        navigationItem.title = "프로필 편집"
        
        configureView()
        
        setThemeColor()
        
        hideKeyboardWhenTappedAround()
        
        uploadImageRequest.delegate = self
        editProfileImageRequest.delegate = self
        checkNicknameRequest.delegate = self
        editNicknameRequest.delegate = self
        
        nicknameTextField.text = app.getUserNickName()
        guard let url = URL(string: PLAPICK_URL + app.getUserProfileImage()) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            profileIconImageView.isHidden = true
            profileImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        profileImageView.layer.borderColor = UIColor.separator.cgColor
        
        addImageView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        profileIconImageView.tintColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        nicknameTextContainerView.layer.borderColor = UIColor.separator.cgColor
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
        
        containerView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_XXL).isActive = true
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
        nicknameInfoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    
    // MARK: Function - @OBJC
    @objc func imageTapped() {
        dismissKeyboard()
        
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
            navigationItem.rightBarButtonItem = nil
            return
        }
        
        if nickname.prefix(1) == "." || nickname.prefix(1) == "_" {
            nicknameInfoLabel.text = ". 또는 _ 로 시작할 수 없습니다."
            nicknameInfoLabel.textColor = .systemRed
            navigationItem.rightBarButtonItem = nil
            return
        }
        
        nicknameInfoLabel.textColor = .systemGreen
        
        if nickname != app.getUserNickName() {
            nicknameInfoLabel.text = "사용 가능한 닉네임 형식입니다."
            nicknameInfoLabel.textColor = .systemGreen
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveTapped))
        } else {
            nicknameInfoLabel.text = ""
            nicknameInfoLabel.textColor = .systemGreen
            if isUploadImage {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveTapped))
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    @objc func saveTapped() {
        dismissKeyboard()
        
        guard let nickname = nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if nickname != app.getUserNickName() {
            checkNicknameRequest.fetch(vc: self, paramDict: ["nickname": nickname])
        } else {
            if isUploadImage {
                showIndicator(idv: indicatorView, bov: blurOverlayView)
                guard let image = profileImageView.image else { return }
                uploadImageRequest.fetch(vc: self, image: image)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
}


// MARK: PHPicker
extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
            DispatchQueue.main.async {
                let resImage = image as! UIImage
                self.profileImageView.image = resImage
                self.profileIconImageView.isHidden = true
                self.isUploadImage = true
                self.nicknameChanged()
            }
        })
    }
}

// MARK: HTTP - UploadImage
extension EditProfileViewController: UploadImageRequestProtocol {
    func response(imageName: Int?, uploadImage status: String) {
        print("[HTTP RES]", uploadImageRequest.apiUrl, status)
        
        if status == "OK" {
            guard let imageName = imageName else { return }
            let profileImage = "/images/users/\(app.getUserId())/\(imageName).jpg"
            app.setUserProfileImage(profileImage: profileImage)
            editProfileImageRequest.fetch(vc: self, paramDict: ["profileImage": profileImage])
        }
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}

// MARK: HTTP - EditProfileImage
extension EditProfileViewController: EditProfileImageRequestProtocol {
    func response(profileImage status: String) {
        print("[HTTP RES]", editProfileImageRequest.apiUrl, status)
        
        if status == "OK" {
            delegate?.editProfile()
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: HTTP - CheckNickname
extension EditProfileViewController: CheckNicknameRequestProtocol {
    func response(checkNickname status: String) {
        print("[HTTP RES]", checkNicknameRequest.apiUrl, status)
        
        if status == "OK" {
            guard let nickname = nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            app.setUserNickname(nickname: nickname)
            editNicknameRequest.fetch(vc: self, paramDict: ["nickname": nickname])
            
        } else if status == "EXISTS_NICKNAME" {
            nicknameInfoLabel.text = "이미 사용중인 닉네임입니다."
            nicknameInfoLabel.textColor = .systemRed
            navigationItem.rightBarButtonItem = nil
            
            let alert = UIAlertController(title: nil, message: "이미 사용중인 닉네임입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        }
    }
}

// MARK: HTTP - EditNickname
extension EditProfileViewController: EditNicknameRequestProtocol {
    func response(editNickname status: String) {
        print("[HTTP RES]", editNicknameRequest.apiUrl, status)
        
        if status == "OK" {
            if isUploadImage {
                showIndicator(idv: indicatorView, bov: blurOverlayView)
                guard let image = profileImageView.image else { return }
                uploadImageRequest.fetch(vc: self, image: image)
                
            } else {
                delegate?.editProfile()
                navigationController?.popViewController(animated: true)
            }
            
        } else if status == "EXISTS_NICKNAME" {
            nicknameInfoLabel.text = "이미 사용중인 닉네임입니다."
            nicknameInfoLabel.textColor = .systemRed
            navigationItem.rightBarButtonItem = nil
            
            let alert = UIAlertController(title: nil, message: "이미 사용중인 닉네임입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        }
    }
}
