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
    let searchPlaceViewController = SearchPlaceViewController()
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
    
    lazy var photoView: PhotoView = {
        let pv = PhotoView()
        pv.contentMode = .scaleAspectFit
        return pv
    }()
    
//    lazy var photoAuthButton: UIButton = {
//        let button = UIButton(type: UIButton.ButtonType.system)
//        button.setTitle("앨범 액세스 허용하기", for: UIControl.State.normal)
//        button.addTarget(self, action: #selector(requestAuth), for: UIControl.Event.touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
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
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        
        view.addSubview(pickButton)
        pickButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        pickButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: pickButton.bottomAnchor, constant: 20).isActive = true
        photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photoView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        photoView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(topLineView)
        topLineView.topAnchor.constraint(equalTo: photoView.topAnchor).isActive = true
        topLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: LINE_VIEW_HEIGHT).isActive = true
        
        view.addSubview(bottomLineView)
        bottomLineView.bottomAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
        bottomLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomLineView.heightAnchor.constraint(equalToConstant: LINE_VIEW_HEIGHT).isActive = true
        
        adjustColors()
        
        searchPlaceViewController.delegate = self
        searchPlaceViewController.isSelectMode = true
        app.delegate = self
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
    }
    
    
    // MARK:
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.closeViewController()
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .systemBackground
//            imageView.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .tertiarySystemGroupedBackground
//            imageView.backgroundColor = .systemBackground
        }
    }
    
//    @objc func backTapped() {
//        delegate?.closeViewController() // 부모인 MainTabBarController에게 자신이 종료됨을 알려주어야 함
//    }
    
    @objc func openImagePickerController() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        app.checkPhotoGallaryAvailable(parentViewController: self)
    }
    
    @objc func openSearchViewController() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        self.navigationController?.pushViewController(searchPlaceViewController, animated: true)
        
//        let navigationController = UINavigationController(rootViewController: searchPlaceViewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true)
    }
    
//    @objc func requestAuth() {
//        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
//            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
//        }
//    }
    
//    func configurePhotoAuthView() {
//        DispatchQueue.main.async {
//            self.view.addSubview(self.photoAuthButton)
//            self.photoAuthButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//            self.photoAuthButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        }
//    }
//
//    func configureImageView() {
//        DispatchQueue.main.async {
//
//        }
//    }
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
        
        photoView.image = _selectedImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: UIBarButtonItem.Style.plain, target: self, action: #selector(openSearchViewController))
        
        dismiss(animated: true, completion: nil)
    }
}


extension PostingViewController: SearchPlaceViewControllerProtocol {
    func selectPlace(place: Place) {
        uploadViewController = UploadViewController(uploadImage: photoView.image!, place: place)
        uploadViewController?.delegate = self
        uploadViewController?.accountViewController = accountViewController
        self.navigationController?.pushViewController(uploadViewController!, animated: true)
//        let navigationController = UINavigationController(rootViewController: uploadViewController!)
//        navigationController.modalPresentationStyle = .fullScreen
//        searchPlaceViewController.present(navigationController, animated: true)
    }
}


extension PostingViewController: UploadViewControllerProtocol {
    func closeViewController() {
        self.navigationController?.popToRootViewController(animated: true)
//        self.uploadViewController?.dismiss(animated: false) {
//            self.searchPlaceViewController.dismiss(animated: false) {
//                self.delegate?.closeViewController()
//            }
//        }
    }
}


extension PostingViewController: AppProtocol {
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
