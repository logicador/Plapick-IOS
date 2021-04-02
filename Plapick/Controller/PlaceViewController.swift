//
//  PlaceViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit


protocol PlaceViewControllerProtocol {
    func likePlace(place: Place)
}


class PlaceViewController: UIViewController {
    
    // MARK: Property
    var delegate: PlaceViewControllerProtocol?
    var pId: Int? {
        didSet {
            guard let pId = self.pId else { return }
            
            getPlaceRequest.fetch(vc: self, paramDict: ["pId": String(pId)])
        }
    }
    var kakaoPlace: KakaoPlace? {
        didSet {
            guard let kakaoPlace = self.kakaoPlace else { return }
            
            navigationItem.title = kakaoPlace.place_name
            
            getPlaceRequest.fetch(vc: self, paramDict: ["kId": kakaoPlace.id, "name": kakaoPlace.place_name, "address": kakaoPlace.address_name, "roadAddress": kakaoPlace.road_address_name, "lat": kakaoPlace.y, "lng": kakaoPlace.x, "categoryGroupCode": kakaoPlace.category_group_code, "categoryGroupName": kakaoPlace.category_group_name, "categoryName": kakaoPlace.category_name, "phone": kakaoPlace.phone])
        }
    }
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            navigationItem.title = place.p_name
            
//            isLike = place.p_is_like
            
            getPosts()
        }
    }
    let getPlaceRequest = GetPlaceRequest()
    let getPostsRequest = GetPostsRequest()
    let likePlaceRequest = LikePlaceRequest()
//    var isLike = "N"
    var postsList: [Posts] = []
    
    
    // MARK: View
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.register(PostsCVCell.self, forCellWithReuseIdentifier: "PostsCVCell")
        cv.register(PlaceHeaderCVCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlaceHeaderCVCell")
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.refreshControl = UIRefreshControl()
        cv.refreshControl?.addTarget(self, action: #selector(refreshed), for: .valueChanged)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(moreTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        getPlaceRequest.delegate = self
        getPostsRequest.delegate = self
        likePlaceRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        collectionView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func getPosts() {
        guard let place = self.place else { return }
        
        getPostsRequest.fetch(vc: self, paramDict: ["mode": "PLACE", "pId": String(place.p_id)])
    }
    
    // MARK: Function - @OBJC
    @objc func refreshed() {
        guard let place = self.place else { return }
        
        getPlaceRequest.fetch(vc: self, paramDict: ["pId": String(place.p_id)])
    }
    
//    @objc func likeTapped() {
//        guard let place = self.place else { return }
//        likePlaceRequest.fetch(vc: self, paramDict: ["pId": String(place.p_id)])
//    }
    
    @objc func moreTapped() {
        
        let alert = UIAlertController(title: nil, message: "다음 중 항목을 선택해주세요.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        
//        alert.addAction(UIAlertAction(title: (isLike == "Y") ? "좋아요 취소" : "좋아요", style: .default, handler: { (_) in
//            guard let place = self.place else { return }
//            self.likePlaceRequest.fetch(vc: self, paramDict: ["pId": String(place.p_id)])
//        }))
        alert.addAction(UIAlertAction(title: "공유하기", style: .default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "신고하기", style: .destructive, handler: { (_) in
            guard let pId = self.pId else { return }
            let reportVC = ReportViewController()
            reportVC.targetType = "PLACE"
            reportVC.targetId = pId
            self.present(UINavigationController(rootViewController: reportVC), animated: true, completion: nil)
        }))
        
        present(alert, animated: true)
    }
}


// MARK: CollectionView
extension PlaceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostsCVCell", for: indexPath) as! PostsCVCell
        cell.posts = postsList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PlaceHeaderCVCell", for: indexPath) as! PlaceHeaderCVCell
        cell.place = place
        cell.delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 12 + 12 + 12 + 200 + SPACE_S + 12 + SPACE_XS + 14 + SPACE_S)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postsVC = PostsViewController()
        postsVC.postsList = postsList
        postsVC.poId = postsList[indexPath.row].po_id
        postsVC.isEnd = true
        postsVC.delegate = self
        navigationController?.pushViewController(postsVC, animated: true)
    }
}

// MARK: PostsVC
extension PlaceViewController: PostsViewControllerProtocol {
    func removePosts(poId: Int) { getPosts() }
    func likePosts(poId: Int, isLike: String) { getPosts() }
    func editPosts(posts: Posts) { getPosts() }
}

// MARK: PlaceHeaderCVCell
extension PlaceViewController: PlaceHeaderCVCellProtocol {
    func like() {
        guard let place = self.place else { return }
        likePlaceRequest.fetch(vc: self, paramDict: ["pId": String(place.p_id)])
    }
    
    func selectMap() {
        guard let place = self.place else { return }
        
        let placeMapVC = PlaceMapViewController()
        placeMapVC.place = place
        navigationController?.pushViewController(placeMapVC, animated: true)
    }
    
    func selectComment() {
        guard let place = self.place else { return }
        
        let placeCommentVC = PlaceCommentViewController()
        placeCommentVC.place = place
        present(UINavigationController(rootViewController: placeCommentVC), animated: true, completion: nil)
    }
}

// MARK: HTTP - GetPlace
extension PlaceViewController: GetPlaceRequestProtocol {
    func response(place: Place?, getPlace status: String) {
        print("[HTTP RES]", getPlaceRequest.apiUrl, status)
        
        if status == "OK" {
            guard let place = place else { return }
            self.place = place
        }
    }
}

// MARK: HTTP - GetPosts
extension PlaceViewController: GetPostsRequestProtocol {
    func response(postsList: [Posts]?, mode: String?, getPosts status: String) {
        print("[HTTP RES]", getPostsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let postsList = postsList else { return }
            
            self.postsList = postsList
            collectionView.reloadData()
        }
        
        collectionView.refreshControl?.endRefreshing()
    }
}

// MARK: HTTP - LikePlace
extension PlaceViewController: LikePlaceRequestProtocol {
    func response(isLike: String?, likePlace status: String) {
        print("[HTTP RES]", likePlaceRequest.apiUrl, status)
        
        if status == "OK" {
//            guard let isLike = isLike else { return }
            guard let place = self.place else { return }
            
//            self.isLike = isLike
            
            getPlaceRequest.fetch(vc: self, paramDict: ["pId": String(place.p_id)])
            
            delegate?.likePlace(place: place)
        }
    }
}
