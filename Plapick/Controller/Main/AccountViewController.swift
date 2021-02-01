//
//  AccountViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit
import SDWebImage


protocol AccountViewControllerProtocol {
    func closeAccountVC()
    func follow()
}


class AccountViewController: UIViewController {
    
    // MARK: Property
    var delegate: AccountViewControllerProtocol?
    var app = App()
    var uId: Int?
    let getPicksRequest = GetPicksRequest()
    let getUserReuqest = GetUserRequest()
    let profileImageWidth = SCREEN_WIDTH * (1 / 4)
    var isOpenedChildVC: Bool = false
    var photoGroupViewList: [PhotoGroupView] = []
    let followRequest = FollowRequest()
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Profile
    lazy var profileContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileImagePhotoView: PhotoView = {
        let pv = PhotoView()
        pv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
        pv.layer.cornerRadius = profileImageWidth / 2
        return pv
    }()
    
    lazy var profileLabelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var pickCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "게시한 픽"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var pickCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followerCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로워"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followerCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profileLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Follow
    lazy var followContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var followImageView: UIImageView = {
        let img = UIImage(systemName: "person.2.fill")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var followTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로우"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followerButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.setTitle("팔로워", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = SPACE_S
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XXS, left: SPACE_S, bottom: SPACE_XXS, right: SPACE_S)
        button.addTarget(self, action: #selector(followerTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var followingButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.setTitle("팔로잉", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = SPACE_S
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XXS, left: SPACE_S, bottom: SPACE_XXS, right: SPACE_S)
        button.addTarget(self, action: #selector(followingTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Like
    lazy var likeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var likeImageView: UIImageView = {
        let img = UIImage(systemName: "heart.fill")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var likeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아요"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var likePickButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.setTitle("픽", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = SPACE_S
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XXS, left: SPACE_S, bottom: SPACE_XXS, right: SPACE_S)
        button.addTarget(self, action: #selector(likePickTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var likePlaceButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.setTitle("플레이스", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = SPACE_S
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XXS, left: SPACE_S, bottom: SPACE_XXS, right: SPACE_S)
        button.addTarget(self, action: #selector(likePlaceTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var followLikeLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Other
    lazy var pickTitleView: TitleView = {
        let tv = TitleView(text: "게시한 픽")
        return tv
    }()
    lazy var followButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = SPACE_S
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XXS, left: SPACE_S, bottom: SPACE_XXS, right: SPACE_S)
        button.addTarget(self, action: #selector(followTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var pickContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noPickContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noPickLabel: UILabel = {
        let label = UILabel()
        label.text = "등록된 픽이 없습니다"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addPickbutton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("새로운 픽", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(addPickTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    init(uId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.uId = uId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(closeTapped))
        
        guard let uId = self.uId else { return }
        let appUser = app.getUser()
        
        var isAuthUser = false
        if appUser.id == uId {
            isAuthUser = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "설정", style: UIBarButtonItem.Style.plain, target: self, action: #selector(settingTapped))
        }
        
        configureView(isAuthUser: isAuthUser)
        
        setThemeColor()
        
        getPicksRequest.delegate = self
        getUserReuqest.delegate = self
        followRequest.delegate = self
        
        getUser()
        getPicks()
    }
    
    
    // MARK: ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isOpenedChildVC {
            delegate?.closeAccountVC()
        }
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
            followImageView.tintColor = .white
            likeImageView.tintColor = .white
        } else {
            view.backgroundColor = .white
            followImageView.tintColor = .black
            likeImageView.tintColor = .black
        }
    }
    
    func configureView(isAuthUser: Bool) {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Profile
        contentView.addSubview(profileContainerView)
        profileContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        profileContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        profileContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        profileContainerView.addSubview(profileImageContainerView)
        profileImageContainerView.topAnchor.constraint(equalTo: profileContainerView.topAnchor).isActive = true
        profileImageContainerView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor).isActive = true
        profileImageContainerView.widthAnchor.constraint(equalTo: profileContainerView.widthAnchor, multiplier: 0.5).isActive = true
        profileImageContainerView.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor).isActive = true
        
        profileContainerView.addSubview(profileLabelContainerView)
        profileLabelContainerView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor).isActive = true
        profileLabelContainerView.widthAnchor.constraint(equalTo: profileContainerView.widthAnchor, multiplier: 0.5).isActive = true
        profileLabelContainerView.centerYAnchor.constraint(equalTo: profileContainerView.centerYAnchor).isActive = true
        
        profileImageContainerView.addSubview(profileImagePhotoView)
        profileImagePhotoView.topAnchor.constraint(equalTo: profileImageContainerView.topAnchor, constant: SPACE_XL).isActive = true
        profileImagePhotoView.trailingAnchor.constraint(equalTo: profileImageContainerView.trailingAnchor).isActive = true
        profileImagePhotoView.widthAnchor.constraint(equalToConstant: profileImageWidth).isActive = true
        profileImagePhotoView.heightAnchor.constraint(equalToConstant: profileImageWidth).isActive = true
        profileImagePhotoView.bottomAnchor.constraint(equalTo: profileImageContainerView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        profileLabelContainerView.addSubview(pickCntTitleLabel)
        pickCntTitleLabel.topAnchor.constraint(equalTo: profileLabelContainerView.topAnchor).isActive = true
        pickCntTitleLabel.leadingAnchor.constraint(equalTo: profileLabelContainerView.leadingAnchor, constant: SPACE).isActive = true
        
        profileLabelContainerView.addSubview(pickCntLabel)
        pickCntLabel.topAnchor.constraint(equalTo: pickCntTitleLabel.bottomAnchor).isActive = true
        pickCntLabel.leadingAnchor.constraint(equalTo: profileLabelContainerView.leadingAnchor, constant: SPACE).isActive = true
        
        profileLabelContainerView.addSubview(followerCntTitleLabel)
        followerCntTitleLabel.topAnchor.constraint(equalTo: pickCntLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        followerCntTitleLabel.leadingAnchor.constraint(equalTo: profileLabelContainerView.leadingAnchor, constant: SPACE).isActive = true
        
        profileLabelContainerView.addSubview(followerCntLabel)
        followerCntLabel.topAnchor.constraint(equalTo: followerCntTitleLabel.bottomAnchor).isActive = true
        followerCntLabel.leadingAnchor.constraint(equalTo: profileLabelContainerView.leadingAnchor, constant: SPACE).isActive = true
        followerCntLabel.bottomAnchor.constraint(equalTo: profileLabelContainerView.bottomAnchor).isActive = true
        
        contentView.addSubview(profileLine)
        profileLine.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor).isActive = true
        profileLine.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        profileLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        var nextBottomAnchor: NSLayoutYAxisAnchor = profileLine.bottomAnchor
        if isAuthUser {
            
            // MARK: ConfigureView - Follow
            contentView.addSubview(followContainerView)
            followContainerView.topAnchor.constraint(equalTo: profileLine.bottomAnchor, constant: SPACE_XL).isActive = true
            followContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
            followContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            
            followContainerView.addSubview(followImageView)
            followImageView.leadingAnchor.constraint(equalTo: followContainerView.leadingAnchor).isActive = true
            followImageView.centerYAnchor.constraint(equalTo: followContainerView.centerYAnchor).isActive = true
            followImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
            followImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
            
            followContainerView.addSubview(followTitleLabel)
            followTitleLabel.topAnchor.constraint(equalTo: followContainerView.topAnchor).isActive = true
            followTitleLabel.leadingAnchor.constraint(equalTo: followImageView.trailingAnchor, constant: SPACE_XS).isActive = true
            followTitleLabel.bottomAnchor.constraint(equalTo: followContainerView.bottomAnchor).isActive = true
            
            followContainerView.addSubview(followingButton)
            followingButton.centerYAnchor.constraint(equalTo: followContainerView.centerYAnchor).isActive = true
            followingButton.trailingAnchor.constraint(equalTo: followContainerView.trailingAnchor).isActive = true
            
            followContainerView.addSubview(followerButton)
            followerButton.centerYAnchor.constraint(equalTo: followContainerView.centerYAnchor).isActive = true
            followerButton.trailingAnchor.constraint(equalTo: followingButton.leadingAnchor, constant: -SPACE_XS).isActive = true
            
            // MARK: ConfigureView - Like
            contentView.addSubview(likeContainerView)
            likeContainerView.topAnchor.constraint(equalTo: followContainerView.bottomAnchor, constant: SPACE_XL).isActive = true
            likeContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
            likeContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            
            likeContainerView.addSubview(likeImageView)
            likeImageView.leadingAnchor.constraint(equalTo: likeContainerView.leadingAnchor).isActive = true
            likeImageView.centerYAnchor.constraint(equalTo: likeContainerView.centerYAnchor).isActive = true
            likeImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
            likeImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
            
            likeContainerView.addSubview(likeTitleLabel)
            likeTitleLabel.topAnchor.constraint(equalTo: likeContainerView.topAnchor).isActive = true
            likeTitleLabel.leadingAnchor.constraint(equalTo: likeImageView.trailingAnchor, constant: SPACE_XS).isActive = true
            likeTitleLabel.bottomAnchor.constraint(equalTo: likeContainerView.bottomAnchor).isActive = true
            
            likeContainerView.addSubview(likePlaceButton)
            likePlaceButton.centerYAnchor.constraint(equalTo: likeContainerView.centerYAnchor).isActive = true
            likePlaceButton.trailingAnchor.constraint(equalTo: likeContainerView.trailingAnchor).isActive = true
            
            followContainerView.addSubview(likePickButton)
            likePickButton.centerYAnchor.constraint(equalTo: likeContainerView.centerYAnchor).isActive = true
            likePickButton.trailingAnchor.constraint(equalTo: likePlaceButton.leadingAnchor, constant: -SPACE_XS).isActive = true
            
            contentView.addSubview(followLikeLine)
            followLikeLine.topAnchor.constraint(equalTo: likeContainerView.bottomAnchor, constant: SPACE_XL).isActive = true
            followLikeLine.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
            followLikeLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            
            nextBottomAnchor = followLikeLine.bottomAnchor
        }
        
        // MARK: ConfigureView - Other
        contentView.addSubview(pickTitleView)
        pickTitleView.topAnchor.constraint(equalTo: nextBottomAnchor).isActive = true
        pickTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pickTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        if isAuthUser {
            pickTitleView.addSubview(addPickbutton)
            addPickbutton.trailingAnchor.constraint(equalTo: pickTitleView.containerView.trailingAnchor).isActive = true
            addPickbutton.centerYAnchor.constraint(equalTo: pickTitleView.label.centerYAnchor).isActive = true
            
        } else {
            pickTitleView.addSubview(followButton)
            followButton.trailingAnchor.constraint(equalTo: pickTitleView.containerView.trailingAnchor).isActive = true
            followButton.centerYAnchor.constraint(equalTo: pickTitleView.label.centerYAnchor).isActive = true
        }
        
        contentView.addSubview(pickContainerView)
        pickContainerView.topAnchor.constraint(equalTo: pickTitleView.bottomAnchor).isActive = true
        pickContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pickContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pickContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func getUser() {
        guard let uId = self.uId else { return }
        getUserReuqest.fetch(vc: self, paramDict: ["uId": String(uId)])
    }
    
    func getPicks() {
        guard let uId = self.uId else { return }
        getPicksRequest.fetch(vc: self, paramDict: ["uId": String(uId)])
    }
    
    func setNoPickView() {
        pickContainerView.addSubview(noPickContainerView)
        noPickContainerView.topAnchor.constraint(equalTo: pickContainerView.topAnchor).isActive = true
        noPickContainerView.centerXAnchor.constraint(equalTo: pickContainerView.centerXAnchor).isActive = true
        noPickContainerView.widthAnchor.constraint(equalTo: pickContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        noPickContainerView.bottomAnchor.constraint(equalTo: pickContainerView.bottomAnchor).isActive = true
        
        noPickContainerView.addSubview(noPickLabel)
        noPickLabel.topAnchor.constraint(equalTo: noPickContainerView.topAnchor, constant: SPACE_XXXXL).isActive = true
        noPickLabel.centerXAnchor.constraint(equalTo: noPickContainerView.centerXAnchor).isActive = true
        noPickLabel.bottomAnchor.constraint(equalTo: noPickContainerView.bottomAnchor, constant: -SPACE_XXXXL).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func settingTapped() {
        isOpenedChildVC = true
        let settingVC = SettingViewController()
        settingVC.authAccountVC = self
        settingVC.delegate = self
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func followerTapped() {
        isOpenedChildVC = true
        let searchUserTVC = SearchUserTableViewController()
        searchUserTVC.mode = "FOLLOWER"
        searchUserTVC.delegate = self
        navigationController?.pushViewController(searchUserTVC, animated: true)
    }
    
    @objc func followingTapped() {
        isOpenedChildVC = true
        let searchUserTVC = SearchUserTableViewController()
        searchUserTVC.mode = "FOLLOWING"
        searchUserTVC.delegate = self
        navigationController?.pushViewController(searchUserTVC, animated: true)
    }
    
    @objc func likePickTapped() {
        
    }
    
    @objc func likePlaceTapped() {
        isOpenedChildVC = true
        let searchPlaceVC = SearchPlaceViewController()
        searchPlaceVC.mode = "MY_LIKE_PLACE"
        searchPlaceVC.delegate = self
        navigationController?.pushViewController(searchPlaceVC, animated: true)
    }
    
    @objc func followTapped(sender: UIButton) {
        guard let uId = self.uId else { return }
        
        var cnt = 0
        if let followerCntText = followerCntLabel.text {
            if let followerCnt = Int(followerCntText) {
                cnt = followerCnt
            }
        }
        
        if sender.tag == 1 {
            cnt += 1
            followButton.setTitle("팔로우 취소", for: UIControl.State.normal)
            followButton.tag = 2
            
        } else {
            cnt -= 1
            followButton.setTitle("팔로우", for: UIControl.State.normal)
            followButton.tag = 1
        }
        
        followerCntLabel.text = String(cnt)
        
        followRequest.fetch(vc: self, paramDict: ["uId": String(uId)])
    }
    
    @objc func addPickTapped() {
        isOpenedChildVC = true
        let postingVC = PostingViewController()
        postingVC.authAccountVC = self
        postingVC.delegate = self
        navigationController?.pushViewController(postingVC, animated: true)
    }
    
    @objc func profileImageTapped() {
        isOpenedChildVC = true
        let photoVC = PhotoViewController()
        photoVC.image = profileImagePhotoView.image
        if let nickName = navigationItem.title {
            photoVC.navigationItem.title = "\(nickName)님의 사진"
        }
        photoVC.delegate = self
        navigationController?.pushViewController(photoVC, animated: true)
    }
}


// MARK: Extension - GetPicks
extension AccountViewController: GetPicksRequestProtocol {
    func response(pickList: [Pick]?, getPicks status: String) {
        if status == "OK" {
            if let pickList = pickList {
                pickContainerView.removeAllChildView()
                
                if pickList.count > 0 {
                    var _pickList: [Pick] = []
                    for (i, pick) in pickList.enumerated() {
                        let index = i + 1
                        _pickList.append(pick)
                        
                        if _pickList.count == 3 { // 3개가 쌓였을때
                            let pgv = PhotoGroupView()
                            pgv.pickList = _pickList
                            pgv.delegate = self
    
                            pickContainerView.addSubview(pgv)
                            pgv.leadingAnchor.constraint(equalTo: pickContainerView.leadingAnchor).isActive = true
                            pgv.trailingAnchor.constraint(equalTo: pickContainerView.trailingAnchor).isActive = true
                            
                            if index / 3 == 1 { // 첫번째 pgv
                                pgv.topAnchor.constraint(equalTo: pickContainerView.topAnchor).isActive = true
                            } else { // 그 이후 pgv
                                pgv.topAnchor.constraint(equalTo: pickContainerView.subviews[pickContainerView.subviews.count - 2].bottomAnchor, constant: 1).isActive = true
                            }
                            
                            _pickList = []
                        }
                        
                        if index == pickList.count { // 마지막 픽
                            if _pickList.count > 0 { // 쌓아둔 픽이 있다면
                                let pgv = PhotoGroupView()
                                pgv.pickList = _pickList
                                pgv.delegate = self
                                pickContainerView.addSubview(pgv)
                                pgv.leadingAnchor.constraint(equalTo: pickContainerView.leadingAnchor).isActive = true
                                pgv.trailingAnchor.constraint(equalTo: pickContainerView.trailingAnchor).isActive = true
                                pgv.topAnchor.constraint(equalTo: pickContainerView.subviews[pickContainerView.subviews.count - 2].bottomAnchor, constant: 1).isActive = true
                                pgv.bottomAnchor.constraint(equalTo: pickContainerView.bottomAnchor).isActive = true
                                
                            } else { // 없다면 마지막 pgv bottom cons 잡아주기
                                pickContainerView.subviews[pickContainerView.subviews.count - 1].bottomAnchor.constraint(equalTo: pickContainerView.bottomAnchor).isActive = true
                            }
                        }
                    }
                    
                } else {
                    setNoPickView()
                }
            }
        }
    }
}

// MARK: Extension - Setting
extension AccountViewController: SettingViewControllerProtocol {
    func closeSettingVC() {
        isOpenedChildVC = false
    }
}

// MARK: Extension - GetUser
extension AccountViewController: GetUserRequestProtocol {
    func response(user: User?, getUser status: String) {
        if status == "OK" {
            if let user = user {
                navigationItem.title = user.nickName
                
                profileImagePhotoView.setProfileImage(uId: user.id, profileImage: user.profileImage)
                
                followerCntLabel.text = String(user.followerCnt)
                pickCntLabel.text = String(user.pickCnt)
                
                let isFollow = user.isFollow ?? "N"
                if isFollow == "Y" {
                    followButton.setTitle("팔로우 취소", for: UIControl.State.normal)
                    followButton.tag = 2
                } else {
                    followButton.setTitle("팔로우", for: UIControl.State.normal)
                    followButton.tag = 1
                }
            }
        }
    }
}

// MARK: Extension - PhotoGroupView
extension AccountViewController: PhotoGroupViewProtocol {
    func openPick(pick: Pick) {
        print("openPick", pick.id)
    }
}

// MARK: Extension - PostingVCProtocol
extension AccountViewController: PostingViewControllerProtocol {
    func closePostingVC(isUploaded: Bool) {
        isOpenedChildVC = false
    }
}

// MARK: Extension - SearchUserTVCProtocol {
extension AccountViewController: SearchUserTableViewControllerProtocol {
    func closeSearchUserTVC() {
        isOpenedChildVC = false
    }
}

// MARK: Extension - FollowRequest
extension AccountViewController: FollowRequestProtocol {
    func response(follow status: String) {
        if status == "OK" {
            delegate?.follow()
        }
    }
}

// MARK: Extension - SearchPlaceVC
extension AccountViewController: SearchPlaceViewControllerProtocol {
    func closeSearchPlaceVC(place: Place?) {
        isOpenedChildVC = false
    }
}

// MARK: Extension - PhotoVC
extension AccountViewController: PhotoViewControllerProtocol {
    func closePhotoViewVC() {
        isOpenedChildVC = false
    }
}
