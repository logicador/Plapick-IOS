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
    func addPick()
}


class PostingViewController: UIViewController {
    
    // MARK: Property
    var delegate: PostingViewControllerProtocol?
    let addPlaceRequest = AddPlaceRequest()
    let uploadImageRequest = UploadImageRequest()
    let addPickRequest = AddPickRequest()
    var isUploaded: Bool = false
    var selectedPlace: Place? {
        didSet {
            guard let place = selectedPlace else { return }
            placeSmallView.place = place
            placeSmallView.isHidden = false
            noPlaceContainerView.isHidden = true
            
            guard let _ = selectedImage else {
                navigationItem.rightBarButtonItem = nil
                return
            }
            let message = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if message.count > 100 { navigationItem.rightBarButtonItem = nil }
            else { navigationItem.rightBarButtonItem = UIBarButtonItem(title: "게시", style: .plain, target: self, action: #selector(postingTapped)) }
        }
    }
    var selectedImage: UIImage? {
        didSet {
            guard let image = selectedImage else { return }
            imageView.image = image
            imageView.isHidden = false
            noImageContainerView.isHidden = true
            
            guard let _ = selectedPlace else {
                navigationItem.rightBarButtonItem = nil
                return
            }
            let message = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if message.count > 100 { navigationItem.rightBarButtonItem = nil}
            else { navigationItem.rightBarButtonItem = UIBarButtonItem(title: "게시", style: .plain, target: self, action: #selector(postingTapped)) }
        }
    }
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Message
    lazy var messageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "메시지"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var messageTextContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = LINE_WIDTH
        view.layer.cornerRadius = SPACE_XS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var messageTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15)
        tv.text = "이곳에 메시지를 입력합니다."
        tv.textColor = .systemGray
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    lazy var messageCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 100"
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var messageClearImageView: UIImageView = {
        let image = UIImage(systemName: "xmark.circle.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(messageClearTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Place
    lazy var placeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "플레이스"
        label.font = .boldSystemFont(ofSize: 22)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var searchPlaceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("찾기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(searchPlaceTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var noPlaceContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XS
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noPlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "등록된 플레이스가 없습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var placeSmallView: PlaceSmallView = {
        let psv = PlaceSmallView()
        psv.isHidden = true
        return psv
    }()
    
    // MARK: View - Image
    lazy var imageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사진"
        label.font = .boldSystemFont(ofSize: 22)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("앨범에서 선택", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var noImageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XS
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noImageLabel: UILabel = {
        let label = UILabel()
        label.text = "선택된 사진이 없습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = SPACE_XS
        iv.isHidden = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
        
        configureView()
        
        hideKeyboardWhenTappedAround()
        
        setThemeColor()
        
        addPlaceRequest.delegate = self
        uploadImageRequest.delegate = self
        addPickRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setThemeColor()
    }
    func setThemeColor() {
        messageTextContainerView.layer.borderColor = UIColor.separator.cgColor
        if messageTextView.textColor != .systemGray { messageTextView.textColor = (traitCollection.userInterfaceStyle == .dark) ? .white : .black }
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_XL).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        // MARK: ConfigureView - Message
        stackView.addArrangedSubview(messageTitleLabel)
        messageTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        messageTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        stackView.addArrangedSubview(messageTextContainerView)
        messageTextContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        messageTextContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        messageTextContainerView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4).isActive = true

        messageTextContainerView.addSubview(messageTextView)
        messageTextView.topAnchor.constraint(equalTo: messageTextContainerView.topAnchor, constant: SPACE_XXS).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: messageTextContainerView.leadingAnchor, constant: SPACE_XS).isActive = true
        messageTextView.trailingAnchor.constraint(equalTo: messageTextContainerView.trailingAnchor, constant: -SPACE_XS).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: messageTextContainerView.bottomAnchor, constant: -(SPACE_XS + 12 + SPACE_XS)).isActive = true
        
        messageTextContainerView.addSubview(messageCntLabel)
        messageCntLabel.bottomAnchor.constraint(equalTo: messageTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        messageCntLabel.leadingAnchor.constraint(equalTo: messageTextContainerView.leadingAnchor, constant: SPACE_XS).isActive = true
        
        messageTextContainerView.addSubview(messageClearImageView)
        messageClearImageView.trailingAnchor.constraint(equalTo: messageTextContainerView.trailingAnchor, constant: -SPACE_XS).isActive = true
        messageClearImageView.centerYAnchor.constraint(equalTo: messageCntLabel.centerYAnchor).isActive = true
        messageClearImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        messageClearImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        // MARK: ConfigureView - Place
        stackView.addArrangedSubview(placeTitleLabel)
        placeTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        placeTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        placeTitleLabel.addSubview(searchPlaceButton)
        searchPlaceButton.centerYAnchor.constraint(equalTo: placeTitleLabel.centerYAnchor).isActive = true
        searchPlaceButton.trailingAnchor.constraint(equalTo: placeTitleLabel.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(noPlaceContainerView)
        noPlaceContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        noPlaceContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        noPlaceContainerView.addSubview(noPlaceLabel)
        noPlaceLabel.topAnchor.constraint(equalTo: noPlaceContainerView.topAnchor, constant: SPACE_XL).isActive = true
        noPlaceLabel.centerXAnchor.constraint(equalTo: noPlaceContainerView.centerXAnchor).isActive = true
        noPlaceLabel.bottomAnchor.constraint(equalTo: noPlaceContainerView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        stackView.addArrangedSubview(placeSmallView)
        placeSmallView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        placeSmallView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        // MARK: ConfigureView - Image
        stackView.addArrangedSubview(imageTitleLabel)
        imageTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        imageTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        imageTitleLabel.addSubview(selectImageButton)
        selectImageButton.centerYAnchor.constraint(equalTo: imageTitleLabel.centerYAnchor).isActive = true
        selectImageButton.trailingAnchor.constraint(equalTo: imageTitleLabel.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(noImageContainerView)
        noImageContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        noImageContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        noImageContainerView.addSubview(noImageLabel)
        noImageLabel.topAnchor.constraint(equalTo: noImageContainerView.topAnchor, constant: SPACE_XL).isActive = true
        noImageLabel.centerXAnchor.constraint(equalTo: noImageContainerView.centerXAnchor).isActive = true
        noImageLabel.bottomAnchor.constraint(equalTo: noImageContainerView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        stackView.addArrangedSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        imageView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func searchPlaceTapped() {
        dismissKeyboard()
        
        let searchPlaceVC = SearchPlaceViewController()
        searchPlaceVC.mode = "KEYWORD"
        searchPlaceVC.delegate = self
        navigationController?.pushViewController(searchPlaceVC, animated: true)
    }
    
    @objc func selectImageTapped() {
        dismissKeyboard()
        
        checkPhotoGallaryAvailable(allow: {
            let ipc = UIImagePickerController()
            ipc.sourceType = .photoLibrary
            ipc.allowsEditing = false
            ipc.delegate = self
            self.present(ipc, animated: true, completion: nil)
        })
    }
    
    @objc func postingTapped() {
        guard let place = selectedPlace else { return }
        guard let image = selectedImage else { return }
        
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        
        if place.id == 0 {
            addPlaceRequest.fetch(vc: self, paramDict: ["kId": String(place.kId), "name": place.name, "categoryName": place.categoryName, "categoryGroupCode": place.categoryGroupCode, "categoryGroupName": place.categoryGroupName, "address": place.address, "roadAddress": place.roadAddress, "latitude": place.latitude, "longitude": place.longitude, "phone": place.phone])
            
        } else {
            uploadImageRequest.fetch(vc: self, image: image)
        }
    }
    
    @objc func messageClearTapped() {
        messageTextView.text = ""
        if !messageTextView.isFirstResponder { messageTextView.becomeFirstResponder() }
        
        messageCntLabel.text = "0 / 100"
        
        messageCntLabel.textColor = .systemBlue
        guard let _ = selectedPlace else {
            navigationItem.rightBarButtonItem = nil
            return
        }
        guard let _ = selectedImage else {
            navigationItem.rightBarButtonItem = nil
            return
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "게시", style: .plain, target: self, action: #selector(postingTapped))
    }
}


// MARK: ImagePicker
extension PostingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let image = info[.editedImage] as? UIImage { selectedImage = image }
        else if let image = info[.originalImage] as? UIImage { selectedImage = image }
        
        if let _selectedImage = selectedImage {
            self.selectedImage = _selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}


// MARK: SearchPlaceVC
extension PostingViewController: SearchPlaceViewControllerProtocol {
    func selectPlace(place: Place) {
        selectedPlace = place
    }
}

// MARK: TextView
extension PostingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let message = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        messageCntLabel.text = "\(message.count) / 100"
        
        if message.count > 100 {
            messageCntLabel.textColor = .systemRed
            navigationItem.rightBarButtonItem = nil
        } else {
            messageCntLabel.textColor = .systemBlue
            guard let _ = selectedPlace else {
                navigationItem.rightBarButtonItem = nil
                return
            }
            guard let _ = selectedImage else {
                navigationItem.rightBarButtonItem = nil
                return
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "게시", style: .plain, target: self, action: #selector(postingTapped))
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = ""
            textView.textColor = UIColor.systemBackground.inverted
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "이곳에 메시지를 입력합니다."
            textView.textColor = .systemGray
        }
    }
}

// MARK: HTTP - AddPlace
extension PostingViewController: AddPlaceRequestProtocol {
    func response(place: Place?, addPlace status: String) {
        print("[HTTP RES]", addPlaceRequest.apiUrl, status)
        
        if status == "OK" {
            guard let place = place else { return }
            selectedPlace = place
            
            guard let image = selectedImage else { return }
            uploadImageRequest.fetch(vc: self, image: image)
            
        } else { hideIndicator(idv: indicatorView, bov: blurOverlayView) }
    }
}

// MARK: HTTP - UploadImage
extension PostingViewController: UploadImageRequestProtocol {
    func response(imageName: Int?, uploadImage status: String) {
        print("[HTTP RES]", uploadImageRequest.apiUrl, status)
        
        if status == "OK" {
            guard let imageName = imageName else { return }
            guard let place = selectedPlace else { return }
            
            let message = (messageTextView.textColor == .systemGray) ? "" : messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            addPickRequest.fetch(vc: self, paramDict: ["message": message, "piId": String(imageName), "pId": String(place.id)])
            
        } else { hideIndicator(idv: indicatorView, bov: blurOverlayView) }
    }
}

// MARK: HTTP - AddPick
extension PostingViewController: AddPickRequestProtocol {
    func response(addPick status: String) {
        print("[HTTP RES]", addPickRequest.apiUrl, status)
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
        
        if status == "OK" {
            delegate?.addPick()
            
            let alert = UIAlertController(title: "게시하기", message: "새로운 픽이 게시되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
