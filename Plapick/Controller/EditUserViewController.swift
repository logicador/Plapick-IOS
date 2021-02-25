//
//  EditUserViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/28.
//

import UIKit
import SDWebImage


class EditUserViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var user: User?
    let checkUserNickNameRequest = CheckUserNickNameRequest()
    let uploadImageRequest = UploadImageRequest()
    let editUserRequest = EditUserRequest()
    var isUploadImage: Bool = false
    var profileImage: String = "" {
        didSet {
            guard let user = self.user else { return }
            profileImageView.setProfileImage(uId: user.id, profileImage: profileImage)
        }
    }
    
    
    // MARK: View
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = SCREEN_WIDTH * (1 / 8)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var cameraImageView: UIImageView = {
        let img = UIImage(systemName: "camera.circle.fill")
        let iv = UIImageView(image: img)
        iv.layer.cornerRadius = SCREEN_WIDTH * (1 / 24)
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var textContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = SPACE_XS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.placeholder = "문자, 숫자, 마침표 및 밑줄 2-16자"
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // MARK: View - Indicator
    lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    lazy var blurOverlayView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let vev = UIVisualEffectView(effect: blurEffect)
        vev.alpha = 0.3
        vev.translatesAutoresizingMaskIntoConstraints = false
        return vev
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "프로필 편집"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveTapped))
        
        configureView()
        
        hideKeyboardWhenTappedAround()
        
        uploadImageRequest.delegate = self
        editUserRequest.delegate = self
        checkUserNickNameRequest.delegate = self
        
        user = app.getUser()
        guard let user = self.user else { return }
        
        profileImage = user.profileImage ?? ""
        textField.text = user.nickName
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SPACE_XL).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH * (1 / 4)).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH * (1 / 4)).isActive = true
        
        view.addSubview(cameraImageView)
        cameraImageView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor).isActive = true
        cameraImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        cameraImageView.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH * (1 / 12)).isActive = true
        cameraImageView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH * (1 / 12)).isActive = true
        
        view.addSubview(textContainerView)
        textContainerView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: SPACE_XL).isActive = true
        textContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
    
        textContainerView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: textContainerView.topAnchor, constant: SPACE_XS).isActive = true
        textField.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        textField.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        textField.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func uploadImageTapped() {
        dismissKeyboard()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        alert.addAction(UIAlertAction(title: "사진 선택", style: .default, handler: { (_) in
            self.checkPhotoGallaryAvailable(allow: {
                let ipc = UIImagePickerController()
                ipc.sourceType = .photoLibrary
                ipc.allowsEditing = true
                ipc.delegate = self
                self.present(ipc, animated: true, completion: nil)
            })
        }))
        alert.addAction(UIAlertAction(title: "사진 제거", style: .destructive, handler: { (_) in
            self.profileImageView.image = nil
            self.isUploadImage = true
            self.profileImage = ""
        }))
        present(alert, animated: true)
    }
    
    @objc func saveTapped() {
        dismissKeyboard()
        
        guard let user = self.user else { return }
        guard let newNickName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        // 아무것도 안했음
        if newNickName == user.nickName && !isUploadImage {
            navigationController?.popViewController(animated: true)
            return
        }
        
        if newNickName != user.nickName {
            let regEx = "[a-zA-Z0-9가-힣._]{2,16}"
            let test = NSPredicate(format: "SELF MATCHES %@", regEx)
            if !test.evaluate(with: newNickName) {
                let alert = UIAlertController(title: nil, message: "닉네임은 문자, 숫자, 밑줄 및 마침표 2-16자 이내로 입력 가능합니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                present(alert, animated: true, completion: nil)
                return
            }
            
            if newNickName.prefix(1) == "." {
                let alert = UIAlertController(title: nil, message: "닉네임은 마침표로 시작할 수 없습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                present(alert, animated: true, completion: nil)
                return
            }
            
            showIndicator(idv: indicatorView, bov: blurOverlayView)
            checkUserNickNameRequest.fetch(vc: self, paramDict: ["nickName": newNickName])
            
        } else {  // 이미지 변경만 했음
            showIndicator(idv: indicatorView, bov: blurOverlayView)
            if let image = profileImageView.image { uploadImageRequest.fetch(vc: self, image: image) } // 이미지를 교체함
            else { editUserRequest.fetch(vc: self, paramDict: ["nickName": newNickName, "profileImage": ""]) } // 이미지를 제거함
        }
    }
}

// MARK: ImagePicker
extension EditUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let image = info[.editedImage] as? UIImage { selectedImage = image }
        else if let image = info[.originalImage] as? UIImage { selectedImage = image }
        
        if let _selectedImage = selectedImage {
            profileImageView.image = _selectedImage
            isUploadImage = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: HTTP - CheckUserNickName
extension EditUserViewController: CheckUserNickNameRequestProtocol {
    func response(checkUserNickName status: String) {
        print("[HTTP RES]", checkUserNickNameRequest.apiUrl, status)
        
        if status == "OK" {
            guard let user = self.user else { return }
            guard let newNickName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            if isUploadImage {
                if let image = profileImageView.image { uploadImageRequest.fetch(vc: self, image: image) } // 이미지를 교체함
                else { editUserRequest.fetch(vc: self, paramDict: ["nickName": newNickName, "profileImage": ""]) } // 이미지를 제거함
            } else { editUserRequest.fetch(vc: self, paramDict: ["nickName": newNickName, "profileImage": user.profileImage ?? ""]) } // 닉네임만 변경함
            
        } else {
            if status == "WRONG_NICKNAME" {
                let alert = UIAlertController(title: "프로필 편집", message: "닉네임은 2-16자까지 입력 가능합니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                present(alert, animated: true, completion: nil)
                
            } else if status == "EXISTS_NICKNAME" {
                let alert = UIAlertController(title: "프로필 편집", message: "중복된 닉네임입니다. 다른 닉네임을 사용해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                present(alert, animated: true, completion: nil)
            }
            hideIndicator(idv: indicatorView, bov: blurOverlayView)
        }
    }
}

// MARK: HTTP - UploadImage
extension EditUserViewController: UploadImageRequestProtocol {
    func response(imageName: Int?, uploadImage status: String) {
        print("[HTTP RES]", uploadImageRequest.apiUrl, status)
        
        if status == "OK" {
            guard let user = self.user else { return }
            
            guard let imageName = imageName else { return }
            profileImage = "/images/users/\(user.id)/\(imageName).jpg"
            guard let newNickName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            editUserRequest.fetch(vc: self, paramDict: ["nickName": newNickName, "profileImage": profileImage])
            
        } else { hideIndicator(idv: indicatorView, bov: blurOverlayView) }
    }
}

// MARK: HTTP - EditUser
extension EditUserViewController: EditUserRequestProtocol {
    func response(editUser status: String) {
        print("[HTTP RES]", editUserRequest.apiUrl, status)
        
        if status == "OK" {
            guard let newNickName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            app.setProfileImage(profileImage: profileImage)
            app.setNickName(nickName: newNickName)
            
            navigationController?.popViewController(animated: true)
            
        } else {
            if status == "WRONG_NICKNAME" {
                let alert = UIAlertController(title: "프로필 편집", message: "닉네임은 2-16자까지 입력 가능합니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                present(alert, animated: true, completion: nil)
                
            } else if status == "EXISTS_NICKNAME" {
                let alert = UIAlertController(title: "프로필 편집", message: "중복된 닉네임입니다. 다른 닉네임을 사용해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                present(alert, animated: true, completion: nil)
            }
        }
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}
