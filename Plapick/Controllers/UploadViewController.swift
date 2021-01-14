//
//  UploadViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/08.
//

import UIKit
import Alamofire


protocol UploadViewControllerProtocol {
    func closeViewController()
}


class UploadViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    var delegate: UploadViewControllerProtocol?
    var uploadImage: UIImage?
    var place: Place?
    var uploadImageRequest = UploadImageRequest()
    var addPickrequest = AddPickRequest()
    var accountViewController: AccountViewController?
    
    
    // MARK: Views
    lazy var messageTitleView: TitleView = {
        let tv = TitleView(titleText: "메세지 입력", actionText: nil, actionMode: nil)
        return tv
    }()
    
    lazy var messageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var messageTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.text = "이곳에 메세지를 입력합니다."
        tv.textColor = .lightGray
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    lazy var messageBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var placeTitleView: TitleView = {
        let tv = TitleView(titleText: "선택한 플레이스", actionText: nil, actionMode: nil)
        return tv
    }()
    
    var placeSmallView: PlaceSmallView?
    
    lazy var imageTitleView: TitleView = {
        let tv = TitleView(titleText: "선택한 사진", actionText: nil, actionMode: nil)
        return tv
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .tertiarySystemGroupedBackground
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
    
    lazy var placeBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: Init
    init(uploadImage: UIImage, place: Place) {
        super.init(nibName: nil, bundle: nil)
        
        self.uploadImage = uploadImage
        self.place = place
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "픽 업로드"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(upload))
        
        placeSmallView = PlaceSmallView(place: self.place!)
        imageView.image = self.uploadImage
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        contentView.addSubview(messageTitleView)
        messageTitleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        messageTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        messageTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        messageTitleView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(messageView)
        messageView.topAnchor.constraint(equalTo: messageTitleView.bottomAnchor).isActive = true
        messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        messageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        messageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        messageView.addSubview(messageTextView)
        messageTextView.topAnchor.constraint(equalTo: messageView.topAnchor).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        messageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: messageView.bottomAnchor).isActive = true
        
        contentView.addSubview(placeTitleView)
        placeTitleView.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 40).isActive = true
        placeTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        placeTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        placeTitleView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(placeSmallView!)
        placeSmallView?.topAnchor.constraint(equalTo: placeTitleView.bottomAnchor).isActive = true
        placeSmallView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        placeSmallView?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        placeSmallView?.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(imageTitleView)
        imageTitleView.topAnchor.constraint(equalTo: placeSmallView!.bottomAnchor, constant: 40).isActive = true
        imageTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageTitleView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: imageTitleView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        view.addSubview(messageBottomLineView)
        messageBottomLineView.bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor).isActive = true
        messageBottomLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageBottomLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messageBottomLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        view.addSubview(placeBottomLineView)
        placeBottomLineView.bottomAnchor.constraint(equalTo: placeSmallView!.bottomAnchor).isActive = true
        placeBottomLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        placeBottomLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        placeBottomLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        view.addSubview(imageBottomLineView)
        imageBottomLineView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        imageBottomLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageBottomLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageBottomLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        self.hideKeyboardWhenTappedAround()
        
        uploadImageRequest.delegate = self
        addPickrequest.delegate = self
        
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
            messageView.backgroundColor = .systemGray6
            messageTextView.backgroundColor = .systemGray6
            if messageTextView.textColor != UIColor.lightGray {
                messageTextView.textColor = .white
            }
        } else {
            view.backgroundColor = .tertiarySystemGroupedBackground
            imageView.backgroundColor = .systemBackground
            messageView.backgroundColor = .systemBackground
            messageTextView.backgroundColor = .systemBackground
            if messageTextView.textColor != UIColor.lightGray {
                messageTextView.textColor = .black
            }
        }
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func upload() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        guard let uploadImage = self.uploadImage else { return }
        
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
        
        uploadImageRequest.fetch(vc: self, imageData: uploadImage.jpegData(compressionQuality: 1)!)
    }
    
    func hideIndicator() {
        self.indicatorView.stopAnimating()
        self.indicatorView.removeView()
        self.overlayView.removeView()
    }
}


// MARK: Extensions
extension UploadViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            if self.traitCollection.userInterfaceStyle == .dark {
                textView.textColor = .white
            } else {
                textView.textColor = .black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "이곳에 메세지를 입력합니다."
            textView.textColor = UIColor.lightGray
        }
    }
}


extension UploadViewController: UploadImageRequestProtocol {
    func response(imageName: Int?, status: String) {
        if status == "OK" {
            if let piId = imageName {
                guard let place = self.place else { return }
                let message = messageTextView.textColor == UIColor.lightGray ? "" : messageTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                var paramList: [Param] = []
                paramList.append(Param(key: "piId", value: String(piId)))
                paramList.append(Param(key: "piMessage", value: message))
                paramList.append(Param(key: "pkId", value: String(place.kId)))
                paramList.append(Param(key: "pName", value: place.name))
                paramList.append(Param(key: "pAddress", value: place.address))
                paramList.append(Param(key: "pRoadAddress", value: place.roadAddress))
                paramList.append(Param(key: "pCategoryName", value: place.categoryName))
                paramList.append(Param(key: "pCategoryGroupName", value: place.categoryGroupName))
                paramList.append(Param(key: "pCategoryGroupCode", value: place.categoryGroupCode))
                paramList.append(Param(key: "pPhone", value: place.phone))
                paramList.append(Param(key: "pLat", value: String(place.lat)))
                paramList.append(Param(key: "pLng", value: String(place.lng)))
                
                addPickrequest.fetch(vc: self, paramList: paramList)
            }
        } else { hideIndicator() }
    }
}


extension UploadViewController: AddPickRequestProtocol {
    func response(status: String) {
        hideIndicator()
        
        if status == "OK" {
            self.accountViewController?.getMyPicks()
            let alert = UIAlertController(title: "픽 업로드", message: "새로운 픽이 게시되었습니다.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (_) in
                self.delegate?.closeViewController()
            }))
            present(alert, animated: true)
        }
    }
}
