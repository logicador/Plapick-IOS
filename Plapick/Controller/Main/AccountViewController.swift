//
//  AccountViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit
import SDWebImage


protocol AccountViewControllerProtocol {
//    func follow(user: User)
    func follow()
}


class AccountViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var delegate: AccountViewControllerProtocol?
    let getPicksRequest = GetPicksRequest()
    let followRequest = FollowRequest()
    let getUserRequest = GetUserRequest()
    var user: User? {
        didSet {
            guard let user = self.user else { return }
            
            profileImageView.setProfileImage(uId: user.id, profileImage: user.profileImage ?? "")
            nickNameLabel.text = user.nickName
            pickCntLabel.text = "\(String(user.pickCnt))개"
            followerCntLabel.text = String(user.followerCnt)
            followingCntLabel.text = String(user.followingCnt)
            likePickCntLabel.text = String(user.likePickCnt)
            likePlaceCntLabel.text = String(user.likePlaceCnt)
        }
    }
    var isFollow = "N" {
        didSet {
            navigationItem.rightBarButtonItem = (isFollow == "Y") ? UIBarButtonItem(title: "팔로우 취소", style: .plain, target: self, action: #selector(followTapped)) : UIBarButtonItem(title: "팔로우", style: .plain, target: self, action: #selector(followTapped))
            navigationItem.rightBarButtonItem?.tintColor = (isFollow == "Y") ? .systemRed : .systemBlue
        }
    }
    var isEnded = false
    var isLoading = false
    var page = 1
    
    
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
        sv.spacing = SPACE_L
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Profile
    lazy var profileContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray6
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
        iv.layer.cornerRadius = SCREEN_WIDTH * (1 / 8)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var profileLabelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var pickCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "게시한 픽"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var pickCntLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var profileBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Cnt
    lazy var cntContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var cntCenterLine: LineView = {
        let lv = LineView(orientation: .vertical)
        return lv
    }()
    
    // MARK: View - Cnt - Like
    lazy var likeCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아요"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var likePlaceCntContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likePlaceCntTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var likePlaceCntLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var likePlaceCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "플레이스"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var likePickCntContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likePickCntTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var likePickCntLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var likePickCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "픽"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Cnt - Follow
    lazy var followingCntContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followingCntTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var followingCntLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followingCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로잉"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var followerCntContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followerCntTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var followerCntLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followerCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로워"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Pick
    lazy var pickStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 1
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var noPickContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noPickTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var noPickLabel: UILabel = {
        let label = UILabel()
        label.text = "게시된 픽이 없습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "사용자"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        getPicksRequest.delegate = self
        followRequest.delegate = self
        getUserRequest.delegate = self
        
        getPicks()
    }
    
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUser()
//        guard let user = self.user else { return }
//        getUserRequest.fetch(vc: self, paramDict: ["uId": String(user.id)])
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_L).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Profile
        stackView.addArrangedSubview(profileContainerView)
        profileContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        profileContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true

        profileContainerView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: profileContainerView.topAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH * (1 / 4)).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH * (1 / 4)).isActive = true
        
        profileContainerView.addSubview(profileLabelContainerView)
        profileLabelContainerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: SPACE_L).isActive = true
        profileLabelContainerView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        profileLabelContainerView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor).isActive = true
        
        profileLabelContainerView.addSubview(nickNameLabel)
        nickNameLabel.topAnchor.constraint(equalTo: profileLabelContainerView.topAnchor).isActive = true
        nickNameLabel.leadingAnchor.constraint(equalTo: profileLabelContainerView.leadingAnchor).isActive = true
        
        profileLabelContainerView.addSubview(pickCntTitleLabel)
        pickCntTitleLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        pickCntTitleLabel.leadingAnchor.constraint(equalTo: profileLabelContainerView.leadingAnchor).isActive = true
        
        profileLabelContainerView.addSubview(pickCntLabel)
        pickCntLabel.topAnchor.constraint(equalTo: pickCntTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        pickCntLabel.leadingAnchor.constraint(equalTo: profileLabelContainerView.leadingAnchor).isActive = true
        pickCntLabel.bottomAnchor.constraint(equalTo: profileLabelContainerView.bottomAnchor).isActive = true
        
        profileContainerView.addSubview(profileBottomLine)
        profileBottomLine.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: SPACE_L).isActive = true
        profileBottomLine.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor).isActive = true
        profileBottomLine.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor).isActive = true
        profileBottomLine.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Cnt
        stackView.addArrangedSubview(cntContainerView)
        cntContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        cntContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        cntContainerView.addSubview(cntCenterLine)
        cntCenterLine.centerXAnchor.constraint(equalTo: cntContainerView.centerXAnchor).isActive = true
        cntCenterLine.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        cntCenterLine.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Cnt - Like
        cntContainerView.addSubview(likeCntTitleLabel)
        likeCntTitleLabel.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        likeCntTitleLabel.trailingAnchor.constraint(equalTo: cntContainerView.trailingAnchor).isActive = true
        likeCntTitleLabel.widthAnchor.constraint(equalTo: cntContainerView.widthAnchor, multiplier: 0.5).isActive = true
        
        cntContainerView.addSubview(likePlaceCntContainerView)
        likePlaceCntContainerView.topAnchor.constraint(equalTo: likeCntTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        likePlaceCntContainerView.trailingAnchor.constraint(equalTo: cntContainerView.trailingAnchor).isActive = true
        likePlaceCntContainerView.widthAnchor.constraint(equalTo: cntContainerView.widthAnchor, multiplier: 1 / 4).isActive = true
        likePlaceCntContainerView.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        
        likePlaceCntContainerView.addSubview(likePlaceCntLabel)
        likePlaceCntLabel.topAnchor.constraint(equalTo: likePlaceCntContainerView.topAnchor).isActive = true
        likePlaceCntLabel.centerXAnchor.constraint(equalTo: likePlaceCntContainerView.centerXAnchor).isActive = true

        likePlaceCntContainerView.addSubview(likePlaceCntTitleLabel)
        likePlaceCntTitleLabel.topAnchor.constraint(equalTo: likePlaceCntLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        likePlaceCntTitleLabel.centerXAnchor.constraint(equalTo: likePlaceCntContainerView.centerXAnchor).isActive = true
        likePlaceCntTitleLabel.bottomAnchor.constraint(equalTo: likePlaceCntContainerView.bottomAnchor).isActive = true
        
        cntContainerView.addSubview(likePickCntContainerView)
        likePickCntContainerView.centerYAnchor.constraint(equalTo: likePlaceCntContainerView.centerYAnchor).isActive = true
        likePickCntContainerView.trailingAnchor.constraint(equalTo: likePlaceCntContainerView.leadingAnchor).isActive = true
        likePickCntContainerView.widthAnchor.constraint(equalTo: cntContainerView.widthAnchor, multiplier: 1 / 4).isActive = true
        
        likePickCntContainerView.addSubview(likePickCntLabel)
        likePickCntLabel.topAnchor.constraint(equalTo: likePickCntContainerView.topAnchor).isActive = true
        likePickCntLabel.centerXAnchor.constraint(equalTo: likePickCntContainerView.centerXAnchor).isActive = true

        likePickCntContainerView.addSubview(likePickCntTitleLabel)
        likePickCntTitleLabel.topAnchor.constraint(equalTo: likePickCntLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        likePickCntTitleLabel.centerXAnchor.constraint(equalTo: likePickCntContainerView.centerXAnchor).isActive = true
        likePickCntTitleLabel.bottomAnchor.constraint(equalTo: likePickCntContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Cnt - Follow
        cntContainerView.addSubview(followingCntContainerView)
        followingCntContainerView.centerYAnchor.constraint(equalTo: likePlaceCntContainerView.centerYAnchor).isActive = true
        followingCntContainerView.trailingAnchor.constraint(equalTo: likePickCntContainerView.leadingAnchor).isActive = true
        followingCntContainerView.widthAnchor.constraint(equalTo: cntContainerView.widthAnchor, multiplier: 1 / 4).isActive = true
        
        followingCntContainerView.addSubview(followingCntLabel)
        followingCntLabel.topAnchor.constraint(equalTo: followingCntContainerView.topAnchor).isActive = true
        followingCntLabel.centerXAnchor.constraint(equalTo: followingCntContainerView.centerXAnchor).isActive = true

        followingCntContainerView.addSubview(followingCntTitleLabel)
        followingCntTitleLabel.topAnchor.constraint(equalTo: followingCntLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        followingCntTitleLabel.centerXAnchor.constraint(equalTo: followingCntContainerView.centerXAnchor).isActive = true
        followingCntTitleLabel.bottomAnchor.constraint(equalTo: followingCntContainerView.bottomAnchor).isActive = true
        
        cntContainerView.addSubview(followerCntContainerView)
        followerCntContainerView.centerYAnchor.constraint(equalTo: likePlaceCntContainerView.centerYAnchor).isActive = true
        followerCntContainerView.trailingAnchor.constraint(equalTo: followingCntContainerView.leadingAnchor).isActive = true
        followerCntContainerView.widthAnchor.constraint(equalTo: cntContainerView.widthAnchor, multiplier: 1 / 4).isActive = true
        
        followerCntContainerView.addSubview(followerCntLabel)
        followerCntLabel.topAnchor.constraint(equalTo: followerCntContainerView.topAnchor).isActive = true
        followerCntLabel.centerXAnchor.constraint(equalTo: followerCntContainerView.centerXAnchor).isActive = true

        followerCntContainerView.addSubview(followerCntTitleLabel)
        followerCntTitleLabel.topAnchor.constraint(equalTo: followerCntLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        followerCntTitleLabel.centerXAnchor.constraint(equalTo: followerCntContainerView.centerXAnchor).isActive = true
        followerCntTitleLabel.bottomAnchor.constraint(equalTo: followerCntContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Pick
        stackView.addArrangedSubview(pickStackView)
        pickStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        pickStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        pickStackView.addArrangedSubview(noPickContainerView)
        noPickContainerView.centerXAnchor.constraint(equalTo: pickStackView.centerXAnchor).isActive = true
        noPickContainerView.widthAnchor.constraint(equalTo: pickStackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        noPickContainerView.addSubview(noPickTopLine)
        noPickTopLine.topAnchor.constraint(equalTo: noPickContainerView.topAnchor).isActive = true
        noPickTopLine.leadingAnchor.constraint(equalTo: noPickContainerView.leadingAnchor).isActive = true
        noPickTopLine.trailingAnchor.constraint(equalTo: noPickContainerView.trailingAnchor).isActive = true
        
        noPickContainerView.addSubview(noPickLabel)
        noPickLabel.topAnchor.constraint(equalTo: noPickTopLine.bottomAnchor, constant: SPACE_XL).isActive = true
        noPickLabel.centerXAnchor.constraint(equalTo: noPickContainerView.centerXAnchor).isActive = true
        noPickLabel.bottomAnchor.constraint(equalTo: noPickContainerView.bottomAnchor, constant: -SPACE_XL).isActive = true
    }
    
    func getPicks() {
        guard let user = self.user else { return }
        isLoading = true
        getPicksRequest.fetch(vc: self, paramDict: ["uId": String(user.id), "page": String(page), "limit": "30"])
    }
    
    func getUser() {
        guard let user = self.user else { return }
        getUserRequest.fetch(vc: self, paramDict: ["uId": String(user.id)])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isLoading && !isEnded {
                page += 1
                getPicks()
            }
        }
    }
    
    // MARK: Function - @OBJC
    @objc func likePlaceCntTapped() {
        guard let user = self.user else { return }
        
        let searchPlaceVC = SearchPlaceViewController()
        searchPlaceVC.user = user
        searchPlaceVC.mode = "LIKE_PLACE"
        navigationController?.pushViewController(searchPlaceVC, animated: true)
    }
    
    @objc func likePickCntTapped() {
        
    }
    
    @objc func followerCntTapped() {
        guard let user = self.user else { return }
        
        let searchUserVC = SearchUserViewController()
        searchUserVC.user = user
        searchUserVC.mode = "FOLLOWER"
        navigationController?.pushViewController(searchUserVC, animated: true)
    }
    
    @objc func followingCntTapped() {
        guard let user = self.user else { return }
        
        let searchUserVC = SearchUserViewController()
        searchUserVC.user = user
        searchUserVC.mode = "FOLLOWING"
        navigationController?.pushViewController(searchUserVC, animated: true)
    }
    
    @objc func followTapped() {
        guard let user = self.user else { return }
        let followText = (isFollow == "Y") ? "팔로우 취소" : "팔로우"

        let alert = UIAlertController(title: nil, message: "해당 사용자를\n\"\(followText)\"\n하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
        alert.addAction(UIAlertAction(title: followText, style: (isFollow == "Y") ? .destructive : .default, handler: { (_) in
            self.followRequest.fetch(vc: self, paramDict: ["uId": String(user.id)])
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func profileImageTapped() {
        guard let user = self.user else { return }
        let photoVC = PhotoViewController()
        photoVC.image = profileImageView.image
        photoVC.navigationItem.title = "\(user.nickName)님의 사진"
        navigationController?.pushViewController(photoVC, animated: true)
    }
}

// MARK: PhotoGroupView
extension AccountViewController: PhotoGroupViewProtocol {
    func detailPick(pick: Pick) {
        guard let user = self.user else { return }
        
        let pickVC = PickViewController()
        pickVC.navigationItem.title = "\(user.nickName)님의 픽"
        pickVC.userContainerView.isHidden = true
//        pickVC.placeTopLine.isHidden = true
        pickVC.uId = user.id
        pickVC.id = pick.id
        navigationController?.pushViewController(pickVC, animated: true)
    }
}

// MARK: HTTP - GetPicks
extension AccountViewController: GetPicksRequestProtocol {
    func response(pickList: [Pick]?, getPicks status: String) {
        print("[HTTP RES]", getPicksRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pickList = pickList else { return }
            
            if pickList.count > 0 {
                isEnded = false
                noPickContainerView.isHidden = true
                
                var _pickList: [Pick] = []
                for (i, pick) in pickList.enumerated() {
                    _pickList.append(pick)
                    if ((i + 1) % 3 == 0 || ((i + 1) == pickList.count && _pickList.count > 0)) {
                        let pgv = PhotoGroupView() // 은영이 의견 수렴
//                        let pgv = PhotoGroupView(direction: ((i + 1) == pickList.count && _pickList.count > 0) ? 0 : .random(in: 0...2))
                        pgv.pickList = _pickList
                        pgv.delegate = self
                        
                        pickStackView.addArrangedSubview(pgv)
                        pgv.leadingAnchor.constraint(equalTo: pickStackView.leadingAnchor).isActive = true
                        pgv.trailingAnchor.constraint(equalTo: pickStackView.trailingAnchor).isActive = true
                        _pickList.removeAll()
                    }
                }
                
            } else {
                isEnded = true
                if pickStackView.subviews.count == 1 { noPickContainerView.isHidden = false }
            }
        }
        isLoading = false
    }
}

// MARK: HTTP - Follow
extension AccountViewController: FollowRequestProtocol {
    func response(follow status: String) {
        print("[HTTP RES]", followRequest.apiUrl, status)

        if status == "OK" {
            isFollow = (isFollow == "Y") ? "N" : "Y"
            user?.isFollow = isFollow

//            guard let user = self.user else { return }
//            delegate?.follow(user: user)
            delegate?.follow()
            getUser()
//            getUserRequest.fetch(vc: self, paramDict: ["uId": String(user.id)])
        }
    }
}

// MARK: HTTP - GetUser
extension AccountViewController: GetUserRequestProtocol {
    func response(user: User?, getUser status: String) {
        print("[HTTP RES]", getUserRequest.apiUrl, status)
        
        if status == "OK" {
            guard let user = user else { return }
            
            profileImageView.setProfileImage(uId: user.id, profileImage: user.profileImage ?? "")
            nickNameLabel.text = user.nickName
            pickCntLabel.text = "\(String(user.pickCnt))개"
            followerCntLabel.text = String(user.followerCnt)
            followingCntLabel.text = String(user.followingCnt)
            likePickCntLabel.text = String(user.likePickCnt)
            likePlaceCntLabel.text = String(user.likePlaceCnt)
            
            if user.id != app.getUId() {
                isFollow = user.isFollow
                app.addRecentUser(user: user)
            }
        }
    }
}
