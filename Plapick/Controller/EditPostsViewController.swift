//
//  EditPostsViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/26.
//

import UIKit
import PhotosUI


protocol EditPostsViewControllerProtocol {
    func editPosts(posts: Posts)
}


class EditPostsViewController: UIViewController {
    
    // MARK: Property
    var delegate: EditPostsViewControllerProtocol?
    var posts: Posts? {
        didSet {
            guard let posts = self.posts else { return }
            
            placeNameLabel.text = posts.p_name
            
            messageTextView.text = (posts.po_message.isEmpty) ? "이곳에 메시지를 입력합니다." : posts.po_message
            messageTextView.textColor = (posts.po_message.isEmpty) ? .systemGray3 : (traitCollection.userInterfaceStyle == .dark) ? .white : .black
            messageCntLabel.text = "\(posts.po_message.count) / 300"
            
            for poi in posts.poi.split(separator: "|") {
                let splitted = poi.split(separator: ":")
                
                guard let poiId = Int(splitted[0]) else { return }
                let poiPath = String(splitted[1])
                
                let postsImage = PostsImage(poi_id: poiId, poi_u_id: posts.po_u_id, poi_po_id: posts.po_id, poi_path: poiPath)
                originalPostsImageList.append(postsImage)
                let editPostsImage = EditPostsImage(postsImage: postsImage)
                editPostsImageList.append(editPostsImage)
            }
            imageCollectionView.reloadData()
        }
    }
    var originalPostsImageList: [PostsImage] = []
    var editPostsImageList: [EditPostsImage] = []
    var kakaoPlace: KakaoPlace? {
        didSet {
            guard let kakaoPlace = self.kakaoPlace else { return }
            
            placeNameLabel.text = kakaoPlace.place_name
        }
    }
    let editPostsRequest = EditPostsRequest()
    var isSaving = false
    var isUploading = false
    var progressWidthCons: NSLayoutConstraint?
    var editedPosts: Posts?
    let removePostsImagesRequest = RemovePostsImagesRequest()
    let editPostsImagesRequest = EditPostsImagesRequest()
    let uploadPostsImageRequest = UploadPostsImageRequest()
    var newImageCnt = 0
    var uploadImageCnt = 0
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Place
    lazy var placeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var placeView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(placeTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var placeImageView: UIImageView = {
        let image = UIImage(systemName: "location.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var placeChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("플레이스 변경", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(placeChangeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Message
    lazy var messageTopLine: UIView = {
        let lv = LineView()
        return lv
    }()
    lazy var messageTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15)
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    lazy var messageBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var messageCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 300"
        label.textColor = .systemGreen
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Image
    lazy var imageHeaderContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var imageOrderLabel: UILabel = {
        let label = UILabel()
        label.text = "길게눌러 순서변경"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var imageOrderImageView: UIImageView = {
        let image = UIImage(systemName: "square.grid.3x3.topleft.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var imageAddView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageAddTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var imageAddImageView: UIImageView = {
        let image = UIImage(systemName: "plus.square.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var imageAddLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.text = "사진 추가"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.register(UploadPostsImageCVCell.self, forCellWithReuseIdentifier: "UploadPostsImageCVCell")
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(imageCollectionViewLongPressed)))
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    lazy var imageTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Progress
    lazy var progressBlurOverlayView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let vev = UIVisualEffectView(effect: blurEffect)
        vev.isHidden = true
        vev.alpha = 0
        vev.translatesAutoresizingMaskIntoConstraints = false
        return vev
    }()
    lazy var progressContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "게시물을 업로드중입니다."
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var progressBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Toast
    lazy var toastView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.layer.cornerRadius = 6
        view.layer.borderWidth = LINE_WIDTH
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var toastLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "게시물 수정"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        editPostsRequest.delegate = self
        removePostsImagesRequest.delegate = self
        editPostsImagesRequest.delegate = self
        uploadPostsImageRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        messageTextView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        messageTextView.textColor = (messageTextView.textColor == .systemGray3) ? .systemGray3 : (traitCollection.userInterfaceStyle == .dark) ? .white : .black
        
        imageCollectionView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        progressContainerView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // MARK: Configure - Place
        containerView.addSubview(placeContainerView)
        placeContainerView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        placeContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        placeContainerView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        placeContainerView.addSubview(placeView)
        placeView.topAnchor.constraint(equalTo: placeContainerView.topAnchor).isActive = true
        placeView.leadingAnchor.constraint(equalTo: placeContainerView.leadingAnchor).isActive = true
        placeView.bottomAnchor.constraint(equalTo: placeContainerView.bottomAnchor).isActive = true
        
        placeView.addSubview(placeNameLabel)
        placeNameLabel.topAnchor.constraint(equalTo: placeView.topAnchor, constant: SPACE).isActive = true
        placeNameLabel.trailingAnchor.constraint(equalTo: placeView.trailingAnchor).isActive = true
        placeNameLabel.bottomAnchor.constraint(equalTo: placeView.bottomAnchor, constant: -SPACE).isActive = true
        
        placeView.addSubview(placeImageView)
        placeImageView.centerYAnchor.constraint(equalTo: placeNameLabel.centerYAnchor).isActive = true
        placeImageView.leadingAnchor.constraint(equalTo: placeView.leadingAnchor).isActive = true
        placeImageView.trailingAnchor.constraint(equalTo: placeNameLabel.leadingAnchor, constant: -7).isActive = true
        placeImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        placeImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        placeContainerView.addSubview(placeChangeButton)
        placeChangeButton.centerYAnchor.constraint(equalTo: placeNameLabel.centerYAnchor).isActive = true
        placeChangeButton.trailingAnchor.constraint(equalTo: placeContainerView.trailingAnchor).isActive = true
        
        // MARK: Configure - Message
        containerView.addSubview(messageTopLine)
        messageTopLine.topAnchor.constraint(equalTo: placeContainerView.bottomAnchor).isActive = true
        messageTopLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        messageTopLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        containerView.addSubview(messageTextView)
        messageTextView.topAnchor.constraint(equalTo: messageTopLine.bottomAnchor, constant: SPACE_XS).isActive = true
        messageTextView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        messageTextView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3).isActive = true
        
        containerView.addSubview(messageCntLabel)
        messageCntLabel.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: SPACE_XS).isActive = true
        messageCntLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        messageCntLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        containerView.addSubview(messageBottomLine)
        messageBottomLine.topAnchor.constraint(equalTo: messageCntLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        messageBottomLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        messageBottomLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        // MARK: Configure - Image
        containerView.addSubview(imageHeaderContainerView)
        imageHeaderContainerView.topAnchor.constraint(equalTo: messageBottomLine.bottomAnchor).isActive = true
        imageHeaderContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageHeaderContainerView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        imageHeaderContainerView.addSubview(imageAddView)
        imageAddView.topAnchor.constraint(equalTo: imageHeaderContainerView.topAnchor).isActive = true
        imageAddView.leadingAnchor.constraint(equalTo: imageHeaderContainerView.leadingAnchor).isActive = true
        imageAddView.bottomAnchor.constraint(equalTo: imageHeaderContainerView.bottomAnchor).isActive = true
        
        imageAddView.addSubview(imageAddLabel)
        imageAddLabel.topAnchor.constraint(equalTo: imageAddView.topAnchor, constant: SPACE).isActive = true
        imageAddLabel.trailingAnchor.constraint(equalTo: imageAddView.trailingAnchor).isActive = true
        imageAddLabel.bottomAnchor.constraint(equalTo: imageAddView.bottomAnchor, constant: -SPACE).isActive = true
        
        imageAddView.addSubview(imageAddImageView)
        imageAddImageView.centerYAnchor.constraint(equalTo: imageAddLabel.centerYAnchor).isActive = true
        imageAddImageView.leadingAnchor.constraint(equalTo: imageAddView.leadingAnchor).isActive = true
        imageAddImageView.trailingAnchor.constraint(equalTo: imageAddLabel.leadingAnchor, constant: -7).isActive = true
        imageAddImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageAddImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        imageHeaderContainerView.addSubview(imageOrderLabel)
        imageOrderLabel.centerYAnchor.constraint(equalTo: imageAddLabel.centerYAnchor).isActive = true
        imageOrderLabel.trailingAnchor.constraint(equalTo: imageHeaderContainerView.trailingAnchor).isActive = true
    
        imageHeaderContainerView.addSubview(imageOrderImageView)
        imageOrderImageView.centerYAnchor.constraint(equalTo: imageAddLabel.centerYAnchor).isActive = true
        imageOrderImageView.trailingAnchor.constraint(equalTo: imageOrderLabel.leadingAnchor, constant: -7).isActive = true
        imageOrderImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageOrderImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.addSubview(imageCollectionView)
        imageCollectionView.topAnchor.constraint(equalTo: imageHeaderContainerView.bottomAnchor).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imageCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        containerView.addSubview(imageTopLine)
        imageTopLine.topAnchor.constraint(equalTo: imageCollectionView.topAnchor).isActive = true
        imageTopLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageTopLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Progress
        view.addSubview(progressBlurOverlayView)
        progressBlurOverlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        progressBlurOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        progressBlurOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressBlurOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(progressContainerView)
        progressContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        progressContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        progressContainerView.addSubview(progressLabel)
        progressLabel.topAnchor.constraint(equalTo: progressContainerView.topAnchor, constant: SPACE).isActive = true
        progressLabel.centerXAnchor.constraint(equalTo: progressContainerView.centerXAnchor).isActive = true
        
        progressContainerView.addSubview(progressBackView)
        progressBackView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: SPACE).isActive = true
        progressBackView.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor, constant: SPACE).isActive = true
        progressBackView.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor, constant: -SPACE).isActive = true
        progressBackView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        progressBackView.bottomAnchor.constraint(equalTo: progressContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        progressBackView.addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: progressBackView.topAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: progressBackView.leadingAnchor).isActive = true
        progressWidthCons = progressView.widthAnchor.constraint(equalTo: progressBackView.widthAnchor, multiplier: 0)
        progressWidthCons?.isActive = true
        progressView.bottomAnchor.constraint(equalTo: progressBackView.bottomAnchor).isActive = true
    }
    
    // 플레이스 혹은 메시지 변경되었는지 확인
    func isEditPlaceOrMessage() -> Bool {
        guard let posts = self.posts else { return false }
        
        // 플레이스 업데이트 되었는지
        if let kakaoPlace = self.kakaoPlace {
            guard let kId = Int(kakaoPlace.id) else { return false }
            if (kId != posts.p_k_id) { return true }
        }
        
        // 메시지 수정했는지
        let message = (messageTextView.textColor == .systemGray3) ? "" : messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if message != posts.po_message { return true }
        
        return false
    }
    
    // 이미지 변경되었는지 확인
    func isEditImages() -> Bool {
        if originalPostsImageList.count == editPostsImageList.count {
            for (i, originalPostsImage) in originalPostsImageList.enumerated() {
                if let _ = editPostsImageList[i].image { return true } // 새로운 이미지가 추가됨, 무조건 true
                else {
                    guard let postsImage = editPostsImageList[i].postsImage else { return false } // image와 postsImage 둘 다 없을 수 없음
                    if originalPostsImage.poi_id != postsImage.poi_id { return true } // 이미지 순서가 기존꺼와 다름
                }
            }
        } else { return true } // 애초에 개수가 다르기때문에 무조건 true
        
        for editPostsImage in editPostsImageList {
            if let _ = editPostsImage.image { return true } // 새로운 이미지가 추가됨, 무조건 true
        }
        
        return false
    }
    
    func imageRequest() {
        guard let posts = self.posts else { return }
        
        // 2-1. 삭제된 이미지
        var removedPoiIdList: [Int] = []
        for originalPostsImage in originalPostsImageList {
            var isFind = false
            for editPostsImage in editPostsImageList {
                guard let postsImage = editPostsImage.postsImage else { continue }
                if postsImage.poi_id == originalPostsImage.poi_id {
                    isFind = true
                    break
                }
            }
            if !isFind { removedPoiIdList.append(originalPostsImage.poi_id) }
        }
        if removedPoiIdList.count > 0 {
            removePostsImagesRequest.fetch(vc: self, paramDict: ["poiIdList": removedPoiIdList.description])
            return
        }
        
        // 2-2. 기존 사진 순서 재전송 (새로운 사진은 아직 X)
        var editPoiList: [String] = []
        for (i, editPostsImage) in editPostsImageList.enumerated() {
            guard let postsImage = editPostsImage.postsImage else { continue }
            let order = i + 1
            editPoiList.append("\(postsImage.poi_id)|\(order)")
        }
        if editPoiList.count > 0 {
            editPostsImagesRequest.fetch(vc: self, paramDict: ["poiList": editPoiList.description])
            return
        }
        
        // 2-3. 새로운 사진 추가
        for editPostsImage in editPostsImageList {
            if let _ = editPostsImage.image { newImageCnt += 1 }
        }
        if newImageCnt > 0 {
            isUploading = true
            
            progressWidthCons?.isActive = false
            progressWidthCons = progressView.widthAnchor.constraint(equalTo: progressBackView.widthAnchor, multiplier: CGFloat(0.5) / CGFloat(newImageCnt))
            progressWidthCons?.isActive = true
            
            progressBlurOverlayView.isHidden = false
            progressContainerView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.progressBlurOverlayView.alpha = 0.2
                self.progressContainerView.alpha = 1
                self.view.layoutIfNeeded()
            })
            
            for (i, editPostsImage) in editPostsImageList.enumerated() {
                guard let image = editPostsImage.image else { continue}
                uploadPostsImageRequest.fetch(vc: self, image: image, poId: posts.po_id, order: i + 1)
            }
            return
        }
        
        // 2-4. 여기로 로직 타면 안됨.
        // 삭제된 사진 없어, 기존 이미지들 다 지워서 순서 변경할거 없어, 새로운 사진도 없어
        // 플레이스나 메시지 변경 여부 확인
        if isEditPlaceOrMessage() {
            postsRequest()
            return
        }
        
        // 2-5. 여기로 로직 타면 안됨.
        // 아무것도 수정한게 없음
        dismiss(animated: true, completion: nil)
    }
    
    func postsRequest() {
        guard let posts = self.posts else { return }
        
        let message = (messageTextView.textColor == .systemGray3) ? "" : messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        var paramDict: [String: String] = [:]
        paramDict["poId"] = String(posts.po_id)
        paramDict["message"] = message
        if let kakaoPlace = self.kakaoPlace {
            guard let kId = Int(kakaoPlace.id) else { return }
            // 플레이스가 변경됨, 혹시 모르니 DB 추가용 데이터 던짐
            if (kId != posts.p_k_id) {
                paramDict["kId"] = kakaoPlace.id
                paramDict["name"] = kakaoPlace.place_name
                paramDict["address"] = kakaoPlace.address_name
                paramDict["roadAddress"] = kakaoPlace.road_address_name
                paramDict["lat"] = kakaoPlace.y
                paramDict["lng"] = kakaoPlace.x
                paramDict["categoryGroupCode"] = kakaoPlace.category_group_code
                paramDict["categoryGroupName"] = kakaoPlace.category_group_name
                paramDict["categoryName"] = kakaoPlace.category_name
                paramDict["phone"] = kakaoPlace.phone
            }
        }
        editPostsRequest.fetch(vc: self, paramDict: paramDict)
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismissKeyboard()
        
        if isUploading {
            showToast(tv: toastView, tcl: toastLabel, text: "게시물을 업로드중입니다. 잠시만 기다려주세요.")

        } else {
            if isEditImages() || isEditPlaceOrMessage() {
                let alert = UIAlertController(title: nil, message: "변경하신 내용이 저장되지 않습니다. 계속하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
                alert.addAction(UIAlertAction(title: "예", style: .default, handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true)
                return
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Function - @OBJC - Save
    // 1. 저장버튼 누름
    @objc func saveTapped() {
        dismissKeyboard()
        
        let lineHeight = messageTextView.font?.lineHeight ?? 0
        let line = Int((messageTextView.contentSize.height - 16) / lineHeight)
        if line > POSTS_MESSAGE_LINE_LIMIT {
            let alert = UIAlertController(title: nil, message: "최대 \(POSTS_MESSAGE_LINE_LIMIT)줄까지 입력 가능합니다.\n\n현재 \(line) / \(POSTS_MESSAGE_LINE_LIMIT)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        if isSaving {
            showToast(tv: toastView, tcl: toastLabel, text: "게시물을 업로드중입니다. 잠시만 기다려주세요.")
            return
        }
        isSaving = true
        
        // 2. 이미지 수정흔적 발견
        if isEditImages() {
            imageRequest()
            return
        }
        
        // 3. 플레이스 혹은 메시지 수정흔적 발견
        if isEditPlaceOrMessage() {
            postsRequest()
            return
        }
        
        // 아무것도 안했음
        dismiss(animated: true, completion: nil)
    }
    
    @objc func placeTapped() {
        dismissKeyboard()
        
        print("placeTapped")
    }
    
    @objc func placeChangeTapped() {
        dismissKeyboard()
        
        let searchKakaoPlaceVC = SearchKakaoPlaceViewController()
        searchKakaoPlaceVC.mode = "EDIT_POSTS"
        searchKakaoPlaceVC.delegate = self
        navigationController?.pushViewController(searchKakaoPlaceVC, animated: true)
    }
    
    @objc func imageAddTapped() {
        dismissKeyboard()
        
        if editPostsImageList.count > 11 {
            let alert = UIAlertController(title: nil, message: "최대 12개까지 등록 가능합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
            DispatchQueue.main.async {
                if status == .limited || status == .authorized {
                    var configuration = PHPickerConfiguration()
                    configuration.selectionLimit = 12 - self.editPostsImageList.count
                    configuration.filter = .any(of: [.images])
                    let picker = PHPickerViewController(configuration: configuration)
                    picker.delegate = self
                    picker.modalPresentationStyle = .fullScreen
                    self.present(picker, animated: true, completion: nil)
                    
                } else {
                    self.requestSettingAlert(title: "앨범 액세스 허용하기", message: "게시물 이미지 업로드를 위해 앨범에 접근합니다.")
                }
            }
        }
    }
    
    @objc func imageCollectionViewLongPressed(gesture: UILongPressGestureRecognizer) {
        dismissKeyboard()

        switch gesture.state {
        case .began:
            guard let targetIndexPath = imageCollectionView.indexPathForItem(at: gesture.location(in: imageCollectionView)) else { return }
            imageCollectionView.beginInteractiveMovementForItem(at: targetIndexPath)

        case .changed:
            imageCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: imageCollectionView))
        case .ended:
            imageCollectionView.endInteractiveMovement()
        default:
            imageCollectionView.cancelInteractiveMovement()
        }
    }
}


// MARK: SearchKakaoPlaceVC
extension EditPostsViewController: SearchKakaoPlaceViewControllerProtocol {
    func selectKakaoPlace(kakaoPlace: KakaoPlace) {
        self.kakaoPlace = kakaoPlace
    }
}

// MARK: TextView
extension EditPostsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let message = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        messageCntLabel.text = "\(message.count) / 300"
        
        if message.count > 300 {
            messageCntLabel.textColor = .systemRed
            navigationItem.rightBarButtonItem = nil
        } else {
            messageCntLabel.textColor = .systemGreen
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveTapped))
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = ""
            textView.textColor = (traitCollection.userInterfaceStyle == .dark) ? .white : .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "이곳에 메시지를 입력합니다."
            textView.textColor = .systemGray3
        }
    }
}

// MARK: CollectionView
extension EditPostsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editPostsImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadPostsImageCVCell", for: indexPath) as! UploadPostsImageCVCell
        if let postsImage = editPostsImageList[indexPath.row].postsImage {
            cell.postsImage = postsImage
        } else {
            cell.image = editPostsImageList[indexPath.row].image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - (4 / 3), height: (view.frame.width / 3) - (4 / 3))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissKeyboard()
        
        if editPostsImageList.count == 1 {
            let alert = UIAlertController(title: nil, message: "1개 이상의 사진을 게시해야됩니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let alert = UIAlertController(title: nil, message: "사진을 제거하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "제거", style: .destructive, handler: { (_) in
            self.editPostsImageList.remove(at: indexPath.row)
            self.imageCollectionView.reloadData()
        }))
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = editPostsImageList.remove(at: sourceIndexPath.row)
        editPostsImageList.insert(item, at: destinationIndexPath.row)
    }
}

// MARK: PHPicker
extension EditPostsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        var editPostsImageList: [EditPostsImage] = []
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                guard let image = image else { return }
                let resImage = image as! UIImage
                let editPostsImage = EditPostsImage(image: resImage)
                editPostsImageList.append(editPostsImage)
                
                if editPostsImageList.count == results.count {
                    DispatchQueue.main.async {
                        self.editPostsImageList.append(contentsOf: editPostsImageList)
                        self.imageCollectionView.reloadData()
                    }
                }
            })
        }
    }
}

// MARK: HTTP - EditPosts
extension EditPostsViewController: EditPostsRequestProtocol {
    func response(posts: Posts?, editPosts status: String) {
        print("[HTTP RES]", editPostsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let posts = posts else { return }
            delegate?.editPosts(posts: posts)
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: HTTP - RemovePostsImages
extension EditPostsViewController: RemovePostsImagesRequestProtocol {
    func response(removePostsImages status: String) {
        print("[HTTP RES]", removePostsImagesRequest.apiUrl, status)
        
        if status == "OK" {
            guard let posts = self.posts else { return }
            
            // 2-1-1. 기존 사진 순서 재전송 (새로운 사진은 아직 X)
            var editPoiList: [String] = []
            for (i, editPostsImage) in editPostsImageList.enumerated() {
                guard let postsImage = editPostsImage.postsImage else { continue }
                let order = i + 1
                editPoiList.append("\(postsImage.poi_id)|\(order)")
            }
            if editPoiList.count > 0 {
                editPostsImagesRequest.fetch(vc: self, paramDict: ["poiList": editPoiList.description])
                return
            }
            
            // 2-1-2. 새로운 사진 추가
            for editPostsImage in editPostsImageList {
                if let _ = editPostsImage.image { newImageCnt += 1 }
            }
            if newImageCnt > 0 {
                isUploading = true
                
                progressWidthCons?.isActive = false
                progressWidthCons = progressView.widthAnchor.constraint(equalTo: progressBackView.widthAnchor, multiplier: CGFloat(0.5) / CGFloat(newImageCnt))
                progressWidthCons?.isActive = true
                
                progressBlurOverlayView.isHidden = false
                progressContainerView.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.progressBlurOverlayView.alpha = 0.2
                    self.progressContainerView.alpha = 1
                    self.view.layoutIfNeeded()
                })
                
                for (i, editPostsImage) in editPostsImageList.enumerated() {
                    guard let image = editPostsImage.image else { continue}
                    uploadPostsImageRequest.fetch(vc: self, image: image, poId: posts.po_id, order: i + 1)
                }
                return
            }
            
            // 2-1-3. 기존 이미지들 다 지워서 순서 변경할거 없어, 새로운 사진도 없어
            // 플레이스나 메시지 변경 여부 확인할 것도 없이 새로운 posts 정보 받아와야하므로 일단 edit 날리고 봄
            postsRequest()
        }
    }
}

// MARK: HTTP - EditPostsImages
extension EditPostsViewController: EditPostsImagesRequestProtocol {
    func response(editPostsImages status: String) {
        print("[HTTP RES]", editPostsImagesRequest.apiUrl, status)
        
        if status == "OK" {
            guard let posts = self.posts else { return }
            
            // 2-2-1 / 2-1-1-1. 새로운 사진 추가
            for editPostsImage in editPostsImageList {
                if let _ = editPostsImage.image { newImageCnt += 1 }
            }
            if newImageCnt > 0 {
                isUploading = true
                
                progressWidthCons?.isActive = false
                progressWidthCons = progressView.widthAnchor.constraint(equalTo: progressBackView.widthAnchor, multiplier: CGFloat(0.5) / CGFloat(newImageCnt))
                progressWidthCons?.isActive = true
                
                progressBlurOverlayView.isHidden = false
                progressContainerView.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.progressBlurOverlayView.alpha = 0.2
                    self.progressContainerView.alpha = 1
                    self.view.layoutIfNeeded()
                })
                
                for (i, editPostsImage) in editPostsImageList.enumerated() {
                    guard let image = editPostsImage.image else { continue}
                    uploadPostsImageRequest.fetch(vc: self, image: image, poId: posts.po_id, order: i + 1)
                }
                return
            }
            
            // 2-2-2 / 2-1-1-2. 새로운 사진 없어
            // 플레이스나 메시지 변경 여부 확인할 것도 없이 새로운 posts 정보 받아와야하므로 일단 edit 날리고 봄
            postsRequest()
        }
    }
}

// MARK: HTTP - UploadPostsImage
extension EditPostsViewController: UploadPostsImageRequestProtocol {
    func response(uploadPostsImage status: String) {
        print("[HTTP RES]", uploadPostsImageRequest.apiUrl, status)
        
        if status == "OK" {
            uploadImageCnt += 1
            
            progressWidthCons?.isActive = false
            progressWidthCons = progressView.widthAnchor.constraint(equalTo: progressBackView.widthAnchor, multiplier: CGFloat(uploadImageCnt) / CGFloat(newImageCnt))
            progressWidthCons?.isActive = true
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            
            if uploadImageCnt == newImageCnt {
                progressBlurOverlayView.removeFromSuperview()
                progressContainerView.removeFromSuperview()
                
                // 2-3-1 / 2-1-2-1 / 2-2-1-1 / 2-1-1-1-1
                // 플레이스나 메시지 변경 여부 확인할 것도 없이 새로운 posts 정보 받아와야하므로 일단 edit 날리고 봄
                postsRequest()
            }
            
        } else {
            isUploading = false
            progressBlurOverlayView.removeFromSuperview()
            progressContainerView.removeFromSuperview()
        }
    }
}
