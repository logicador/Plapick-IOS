//
//  ProfileSettingViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/13.
//

import UIKit
import Alamofire


class ProfileSettingViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    var isUploadProfileImage: Bool = false
    var isRemoveProfileImage: Bool = false
    var checkNickNameRequest = CheckNickNameRequest()
    var uploadImageRequest = UploadImageRequest()
    var setMyProfileRequest = SetMyProfileRequest()
    var accountViewController: AccountViewController?
    
    
    // MARK: Views
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profilePhotoView: PhotoView = {
        let pv = PhotoView()
        pv.layer.cornerRadius = 60
        pv.layer.borderWidth = 2
        pv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profilePhotoViewTapped)))
        return pv
    }()
    
    lazy var cameraImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.image = UIImage(systemName: "camera.circle.fill")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 18
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var nickNameTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var nickNameTextFieldView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = LINE_VIEW_HEIGHT
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "프로필 설정"
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editProfile))
        
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        containerView.addSubview(profilePhotoView)
        profilePhotoView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        profilePhotoView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profilePhotoView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        profilePhotoView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(nickNameTextFieldView)
        nickNameTextFieldView.topAnchor.constraint(equalTo: profilePhotoView.bottomAnchor, constant: 20).isActive = true
        nickNameTextFieldView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        nickNameTextFieldView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        nickNameTextFieldView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nickNameTextFieldView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        
        nickNameTextFieldView.addSubview(nickNameTextField)
        nickNameTextField.topAnchor.constraint(equalTo: nickNameTextFieldView.topAnchor).isActive = true
        nickNameTextField.leadingAnchor.constraint(equalTo: nickNameTextFieldView.leadingAnchor, constant: 10).isActive = true
        nickNameTextField.trailingAnchor.constraint(equalTo: nickNameTextFieldView.trailingAnchor, constant: -10).isActive = true
        nickNameTextField.bottomAnchor.constraint(equalTo: nickNameTextFieldView.bottomAnchor).isActive = true
        
        containerView.addSubview(cameraImageView)
        cameraImageView.trailingAnchor.constraint(equalTo: profilePhotoView.trailingAnchor).isActive = true
        cameraImageView.bottomAnchor.constraint(equalTo: profilePhotoView.bottomAnchor).isActive = true
        cameraImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        cameraImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        view.addSubview(topLineView)
        topLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        topLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: LINE_VIEW_HEIGHT).isActive = true
        
        view.addSubview(bottomLineView)
        bottomLineView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bottomLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomLineView.heightAnchor.constraint(equalToConstant: LINE_VIEW_HEIGHT).isActive = true
        
        checkNickNameRequest.delegate = self
        uploadImageRequest.delegate = self
        setMyProfileRequest.delegate = self
        app.delegate = self
        
        adjustColors()
        hideKeyboardWhenTappedAround()
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        let user = app.getUser()
        if !user.profileImageUrl.isEmpty {
            profilePhotoView.image = app.getUrlImage(urlString: ((user.profileImageUrl.contains(String(user.id))) ? (PLAPICK_URL + user.profileImageUrl) : user.profileImageUrl))
        }
        nickNameTextField.text = user.nickName
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        nickNameTextFieldView.layer.borderColor = UIColor.separator.cgColor
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .systemBackground
            containerView.backgroundColor = .systemGray6
            profilePhotoView.layer.borderColor = UIColor.systemBackground.cgColor
            nickNameTextFieldView.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .tertiarySystemGroupedBackground
            containerView.backgroundColor = .systemBackground
            profilePhotoView.layer.borderColor = UIColor.tertiarySystemGroupedBackground.cgColor
            nickNameTextFieldView.backgroundColor = .tertiarySystemGroupedBackground
        }
    }
    
//    @objc func backTapped() {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @objc func profilePhotoViewTapped() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        app.checkPhotoGallaryAvailable(parentViewController: self)
    }
    
    @objc func editProfile() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        let newNickName = nickNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if newNickName == "" {
            let alert = UIAlertController(title: "프로필 설정", message: "닉네임을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
            present(alert, animated: true)
            return
        }
        
        if newNickName!.count < 2 {
            let alert = UIAlertController(title: "프로필 설정", message: "닉네임은 2자 이상 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
            present(alert, animated: true)
            return
        }
        
        if newNickName!.count > 12 {
            let alert = UIAlertController(title: "프로필 설정", message: "닉네임은 최대 12자까지 입력 가능합니다.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
            present(alert, animated: true)
            return
        }
        
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
        
        // 닉네임이 변경되었다면 (중복체크)
        if newNickName != app.getUser().nickName {
            checkNickNameRequest.fetch(vc: self, nickName: newNickName!)
            return
        }
        
        // 프로필 이미지를 업로드했을 경우
        if isUploadProfileImage {
            guard let image = profilePhotoView.image else {
                hideIndicator()
                let alert = UIAlertController(title: "ERR_IMAGE", message: "이미지 데이터를 찾지 못했습니다.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                present(alert, animated: true)
                return
            }
            uploadImageRequest.fetch(imageData: image.jpegData(compressionQuality: COMPRESS_IMAGE_QUALITY)!)
            return
        }
        
        // 아무것도 변경된게 없을 때 (프로필 이미지도 업로드 안하고 삭제도 안하고 닉네임 변경도 안함)
        if !isRemoveProfileImage && newNickName == app.getUser().nickName {
            hideIndicator()
//            dismiss(animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
            
        } else {
            var paramList: [Param] = []
            paramList.append(Param(key: "isUploadProfileImage", value: (isUploadProfileImage ? "Y" : "N")))
            paramList.append(Param(key: "isRemoveProfileImage", value: (isRemoveProfileImage ? "Y" : "N")))
            paramList.append(Param(key: "nickName", value: newNickName!))
            setMyProfileRequest.fetch(vc: self, paramList: paramList)
        }
    }
    
    func hideIndicator() {
        self.indicatorView.stopAnimating()
        self.indicatorView.removeView()
        self.overlayView.removeView()
    }
}


// MARK: Extensions
extension ProfileSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        var selectedImage: UIImage?
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        
        guard let _selectedImage = selectedImage else { return }
        
        profilePhotoView.image = _selectedImage
        isUploadProfileImage = true
        isRemoveProfileImage = false
        
        // imagePicker dismiss
        dismiss(animated: true, completion: nil)
    }
}


extension ProfileSettingViewController: CheckNickNameRequestProtocol {
    func response(status: String) {
        if status == "OK" {
            let newNickName = nickNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            // 프로필 이미지를 업로드했을 경우
            if isUploadProfileImage {
                guard let image = profilePhotoView.image else {
                    hideIndicator()
                    let alert = UIAlertController(title: "ERR_IMAGE", message: "이미지 데이터를 찾지 못했습니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                    present(alert, animated: true)
                    return
                }
                uploadImageRequest.fetch(imageData: image.jpegData(compressionQuality: COMPRESS_IMAGE_QUALITY)!)
                return
            }
            
            // 아무것도 변경된게 없을 때 (프로필 이미지도 업로드 안하고 삭제도 안하고 닉네임 변경도 안함)
            if !isRemoveProfileImage && newNickName == app.getUser().nickName {
                hideIndicator()
//                dismiss(animated: true, completion: nil)
                navigationController?.popViewController(animated: true)
                
            } else {
                var paramList: [Param] = []
                paramList.append(Param(key: "isUploadProfileImage", value: (isUploadProfileImage ? "Y" : "N")))
                paramList.append(Param(key: "isRemoveProfileImage", value: (isRemoveProfileImage ? "Y" : "N")))
                paramList.append(Param(key: "nickName", value: newNickName!))
                setMyProfileRequest.fetch(vc: self, paramList: paramList)
            }
            
        } else if status == "EXISTS_NICK_NAME" {
            hideIndicator()
            let alert = UIAlertController(title: "닉네임 중복", message: "이미 누군가 사용중인 닉네임입니다.\n다른 닉네임을 사용해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
            present(alert, animated: true)
            
        } else { hideIndicator() }
    }
}


extension ProfileSettingViewController: UploadImageRequestProtocol {
    func response(imageName: Int?, status: String) {
        if status == "OK" {
            if let imageName = imageName {
                let newNickName = nickNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                var paramList: [Param] = []
                paramList.append(Param(key: "isUploadProfileImage", value: (isUploadProfileImage ? "Y" : "N")))
                paramList.append(Param(key: "isRemoveProfileImage", value: (isRemoveProfileImage ? "Y" : "N")))
                paramList.append(Param(key: "nickName", value: newNickName!))
                paramList.append(Param(key: "imageName", value: String(imageName)))
                setMyProfileRequest.fetch(vc: self, paramList: paramList)
            }
        } else { hideIndicator() }
    }
}


extension ProfileSettingViewController: SetMyProfileRequestProtocol {
    func response(user: User?, status: String) {
        hideIndicator()
        
        if status == "OK" {
            if let user = user {
                app.setNickName(nickName: user.nickName)
                app.setProfileImage(profileImageUrl: user.profileImageUrl)
                accountViewController?.getAccount()
//                dismiss(animated: true, completion: nil)
                navigationController?.popViewController(animated: true)
            }
        }
    }
}


extension ProfileSettingViewController: AppProtocol {
    func pushNotification(isAllowed: Bool) { }
    func photoGallary(isAllowed: Bool) {
        if isAllowed {
            let alert = UIAlertController(title: "프로필 이미지 변경", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel))
            alert.addAction(UIAlertAction(title: "앨범에서 선택", style: UIAlertAction.Style.default, handler: { (_) in
                if !self.app.isNetworkAvailable() {
                    self.app.showNetworkAlert(parentViewController: self)
                    return
                }
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.allowsEditing = true
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "프로필 이미지 제거", style: UIAlertAction.Style.destructive, handler: { (_) in
                if !self.app.isNetworkAvailable() {
                    self.app.showNetworkAlert(parentViewController: self)
                    return
                }
                
                self.profilePhotoView.image = nil
                self.isUploadProfileImage = false
                self.isRemoveProfileImage = true
            }))
            present(alert, animated: true)
        }
    }
}
