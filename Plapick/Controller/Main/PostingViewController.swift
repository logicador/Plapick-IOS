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
    func closePostingVC(isUploaded: Bool)
}


class PostingViewController: UIViewController {
    
    // MARK: Property
    var app = App()
    var delegate: PostingViewControllerProtocol?
//    var searchKakaoPlaceVC = SearchKakaoPlaceViewController()
    var isOpenedChildVC: Bool = false
//    var authAccountVC: AccountViewController?
    var selectedImage: UIImage?
    let addPlaceRequest = AddPlaceRequest()
    let uploadImageRequest = UploadImageRequest()
    let addPickRequest = AddPickRequest()
    var isUploaded: Bool = false
    var selectedPlace: Place? {
        didSet {
            guard let place = selectedPlace else { return }
            
            placeContainerView.removeAllChildView()
            
            let pmv = PlaceMediumView()
            pmv.place = place
            pmv.delegate = self
            
            placeContainerView.addSubview(pmv)
            pmv.topAnchor.constraint(equalTo: placeContainerView.topAnchor).isActive = true
            pmv.leadingAnchor.constraint(equalTo: placeContainerView.leadingAnchor).isActive = true
            pmv.trailingAnchor.constraint(equalTo: placeContainerView.trailingAnchor).isActive = true
            pmv.bottomAnchor.constraint(equalTo: placeContainerView.bottomAnchor).isActive = true
        }
    }
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Message
    lazy var messageTitleView: TitleView = {
        let tv = TitleView(text: "메시지")
        return tv
    }()
    
    lazy var messageTextContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var messageTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.text = "이곳에 메시지를 입력합니다."
        tv.textColor = .lightGray
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: View - Image
    lazy var imageTitleView: TitleView = {
        let tv = TitleView(text: "사진", isAction: true, actionText: "앨범에서 선택", actionMode: "SELECT_IMAGE")
        tv.delegate = self
        return tv
    }()
    
    lazy var photoView: PhotoView = {
        let pv = PhotoView(contentMode: .scaleAspectFit)
        return pv
    }()
    
    lazy var noPhotoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "사진을 등록해주세요"
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Place
    lazy var placeTitleView: TitleView = {
        let tv = TitleView(text: "플레이스", isAction: true, actionText: "찾기", actionMode: "SEARCH_PLACE")
        tv.delegate = self
        return tv
    }()
    
    lazy var placeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noPlaceContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noPlaceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "플레이스를 등록해주세요"
        label.textColor = .systemGray
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
        
        navigationItem.title = "새로운 픽"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        isModalInPresentation = true
        
        configureView()
        
        setThemeColor()
        
//        searchKakaoPlaceVC.delegate = self
        
        app.delegate = self
        addPlaceRequest.delegate = self
        uploadImageRequest.delegate = self
        addPickRequest.delegate = self
    }
    
    
    // MARK: ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // searchKakaoPlaceVC가 열리면서 viewDidDisappear가 호출되기때문에 Main에 closeVC를 주게됨
        // 그걸 막기 위해 searchKakaoPlaceVC가 nil인지 확인 후 종료 시그널
        if !isOpenedChildVC {
            delegate?.closePostingVC(isUploaded: isUploaded)
        }
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setThemeColor()
    }
    func setThemeColor() {
        messageTextContainerView.layer.borderColor = UIColor.separator.cgColor
        if messageTextView.textColor != UIColor.lightGray {
            messageTextView.textColor = UIColor.systemBackground.inverted
        }
        
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
            messageTextView.backgroundColor = .black
        } else {
            view.backgroundColor = .white
            messageTextView.backgroundColor = .white
        }
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        // MARK: ConfigureView - Message
        contentView.addSubview(messageTitleView)
        messageTitleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        messageTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        messageTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(messageTextContainerView)
        messageTextContainerView.topAnchor.constraint(equalTo: messageTitleView.bottomAnchor).isActive = true
        messageTextContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        messageTextContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        messageTextContainerView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH * 0.33).isActive = true
        
        messageTextContainerView.addSubview(messageTextView)
        messageTextView.topAnchor.constraint(equalTo: messageTextContainerView.topAnchor, constant: SPACE_XS).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: messageTextContainerView.leadingAnchor, constant: SPACE_XS).isActive = true
        messageTextView.trailingAnchor.constraint(equalTo: messageTextContainerView.trailingAnchor, constant: -SPACE_XS).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: messageTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        // MARK: ConfigureView - Image
        contentView.addSubview(imageTitleView)
        imageTitleView.topAnchor.constraint(equalTo: messageTextView.bottomAnchor).isActive = true
        imageTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: imageTitleView.bottomAnchor).isActive = true
        photoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        photoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        photoView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        photoView.addSubview(noPhotoLabel)
        noPhotoLabel.centerXAnchor.constraint(equalTo: photoView.centerXAnchor).isActive = true
        noPhotoLabel.centerYAnchor.constraint(equalTo: photoView.centerYAnchor).isActive = true
        
        // MARK: ConfigureView - Place
        contentView.addSubview(placeTitleView)
        placeTitleView.topAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
        placeTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        placeTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(placeContainerView)
        placeContainerView.topAnchor.constraint(equalTo: placeTitleView.bottomAnchor).isActive = true
        placeContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        placeContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        placeContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        if selectedPlace == nil {
            placeContainerView.addSubview(noPlaceContainerView)
            noPlaceContainerView.topAnchor.constraint(equalTo: placeTitleView.bottomAnchor).isActive = true
            noPlaceContainerView.leadingAnchor.constraint(equalTo: placeContainerView.leadingAnchor).isActive = true
            noPlaceContainerView.trailingAnchor.constraint(equalTo: placeContainerView.trailingAnchor).isActive = true
            noPlaceContainerView.bottomAnchor.constraint(equalTo: placeContainerView.bottomAnchor).isActive = true
        
            noPlaceContainerView.addSubview(noPlaceLabel)
            noPlaceLabel.centerXAnchor.constraint(equalTo: noPlaceContainerView.centerXAnchor).isActive = true
            noPlaceLabel.topAnchor.constraint(equalTo: noPlaceContainerView.topAnchor, constant: NO_DATA_SPACE).isActive = true
            noPlaceLabel.bottomAnchor.constraint(equalTo: noPlaceContainerView.bottomAnchor, constant: -NO_DATA_SPACE).isActive = true
        }
    }
    
    // MARK: Function - @OBJC
    @objc func postingTapped() {
        guard let place = selectedPlace else { return }
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        
        if place.id == 0 {
            addPlaceRequest.fetch(vc: self, paramDict: ["kId": String(place.kId), "name": place.name, "categoryName": place.categoryName, "categoryGroupCode": place.categoryGroupCode, "categoryGroupName": place.categoryGroupName, "address": place.address, "roadAddress": place.roadAddress, "latitude": place.latitude, "longitude": place.longitude, "phone": place.phone])
            
        } else {
            guard let image = selectedImage else {
                hideIndicator(idv: indicatorView, bov: blurOverlayView)
                return
            }
            uploadImageRequest.fetch(vc: self, image: image)
        }
    }
}


// MARK: Extension - TitleView
extension PostingViewController: TitleViewProtocol {
    func action(actionMode: String) {
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
        
        if actionMode == "SELECT_IMAGE" {
            app.checkPhotoGallaryAvailable(vc: self)
            
        } else if actionMode == "SEARCH_PLACE" {
            isOpenedChildVC = true
            let searchPlaceVC = SearchPlaceViewController()
            searchPlaceVC.mode = "KEYWORD"
            searchPlaceVC.delegate = self
            navigationController?.pushViewController(searchPlaceVC, animated: true)
        }
    }
}

// MARK: Extension - ImagePicker
extension PostingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        noPhotoLabel.removeView()
        
        photoView.image = selectedImage
        if selectedPlace != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "게시하기", style: UIBarButtonItem.Style.plain, target: self, action: #selector(postingTapped))
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Extension - App
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

// MARK: Extension - SearchPlace
extension PostingViewController: SearchPlaceViewControllerProtocol {
    func closeSearchPlaceVC(place: Place?) {
        // searchKakaoPlaceVC가 종료되면 nil로 초기화 필수
        // viewDidDisappear과 관련있음
//        searchKakaoPlaceVC = nil
        isOpenedChildVC = false
        
        if let place = place {
            
            // 똑같은 플레이스를 선택함
            if let selectedPlace = self.selectedPlace {
                if selectedPlace.id == place.id { return }
            }
            
            selectedPlace = place
            
            if selectedImage != nil {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "게시하기", style: UIBarButtonItem.Style.plain, target: self, action: #selector(postingTapped))
            }
        }
    }
}

// MARK: Extension - PlaceMediumView
extension PostingViewController: PlaceMediumViewProtocol {
    func openPlace(place: Place) {
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
        isOpenedChildVC = true
        let placeVC = PlaceViewController(place: place)
        placeVC.delegate = self
        navigationController?.pushViewController(placeVC, animated: true)
    }
}

// MARK: Extension - ScrollView
extension PostingViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
    }
}

// MARK: Extension - TextView
extension PostingViewController: UITextViewDelegate {
    // 입력을 시작할때 (커서가 올라갔을때)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.systemBackground.inverted
        }
    }
    
    // 입력이 끝났을때 (커서가 내려갔을때)
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "이곳에 메시지를 입력합니다."
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: Extension - AddPlace
extension PostingViewController: AddPlaceRequestProtocol {
    func response(place: Place?, addPlace status: String) {
        if status == "OK" {
            if let place = place {
                guard let image = selectedImage else {
                    hideIndicator(idv: indicatorView, bov: blurOverlayView)
                    return
                }
                selectedPlace = place
                uploadImageRequest.fetch(vc: self, image: image)
            }
        } else {
            hideIndicator(idv: indicatorView, bov: blurOverlayView)
        }
    }
}

// MARK: Extension - UploadImage
extension PostingViewController: UploadImageRequestProtocol {
    func response(imageName: Int?, uploadImage status: String) {
        if status == "OK" {
            if let piId = imageName {
                guard let place = selectedPlace else { return }
                
                var message = ""
                if messageTextView.textColor != UIColor.lightGray {
                    message = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                
                addPickRequest.fetch(vc: self, paramDict: ["message": message, "piId": String(piId), "pId": String(place.id)])
            }
            
        } else {
            hideIndicator(idv: indicatorView, bov: blurOverlayView)
        }
    }
}

// MARK: Extension - AddPick
extension PostingViewController: AddPickRequestProtocol {
    func response(addPick status: String) {
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
        if status == "OK" {
            isUploaded = true
//            authAccountVC?.getPicks()
            let alert = UIAlertController(title: "픽 게시하기", message: "새로운 픽이 게시되었습니다.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
        }
    }
}

// MARK: Extension - PlaceVC
extension PostingViewController: PlaceViewControllerProtocol {
    func closePlaceVC() {
        isOpenedChildVC = false
    }
    func reloadPlace() {}
}
