//
//  PostingConfirmViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/23.
//

import UIKit


class PostingConfirmViewController: UIViewController {
    
    // MARK: Property
    var prevVC: UIViewController?
    var message = "" {
        didSet {
            messageTopLine.isHidden = (message.isEmpty) ? true : false
            messageLabel.isHidden = (message.isEmpty) ? true : false
            
            messageLabel.text = message
        }
    }
    var imageList: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
            pageControl.numberOfPages = imageList.count
        }
    }
    var kakaoPlace: KakaoPlace? {
        didSet {
            guard let kakaoPlace = self.kakaoPlace else { return }
            
            categoryLabel.text = kakaoPlace.category_name.replacingOccurrences(of: ">", with: "-")
            nameLabel.text = kakaoPlace.place_name
            addressLabel.text = (kakaoPlace.road_address_name.isEmpty) ? kakaoPlace.address_name : kakaoPlace.road_address_name
            
            let cntMabs = NSMutableAttributedString()
                .normal("게시물 ", size: 12, color: .systemGray3)
                .bold(String(kakaoPlace.p_posts_cnt ?? 0), size: 12, color: .systemGray)
                .normal("  좋아요 ", size: 12, color: .systemGray3)
                .bold(String(kakaoPlace.p_like_cnt ?? 0), size: 12, color: .systemGray)
                .normal("  댓글 ", size: 12, color: .systemGray3)
                .bold(String(kakaoPlace.p_comment_cnt ?? 0), size: 12, color: .systemGray)
            cntLabel.attributedText = cntMabs
        }
    }
    let addPostsRequest = AddPostsRequest()
    let uploadPostsImageRequest = UploadPostsImageRequest()
    var progressWidthCons: NSLayoutConstraint?
    var uploadImageCnt = 0
    var isUploading = false
    
    
    // MARK: View
    lazy var bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("게시하기", for: .normal)
        button.backgroundColor = .systemGray6
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(postsTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var bottomButtonTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Place
    lazy var placeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XXS
        sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(placeTapped)))
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var cntLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Image
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceHorizontal = true
        cv.isPagingEnabled = true
        cv.register(SlideImageCVCell.self, forCellWithReuseIdentifier: "SlideImageCVCell")
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .systemGray6
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.backgroundStyle = .minimal
        pc.allowsContinuousInteraction = false
        pc.isEnabled = false
        pc.currentPageIndicatorTintColor = .systemBlue
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    // MARK: View - Message
    lazy var messageTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        vev.alpha = 0.2
        vev.translatesAutoresizingMaskIntoConstraints = false
        return vev
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
        
        view.backgroundColor = .systemGray6
        
        navigationItem.title = "새로운 게시물"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        addPostsRequest.delegate = self
        uploadPostsImageRequest.delegate = self
        
        prevVC = presentingViewController
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        scrollView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        pageControl.pageIndicatorTintColor = .separator
        progressContainerView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(bottomButton)
        bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(bottomButtonTopLine)
        bottomButtonTopLine.topAnchor.constraint(equalTo: bottomButton.topAnchor).isActive = true
        bottomButtonTopLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomButtonTopLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE).isActive = true
        
        // MARK: ConfigureView - Place
        stackView.addArrangedSubview(placeStackView)
        placeStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        placeStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        placeStackView.addArrangedSubview(categoryLabel)
        categoryLabel.leadingAnchor.constraint(equalTo: placeStackView.leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: placeStackView.trailingAnchor).isActive = true
        
        categoryLabel.addSubview(cntLabel)
        cntLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor).isActive = true
        cntLabel.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        
        placeStackView.addArrangedSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: placeStackView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: placeStackView.trailingAnchor).isActive = true
        
        placeStackView.addArrangedSubview(addressLabel)
        addressLabel.leadingAnchor.constraint(equalTo: placeStackView.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: placeStackView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Image
        stackView.addArrangedSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        stackView.addArrangedSubview(pageControl)
        pageControl.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Message
        stackView.addArrangedSubview(messageTopLine)
        messageTopLine.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        messageTopLine.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(messageLabel)
        messageLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        messageLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(collectionView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        if isUploading {
            showToast(tv: toastView, tcl: toastLabel, text: "게시물을 업로드중입니다. 잠시만 기다려주세요.")

        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func postsTapped() {
        guard let kakaoPlace = self.kakaoPlace else { return }
        
        isUploading = true
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        addPostsRequest.fetch(vc: self, paramDict: ["kId": kakaoPlace.id, "name": kakaoPlace.place_name, "address": kakaoPlace.address_name, "roadAddress": kakaoPlace.road_address_name, "lat": kakaoPlace.y, "lng": kakaoPlace.x, "categoryGroupCode": kakaoPlace.category_group_code, "categoryGroupName": kakaoPlace.category_group_name, "categoryName": kakaoPlace.category_name, "phone": kakaoPlace.phone, "message": message])
    }
    
    @objc func placeTapped() {
        guard let kakaoPlace = self.kakaoPlace else { return }
        
        let placeVC = PlaceViewController()
        placeVC.kakaoPlace = kakaoPlace
        navigationController?.pushViewController(placeVC, animated: true)
    }
}


// MARK: HTTP - AddPosts
extension PostingConfirmViewController: AddPostsRequestProtocol {
    func response(poId: Int?, addPosts status: String) {
        print("[HTTP RES]", addPostsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let poId = poId else { return }
            
            progressWidthCons?.isActive = false
            progressWidthCons = progressView.widthAnchor.constraint(equalTo: progressBackView.widthAnchor, multiplier: CGFloat(0.5) / CGFloat(imageList.count))
            progressWidthCons?.isActive = true
            
            progressBlurOverlayView.isHidden = false
            progressContainerView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.progressBlurOverlayView.alpha = 0.2
                self.progressContainerView.alpha = 1
                self.view.layoutIfNeeded()
            })
            
            for (i, image) in imageList.enumerated() {
                uploadPostsImageRequest.fetch(vc: self, image: image, poId: poId, order: i + 1)
            }
        }
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}

// MARK: HTTP - UploadPostsImage
extension PostingConfirmViewController: UploadPostsImageRequestProtocol {
    func response(uploadPostsImage status: String) {
        print("[HTTP RES]", uploadPostsImageRequest.apiUrl, status)
        
        if status == "OK" {
            uploadImageCnt += 1
            
            progressWidthCons?.isActive = false
            progressWidthCons = progressView.widthAnchor.constraint(equalTo: progressBackView.widthAnchor, multiplier: CGFloat(uploadImageCnt) / CGFloat(imageList.count))
            progressWidthCons?.isActive = true
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            
            if uploadImageCnt == imageList.count {
                progressBlurOverlayView.removeFromSuperview()
                progressContainerView.removeFromSuperview()
                
                let alert = UIAlertController(title: nil, message: "게시물이 업로드되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                    self.dismiss(animated: true, completion: {
                        self.prevVC?.dismiss(animated: true, completion: nil)
                    })
                }))
                present(alert, animated: true)
            }
            
        } else {
            isUploading = false
            progressBlurOverlayView.removeFromSuperview()
            progressContainerView.removeFromSuperview()
        }
    }
}

// MARK: CollectionView
extension PostingConfirmViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideImageCVCell", for: indexPath) as! SlideImageCVCell
        cell.image = imageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
}
