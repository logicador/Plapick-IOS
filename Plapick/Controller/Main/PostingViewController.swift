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
    func closeVC()
}


class PostingViewController: UIViewController {
    
    // MARK: Property
    var app = App()
    var delegate: PostingViewControllerProtocol?
    var accountVC: AccountViewController?
    var searchKakaoPlaceVC: SearchKakaoPlaceViewController?
    var selectedImage: UIImage?
    var selectedPlace: Place?
    let addPlaceRequest = AddPlaceRequest()
    
    
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
    
    lazy var messageTextFieldView: UIView = {
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
//        tv.textColor = .lightGray
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
    
    
    // MARK: Init
    init(accountVC: AccountViewController) {
        super.init(nibName: nil, bundle: nil)
        self.accountVC = accountVC
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "새로운 픽"
        
        configureView()
        
        setThemeColor()
        
        app.delegate = self
        addPlaceRequest.delegate = self
    }
    
    
    // MARK: ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        // searchKakaoPlaceVC가 열리면서 viewDidDisappear가 호출되기때문에 Main에 closeVC를 주게됨
        // 그걸 막기 위해 searchKakaoPlaceVC가 nil인지 확인 후 종료 시그널
        if searchKakaoPlaceVC == nil {
            delegate?.closeVC()
        }
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setThemeColor()
    }
    func setThemeColor() {
        messageTextFieldView.layer.borderColor = UIColor.separator.cgColor
        if messageTextView.textColor != UIColor.lightGray {
            messageTextView.textColor = UIColor.systemBackground.inverted
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
        
        // MARK: View - Message
        contentView.addSubview(messageTitleView)
        messageTitleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        messageTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        messageTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(messageTextFieldView)
        messageTextFieldView.topAnchor.constraint(equalTo: messageTitleView.bottomAnchor).isActive = true
        messageTextFieldView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        messageTextFieldView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        messageTextFieldView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH * 0.33).isActive = true
        
        messageTextFieldView.addSubview(messageTextView)
        messageTextView.topAnchor.constraint(equalTo: messageTextFieldView.topAnchor, constant: SPACE_XS).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: messageTextFieldView.leadingAnchor, constant: SPACE_XS).isActive = true
        messageTextView.trailingAnchor.constraint(equalTo: messageTextFieldView.trailingAnchor, constant: -SPACE_XS).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: messageTextFieldView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        // MARK: View - Image
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
        
        // MARK: View - Place
        contentView.addSubview(placeTitleView)
        placeTitleView.topAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
        placeTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        placeTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(placeContainerView)
        placeContainerView.topAnchor.constraint(equalTo: placeTitleView.bottomAnchor).isActive = true
        placeContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        placeContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        placeContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        placeContainerView.addSubview(noPlaceLabel)
        noPlaceLabel.centerXAnchor.constraint(equalTo: placeContainerView.centerXAnchor).isActive = true
        noPlaceLabel.topAnchor.constraint(equalTo: placeContainerView.topAnchor, constant: SPACE_XXXXL).isActive = true
        noPlaceLabel.bottomAnchor.constraint(equalTo: placeContainerView.bottomAnchor, constant: -SPACE_XXXXL).isActive = true
    }
    
    func posting() {
        guard let place = self.selectedPlace else { return }
        guard let image = self.selectedImage else { return }
        
        var message = ""
        if messageTextView.textColor != UIColor.lightGray {
            message = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // addpick
    }
    
    // MARK: Function - @OBJC
    @objc func postingTapped() {
        guard let place = self.selectedPlace else { return }
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        
        if place.id == 0 {
            showIndicator(idv: indicatorView, bov: blurOverlayView)
            addPlaceRequest.fetch(vc: self, paramDict: ["kId": String(place.kId), "name": place.name ?? "", "categoryName": place.categoryName ?? "", "categoryGroupCode": place.categoryGroupCode ?? "", "categoryGroupName": place.categoryGroupName ?? "", "address": place.address ?? "", "roadAddress": place.roadAddress ?? "", "latitude": place.latitude ?? "", "longitude": place.longitude ?? "", "phone": place.phone ?? ""])
            
        } else {
            posting()
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
            searchKakaoPlaceVC = SearchKakaoPlaceViewController()
            searchKakaoPlaceVC?.delegate = self
            navigationController?.pushViewController(searchKakaoPlaceVC!, animated: true)
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

// MARK: Extension - SearchKakaoPlaceView
extension PostingViewController: SearchKakaoPlaceViewControllerProtocol {
    func selectPlace(place: Place?) {
        // searchKakaoPlaceVC가 종료되면 nil로 초기화 필수
        // viewDidDisappear과 관련있음
        searchKakaoPlaceVC = nil
        
        if let place = place {
            
            // 똑같은 플레이스를 선택함
            if let selectedPlace = self.selectedPlace {
                if selectedPlace.id == place.id { return }
            }
            
            selectedPlace = place
            placeContainerView.removeAllChildView()
            
            let psv = PlaceSmallView()
            psv.place = place
            psv.delegate = self
            
            placeContainerView.addSubview(psv)
            psv.topAnchor.constraint(equalTo: placeContainerView.topAnchor).isActive = true
            psv.leadingAnchor.constraint(equalTo: placeContainerView.leadingAnchor).isActive = true
            psv.trailingAnchor.constraint(equalTo: placeContainerView.trailingAnchor).isActive = true
            psv.bottomAnchor.constraint(equalTo: placeContainerView.bottomAnchor).isActive = true
            
            if selectedImage != nil {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "게시하기", style: UIBarButtonItem.Style.plain, target: self, action: #selector(postingTapped))
            }
        }
    }
}

// MARK: Extension - PlaceSmallView
extension PostingViewController: PlaceSmallViewProtocol {
    func openPlace(place: Place) {
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
        print("openPlace", place.id)
    }
}

// MARK: Extension - ScrollView
extension PostingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
            textView.text = "이곳에 메세지를 입력합니다."
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: Extension - AddPlaceRequest
extension PostingViewController: AddPlaceRequestProtocol {
    func response(place: Place?, addPlace status: String) {
        if status == "OK" {
            selectedPlace = place
            posting()
        } else {
            hideIndicator(idv: indicatorView, bov: blurOverlayView)
        }
    }
}