//
//  AccountViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit
import SDWebImage


class AccountViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let getUserRequest = GetUserRequest()
    
    let getPostsRequest = GetPostsRequest()
    var postsList: [Posts] = []
    var postsPage = 1
    var isPostsLoading = false
    var isPostsEnd = false
    
    let getPlacesRequest = GetPlacesRequest()
    var placeList: [Place] = []
    
    
    // MARK: View
    lazy var profileContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 35
        iv.layer.borderWidth = LINE_WIDTH
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var cntContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Cnt - Posts
    lazy var postsCntView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPostsTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var postsCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "게시물"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var postsCntLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Cnt - Place
    lazy var placeCntView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPlaceTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var placeCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "플레이스"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var placeCntLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Cnt - Follower
    lazy var followerCntView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followerCntTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var followerCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로워"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followerCntLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Cnt - Following
    lazy var followingCntView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followingCntTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var followingCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로잉"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followingCntLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Tab
    lazy var tabTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var tabContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tabBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Tab - Posts
    lazy var showPostsTabView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPostsTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var showPostsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var showPostsLabel: UILabel = {
        let label = UILabel()
        label.text = "게시물 모두보기"
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var showPostsImageView: UIImageView = {
        let image = UIImage(systemName: "square.grid.3x3.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Tab - Place
    lazy var showPlaceTabView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPlaceTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var showPlaceContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var showPlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "플레이스 모아보기"
        label.textColor = .systemGray3
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var showPlaceImageView: UIImageView = {
        let image = UIImage(systemName: "shippingbox.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - List
    lazy var postsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.register(PostsCVCell.self, forCellWithReuseIdentifier: "PostsCVCell")
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.refreshControl = UIRefreshControl()
        cv.refreshControl?.addTarget(self, action: #selector(postsRefreshed), for: .valueChanged)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    lazy var placeTableView: UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        tv.alpha = 0
        tv.register(PostsPlaceTVCell.self, forCellReuseIdentifier: "PostsPlaceTVCell")
        tv.separatorStyle = .none
        tv.tableFooterView = UIView(frame: .zero) // 빈 셀 안보이게
        tv.dataSource = self
        tv.delegate = self
        tv.refreshControl = UIRefreshControl()
        tv.refreshControl?.addTarget(self, action: #selector(placeRefreshed), for: .valueChanged)
        tv.alwaysBounceVertical = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(alarmTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(menuTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        getUserRequest.delegate = self
        getPostsRequest.delegate = self
        getPlacesRequest.delegate = self
        
        getPosts()
        getPlaces()
        
        navigationItem.title = app.getUserNickName()
        
        guard let url = URL(string: PLAPICK_URL + app.getUserProfileImage()) else { return }
        profileImageView.sd_setImage(with: url, completed: nil)
        
        postsCntLabel.text = String(app.getUserPostsCnt())
        placeCntLabel.text = String(app.getUserPlaceCnt())
        followerCntLabel.text = String(app.getUserFollowerCnt())
        followingCntLabel.text = String(app.getUserFollowingCnt())
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        profileImageView.layer.borderColor = UIColor.separator.cgColor
        
        postsCollectionView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        placeTableView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(profileContainerView)
        profileContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        profileContainerView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: profileContainerView.topAnchor, constant: SPACE).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        profileContainerView.addSubview(cntContainerView)
        cntContainerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: SCREEN_WIDTH * 0.06).isActive = true
        cntContainerView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor).isActive = true
        cntContainerView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        // MARK: ConfigureView - Cnt - Posts
        cntContainerView.addSubview(postsCntView)
        postsCntView.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        postsCntView.leadingAnchor.constraint(equalTo: cntContainerView.leadingAnchor).isActive = true
        postsCntView.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        
        postsCntView.addSubview(postsCntTitleLabel)
        postsCntTitleLabel.topAnchor.constraint(equalTo: postsCntView.topAnchor).isActive = true
        postsCntTitleLabel.leadingAnchor.constraint(equalTo: postsCntView.leadingAnchor).isActive = true
        postsCntTitleLabel.trailingAnchor.constraint(equalTo: postsCntView.trailingAnchor).isActive = true
        
        postsCntView.addSubview(postsCntLabel)
        postsCntLabel.topAnchor.constraint(equalTo: postsCntTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        postsCntLabel.centerXAnchor.constraint(equalTo: postsCntTitleLabel.centerXAnchor).isActive = true
        postsCntLabel.bottomAnchor.constraint(equalTo: postsCntView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Cnt - Place
        cntContainerView.addSubview(placeCntView)
        placeCntView.topAnchor.constraint(equalTo: postsCntView.topAnchor).isActive = true
        placeCntView.leadingAnchor.constraint(equalTo: postsCntView.trailingAnchor, constant: SCREEN_WIDTH * 0.06).isActive = true
        placeCntView.bottomAnchor.constraint(equalTo: postsCntView.bottomAnchor).isActive = true
        
        placeCntView.addSubview(placeCntTitleLabel)
        placeCntTitleLabel.topAnchor.constraint(equalTo: placeCntView.topAnchor).isActive = true
        placeCntTitleLabel.leadingAnchor.constraint(equalTo: placeCntView.leadingAnchor).isActive = true
        placeCntTitleLabel.trailingAnchor.constraint(equalTo: placeCntView.trailingAnchor).isActive = true
        
        placeCntView.addSubview(placeCntLabel)
        placeCntLabel.topAnchor.constraint(equalTo: placeCntTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        placeCntLabel.centerXAnchor.constraint(equalTo: placeCntTitleLabel.centerXAnchor).isActive = true
        placeCntLabel.bottomAnchor.constraint(equalTo: placeCntView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Cnt - Follower
        cntContainerView.addSubview(followerCntView)
        followerCntView.topAnchor.constraint(equalTo: postsCntView.topAnchor).isActive = true
        followerCntView.leadingAnchor.constraint(equalTo: placeCntView.trailingAnchor, constant: SCREEN_WIDTH * 0.06).isActive = true
        followerCntView.bottomAnchor.constraint(equalTo: postsCntView.bottomAnchor).isActive = true
        
        followerCntView.addSubview(followerCntTitleLabel)
        followerCntTitleLabel.topAnchor.constraint(equalTo: followerCntView.topAnchor).isActive = true
        followerCntTitleLabel.leadingAnchor.constraint(equalTo: followerCntView.leadingAnchor).isActive = true
        followerCntTitleLabel.trailingAnchor.constraint(equalTo: followerCntView.trailingAnchor).isActive = true
        
        followerCntView.addSubview(followerCntLabel)
        followerCntLabel.topAnchor.constraint(equalTo: followerCntTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        followerCntLabel.centerXAnchor.constraint(equalTo: followerCntTitleLabel.centerXAnchor).isActive = true
        followerCntLabel.bottomAnchor.constraint(equalTo: followerCntView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Cnt - Following
        cntContainerView.addSubview(followingCntView)
        followingCntView.topAnchor.constraint(equalTo: postsCntView.topAnchor).isActive = true
        followingCntView.leadingAnchor.constraint(equalTo: followerCntView.trailingAnchor, constant: SCREEN_WIDTH * 0.06).isActive = true
        followingCntView.trailingAnchor.constraint(equalTo: cntContainerView.trailingAnchor).isActive = true
        followingCntView.bottomAnchor.constraint(equalTo: postsCntView.bottomAnchor).isActive = true
        
        followingCntView.addSubview(followingCntTitleLabel)
        followingCntTitleLabel.topAnchor.constraint(equalTo: followingCntView.topAnchor).isActive = true
        followingCntTitleLabel.leadingAnchor.constraint(equalTo: followingCntView.leadingAnchor).isActive = true
        followingCntTitleLabel.trailingAnchor.constraint(equalTo: followingCntView.trailingAnchor).isActive = true
        
        followingCntView.addSubview(followingCntLabel)
        followingCntLabel.topAnchor.constraint(equalTo: followingCntTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        followingCntLabel.centerXAnchor.constraint(equalTo: followingCntTitleLabel.centerXAnchor).isActive = true
        followingCntLabel.bottomAnchor.constraint(equalTo: followingCntView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Tab
        view.addSubview(tabTopLine)
        tabTopLine.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor).isActive = true
        tabTopLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabTopLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tabContainerView)
        tabContainerView.topAnchor.constraint(equalTo: tabTopLine.bottomAnchor).isActive = true
        tabContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tabBottomLine)
        tabBottomLine.topAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        tabBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Tab - Posts
        tabContainerView.addSubview(showPostsTabView)
        showPostsTabView.topAnchor.constraint(equalTo: tabContainerView.topAnchor).isActive = true
        showPostsTabView.leadingAnchor.constraint(equalTo: tabContainerView.leadingAnchor).isActive = true
        showPostsTabView.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 0.5).isActive = true
        showPostsTabView.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        
        showPostsTabView.addSubview(showPostsContainerView)
        showPostsContainerView.topAnchor.constraint(equalTo: showPostsTabView.topAnchor).isActive = true
        showPostsContainerView.centerXAnchor.constraint(equalTo: showPostsTabView.centerXAnchor).isActive = true
        showPostsContainerView.bottomAnchor.constraint(equalTo: showPostsTabView.bottomAnchor).isActive = true
        
        showPostsContainerView.addSubview(showPostsLabel)
        showPostsLabel.topAnchor.constraint(equalTo: showPostsContainerView.topAnchor, constant: SPACE_S).isActive = true
        showPostsLabel.trailingAnchor.constraint(equalTo: showPostsContainerView.trailingAnchor).isActive = true
        showPostsLabel.bottomAnchor.constraint(equalTo: showPostsContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
        
        showPostsContainerView.addSubview(showPostsImageView)
        showPostsImageView.centerYAnchor.constraint(equalTo: showPostsLabel.centerYAnchor).isActive = true
        showPostsImageView.leadingAnchor.constraint(equalTo: showPostsContainerView.leadingAnchor).isActive = true
        showPostsImageView.trailingAnchor.constraint(equalTo: showPostsLabel.leadingAnchor, constant: -7).isActive = true
        showPostsImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        showPostsImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // MARK: ConfigureView - Tab - Place
        tabContainerView.addSubview(showPlaceTabView)
        showPlaceTabView.topAnchor.constraint(equalTo: showPostsTabView.topAnchor).isActive = true
        showPlaceTabView.trailingAnchor.constraint(equalTo: tabContainerView.trailingAnchor).isActive = true
        showPlaceTabView.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 0.5).isActive = true
        showPlaceTabView.bottomAnchor.constraint(equalTo: showPostsTabView.bottomAnchor).isActive = true
        
        showPlaceTabView.addSubview(showPlaceContainerView)
        showPlaceContainerView.topAnchor.constraint(equalTo: showPlaceTabView.topAnchor).isActive = true
        showPlaceContainerView.centerXAnchor.constraint(equalTo: showPlaceTabView.centerXAnchor).isActive = true
        showPlaceContainerView.bottomAnchor.constraint(equalTo: showPlaceTabView.bottomAnchor).isActive = true
        
        showPlaceContainerView.addSubview(showPlaceLabel)
        showPlaceLabel.centerYAnchor.constraint(equalTo: showPlaceContainerView.centerYAnchor).isActive = true
        showPlaceLabel.trailingAnchor.constraint(equalTo: showPlaceContainerView.trailingAnchor).isActive = true
        
        showPlaceContainerView.addSubview(showPlaceImageView)
        showPlaceImageView.centerYAnchor.constraint(equalTo: showPlaceLabel.centerYAnchor).isActive = true
        showPlaceImageView.leadingAnchor.constraint(equalTo: showPlaceContainerView.leadingAnchor).isActive = true
        showPlaceImageView.trailingAnchor.constraint(equalTo: showPlaceLabel.leadingAnchor, constant: -7).isActive = true
        showPlaceImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        showPlaceImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // MARK: ConfigureView - List
        view.addSubview(postsCollectionView)
        postsCollectionView.topAnchor.constraint(equalTo: tabBottomLine.bottomAnchor).isActive = true
        postsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        postsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        postsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(placeTableView)
        placeTableView.topAnchor.constraint(equalTo: tabBottomLine.bottomAnchor).isActive = true
        placeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        placeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        placeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func getUser() {
        getUserRequest.fetch(vc: self, paramDict: ["uId": String(app.getUserId())])
    }
    
    func getPosts() {
        isPostsLoading = true
        getPostsRequest.fetch(vc: self, paramDict: ["mode": "USER", "uId": String(app.getUserId()), "page": String(postsPage)])
    }
    
    func getPlaces() {
        getPlacesRequest.fetch(vc: self, paramDict: ["mode": "POSTS", "uId": String(app.getUserId())])
    }
    
    func reloadItems() {
        postsList.removeAll()
        postsPage = 1
        isPostsEnd = false
        getPosts()
        getPlaces()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = postsCollectionView.contentOffset.y
        let contentHeight = postsCollectionView.contentSize.height
        let frameHeight = postsCollectionView.frame.height

        if offsetY > contentHeight - frameHeight {
            if !isPostsLoading && !isPostsEnd {
                postsPage += 1
                getPosts()
            }
        }
    }
    
    // MARK: Function - @OBJC
    @objc func alarmTapped() {
        present(UINavigationController(rootViewController: AlarmViewController()), animated: true, completion: nil)
    }
    
    @objc func menuTapped() {
        let menuVC = MenuViewController()
        menuVC.delegate = self
        navigationController?.pushViewController(menuVC, animated: true)
    }
    
    @objc func postsRefreshed() {
        getUser()
        postsList.removeAll()
        postsPage = 1
        isPostsEnd = false
        getPosts()
    }
    
    @objc func placeRefreshed() {
        getUser()
        getPlaces()
    }
    
    @objc func showPostsTapped() {
        if showPostsLabel.textColor == .systemBlue { return }
        
        showPostsLabel.textColor = .systemBlue
        showPostsImageView.tintColor = .systemBlue
        showPlaceLabel.textColor = .systemGray3
        showPlaceImageView.tintColor = .systemGray3
        
        placeTableView.isHidden = true
        placeTableView.alpha = 0
        
        postsCollectionView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.postsCollectionView.alpha = 1
        })
    }
    
    @objc func showPlaceTapped() {
        if showPlaceLabel.textColor == .systemBlue { return }
        
        showPlaceLabel.textColor = .systemBlue
        showPlaceImageView.tintColor = .systemBlue
        showPostsLabel.textColor = .systemGray3
        showPostsImageView.tintColor = .systemGray3
        
        postsCollectionView.isHidden = true
        postsCollectionView.alpha = 0
        
        placeTableView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.placeTableView.alpha = 1
        })
    }
    
    @objc func followerCntTapped() {
        let userListVC = UserListViewController()
        userListVC.mode = "FOLLOWER"
        userListVC.uId = app.getUserId()
        navigationController?.pushViewController(userListVC, animated: true)
    }
    
    @objc func followingCntTapped() {
        let userListVC = UserListViewController()
        userListVC.mode = "FOLLOWING"
        userListVC.uId = app.getUserId()
        navigationController?.pushViewController(userListVC, animated: true)
    }
}


// MARK: CollectionView
extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostsCVCell", for: indexPath) as! PostsCVCell
        cell.posts = postsList[indexPath.row]
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
        let postsVC = PostsViewController()
        postsVC.mode = "USER"
        postsVC.uId = app.getUserId()
        postsVC.poId = postsList[indexPath.row].po_id
        postsVC.postsList = postsList
        postsVC.page = postsPage
        postsVC.isEnd = isPostsEnd
        postsVC.delegate = self
        navigationController?.pushViewController(postsVC, animated: true)
    }
}

// MARK: TableView
extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsPlaceTVCell", for: indexPath) as! PostsPlaceTVCell
        cell.selectionStyle = .none
        cell.place = placeList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: PostsPlaceTVCell
extension AccountViewController: PostsPlaceTVCellProtocol {
    func selectPlace(place: Place) {
        let placeVC = PlaceViewController()
        placeVC.navigationItem.title = place.p_name
        placeVC.pId = place.p_id
        navigationController?.pushViewController(placeVC, animated: true)
    }
    
    func selectPosts(isMoveInitPosition: Bool, poId: Int, postsList: [Posts]) {
        let postsVC = PostsViewController()
        postsVC.postsList = postsList
        postsVC.poId = poId
        postsVC.isEnd = true
        postsVC.delegate = self
        navigationController?.pushViewController(postsVC, animated: true)
    }
}

// MARK: PostsVC
extension AccountViewController: PostsViewControllerProtocol {
    func removePosts(poId: Int) {
        getUser()
        reloadItems()
    }
    func likePosts(poId: Int, isLike: String) { reloadItems() }
    func editPosts(posts: Posts) { reloadItems() }
}

// MARK: MenuVC
extension AccountViewController: MenuViewControllerProtocol {
    func editProfile() {
        navigationItem.title = app.getUserNickName()
        guard let url = URL(string: PLAPICK_URL + app.getUserProfileImage()) else { return }
        profileImageView.sd_setImage(with: url, completed: nil)
    }
}

// MARK: HTTP - GetUser
extension AccountViewController: GetUserRequestProtocol {
    func response(user: User?, getUser status: String) {
        print("[HTTP RES]", getUserRequest.apiUrl, status)
        
        if status == "OK" {
            guard let user = user else { return }
            
            postsCntLabel.text = String(user.u_posts_cnt)
            placeCntLabel.text = String(user.u_place_cnt)
            followerCntLabel.text = String(user.u_follower_cnt)
            followingCntLabel.text = String(user.u_following_cnt)
            
            guard let profileImage = user.u_profile_image else { return }
            guard let url = URL(string: PLAPICK_URL + profileImage) else { return }
            profileImageView.sd_setImage(with: url, completed: nil)
        }
    }
}

// MARK: HTTP - GetPosts
extension AccountViewController: GetPostsRequestProtocol {
    func response(postsList: [Posts]?, mode: String?, getPosts status: String) {
        print("[HTTP RES]", getPostsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let postsList = postsList else { return }
            guard let mode = mode else { return }
            
            if mode == "USER" {
                self.postsList.append(contentsOf: postsList)
                postsCollectionView.reloadData()
                
                if postsList.count < GET_POSTS_LIMIT { isPostsEnd = true }
                
            } else if mode == "PLACES" {
                for posts in postsList {
                    for (i, place) in placeList.enumerated() {
                        if posts.po_p_id == place.p_id {
                            if placeList[i].postsList == nil {
                                placeList[i].postsList = []
                            }
                            placeList[i].postsList?.append(posts)
                            break
                        }
                    }
                }
                
                placeTableView.reloadData()
            }
        }
        isPostsLoading = false
        postsCollectionView.refreshControl?.endRefreshing()
    }
}

// MARK: HTTP - GetPlaces
extension AccountViewController: GetPlacesRequestProtocol {
    func response(placeList: [Place]?, getPlaces status: String) {
        print("[HTTP RES]", getPlacesRequest.apiUrl, status)
        
        if status == "OK" {
            guard let placeList = placeList else { return }
            self.placeList = placeList
            
            if placeList.count > 0 {
                var pIdList = ""
                for (i, place) in placeList.enumerated() {
                    if i > 0 { pIdList += "|" }
                    pIdList += String(place.p_id)
                }
                
                getPostsRequest.fetch(vc: self, paramDict: ["mode": "PLACES", "uId": String(app.getUserId()), "pIdList": pIdList])
            }
        }
        placeTableView.refreshControl?.endRefreshing()
    }
}
