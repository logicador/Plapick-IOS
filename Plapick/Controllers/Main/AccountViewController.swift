//
//  AccountViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class AccountViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    var postingViewController: PostingViewController?
    var getUserPicksRequest = GetUserPicksRequest()
    
    
    // MARK: Views
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
    
    // MARK: Profile
    lazy var profileContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 50
        iv.layer.borderWidth = 2
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var userNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profileTopLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Figure
    lazy var figureContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var figureTopLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Like
    lazy var likeCntView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeCntTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var likeCntWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var likeCntLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var likeCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아요"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Following
    lazy var followingCntView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followingCntTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var followingCntWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var followingCntLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followingCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로잉"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Follower
    lazy var followerCntView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followerCntTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var followerCntWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var followerCntLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followerCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로워"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followerLeftLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var followerRightLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: MyPick
    lazy var myPickTitleView: TitleView = {
        let tv = TitleView(titleText: "나의 픽", isAction: true, actionText: "추가", actionMode: "POSTING")
        tv.delegate = self
        return tv
    }()
    
    lazy var myPickContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var noPickView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var noPickLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 게시된 픽이 없습니다\n새로운 픽을 추가해주세요"
        label.textColor = .lightGray
        label.setLineSpacing(lineSpacing: 10)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var noPickBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "내 정보"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(setting))
        
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
        
        // MARK: Profile
        contentView.addSubview(profileContainerView)
        profileContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        profileContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        profileContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        profileContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        profileContainerView.addSubview(profileWrapperView)
        profileWrapperView.topAnchor.constraint(equalTo: profileContainerView.topAnchor, constant: 20).isActive = true
        profileWrapperView.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor).isActive = true
        
        profileWrapperView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: profileWrapperView.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: profileWrapperView.leadingAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: profileWrapperView.bottomAnchor).isActive = true
        
        profileWrapperView.addSubview(userNickNameLabel)
        userNickNameLabel.centerYAnchor.constraint(equalTo: profileWrapperView.centerYAnchor).isActive = true
        userNickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
        userNickNameLabel.trailingAnchor.constraint(equalTo: profileWrapperView.trailingAnchor).isActive = true
        
        contentView.addSubview(profileTopLineView)
        profileTopLineView.topAnchor.constraint(equalTo: profileContainerView.topAnchor).isActive = true
        profileTopLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileTopLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileTopLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        contentView.addSubview(profileBottomLineView)
        profileBottomLineView.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor).isActive = true
        profileBottomLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileBottomLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileBottomLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        // MARK: Figure
        profileContainerView.addSubview(figureContainerView)
        figureContainerView.topAnchor.constraint(equalTo: profileWrapperView.bottomAnchor, constant: 20).isActive = true
        figureContainerView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor).isActive = true
        figureContainerView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor).isActive = true
        figureContainerView.widthAnchor.constraint(equalTo: profileContainerView.widthAnchor).isActive = true
        figureContainerView.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor).isActive = true
        
        contentView.addSubview(figureTopLineView)
        figureTopLineView.topAnchor.constraint(equalTo: figureContainerView.topAnchor).isActive = true
        figureTopLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        figureTopLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        figureTopLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        // MARK: Like
        figureContainerView.addSubview(likeCntView)
        likeCntView.leadingAnchor.constraint(equalTo: figureContainerView.leadingAnchor).isActive = true
        likeCntView.widthAnchor.constraint(equalTo: figureContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        likeCntView.topAnchor.constraint(equalTo: figureContainerView.topAnchor).isActive = true
        likeCntView.bottomAnchor.constraint(equalTo: figureContainerView.bottomAnchor).isActive = true
        
        likeCntView.addSubview(likeCntWrapperView)
        likeCntWrapperView.topAnchor.constraint(equalTo: likeCntView.topAnchor, constant: 20).isActive = true
        likeCntWrapperView.leadingAnchor.constraint(equalTo: likeCntView.leadingAnchor).isActive = true
        likeCntWrapperView.trailingAnchor.constraint(equalTo: likeCntView.trailingAnchor).isActive = true
        likeCntWrapperView.widthAnchor.constraint(equalTo: likeCntView.widthAnchor).isActive = true
        likeCntWrapperView.bottomAnchor.constraint(equalTo: likeCntView.bottomAnchor, constant: -20).isActive = true
        
        likeCntWrapperView.addSubview(likeCntLabel)
        likeCntLabel.topAnchor.constraint(equalTo: likeCntWrapperView.topAnchor).isActive = true
        likeCntLabel.centerXAnchor.constraint(equalTo: likeCntWrapperView.centerXAnchor).isActive = true
        
        likeCntWrapperView.addSubview(likeCntTitleLabel)
        likeCntTitleLabel.topAnchor.constraint(equalTo: likeCntLabel.bottomAnchor, constant: 2).isActive = true
        likeCntTitleLabel.centerXAnchor.constraint(equalTo: likeCntWrapperView.centerXAnchor).isActive = true
        likeCntTitleLabel.bottomAnchor.constraint(equalTo: likeCntWrapperView.bottomAnchor).isActive = true
        
        // MARK: Following
        figureContainerView.addSubview(followingCntView)
        followingCntView.trailingAnchor.constraint(equalTo: figureContainerView.trailingAnchor).isActive = true
        followingCntView.widthAnchor.constraint(equalTo: figureContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        followingCntView.topAnchor.constraint(equalTo: figureContainerView.topAnchor).isActive = true
        followingCntView.bottomAnchor.constraint(equalTo: figureContainerView.bottomAnchor).isActive = true
        
        followingCntView.addSubview(followingCntWrapperView)
        followingCntWrapperView.topAnchor.constraint(equalTo: followingCntView.topAnchor, constant: 20).isActive = true
        followingCntWrapperView.leadingAnchor.constraint(equalTo: followingCntView.leadingAnchor).isActive = true
        followingCntWrapperView.trailingAnchor.constraint(equalTo: followingCntView.trailingAnchor).isActive = true
        followingCntWrapperView.widthAnchor.constraint(equalTo: followingCntView.widthAnchor).isActive = true
        followingCntWrapperView.bottomAnchor.constraint(equalTo: followingCntView.bottomAnchor, constant: -20).isActive = true
        
        followingCntWrapperView.addSubview(followingCntLabel)
        followingCntLabel.topAnchor.constraint(equalTo: followingCntWrapperView.topAnchor).isActive = true
        followingCntLabel.centerXAnchor.constraint(equalTo: followingCntWrapperView.centerXAnchor).isActive = true
        
        followingCntWrapperView.addSubview(followingCntTitleLabel)
        followingCntTitleLabel.topAnchor.constraint(equalTo: followingCntLabel.bottomAnchor, constant: 2).isActive = true
        followingCntTitleLabel.centerXAnchor.constraint(equalTo: followingCntWrapperView.centerXAnchor).isActive = true
        followingCntTitleLabel.bottomAnchor.constraint(equalTo: followingCntWrapperView.bottomAnchor).isActive = true
        
        // MARK: Follower
        figureContainerView.addSubview(followerCntView)
        followerCntView.leadingAnchor.constraint(equalTo: likeCntView.trailingAnchor).isActive = true
        followerCntView.trailingAnchor.constraint(equalTo: followingCntView.leadingAnchor).isActive = true
        followerCntView.topAnchor.constraint(equalTo: figureContainerView.topAnchor).isActive = true
        followerCntView.bottomAnchor.constraint(equalTo: figureContainerView.bottomAnchor).isActive = true
        
        followerCntView.addSubview(followerCntWrapperView)
        followerCntWrapperView.topAnchor.constraint(equalTo: followerCntView.topAnchor, constant: 20).isActive = true
        followerCntWrapperView.leadingAnchor.constraint(equalTo: followerCntView.leadingAnchor).isActive = true
        followerCntWrapperView.trailingAnchor.constraint(equalTo: followerCntView.trailingAnchor).isActive = true
        followerCntWrapperView.widthAnchor.constraint(equalTo: followerCntView.widthAnchor).isActive = true
        followerCntWrapperView.bottomAnchor.constraint(equalTo: followerCntView.bottomAnchor, constant: -20).isActive = true
        
        followerCntWrapperView.addSubview(followerCntLabel)
        followerCntLabel.topAnchor.constraint(equalTo: followerCntWrapperView.topAnchor).isActive = true
        followerCntLabel.centerXAnchor.constraint(equalTo: followerCntWrapperView.centerXAnchor).isActive = true
        
        followerCntWrapperView.addSubview(followerCntTitleLabel)
        followerCntTitleLabel.topAnchor.constraint(equalTo: followerCntLabel.bottomAnchor, constant: 2).isActive = true
        followerCntTitleLabel.centerXAnchor.constraint(equalTo: followerCntWrapperView.centerXAnchor).isActive = true
        followerCntTitleLabel.bottomAnchor.constraint(equalTo: followerCntWrapperView.bottomAnchor).isActive = true
        
        followerCntView.addSubview(followerLeftLineView)
        followerLeftLineView.widthAnchor.constraint(equalToConstant: 0.4).isActive = true
        followerLeftLineView.leadingAnchor.constraint(equalTo: followerCntView.leadingAnchor).isActive = true
        followerLeftLineView.heightAnchor.constraint(equalTo: followerCntView.heightAnchor, constant: -40).isActive = true
        followerLeftLineView.centerYAnchor.constraint(equalTo: followerCntView.centerYAnchor).isActive = true
        
        followerCntView.addSubview(followerRightLineView)
        followerRightLineView.widthAnchor.constraint(equalToConstant: 0.4).isActive = true
        followerRightLineView.trailingAnchor.constraint(equalTo: followerCntView.trailingAnchor).isActive = true
        followerRightLineView.heightAnchor.constraint(equalTo: followerCntView.heightAnchor, constant: -40).isActive = true
        followerRightLineView.centerYAnchor.constraint(equalTo: followerCntView.centerYAnchor).isActive = true
        
        // MARK: MyPick
        contentView.addSubview(myPickTitleView)
        myPickTitleView.topAnchor.constraint(equalTo: figureContainerView.bottomAnchor, constant: 20).isActive = true
        myPickTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        myPickTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        myPickTitleView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(myPickContainerView)
        myPickContainerView.topAnchor.constraint(equalTo: myPickTitleView.bottomAnchor).isActive = true
        myPickContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        myPickContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        myPickContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        myPickContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        adjustColors()
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        getUserPicksRequest.delegate = self
        
        getAccount()
        getMyPicks()
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .systemBackground
            profileContainerView.backgroundColor = .systemGray6
            profileImageView.backgroundColor = .systemBackground
            profileImageView.layer.borderColor = UIColor.systemBackground.cgColor
            figureContainerView.backgroundColor = .systemGray6
            noPickView.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .tertiarySystemGroupedBackground
            profileContainerView.backgroundColor = .systemBackground
            profileImageView.backgroundColor = .tertiarySystemGroupedBackground
            profileImageView.layer.borderColor = UIColor.tertiarySystemGroupedBackground.cgColor
            figureContainerView.backgroundColor = .systemBackground
            noPickView.backgroundColor = .systemBackground
        }
    }
    
    func getAccount() {
        let user = app.getUser()
        
        if user.profileImageUrl.isEmpty {
            profileImageView.image = nil
        } else {
            profileImageView.load(urlString: ((user.profileImageUrl.contains(String(user.id))) ? (PLAPICK_URL + user.profileImageUrl) : user.profileImageUrl))
        }
        userNickNameLabel.text = user.nickName
        likeCntLabel.text = String(user.likeCnt)
        followingCntLabel.text = String(user.followingCnt)
        followerCntLabel.text = String(user.followerCnt)
    }
    
    @objc func setting() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        let settingViewController = SettingTableViewController()
        settingViewController.accountViewController = self
        let navigationController = UINavigationController(rootViewController: settingViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func likeCntTapped() {
        print("likeCntTapped")
    }
    
    @objc func followingCntTapped() {
        print("followingCntTapped")
    }
    
    @objc func followerCntTapped() {
        print("followerCntTapped")
    }
    
    func getMyPicks() {
        self.myPickContainerView.removeAllChildView()
        getUserPicksRequest.fetch(vc: self, uId: app.getUser().id)
    }
    
    func setMyPickContainer(photoGroupViewList: [PhotoGroupView]) {
        for (i, photoGroupView) in photoGroupViewList.enumerated() {
            self.myPickContainerView.addSubview(photoGroupView)
            
            photoGroupView.widthAnchor.constraint(equalTo: self.myPickContainerView.widthAnchor).isActive = true
            photoGroupView.leadingAnchor.constraint(equalTo: self.myPickContainerView.leadingAnchor).isActive = true
            photoGroupView.trailingAnchor.constraint(equalTo: self.myPickContainerView.trailingAnchor).isActive = true
            
            if i == 0 {
                photoGroupView.topAnchor.constraint(equalTo: self.myPickContainerView.topAnchor).isActive = true
            } else {
                photoGroupView.topAnchor.constraint(equalTo: photoGroupViewList[i - 1].bottomAnchor, constant: 1).isActive = true
            }
            if i == photoGroupViewList.count - 1 {
                photoGroupView.bottomAnchor.constraint(equalTo: self.myPickContainerView.bottomAnchor).isActive = true
            }
        }
    }
}


// MARK: Extensions
extension AccountViewController: TitleViewProtocol {
    func actionTapped(actionMode: String) {
        postingViewController = PostingViewController()
        postingViewController?.delegate = self
        postingViewController?.accountViewController = self
        let navigationController = UINavigationController(rootViewController: postingViewController!)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}


extension AccountViewController: PhotoGroupViewProtocol {
    func photoTapped(pick: Pick) {
        let pickViewController = PickViewController()
        pickViewController.pick = pick
        let navigationController = UINavigationController(rootViewController: pickViewController)
        present(navigationController, animated: true, completion: nil)
    }
}


extension AccountViewController: PostingViewControllerProtocol {
    func closeViewController() {
//        getMyPicks()
        postingViewController?.dismiss(animated: true, completion: nil)
    }
}


extension AccountViewController: GetUserPicksRequestProtocol {
    func response(pickList: [Pick]?, status: String) {
        if status == "OK" {
            if let pickList = pickList {
                if pickList.count == 0 {
                    myPickContainerView.addSubview(noPickView)
                    noPickView.topAnchor.constraint(equalTo: myPickContainerView.topAnchor).isActive = true
                    noPickView.bottomAnchor.constraint(equalTo: myPickContainerView.bottomAnchor).isActive = true
                    noPickView.leadingAnchor.constraint(equalTo: myPickContainerView.leadingAnchor).isActive = true
                    noPickView.trailingAnchor.constraint(equalTo: myPickContainerView.trailingAnchor).isActive = true
                    noPickView.widthAnchor.constraint(equalTo: myPickContainerView.widthAnchor).isActive = true
                    
                    noPickView.addSubview(noPickLabel)
                    noPickLabel.topAnchor.constraint(equalTo: noPickView.topAnchor, constant: 40).isActive = true
                    noPickLabel.bottomAnchor.constraint(equalTo: noPickView.bottomAnchor, constant: -40).isActive = true
                    noPickLabel.centerXAnchor.constraint(equalTo: noPickView.centerXAnchor).isActive = true
                    
                    view.addSubview(noPickBottomLineView)
                    noPickBottomLineView.bottomAnchor.constraint(equalTo: myPickContainerView.bottomAnchor).isActive = true
                    noPickBottomLineView.leadingAnchor.constraint(equalTo: myPickContainerView.leadingAnchor).isActive = true
                    noPickBottomLineView.trailingAnchor.constraint(equalTo: myPickContainerView.trailingAnchor).isActive = true
                    noPickBottomLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
                    return
                }
                
                noPickBottomLineView.removeView()
                noPickLabel.removeView()
                noPickView.removeView()
                
                var photoGroupViewList: [PhotoGroupView] = []
                var _pickList: [Pick] = []
                for (i, pick) in pickList.enumerated() {
                    let index = i + 1
                    _pickList.append(pick)
                    
                    if index % 3 == 0 || index == pickList.count {
                        let photoGroupView = PhotoGroupView(isBackGround: false, pickList: _pickList)
                        photoGroupView.delegate = self
                        photoGroupViewList.append(photoGroupView)
                        _pickList = []
                    }
                }
                self.setMyPickContainer(photoGroupViewList: photoGroupViewList)
            }
        }
    }
}
