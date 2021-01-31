//
//  EditUserViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/28.
//

import UIKit
import SDWebImage


protocol EditUserViewControllerProtocol {
    func closeEditUserVC()
}


class EditUserViewController: UIViewController {
    
    // MARK: Property
    var delegate: EditUserViewControllerProtocol?
    let app = App()
    var user: User?
    let profileImageWidth = SCREEN_WIDTH * (1 / 4)
    let uploadImageRequest = UploadImageRequest()
    let editUserRequest = EditUserRequest()
    var isUploadImage: Bool = false
    let checkUserNickNameRequest = CheckUserNickNameRequest()
    var imageName: String = ""
    var authAccountVC: AccountViewController?
    
    
    // MARK: View
    lazy var photoView: PhotoView = {
        let pv = PhotoView()
        pv.layer.borderWidth = 2
        pv.layer.cornerRadius = profileImageWidth / 2
        pv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageTapped)))
        return pv
    }()
    lazy var imageView: UIImageView = {
        let img = UIImage(systemName: "camera.circle.fill")
        let iv = UIImageView(image: img)
        iv.layer.cornerRadius = (profileImageWidth / 3) / 2
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var textField: UITextField = {
        let tf = UITextField()
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
        
        navigationItem.title = "프로필 편집"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveTapped))
        
        isModalInPresentation = true // 후....
        
        configureView()
        
        setThemeColor()
        
        app.delegate = self
        uploadImageRequest.delegate = self
        editUserRequest.delegate = self
        checkUserNickNameRequest.delegate = self
        
        user = app.getUser()
        guard let user = self.user else { return }
        if let url = URL(string: ((user.profileImage.contains(String(user.id))) ? (PLAPICK_URL + user.profileImage) : user.profileImage)) {
            photoView.sd_setImage(with: url, completed: nil)
        }
        textField.text = user.nickName
    }
    
    
    // MARK: ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.closeEditUserVC()
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
            photoView.layer.borderColor = UIColor.systemGray3.cgColor
        } else {
            view.backgroundColor = .white
            photoView.layer.borderColor = UIColor.systemGray3.cgColor
        }
    }
    
    func configureView() {
        view.addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SPACE_XL).isActive = true
        photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoView.widthAnchor.constraint(equalToConstant: profileImageWidth).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: profileImageWidth).isActive = true
        
        view.addSubview(imageView)
        imageView.trailingAnchor.constraint(equalTo: photoView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: profileImageWidth / 3).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: profileImageWidth / 3).isActive = true
        
        view.addSubview(textFieldView)
        textFieldView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: SPACE_XL).isActive = true
        textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
    
        textFieldView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: SPACE_XS).isActive = true
        textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: SPACE).isActive = true
        textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -SPACE_XS).isActive = true
        textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -SPACE_XS).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func uploadImageTapped() {
        app.checkPhotoGallaryAvailable(vc: self)
    }
    
    @objc func saveTapped() {
        guard let newNickName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        // 아무것도 안했음
        if newNickName == app.getNickName() && !isUploadImage {
            navigationController?.popViewController(animated: true)
            return
        }
        
        if !isValidStrLength(max: 12, kMin: 2, kMax: 8, value: newNickName) {
            let alert = UIAlertController(title: "프로필 편집 실패", message: "닉네임은 한글 2-8자, 영어 최대 12자까지 입력 가능합니다.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
            present(alert, animated: true, completion: nil)
            return
        }
        
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        checkUserNickNameRequest.fetch(vc: self, paramDict: ["nickName": newNickName])
    }
}


// MARK: Extension - App
extension EditUserViewController: AppProtocol {
    func pushNotification(isAllowed: Bool) { }
    func photoGallary(isAllowed: Bool) {
        if isAllowed {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = false
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
    }
}

// MARK: Extension - ImagePicker
extension EditUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        
        if let _selectedImage = selectedImage {
            photoView.image = _selectedImage
            isUploadImage = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Extension - CheckUserNickName
extension EditUserViewController: CheckUserNickNameRequestProtocol {
    func response(checkUserNickName status: String) {
        if status == "OK" {
            guard let newNickName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                hideIndicator(idv: indicatorView, bov: blurOverlayView)
                return
            }
            
            // 이미지 업로드 했을때
            if isUploadImage {
                guard let image = photoView.image else {
                    hideIndicator(idv: indicatorView, bov: blurOverlayView)
                    return
                }
                uploadImageRequest.fetch(vc: self, image: image)
                
            } else {
                editUserRequest.fetch(vc: self, paramDict: ["nickName": newNickName, "profileImage": (isUploadImage) ?  "/images/users/\(app.getUId())/\(imageName).jpg" : app.getProfileImage()])
            }
            
        } else {
            hideIndicator(idv: indicatorView, bov: blurOverlayView)
            if status == "WRONG_NICKNAME" {
                let alert = UIAlertController(title: "프로필 편집 실패", message: "닉네임은 한글 2-8자, 영어 최대 12자까지 입력 가능합니다.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                present(alert, animated: true, completion: nil)
            } else if status == "EXISTS_NICKNAME" {
                let alert = UIAlertController(title: "프로필 편집 실패", message: "중복된 닉네임입니다. 다른 닉네임을 사용해주세요.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: Extension - UploadImage
extension EditUserViewController: UploadImageRequestProtocol {
    func response(imageName: Int?, uploadImage status: String) {
        if status == "OK" {
            if let imageName = imageName {
                self.imageName = String(imageName)
                guard let newNickName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                    hideIndicator(idv: indicatorView, bov: blurOverlayView)
                    return
                }
                
                editUserRequest.fetch(vc: self, paramDict: ["nickName": newNickName, "profileImage":  "/images/users/\(app.getUId())/\(imageName).jpg"])
            }
        } else {
            hideIndicator(idv: indicatorView, bov: blurOverlayView)
        }
    }
}

// MARK: Extension - EditUser
extension EditUserViewController: EditUserRequestProtocol {
    func response(editUser status: String) {
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
        if status == "OK" {
            guard let newNickName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
//            guard let authAccountVC = self.authAccountVC else { return }
            
            app.setNickName(nickName: newNickName)
            authAccountVC?.navigationItem.title = newNickName
            
            if isUploadImage {
                let profileImage = "/images/users/\(app.getUId())/\(imageName).jpg"
                app.setProfileImage(profileImage: profileImage)
                if let url = URL(string: "\(PLAPICK_URL)\(profileImage)") {
                    authAccountVC?.profileImagePhotoView.sd_setImage(with: url, completed: nil)
                }
            }
            
            navigationController?.popViewController(animated: true)
            
        } else {
            if status == "WRONG_NICKNAME" {
                let alert = UIAlertController(title: "프로필 편집 실패", message: "닉네임은 한글 2-8자, 영어 최대 12자까지 입력 가능합니다.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                present(alert, animated: true, completion: nil)
            } else if status == "EXISTS_NICKNAME" {
                let alert = UIAlertController(title: "프로필 편집 실패", message: "중복된 닉네임입니다. 다른 닉네임을 사용해주세요.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
