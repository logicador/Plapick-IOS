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
    let app = App()
    let getPicksRequest = GetPicksRequest()
    let getPickCommentsRequest = GetPickCommentsRequest()
    let removePickRequest = RemovePickRequest()
    let likePickRequest = LikePickRequest()
    var order: String = "RECENT"
    var uId: Int? {
        didSet {
            userContainerView.isHidden = true
            userBottomLineContainerView.isHidden = true
        }
    }
    var pId: Int? {
        didSet {
            placeContainerView.isHidden = true
            userBottomLineContainerView.isHidden = true
        }
    }
    var mlpiUId: Int?
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
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(removePickTapped))
                navigationItem.rightBarButtonItem?.tintColor = .systemRed
                
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
    
    // MARK: View - User
    lazy var userContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(detailUserTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var userNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var userBottomLineContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var userBottomLine: LineView = {
        let lv = LineView()
        return lv
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
    lazy var pickCntTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
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
        
        // MARK: ConfigureView - User
        stackView.addArrangedSubview(userContainerView)
        userContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        userContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        userContainerView.addSubview(userProfileImageView)
        userProfileImageView.topAnchor.constraint(equalTo: userContainerView.topAnchor, constant: SPACE_XS).isActive = true
        userProfileImageView.leadingAnchor.constraint(equalTo: userContainerView.leadingAnchor).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userProfileImageView.bottomAnchor.constraint(equalTo: userContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        userContainerView.addSubview(userNickNameLabel)
        userNickNameLabel.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor).isActive = true
        userNickNameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        
        stackView.addArrangedSubview(userBottomLineContainerView)
        userBottomLineContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        userBottomLineContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        userBottomLineContainerView.addSubview(userBottomLine)
        userBottomLine.topAnchor.constraint(equalTo: userBottomLineContainerView.topAnchor).isActive = true
        userBottomLine.leadingAnchor.constraint(equalTo: userBottomLineContainerView.leadingAnchor, constant: ((SCREEN_WIDTH * (1 - CONTENTS_RATIO)) / 2) + 30 + SPACE_XS).isActive = true
        userBottomLine.trailingAnchor.constraint(equalTo: userBottomLineContainerView.trailingAnchor).isActive = true
        userBottomLine.bottomAnchor.constraint(equalTo: userBottomLineContainerView.bottomAnchor).isActive = true
        
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
        stackView.addArrangedSubview(pickCntTopLine)
        pickCntTopLine.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        pickCntTopLine.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(pickCntContainerView)
        pickCntContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        pickCntContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        pickCntContainerView.addSubview(pickDateLabel)
        pickDateLabel.topAnchor.constraint(equalTo: pickCntContainerView.topAnchor, constant: SPACE_XS).isActive = true
        pickDateLabel.leadingAnchor.constraint(equalTo: pickCntContainerView.leadingAnchor).isActive = true
        pickDateLabel.bottomAnchor.constraint(equalTo: pickCntContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        pickCntContainerView.addSubview(pickCntLabel)
        pickCntLabel.centerYAnchor.constraint(equalTo: pickDateLabel.centerYAnchor).isActive = true
        pickCntLabel.trailingAnchor.constraint(equalTo: pickCntContainerView.trailingAnchor).isActive = true
        
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
        
        stackView.addArrangedSubview(messageContainerView)
        messageContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        messageContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        messageContainerView.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: SPACE_XL).isActive = true
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
    }
    
    func getPicks() {
        var paramDict: [String: String] = [:]
        paramDict["order"] = order
        if let uId = self.uId { paramDict["uId"] = String(uId) }
        if let pId = self.pId { paramDict["pId"] = String(pId) }
        if let mlpiUId = self.mlpiUId { paramDict["mlpiUId"] = String(mlpiUId) }
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
                
            } else { isEnded = true }
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
    
    
//    // MARK: Properties
//    var app = App()
//    var pick: Pick? {
//        didSet {
////            getPlaceRequest.fetch(pId: pick!.pId)
////            self.navigationItem.title = pick?.user?.nickName // pick!.uNickName
////
////            if pick?.user?.id == app.getUId() {
////                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(moreTapped))
////            }
//        }
//    }
////    var getPlaceRequest = GetPlaceRequest()
////    let removePickRequest = RemovePickRequest()
//    var accountViewController: AccountViewController?
//
//    var isZooming: Bool = false
//    var originalImageCenter: CGPoint?
    
    
//    // MARK: Views
//    lazy var contentView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    lazy var scrollView: UIScrollView = {
//        let sv = UIScrollView()
//        sv.translatesAutoresizingMaskIntoConstraints = false
//        return sv
//    }()
//
//    lazy var spaceView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
////    var placeSmallView: PlaceSmallView?
//    lazy var placeTopLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .separator
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    lazy var placeBottomLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .separator
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    lazy var photoView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        iv.isUserInteractionEnabled = true
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        return iv
//    }()
//    lazy var photoTopLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .separator
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    lazy var photoBottomLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .separator
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    lazy var blurView: UIVisualEffectView = {
//        let vev = UIVisualEffectView()
//        vev.effect = UIBlurEffect(style: UIBlurEffect.Style.regular)
//        vev.alpha = 0
//        vev.translatesAutoresizingMaskIntoConstraints = false
//        return vev
//    }()
//
//    lazy var figureView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    lazy var figureLikeCntLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    lazy var figureCommentCntLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var messageView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    lazy var messageLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    lazy var messageTopLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .separator
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    lazy var messageBottomLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .separator
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    
//    // MARK: ViewDidLoad
//    override func viewDidLoad() {
//        super.viewDidLoad()
        
//        view.addSubview(scrollView)
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//
//        scrollView.addSubview(contentView)
//        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//
//        contentView.addSubview(spaceView)
//        spaceView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        spaceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        spaceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        spaceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        spaceView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
//        spaceView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
//        getPlaceRequest.delegate = self
//        removePickRequest.delegate = self
        
//        adjustColors()
        
//        if !app.isNetworkAvailable() {
//            app.showNetworkAlert(vc: self)
//            return
//        }
//    }
    
    // MARK: Functions
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        adjustColors()
//    }
//    func adjustColors() {
//        if self.traitCollection.userInterfaceStyle == .dark {
//            view.backgroundColor = .systemBackground
//            messageView.backgroundColor = .systemGray6
//        } else {
//            view.backgroundColor = .tertiarySystemGroupedBackground
//            messageView.backgroundColor = .systemBackground
//        }
//    }
    
//    @objc func moreTapped() {
//        let alert = UIAlertController(title: "고객센터", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//        alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
//        alert.addAction(UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.destructive, handler: { (_) in
////            if !self.app.isNetworkAvailable() {
////                self.app.showNetworkAlert(vc: self)
////                return
////            }
//
//            let removeAlert = UIAlertController(title: "삭제하기", message: "정말 해당 픽을 삭제하시겠습니까? 삭제된 픽은 다시 복구하실 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
//            removeAlert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel))
//            removeAlert.addAction(UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: { (_) in
////                let piId = self.pick?.id
////                self.removePickRequest.fetch(vc: self, piId: piId!)
//            }))
//            self.present(removeAlert, animated: true, completion: nil)
//        }))
//        alert.addAction(UIAlertAction(title: "수정하기", style: UIAlertAction.Style.default, handler: { (_) in
//
//        }))
//        present(alert, animated: true)
//    }
//
//    @objc func photoViewPanned(sender: UIPanGestureRecognizer) {
//
//        if self.isZooming && sender.state == .began {
//            if originalImageCenter == nil { originalImageCenter = photoView.center }
//            if scrollView.isScrollEnabled { scrollView.isScrollEnabled = false }
//
//        } else if self.isZooming && sender.state == .changed {
//            let translation = sender.translation(in: self.view)
//            if let view = sender.view {
//                view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
//            }
//            sender.setTranslation(CGPoint.zero, in: self.photoView.superview)
//        }
//    }
//
//    @objc func photoViewPinched(sender: UIPinchGestureRecognizer) {
//
//        if sender.state == .began {
//            if originalImageCenter == nil { originalImageCenter = photoView.center }
//            if scrollView.isScrollEnabled { scrollView.isScrollEnabled = false }
//
//            let currentScale = self.photoView.frame.size.width / self.photoView.bounds.size.width
//            let newScale = currentScale * sender.scale
//            if newScale > 1 { self.isZooming = true }
//
//        } else if sender.state == .changed {
//            guard let view = sender.view else { return }
//
//            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX, y: sender.location(in: view).y - view.bounds.midY)
//
//            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y).scaledBy(x: sender.scale, y: sender.scale).translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
//
//            let currentScale = self.photoView.frame.size.width / self.photoView.bounds.size.width
//
//            var newScale = currentScale * sender.scale
//
//            if newScale < 1 {
//                newScale = 1
//                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
//                self.photoView.transform = transform
//                sender.scale = 1
//
//            } else {
//                view.transform = transform
//                sender.scale = 1
//            }
//
//            if newScale > 2.0 { blurView.alpha = 1.0 }
//            else { blurView.alpha = newScale - 1.0 }
//
//        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
//            guard let center = self.originalImageCenter else { return }
//
//            UIView.animate(withDuration: 0.3, animations: {
//                self.photoView.transform = CGAffineTransform.identity
//                self.photoView.center = center
//                self.blurView.alpha = 0
//            }, completion: { (_) in
//                self.isZooming = false
//                self.scrollView.isScrollEnabled = true
//            })
//        }
//    }
//
//    @objc func photoViewTapped() {
//        let photoViewController = PhotoViewController()
//        photoViewController.image = photoView.image
//        self.navigationController?.pushViewController(photoViewController, animated: true)
//    }
//
//    @objc func placeTapped() {
//        print("placeTapped")
//    }
    
//    func configureView() {
//        guard let pick = self.pick else { return }
//        spaceView.removeView()
//
////        placeSmallView = PlaceSmallView(place: place)
////        placeSmallView = PlaceSmallView()
////        placeSmallView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(placeTapped)))
//
////        photoView.image = app.getUrlImage(urlString: pick.photoUrl)
//
//        messageLabel.text = pick.message
////        figureLikeCntLabel.text = "좋아요 \(String(pick.likeCnt))개"
////        figureCommentCntLabel.text = "댓글 \(String(pick.commentCnt))개"
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoViewTapped))
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(photoViewPanned(sender:)))
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(photoViewPinched(sender:)))
//        panGesture.delegate = self
//        pinchGesture.delegate = self
//        photoView.addGestureRecognizer(tapGesture)
//        photoView.addGestureRecognizer(panGesture)
//        photoView.addGestureRecognizer(pinchGesture)
//
////        contentView.addSubview(placeSmallView!)
////        placeSmallView?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
////        placeSmallView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
////        placeSmallView?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//
//        contentView.addSubview(placeTopLineView)
////        placeTopLineView.topAnchor.constraint(equalTo: placeSmallView!.topAnchor).isActive = true
//        placeTopLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        placeTopLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        placeTopLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
//
//        contentView.addSubview(placeBottomLineView)
////        placeBottomLineView.bottomAnchor.constraint(equalTo: placeSmallView!.bottomAnchor).isActive = true
//        placeBottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        placeBottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        placeBottomLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
//
//        contentView.addSubview(photoTopLineView)
////        photoTopLineView.topAnchor.constraint(equalTo: placeSmallView!.bottomAnchor, constant: 20).isActive = true
//        photoTopLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        photoTopLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        photoTopLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
//
//        contentView.addSubview(photoBottomLineView)
//        photoBottomLineView.topAnchor.constraint(equalTo: photoTopLineView.bottomAnchor, constant: view.frame.size.width).isActive = true
//        photoBottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        photoBottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        photoBottomLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
//
//        contentView.addSubview(figureView)
//        figureView.topAnchor.constraint(equalTo: photoBottomLineView.bottomAnchor).isActive = true
//        figureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        figureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//
//        figureView.addSubview(figureLikeCntLabel)
//        figureLikeCntLabel.topAnchor.constraint(equalTo: figureView.topAnchor, constant: 10).isActive = true
//        figureLikeCntLabel.leadingAnchor.constraint(equalTo: figureView.leadingAnchor, constant: 20).isActive = true
//        figureLikeCntLabel.bottomAnchor.constraint(equalTo: figureView.bottomAnchor, constant: -10).isActive = true
//
//        figureView.addSubview(figureCommentCntLabel)
//        figureCommentCntLabel.topAnchor.constraint(equalTo: figureView.topAnchor, constant: 10).isActive = true
//        figureCommentCntLabel.leadingAnchor.constraint(equalTo: figureLikeCntLabel.trailingAnchor, constant: 20).isActive = true
//        figureCommentCntLabel.bottomAnchor.constraint(equalTo: figureView.bottomAnchor, constant: -10).isActive = true
//
//        contentView.addSubview(messageView)
//        messageView.topAnchor.constraint(equalTo: figureView.bottomAnchor).isActive = true
//        messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//
//        messageView.addSubview(messageLabel)
//        messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10).isActive = true
//        messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 20).isActive = true
//        messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -20).isActive = true
//        messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10).isActive = true
//
//        contentView.addSubview(messageTopLineView)
//        messageTopLineView.topAnchor.constraint(equalTo: messageView.topAnchor).isActive = true
//        messageTopLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        messageTopLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        messageTopLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
//
//        contentView.addSubview(messageBottomLineView)
//        messageBottomLineView.topAnchor.constraint(equalTo: messageView.bottomAnchor).isActive = true
//        messageBottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        messageBottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        messageBottomLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
//
//        contentView.addSubview(blurView)
//        blurView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//
//        contentView.addSubview(photoView)
//        photoView.topAnchor.constraint(equalTo: photoTopLineView.bottomAnchor).isActive = true
//        photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        photoView.bottomAnchor.constraint(equalTo: photoBottomLineView.topAnchor).isActive = true
//    }
//}


//// MARK: Extensions
////extension PickViewController: GetPlaceRequestProtocol {
////    func response(place: Place?, status: String) {
////        if status == "OK" {
////            if let place = place {
////                configureView(place: place)
////            }
////        }
////    }
////}
//
//
////extension PickViewController: RemovePickRequestProtocol {
////    func response(status: String) {
////        if status == "OK" {
//////            self.accountViewController?.getMyPicks()
////            let alert = UIAlertController(title: "픽 삭제", message: "픽이 삭제되었습니다.", preferredStyle: UIAlertController.Style.alert)
////            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (_) in
////                self.navigationController?.popViewController(animated: true)
////            }))
////            present(alert, animated: true)
////        }
////    }
////}
//
//
//extension PickViewController: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}
