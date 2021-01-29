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
    func changeNewsUser()
}


class AccountViewController: UIViewController {
    
    // MARK: Property
    var delegate: AccountViewControllerProtocol?
    var app = App()
    var uId: Int?
    let getPicksRequest = GetPicksRequest()
    let getUserReuqest = GetUserRequest()
    let profileImageWidth = SCREEN_WIDTH * (1 / 4)
//    var postingVC = PostingViewController()
//    var settingVC = SettingViewController()
    var isOpenedChildVC: Bool = false
    var photoGroupViewList: [PhotoGroupView] = []
    let newsUserRequest = NewsUserRequest()
    
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
    lazy var profileImagePhotoView: PhotoView = {
        let pv = PhotoView()
        pv.layer.borderWidth = 2
        pv.layer.cornerRadius = profileImageWidth / 2
        return pv
    }()
    lazy var labelContainerView: UIView = {
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
    lazy var newsCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "소식을 듣는 사람"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var newsCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Cnt(AuthUser)
    lazy var cntContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var newsButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(newsTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var myNewsButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(myNewsTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var myLikePickButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(myLikePickTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var myLikePlaceButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(myLikePlaceTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Other
    lazy var pickTitleView: TitleView = {
        let tv = TitleView(text: "게시한 픽")
        return tv
    }()
    lazy var doNewsButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = SPACE_S
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XXS, left: SPACE_S, bottom: SPACE_XXS, right: SPACE_S)
        button.addTarget(self, action: #selector(doNewsTapped), for: UIControl.Event.touchUpInside)
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
    
    // 소식듣기 카운트 (newsCnt)
    // 픽 개수 (pickCnt, getpicks으로 가져와짐)
    // 픽 (지역별로 모아보기+필터)
    
    // 내가 소식듣기 (auth, myNewsCnt)
    // 내가 좋아요 픽 (auth, myLikePickCnt) (지역별로 모아보기+필터)
    // 내가 좋아요 플레이스 (auth, myLikePlaceCnt) (지역별로 모아보기+필터)
    
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
        
        view.backgroundColor = .systemBackground
        
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
        
//        settingVC.delegate = self
//        settingVC.accountVC = self
        
//        postingVC.delegate = self
        
        getPicksRequest.delegate = self
        getUserReuqest.delegate = self
        newsUserRequest.delegate = self
    }
    
    
//    // MARK: ViewWillAppear
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let navHeight = navigationController?.navigationBar.frame.height ?? SPACE_XXXL
//        scrollView.setContentOffset(CGPoint(x: 0, y: -navHeight), animated: false)
//    }
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let uId = self.uId else { return }
        getUserReuqest.fetch(vc: self, paramDict: ["uId": String(uId)])
        getPicksRequest.fetch(vc: self, paramDict: ["uId": String(uId)])
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
            profileImagePhotoView.layer.borderColor = UIColor.systemGray3.cgColor
        } else {
            view.backgroundColor = .white
            profileImagePhotoView.layer.borderColor = UIColor.systemGray3.cgColor
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
        profileContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SPACE_XL).isActive = true
        profileContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        profileContainerView.addSubview(profileImagePhotoView)
        profileImagePhotoView.topAnchor.constraint(equalTo: profileContainerView.topAnchor).isActive = true
        profileImagePhotoView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor).isActive = true
        profileImagePhotoView.widthAnchor.constraint(equalToConstant: profileImageWidth).isActive = true
        profileImagePhotoView.heightAnchor.constraint(equalToConstant: profileImageWidth).isActive = true
        profileImagePhotoView.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor).isActive = true
        
        profileContainerView.addSubview(labelContainerView)
        labelContainerView.leadingAnchor.constraint(equalTo: profileImagePhotoView.trailingAnchor, constant: SPACE_XL).isActive = true
        labelContainerView.centerYAnchor.constraint(equalTo: profileImagePhotoView.centerYAnchor).isActive = true
        labelContainerView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor).isActive = true
        
        labelContainerView.addSubview(pickCntTitleLabel)
        pickCntTitleLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor).isActive = true
        pickCntTitleLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        
        labelContainerView.addSubview(pickCntLabel)
        pickCntLabel.topAnchor.constraint(equalTo: pickCntTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        pickCntLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        
        labelContainerView.addSubview(newsCntTitleLabel)
        newsCntTitleLabel.topAnchor.constraint(equalTo: pickCntLabel.bottomAnchor, constant: SPACE_S).isActive = true
        newsCntTitleLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        newsCntTitleLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor).isActive = true
        
        labelContainerView.addSubview(newsCntLabel)
        newsCntLabel.topAnchor.constraint(equalTo: newsCntTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        newsCntLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        newsCntLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Cnt(AuthUser)
        var nextBottomCons: NSLayoutYAxisAnchor = profileContainerView.bottomAnchor
        if isAuthUser {
            contentView.addSubview(cntContainerView)
            cntContainerView.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: SPACE_XL).isActive = true
            cntContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            cntContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
            
            cntContainerView.addSubview(newsButton)
            newsButton.topAnchor.constraint(equalTo: cntContainerView.topAnchor, constant: SPACE_XS).isActive = true
            newsButton.leadingAnchor.constraint(equalTo: cntContainerView.leadingAnchor).isActive = true
            newsButton.trailingAnchor.constraint(equalTo: cntContainerView.trailingAnchor).isActive = true
            
            cntContainerView.addSubview(myNewsButton)
            myNewsButton.topAnchor.constraint(equalTo: newsButton.bottomAnchor, constant: SPACE_XS).isActive = true
            myNewsButton.leadingAnchor.constraint(equalTo: cntContainerView.leadingAnchor).isActive = true
            myNewsButton.trailingAnchor.constraint(equalTo: cntContainerView.trailingAnchor).isActive = true
            
            cntContainerView.addSubview(myLikePickButton)
            myLikePickButton.topAnchor.constraint(equalTo: myNewsButton.bottomAnchor, constant: SPACE_XS).isActive = true
            myLikePickButton.leadingAnchor.constraint(equalTo: cntContainerView.leadingAnchor).isActive = true
            myLikePickButton.trailingAnchor.constraint(equalTo: cntContainerView.trailingAnchor).isActive = true
            
            cntContainerView.addSubview(myLikePlaceButton)
            myLikePlaceButton.topAnchor.constraint(equalTo: myLikePickButton.bottomAnchor, constant: SPACE_XS).isActive = true
            myLikePlaceButton.leadingAnchor.constraint(equalTo: cntContainerView.leadingAnchor).isActive = true
            myLikePlaceButton.trailingAnchor.constraint(equalTo: cntContainerView.trailingAnchor).isActive = true
            myLikePlaceButton.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
            
            nextBottomCons = cntContainerView.bottomAnchor
        }
        
        // MARK: ConfigureView - Other
        contentView.addSubview(pickTitleView)
        pickTitleView.topAnchor.constraint(equalTo: nextBottomCons).isActive = true
        pickTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pickTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        if isAuthUser {
            pickTitleView.addSubview(addPickbutton)
            addPickbutton.trailingAnchor.constraint(equalTo: pickTitleView.containerView.trailingAnchor).isActive = true
            addPickbutton.centerYAnchor.constraint(equalTo: pickTitleView.label.centerYAnchor).isActive = true
            
        } else {
            pickTitleView.addSubview(doNewsButton)
            doNewsButton.trailingAnchor.constraint(equalTo: pickTitleView.containerView.trailingAnchor).isActive = true
            doNewsButton.centerYAnchor.constraint(equalTo: pickTitleView.label.centerYAnchor).isActive = true
        }
        
        contentView.addSubview(pickContainerView)
        pickContainerView.topAnchor.constraint(equalTo: pickTitleView.bottomAnchor).isActive = true
        pickContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pickContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pickContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
//    func getUser() {
//        guard let uId = self.uId else { return }
//        getUserReuqest.fetch(vc: self, paramDict: ["uId": String(uId)])
//    }
//    
//    func getPicks() {
//        guard let uId = self.uId else { return }
//        getPicksRequest.fetch(vc: self, paramDict: ["uId": String(uId)])
//    }
    
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
//        settingVC.authAccountVC = self
        settingVC.delegate = self
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func newsTapped() {
        isOpenedChildVC = true
        let searchUserTVC = SearchUserTableViewController()
        searchUserTVC.mode = "NEWS"
        searchUserTVC.delegate = self
        navigationController?.pushViewController(searchUserTVC, animated: true)
    }
    
    @objc func myNewsTapped() {
        isOpenedChildVC = true
        let searchUserTVC = SearchUserTableViewController()
        searchUserTVC.mode = "MY_NEWS"
        searchUserTVC.delegate = self
        navigationController?.pushViewController(searchUserTVC, animated: true)
    }
    
    @objc func myLikePickTapped() {
        
    }
    
    @objc func myLikePlaceTapped() {
        isOpenedChildVC = true
        let searchPlaceVC = SearchPlaceViewController()
        searchPlaceVC.mode = "MY_LIKE_PLACE"
        searchPlaceVC.delegate = self
        navigationController?.pushViewController(searchPlaceVC, animated: true)
    }
    
    @objc func doNewsTapped(sender: UIButton) {
        guard let uId = self.uId else { return }
        
        if sender.tag == 1 { // do 소식듣기
            doNewsButton.setTitle("소식끊기", for: UIControl.State.normal)
            doNewsButton.tag = 2
        } else { // do 소식끊기
            doNewsButton.setTitle("소식듣기", for: UIControl.State.normal)
            doNewsButton.tag = 1
        }
        newsUserRequest.fetch(vc: self, paramDict: ["uId": String(uId)])
    }
    
    @objc func addPickTapped() {
        isOpenedChildVC = true
        let postingVC = PostingViewController()
        postingVC.delegate = self
        navigationController?.pushViewController(postingVC, animated: true)
    }
}


// MARK: Extension - GetPicks
extension AccountViewController: GetPicksRequestProtocol {
    func response(pickList: [Pick]?, getPicks status: String) {
        if status == "OK" {
            if let pickList = pickList {
                pickContainerView.removeAllChildView()
                pickCntLabel.text = String(pickList.count)
                
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
//        settingVC = nil
    }
}

// MARK: Extension - GetUser
extension AccountViewController: GetUserRequestProtocol {
    func response(user: User?, getUser status: String) {
        if status == "OK" {
            if let user = user {
                navigationItem.title = user.nickName
                if let url = URL(string: ((user.profileImage.contains(String(user.id))) ? (PLAPICK_URL + user.profileImage) : user.profileImage)) {
                    profileImagePhotoView.sd_setImage(with: url, completed: nil)
                }
                
                if let newsCnt = user.newsCnt {
                    newsCntLabel.text = String(newsCnt)
                    newsButton.setTitle("나의 소식을 듣는 사람들 (\(String(newsCnt)))", for: UIControl.State.normal)
                }
                if let myNewsCnt = user.myNewsCnt {
                    myNewsButton.setTitle("내가 소식듣는 사람들 (\(String(myNewsCnt)))", for: UIControl.State.normal)
                }
                if let myLikePickCnt = user.myLikePickCnt {
                    myLikePickButton.setTitle("좋아요한 픽 (\(String(myLikePickCnt)))", for: UIControl.State.normal)
                }
                if let myLikePlaceCnt = user.myLikePlaceCnt {
                    myLikePlaceButton.setTitle("좋아요한 플레이스 (\(String(myLikePlaceCnt)))", for: UIControl.State.normal)
                }
                
                // 소식듣기 / 소식듣기 취소
                let isNewsUser = user.isNewsUser ?? "N"
                if isNewsUser == "Y" {
                    doNewsButton.setTitle("소식끊기", for: UIControl.State.normal)
                    doNewsButton.tag = 2
                } else {
                    doNewsButton.setTitle("소식듣기", for: UIControl.State.normal)
                    doNewsButton.tag = 1
                }
            }
        }
    }
}

// MARK: Extension - PhotoGroupView
extension AccountViewController: PhotoGroupViewProtocol {
    func pickTapped(pick: Pick) {
        print("pickTapped", pick.id)
    }
}

// MARK: Extension - PostingVCProtocol
extension AccountViewController: PostingViewControllerProtocol {
    func closePostingVC(isUploaded: Bool) {
        isOpenedChildVC = false
//        if isUploaded {
////            postingVC = PostingViewController()
////            postingVC.delegate = self
//            getPicks()
//        }
    }
}

// MARK: Extension - SearchUserTVCProtocol {
extension AccountViewController: SearchUserTableViewControllerProtocol {
    func closeSearchUserTVC() {
        isOpenedChildVC = false
    }
}

// MARK: Extension - NewsUserRequest
extension AccountViewController: NewsUserRequestProtocol {
    func response(newsUser status: String) {
        if status == "OK" {
//            getUser()
            guard let uId = self.uId else { return }
            getUserReuqest.fetch(vc: self, paramDict: ["uId": String(uId)])
            delegate?.changeNewsUser()
        }
    }
}

// MARK: Extension - SearchPlaceVC
extension AccountViewController: SearchPlaceViewControllerProtocol {
    func closeSearchPlaceVC(place: Place?) {
        isOpenedChildVC = false
    }
}
