//
//  PickViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/17.
//

import UIKit
import SDWebImage


class PickViewController: UIViewController {
    
    // MARK: Property
//    var isAuth: Bool = false
    let app = App()
    let getPicksRequest = GetPicksRequest()
    let getPickCommentsRequest = GetPickCommentsRequest()
    let removePickRequest = RemovePickRequest()
    let likePickRequest = LikePickRequest()
    let blockPickRequest = BlockPickRequest()
    var order: String = "RECENT"
    var uId: Int? {
        didSet {
//            userContainerView.isHidden = true
//            userBottomLineContainerView.isHidden = true
        }
    }
    var pId: Int? {
        didSet {
//            placeContainerView.isHidden = true
//            userBottomLineContainerView.isHidden = true
        }
    }
    var mlpiUId: Int?
    var bpiUId: Int? {
        didSet {
            getPicksRequest.isHideBlocked = false
        }
    }
    var id: Int? {
        didSet {
            guard let id = self.id else { return }
            
            for v in commentStackView.subviews {
                if v == noCommentContainerView { continue }
                v.removeFromSuperview()
            }
            
            getPickCommentsRequest.fetch(vc: self, paramDict: ["piId": String(id), "page": "1", "limit": "2"])
        }
    }
    var pick: Pick? { // selected / showing
        didSet {
            guard let pick = self.pick else { return }
            
            let user = pick.user
            let place = pick.place
            
            if let profileImage = user.profileImage { userProfileImageView.setProfileImage(uId: user.id, profileImage: profileImage) }
            
            if user.id == app.getUId() {
//                if isAuth {
//                    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(removePickTapped))
//                    navigationItem.rightBarButtonItem?.tintColor = .systemRed
//                }
                
            } else {
                navigationItem.rightBarButtonItem = (pick.isLike == "Y") ? UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(likeTapped)) : UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeTapped))
                navigationItem.rightBarButtonItem?.tintColor = .systemBlue
            }
            
            userNickNameLabel.text = user.nickName
            
            placeNameLabel.text = place.name
            
            pickDateLabel.text = String(pick.createdDate.split(separator: " ")[0])
            
            let pickCntMabs = NSMutableAttributedString()
                .normal("좋아요 ", size: 14, color: .systemGray)
                .bold(String(pick.likeCnt), size: 14)
                .normal("  댓글 ", size: 14, color: .systemGray)
                .bold(String(pick.commentCnt), size: 14)
            pickCntLabel.attributedText = pickCntMabs
            
            if let message = pick.message {
                if !message.isEmpty {
                    messageContainerView.isHidden = false
                    messageLabel.text = message
                    
                } else { messageContainerView.isHidden = true }
            } else { messageContainerView.isHidden = true }
            
            if let url = URL(string: "\(IMAGE_URL)/users/\(pick.uId)/\(pick.id).jpg") { pickImageView.sd_setImage(with: url, completed: nil) }
        }
    }
    var isEnded = false
    var isLoading = false
    var page = 1
    var pickList: [Pick] = []
    var isFoundFirstItem = false
    let collectionImageSize = (SCREEN_WIDTH / 5) - (2 / 3)
    
    
    // MARK: View
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceHorizontal = true
        cv.backgroundColor = .systemBackground
        cv.register(PickCVCell.self, forCellWithReuseIdentifier: "PickCVCell")
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    lazy var collectionTopLine: LineView = {
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
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Place
    lazy var placeContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(detailPlaceTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var placeImageView: UIImageView = {
        let image = UIImage(systemName: "airplane.circle.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Pick
    lazy var pickCntContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var pickDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var pickCntLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pickImageTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var pickImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImageTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var pickImageBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Pick - User
    lazy var userContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(detailUserTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var userNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var blockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
        button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Pick - Message
    lazy var messageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var messageBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Comment
    lazy var commentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var commentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        label.font = .boldSystemFont(ofSize: 22)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var allCommentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("모두 보기 / 댓글 쓰기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(allCommentTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var commentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_S
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var noCommentContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noCommentTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var noCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글이 없습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var noBlockPickContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noBlockPickLabel: UILabel = {
        let label = UILabel()
        label.text = "차단하신 픽이 없습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        getPicksRequest.delegate = self
        getPickCommentsRequest.delegate = self
        removePickRequest.delegate = self
        likePickRequest.delegate = self
        blockPickRequest.delegate = self
        
        getPicks()
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: collectionImageSize).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -BOTTOM_SPACING).isActive = true
        
        view.addSubview(collectionTopLine)
        collectionTopLine.topAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        collectionTopLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionTopLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Place
        stackView.addArrangedSubview(placeContainerView)
        placeContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        placeContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        placeContainerView.addSubview(placeImageView)
        placeImageView.topAnchor.constraint(equalTo: placeContainerView.topAnchor, constant: SPACE_XS).isActive = true
        placeImageView.leadingAnchor.constraint(equalTo: placeContainerView.leadingAnchor).isActive = true
        placeImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        placeImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        placeImageView.bottomAnchor.constraint(equalTo: placeContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        placeContainerView.addSubview(placeNameLabel)
        placeNameLabel.centerYAnchor.constraint(equalTo: placeImageView.centerYAnchor).isActive = true
        placeNameLabel.leadingAnchor.constraint(equalTo: placeImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        
        // MARK: ConfigureView - Pick
        stackView.addArrangedSubview(pickImageView)
        pickImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        pickImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        pickImageView.heightAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        pickImageView.addSubview(pickImageTopLine)
        pickImageTopLine.topAnchor.constraint(equalTo: pickImageView.topAnchor).isActive = true
        pickImageTopLine.leadingAnchor.constraint(equalTo: pickImageView.leadingAnchor).isActive = true
        pickImageTopLine.trailingAnchor.constraint(equalTo: pickImageView.trailingAnchor).isActive = true

        pickImageView.addSubview(pickImageBottomLine)
        pickImageBottomLine.bottomAnchor.constraint(equalTo: pickImageView.bottomAnchor).isActive = true
        pickImageBottomLine.leadingAnchor.constraint(equalTo: pickImageView.leadingAnchor).isActive = true
        pickImageBottomLine.trailingAnchor.constraint(equalTo: pickImageView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(pickCntContainerView)
        pickCntContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        pickCntContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        pickCntContainerView.addSubview(pickDateLabel)
        pickDateLabel.topAnchor.constraint(equalTo: pickCntContainerView.topAnchor, constant: SPACE_XS).isActive = true
        pickDateLabel.leadingAnchor.constraint(equalTo: pickCntContainerView.leadingAnchor).isActive = true
        pickDateLabel.bottomAnchor.constraint(equalTo: pickCntContainerView.bottomAnchor).isActive = true
        
        pickCntContainerView.addSubview(pickCntLabel)
        pickCntLabel.centerYAnchor.constraint(equalTo: pickDateLabel.centerYAnchor).isActive = true
        pickCntLabel.trailingAnchor.constraint(equalTo: pickCntContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Pick - User
        stackView.addArrangedSubview(userContainerView)
        userContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        userContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true

        userContainerView.addSubview(userProfileImageView)
        userProfileImageView.topAnchor.constraint(equalTo: userContainerView.topAnchor, constant: SPACE_XS).isActive = true
        userProfileImageView.leadingAnchor.constraint(equalTo: userContainerView.leadingAnchor).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userProfileImageView.bottomAnchor.constraint(equalTo: userContainerView.bottomAnchor).isActive = true

        userContainerView.addSubview(userNickNameLabel)
        userNickNameLabel.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor).isActive = true
        userNickNameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        
        userContainerView.addSubview(blockButton)
        blockButton.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor).isActive = true
        blockButton.trailingAnchor.constraint(equalTo: userContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Pick - Message
        stackView.addArrangedSubview(messageContainerView)
        messageContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        messageContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        messageContainerView.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: SPACE_XS).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: messageContainerView.centerXAnchor).isActive = true
        messageLabel.widthAnchor.constraint(equalTo: messageContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        messageContainerView.addSubview(messageBottomLine)
        messageBottomLine.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor).isActive = true
        messageBottomLine.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor).isActive = true
        messageBottomLine.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Comment
        stackView.addArrangedSubview(commentContainerView)
        commentContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        commentContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        commentContainerView.addSubview(commentTitleLabel)
        commentTitleLabel.topAnchor.constraint(equalTo: commentContainerView.topAnchor, constant: SPACE_XL).isActive = true
        commentTitleLabel.centerXAnchor.constraint(equalTo: commentContainerView.centerXAnchor).isActive = true
        commentTitleLabel.widthAnchor.constraint(equalTo: commentContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        commentTitleLabel.addSubview(allCommentButton)
        allCommentButton.centerYAnchor.constraint(equalTo: commentTitleLabel.centerYAnchor).isActive = true
        allCommentButton.trailingAnchor.constraint(equalTo: commentTitleLabel.trailingAnchor).isActive = true
        
        commentContainerView.addSubview(commentStackView)
        commentStackView.topAnchor.constraint(equalTo: commentTitleLabel.bottomAnchor, constant: SPACE_XL).isActive = true
        commentStackView.centerXAnchor.constraint(equalTo: commentContainerView.centerXAnchor).isActive = true
        commentStackView.widthAnchor.constraint(equalTo: commentContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        commentStackView.bottomAnchor.constraint(equalTo: commentContainerView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        commentStackView.addArrangedSubview(noCommentContainerView)
        noCommentContainerView.leadingAnchor.constraint(equalTo: commentStackView.leadingAnchor).isActive = true
        noCommentContainerView.trailingAnchor.constraint(equalTo: commentStackView.trailingAnchor).isActive = true
        
        noCommentContainerView.addSubview(noCommentTopLine)
        noCommentTopLine.topAnchor.constraint(equalTo: noCommentContainerView.topAnchor).isActive = true
        noCommentTopLine.leadingAnchor.constraint(equalTo: noCommentContainerView.leadingAnchor).isActive = true
        noCommentTopLine.trailingAnchor.constraint(equalTo: noCommentContainerView.trailingAnchor).isActive = true
        
        noCommentContainerView.addSubview(noCommentLabel)
        noCommentLabel.topAnchor.constraint(equalTo: noCommentTopLine.bottomAnchor, constant: SPACE_XL).isActive = true
        noCommentLabel.centerXAnchor.constraint(equalTo: noCommentContainerView.centerXAnchor).isActive = true
        noCommentLabel.bottomAnchor.constraint(equalTo: noCommentContainerView.bottomAnchor, constant: -SPACE_XL).isActive = true
    
        view.addSubview(noBlockPickContainerView)
        noBlockPickContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        noBlockPickContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        noBlockPickContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        noBlockPickContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        noBlockPickContainerView.addSubview(noBlockPickLabel)
        noBlockPickLabel.centerXAnchor.constraint(equalTo: noBlockPickContainerView.centerXAnchor).isActive = true
        noBlockPickLabel.centerYAnchor.constraint(equalTo: noBlockPickContainerView.centerYAnchor).isActive = true
    }
    
    func getPicks() {
        var paramDict: [String: String] = [:]
        paramDict["order"] = order
        if let uId = self.uId { paramDict["uId"] = String(uId) }
        if let pId = self.pId { paramDict["pId"] = String(pId) }
        if let mlpiUId = self.mlpiUId { paramDict["mlpiUId"] = String(mlpiUId) }
        if let bpiUId = self.bpiUId { paramDict["bpiUId"] = String(bpiUId) }
        paramDict["page"] = String(page)
        
        isLoading = true
        getPicksRequest.fetch(vc: self, paramDict: paramDict)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFoundFirstItem { return }
        
        guard let id = self.id else { return }
        
        for (i, pick) in pickList.enumerated() {
            if pick.id == id {
                collectionView.selectItem(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }
        }
        
        isFoundFirstItem = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !isFoundFirstItem { return }
        
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width

        if offsetX > contentWidth - scrollView.frame.width {
            if !isLoading && !isEnded {
                page += 1
                getPicks()
            }
        }
    }
    
    // MARK: Function - @OBJC
    @objc func pickImageTapped() {
        guard let pick = self.pick else { return }
        let photoVC = PhotoViewController()
        photoVC.image = pickImageView.image
        photoVC.navigationItem.title = "\(pick.user.nickName)님의 사진"
        navigationController?.pushViewController(photoVC, animated: true)
    }
    
    @objc func removePickTapped() {
        guard let pick = self.pick else { return }
        
        let alert = UIAlertController(title: nil, message: "해당 픽을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
            self.removePickRequest.fetch(vc: self, paramDict: ["piId": String(pick.id)])
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func likeTapped() {
        guard let pick = self.pick else { return }
        likePickRequest.fetch(vc: self, paramDict: ["piId": String(pick.id)])
    }
    
    @objc func detailUserTapped() {
        guard let pick = self.pick else { return }
        
        let accountVC = AccountViewController()
        accountVC.user = pick.user
        navigationController?.pushViewController(accountVC, animated: true)
    }
    
    @objc func detailPlaceTapped() {
        guard let pick = self.pick else { return }
        
        let placeVC = PlaceViewController()
        placeVC.place = pick.place
        navigationController?.pushViewController(placeVC, animated: true)
    }
    
    @objc func allCommentTapped() {
        guard let pick = self.pick else { return }
        
        let pickCommentVC = PickCommentViewController()
        pickCommentVC.pick = pick
        navigationController?.pushViewController(pickCommentVC, animated: true)
    }
    
    @objc func moreTapped() {
        guard let pick = self.pick else { return }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        if pick.isBlocked == "Y" {
            alert.addAction(UIAlertAction(title: "차단해제", style: .default, handler: { (_) in
                self.blockPickRequest.fetch(vc: self, paramDict: ["blockPiId": String(pick.id)])
            }))
        } else {
            alert.addAction(UIAlertAction(title: "차단하기", style: .destructive, handler: { (_) in
                let alert = UIAlertController(title: "차단하기", message: "정말 해당 픽을 차단하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "차단", style: .destructive, handler: { (_) in
                    self.blockPickRequest.fetch(vc: self, paramDict: ["blockPiId": String(pick.id)])
                }))
                self.present(alert, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "신고하기", style: .destructive, handler: { (_) in
            let pickReportVC = PickReportViewController()
            pickReportVC.pick = pick
            self.present(UINavigationController(rootViewController: pickReportVC), animated: true, completion: nil)
        }))
        present(alert, animated: true)
    }
}


// MARK: HTTP - GetPicks
extension PickViewController: GetPicksRequestProtocol {
    func response(pickList: [Pick]?, getPicks status: String) {
        print("[HTTP RES]", getPicksRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pickList = pickList else { return }
            guard let id = self.id else { return }
            
            if pickList.count > 0 {
                isEnded = false
                
                var isFindPick = false
                for (i, pick) in pickList.enumerated() {
                    if i == 0 && id == 0 { // 선택되어 들어온 픽이 없음. 맨 첫번째 픽을 선택함
                        isFindPick = true
                        self.id = pick.id
                        self.pick = pick
                    }
                    
                    if pick.id == id {
                        isFindPick = true
                        self.pick = pick
                    }
                    
                    self.pickList.append(pick)
                }
                collectionView.reloadData()
                
                if isFindPick { isFoundFirstItem = false }
                else {
                    page += 1
                    getPicks()
                }
                
            } else {
                isEnded = true
                if let _ = self.bpiUId { noBlockPickContainerView.isHidden = false }
            }
        }
        isLoading = false
    }
}

// MARK: HTTP - GetPickComments
extension PickViewController: GetPickCommentsRequestProtocol {
    func response(pickCommentList: [PickComment]?, getPickComments status: String) {
        print("[HTTP RES]", getPickCommentsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pickCommentList = pickCommentList else { return }
            
            if pickCommentList.count > 0 {
                noCommentContainerView.isHidden = true
                for pickComment in pickCommentList {
                    let cv = CommentView()
                    cv.id = pickComment.id
                    cv.date = pickComment.createdDate
                    cv.comment = pickComment.comment
                    cv.user = pickComment.user
                    cv.removeButton.isHidden = true
                    cv.delegate = self
                    
                    commentStackView.addArrangedSubview(cv)
                    cv.leadingAnchor.constraint(equalTo: commentStackView.leadingAnchor).isActive = true
                    cv.trailingAnchor.constraint(equalTo: commentStackView.trailingAnchor).isActive = true
                }
            } else { if commentStackView.subviews.count == 1 { noCommentContainerView.isHidden = false } }
        }
    }
}

// MARK: HTTP - RemovePick
extension PickViewController: RemovePickRequestProtocol {
    func response(removePick status: String) {
        print("[HTTP RES]", removePickRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pick = self.pick else { return }
            
            for (i, pi) in pickList.enumerated() {
                if pi.id == pick.id {
                    var nextIndex = i
                    
                    if pickList.count > i + 1 { // 뒤에 픽이 더 있음
                        id = pickList[i + 1].id
                        self.pick = pickList[i + 1]
                        
                    } else {
                        if pickList.count > 1 { // 앞에 픽이 더 있음
                            id = pickList[i - 1].id
                            self.pick = pickList[i - 1]
                            nextIndex -= 1
                            
                        } else { // 픽이 자기 자신밖에 없었음
                            navigationController?.popViewController(animated: true)
                            break
                        }
                    }
                    
                    pickList.remove(at: i)
                    collectionView.reloadData()
                    collectionView.selectItem(at: IndexPath(row: nextIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                    break
                }
            }
        }
    }
}

// MARK: HTTP - LikePick
extension PickViewController: LikePickRequestProtocol {
    func response(likePick status: String) {
        print("[HTTP RES]", likePickRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pick = self.pick else { return }
            self.pick?.isLike = (pick.isLike == "Y") ? "N" : "Y"
            
            for (i, pi) in pickList.enumerated() {
                if pi.id == pick.id {
                    pickList[i].isLike = (pick.isLike == "Y") ? "N" : "Y"
                    break
                }
            }
        }
    }
}

// MARK: HTTP - BlockPick
extension PickViewController: BlockPickRequestProtocol {
    func response(blockPick status: String) {
        print("[HTTP RES]", blockPickRequest.apiUrl, status)
        
        if status == "OK" {
            changeRootViewController(rootViewController: UINavigationController(rootViewController: MainViewController()))
        }
    }
}

// MARK: CollectionView
extension PickViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickCVCell", for: indexPath) as! PickCVCell
        cell.pick = pickList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionImageSize, height: collectionImageSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pick = pickList[indexPath.row]
        
        if id != pick.id {
            id = pick.id
            self.pick = pick
        }
    }
}

// MARK: CommentView
extension PickViewController: CommentViewProtocol {
    func detailUser(user: User) {
        let accountVC = AccountViewController()
        accountVC.user = user
        navigationController?.pushViewController(accountVC, animated: true)
    }
    
    func removeComment(id: Int) { }
}
