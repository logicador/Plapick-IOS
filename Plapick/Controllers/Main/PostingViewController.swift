//
//  PostingViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit
import Photos


// MARK: Protocol
protocol PostingViewControllerProtocol {
    func closeViewController()
}


class PostingViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    var delegate: PostingViewControllerProtocol?
    let searchPlaceViewController: SearchPlaceViewController = SearchPlaceViewController()
    var uploadViewController: UploadViewController?
    var accountViewController: AccountViewController?
    
    
    // MARK: Views
    lazy var pickButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("앨범에서 사진 선택", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(openImagePickerController), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var photoAuthButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("앨범 액세스 허용하기", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(requestAuth), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "새로운 픽"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        
        let requiredAccessLevel: PHAccessLevel = .readWrite
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { authorizationStatus in
            switch authorizationStatus {
            case .limited:
                self.configureImageView()
            case .authorized:
                self.configureImageView()
            case .denied:
                self.configurePhotoAuthView()
            default:
                self.configurePhotoAuthView()
            }
        }
        
        searchPlaceViewController.delegate = self
        searchPlaceViewController.isSelectMode = true
        
        adjustColors()
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .systemBackground
            imageView.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .tertiarySystemGroupedBackground
            imageView.backgroundColor = .systemBackground
        }
    }
    
    @objc func backTapped() {
        delegate?.closeViewController() // 부모인 MainTabBarController에게 자신이 종료됨을 알려주어야 함
    }
    
    @objc func openImagePickerController() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func openSearchViewController() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        let navigationController = UINavigationController(rootViewController: searchPlaceViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func requestAuth() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
    
    func configurePhotoAuthView() {
        DispatchQueue.main.async {
            self.view.addSubview(self.photoAuthButton)
            self.photoAuthButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.photoAuthButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        }
    }
    
    func configureImageView() {
        DispatchQueue.main.async {
            self.view.addSubview(self.pickButton)
            self.pickButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            self.pickButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            
            self.view.addSubview(self.imageView)
            self.imageView.topAnchor.constraint(equalTo: self.pickButton.bottomAnchor, constant: 20).isActive = true
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            self.imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            self.imageView.heightAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            
            self.view.addSubview(self.topLineView)
            self.topLineView.topAnchor.constraint(equalTo: self.imageView.topAnchor).isActive = true
            self.topLineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            self.topLineView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            self.topLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
            
            self.view.addSubview(self.bottomLineView)
            self.bottomLineView.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
            self.bottomLineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            self.bottomLineView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            self.bottomLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        }
    }
}


// MARK: Extensions
extension PostingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        var selectedImage: UIImage?
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        
        guard let _selectedImage = selectedImage else { return }
        
        imageView.image = _selectedImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: UIBarButtonItem.Style.plain, target: self, action: #selector(openSearchViewController))
        
        dismiss(animated: true, completion: nil)
    }
}


extension PostingViewController: SearchPlaceViewControllerProtocol {
    func selectPlace(place: Place) {
        uploadViewController = UploadViewController(uploadImage: imageView.image!, place: place)
        uploadViewController?.delegate = self
        uploadViewController?.accountViewController = accountViewController
        let navigationController = UINavigationController(rootViewController: uploadViewController!)
        navigationController.modalPresentationStyle = .fullScreen
        searchPlaceViewController.present(navigationController, animated: true)
    }
}


extension PostingViewController: UploadViewControllerProtocol {
    func closeViewController() {
        self.uploadViewController?.dismiss(animated: false) {
            self.searchPlaceViewController.dismiss(animated: false) {
                self.delegate?.closeViewController()
            }
        }
    }
}
