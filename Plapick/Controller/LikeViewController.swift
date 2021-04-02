//
//  LikeViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/04/02.
//

import UIKit


class LikeViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let getPostsRequest = GetPostsRequest()
    let getPlacesRequest = GetPlacesRequest()
    var postsList: [Posts] = []
    var placeList: [Place] = []
    
    
    // MARK: View
    lazy var tabContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tabBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Posts
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
        label.text = "게시물"
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var showPostsImageView: UIImageView = {
        let image = UIImage(systemName: "text.below.photo")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Place
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
        label.text = "플레이스"
        label.textColor = .systemGray3
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var showPlaceImageView: UIImageView = {
        let image = UIImage(systemName: "mappin.and.ellipse")
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
        tv.register(PlaceTVCell.self, forCellReuseIdentifier: "PlaceTVCell")
        tv.separatorInset.left = 0
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
        
        navigationItem.title = "좋아요"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        getPostsRequest.delegate = self
        getPlacesRequest.delegate = self
        
        getPosts()
        getPlaces()
    }
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        postsCollectionView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        placeTableView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(tabContainerView)
        tabContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tabContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tabBottomLine)
        tabBottomLine.topAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        tabBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // MARK: Configure - Posts
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
        
        // MARK: Configure - Place
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
        
        // MARK: Configure - List
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
    
    func getPosts() {
        getPostsRequest.fetch(vc: self, paramDict: ["mode": "LIKE", "uId": String(app.getUserId())])
    }
    
    func getPlaces() {
        getPlacesRequest.fetch(vc: self, paramDict: ["mode": "LIKE", "uId": String(app.getUserId())])
    }
    
    // MARK: Function - @OBJC
    @objc func postsRefreshed() {
        getPosts()
    }
    
    @objc func placeRefreshed() {
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
}


// MARK: CollectionView
extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        postsVC.poId = postsList[indexPath.row].po_id
        postsVC.postsList = postsList
        postsVC.isEnd = true
        postsVC.delegate = self
        navigationController?.pushViewController(postsVC, animated: true)
    }
}

// MARK: TableView
extension LikeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTVCell", for: indexPath) as! PlaceTVCell
        cell.selectionStyle = .none
        cell.place = placeList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = placeList[indexPath.row]
        let placeVC = PlaceViewController()
        placeVC.pId = place.p_id
        placeVC.delegate = self
        navigationController?.pushViewController(placeVC, animated: true)
    }
}

// MARK: PostsVC
extension LikeViewController: PostsViewControllerProtocol {
    func removePosts(poId: Int) { getPosts() }
    func likePosts(poId: Int, isLike: String) { getPosts() }
    func editPosts(posts: Posts) { getPosts() }
}

// MARK: PlaceVC
extension LikeViewController: PlaceViewControllerProtocol {
    func likePlace(place: Place) { getPlaces() }
}

// MARK: HTTP - GetPosts
extension LikeViewController: GetPostsRequestProtocol {
    func response(postsList: [Posts]?, mode: String?, getPosts status: String) {
        print("[HTTP RES]", getPostsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let postsList = postsList else { return }
            
            self.postsList = postsList
            postsCollectionView.reloadData()
        }
        postsCollectionView.refreshControl?.endRefreshing()
    }
}

// MARK: HTTP - GetPlaces
extension LikeViewController: GetPlacesRequestProtocol {
    func response(placeList: [Place]?, getPlaces status: String) {
        print("[HTTP RES]", getPlacesRequest.apiUrl, status)
        
        if status == "OK" {
            guard let placeList = placeList else { return }
            
            self.placeList = placeList
            placeTableView.reloadData()
        }
        placeTableView.refreshControl?.endRefreshing()
    }
}
