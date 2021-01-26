//
//  HomeViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class HomeViewController: UIViewController {
    
    // MARK: Property
    var app = App()
    var mainVC: MainViewController?
    
    // MARK: Property - Request
    var getRecentPicksRequest = GetRecentPicksRequest()
    var getHotPlacesRequest = GetHotPlacesRequest()
//    let likePlaceRequest = LikePlaceRequest()
    
    // MARK: Property - View
    var photoGroupViewList: [PhotoGroupView] = []
    var placeLargeViewList: [PlaceLargeView] = []
    
    
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
    
    lazy var recentPickTitleView: TitleView = {
        let tv = TitleView(text: "최신 픽", isAction: true, actionText: "모두 보기", actionMode: "ALL_RECENT_PICK")
        tv.delegate = self
        return tv
    }()
    
    lazy var recentPickContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var hotPlaceTitleView: TitleView = {
        let tv = TitleView(text: "인기 플레이스", isAction: true, actionText: "모두 보기", actionMode: "ALL_HOT_PLACE")
        tv.delegate = self
        return tv
    }()
    
    lazy var hotPlaceContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: Init
    init(mainVC: MainViewController) {
        super.init(nibName: nil, bundle: nil)
        self.mainVC = mainVC
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureView()
        
        // 초기세팅 빈 Pick으로 (UI 흔들림 방지)
        for i in 1...5 {
            var pgv = PhotoGroupView()
            if i == 2 { pgv = PhotoGroupView(direction: "L") }
            else if i == 4 { pgv = PhotoGroupView(direction: "R") }
            pgv.delegate = self
            photoGroupViewList.append(pgv)
        }
        configurePhotoGroupView()
        
        // 푸시 알림 허용 확인
        app.checkPushNotificationAvailable(vc: self)
        
        getRecentPicksRequest.delegate = self
        getHotPlacesRequest.delegate = self
//        likePlaceRequest.delegate = self
        
        getRecentPicksRequest.fetch(vc: self, paramDict: [:])
        getHotPlacesRequest.fetch(vc: self, paramDict: [:])
    }
    
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        mainVC?.title = "플레픽"
        if mainVC?.navigationItem.leftBarButtonItem != nil { mainVC?.navigationItem.leftBarButtonItem = nil }
        if mainVC?.navigationItem.rightBarButtonItem != nil { mainVC?.navigationItem.rightBarButtonItem = nil }
//        mainVC?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(openSearchViewController))
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        contentView.addSubview(recentPickTitleView)
        recentPickTitleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        recentPickTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        recentPickTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(recentPickContainerView)
        recentPickContainerView.topAnchor.constraint(equalTo: recentPickTitleView.bottomAnchor).isActive = true
        recentPickContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        recentPickContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(hotPlaceTitleView)
        hotPlaceTitleView.topAnchor.constraint(equalTo: recentPickContainerView.bottomAnchor).isActive = true
        hotPlaceTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        hotPlaceTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(hotPlaceContainerView)
        hotPlaceContainerView.topAnchor.constraint(equalTo: hotPlaceTitleView.bottomAnchor).isActive = true
        hotPlaceContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        hotPlaceContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        hotPlaceContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configurePhotoGroupView() {
        for (i, pgv) in photoGroupViewList.enumerated() {
            recentPickContainerView.addSubview(pgv)
            pgv.leadingAnchor.constraint(equalTo: recentPickContainerView.leadingAnchor).isActive = true
            pgv.trailingAnchor.constraint(equalTo: recentPickContainerView.trailingAnchor).isActive = true
            if i == 0 {
                pgv.topAnchor.constraint(equalTo: recentPickContainerView.topAnchor).isActive = true
            } else {
                pgv.topAnchor.constraint(equalTo: photoGroupViewList[i - 1].bottomAnchor, constant: 1).isActive = true
            }
            if i == photoGroupViewList.count - 1 {
                pgv.bottomAnchor.constraint(equalTo: recentPickContainerView.bottomAnchor).isActive = true
            }
        }
    }
    
//    // MARK: Function - @OBJC
//    @objc func openSearchViewController() {
//
////        let searchPlaceViewController = SearchPlaceViewController()
//////        searchPlaceViewController.isSelectMode = true
//////        let navigationController = UINavigationController(rootViewController: searchPlaceViewController)
//////        navigationController.modalPresentationStyle = .fullScreen
//////        present(navigationController, animated: true)
////        self.navigationController?.pushViewController(searchPlaceViewController, animated: true)
//    }
}


// MARK: Extension
extension HomeViewController: TitleViewProtocol {
    func action(actionMode: String) {
        print(actionMode)
    }
}


extension HomeViewController: PhotoGroupViewProtocol {
    func pickTapped(pick: Pick) {
        print("pickTapped", pick)
    }
}


extension HomeViewController: PlaceLargeViewProtocol {
    func openPlace(place: Place) {
        print("openPlace", place.id)
    }
    
//    func likePlace(place: Place) {
//        likePlaceRequest.fetch(paramDict: ["pId": String(place.id)])
//    }
    
    func openPlaceAllComments(place: Place) {
        print("openAllComments", place.id)
    }
    
    func openPlaceAllPicks(place: Place) {
        print("openAllPicks", place.id)
    }
    
    func openPick(piId: Int) {
        print("openPick", piId)
    }
    
    func openPickUser(uId: Int) {
        print("openPickUser", uId)
    }
    
    func openPickCnt(piId: Int) {
        print("openPickStatistics", piId)
    }
}


extension HomeViewController: GetRecentPicksRequestProtocol {
    func response(pickList: [Pick]?, getRecentPicks status: String) {
        if status == "OK" {
            if let pickList = pickList {
                var _pickList: [Pick] = []
                for (i, pick) in pickList.enumerated() {
                    _pickList.append(pick)
                    if (i + 1) % 3 == 0 {
                        photoGroupViewList[i / 3].pickList = _pickList
                        _pickList.removeAll()
                    }
                }
            }
        }
    }
}


extension HomeViewController: GetHotPlacesRequestProtocol {
    func response(placeList: [Place]?, getHotPlaces status: String) {
        if status == "OK" {
            if let placeList = placeList {
                hotPlaceContainerView.removeAllChildView()
                
                if placeList.count > 0 {
                    for (i, place) in placeList.enumerated() {
                        let plv = PlaceLargeView()
                        plv.place = place
                        plv.delegate = self
                        
                        hotPlaceContainerView.addSubview(plv)
                        plv.leadingAnchor.constraint(equalTo: hotPlaceContainerView.leadingAnchor).isActive = true
                        plv.trailingAnchor.constraint(equalTo: hotPlaceContainerView.trailingAnchor).isActive = true
                        if i == 0 {
                            plv.topAnchor.constraint(equalTo: hotPlaceContainerView.topAnchor).isActive = true
                        } else {
                            plv.topAnchor.constraint(equalTo: hotPlaceContainerView.subviews[hotPlaceContainerView.subviews.count - 2].bottomAnchor, constant: SPACE_XXL).isActive = true
                        }
                        if i == placeList.count - 1 {
                            plv.bottomAnchor.constraint(equalTo: hotPlaceContainerView.bottomAnchor, constant: -SPACE_XL).isActive = true
                        }
                        
                        placeLargeViewList.append(plv)
                    }
                    
                } else {
                    
                }
            }
        }
    }
}


//extension HomeViewController: LikePlaceRequestProtocol {
//    func response(likePlace status: String) {
//        // nothing to do
//    }
//}
