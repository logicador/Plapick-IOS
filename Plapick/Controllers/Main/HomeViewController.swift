//
//  HomeViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class HomeViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    
    
    // MARK: Views
    lazy var recentPickTitleView: TitleView = {
        let tv = TitleView(titleText: "Recent Pick", isAction: true, actionText: "더보기", actionMode: "MORE_RECENT_PICK")
        tv.delegate = self
        return tv
    }()
    
    lazy var recentPickContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var hotPlaceTitleView: TitleView = {
        let tv = TitleView(titleText: "Hot Place", isAction: true, actionText: "더보기", actionMode: "MORE_HOT_PLACE")
        tv.delegate = self
        return tv
    }()
    
    lazy var hotPlaceContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "플레픽"
 
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(openSearchViewController))
        
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
        
        contentView.addSubview(recentPickTitleView)
        recentPickTitleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        recentPickTitleView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        recentPickTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        recentPickTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(recentPickContainerView)
        recentPickContainerView.topAnchor.constraint(equalTo: recentPickTitleView.bottomAnchor).isActive = true
        recentPickContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        recentPickContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        recentPickContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(hotPlaceTitleView)
        hotPlaceTitleView.topAnchor.constraint(equalTo: recentPickContainerView.bottomAnchor, constant: 20).isActive = true
        hotPlaceTitleView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        hotPlaceTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        hotPlaceTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(hotPlaceContainerView)
        hotPlaceContainerView.topAnchor.constraint(equalTo: hotPlaceTitleView.bottomAnchor).isActive = true
        hotPlaceContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        hotPlaceContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        hotPlaceContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        hotPlaceContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        // 초기 세팅 빈 pick으로
        setRecentPickContainer(photoGroupViewList: [
            PhotoGroupView(direction: "N", pickList: [Pick(id: 0), Pick(id: 0), Pick(id: 0)]),
            PhotoGroupView(direction: "L", pickList: [Pick(id: 0), Pick(id: 0), Pick(id: 0)]),
            PhotoGroupView(direction: "N", pickList: [Pick(id: 0), Pick(id: 0), Pick(id: 0)]),
            PhotoGroupView(direction: "R", pickList: [Pick(id: 0), Pick(id: 0), Pick(id: 0)]),
            PhotoGroupView(direction: "N", pickList: [Pick(id: 0), Pick(id: 0), Pick(id: 0)])
        ])
        
        adjustColors()
        
        // 푸시 알림 허용 확인
        app.checkPushNotificationAvailable(parentViewController: self)
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        getRecentPicks()
        getHotPlaces()
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .tertiarySystemGroupedBackground
        }
    }
    
    @objc func openSearchViewController() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        let searchPlaceViewController = SearchPlaceViewController()
//        searchPlaceViewController.isSelectMode = true
        let navigationController = UINavigationController(rootViewController: searchPlaceViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    func getRecentPicks() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.recentPickContainerView.removeAllChildView()
            
            var pickList: [Pick] = []
            
            // 이 부분에서 최근 게시물들 15개 세팅
            for i in 1...15 {
                pickList.append(Pick(id: i, photoUrl: PLAPICK_URL + "/admin/img/ey.jpg"))
            }
            
            var photoGroupViewList: [PhotoGroupView] = []
            
            var _pickList: [Pick] = []
            for (i, pick) in pickList.enumerated() {
                let index = i + 1
                _pickList.append(pick)
                
                if index % 3 == 0 {
                    var direction = "N"
                    if index == 6 { direction = "L" }
                    else if index == 12 { direction = "R" }
                    
                    let photoGroupView = PhotoGroupView(direction: direction, pickList: _pickList)
                    photoGroupView.delegate = self
                    photoGroupViewList.append(photoGroupView)
                    _pickList = []
                }
            }
            
            self.setRecentPickContainer(photoGroupViewList: photoGroupViewList)
        }
    }
    
    func setRecentPickContainer(photoGroupViewList: [PhotoGroupView]) {
        for (i, photoGroupView) in photoGroupViewList.enumerated() {
            self.recentPickContainerView.addSubview(photoGroupView)
            
            photoGroupView.widthAnchor.constraint(equalTo: self.recentPickContainerView.widthAnchor).isActive = true
            photoGroupView.leadingAnchor.constraint(equalTo: self.recentPickContainerView.leadingAnchor).isActive = true
            photoGroupView.trailingAnchor.constraint(equalTo: self.recentPickContainerView.trailingAnchor).isActive = true
            
            if i == 0 {
                photoGroupView.topAnchor.constraint(equalTo: self.recentPickContainerView.topAnchor).isActive = true
            } else {
                photoGroupView.topAnchor.constraint(equalTo: photoGroupViewList[i - 1].bottomAnchor, constant: 1).isActive = true
            }
            if i == photoGroupViewList.count - 1 {
                photoGroupView.bottomAnchor.constraint(equalTo: self.recentPickContainerView.bottomAnchor).isActive = true
            }
        }
    }
    
    func getHotPlaces() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.hotPlaceContainerView.removeAllChildView()
            
            var placeList: [Place] = []
            
            // 이 부분에서 인기 플레이스들 1~2개 세팅
            let randomCnt = Int.random(in: 1...2)
            for i in 1...randomCnt {
                var hotPickList: [Pick] = []
                for i in 1...15 {
                    hotPickList.append(Pick(id: i, photoUrl: PLAPICK_URL + "/admin/img/ey.jpg"))
                }
                placeList.append(Place(id: i, kId: 25855305 + i, name: "아침고요수목원" + String(i), visibleAddress: "경기 가평군 상면 수목원로 432", address: "경기 가평군 상면 행현리 623-3", roadAddress: "경기 가평군 상면 수목원로 432", category: "수목원,식물원", categoryName: "여행 > 관광,명소 > 수목원,식물원", categoryGroupName: "관광명소", categoryGroupCode: "AT4", phone: "1544-6703", lat: 37.743004, lng: 127.351661, hotPickList: hotPickList, likeCnt: Int.random(in: 0...100), pickCnt: Int.random(in: 0...100)))
            }
            
            var placeLargeViewList: [PlaceLargeView] = []
            
            for place in placeList {
                let placeLargeView = PlaceLargeView(place: place)
                placeLargeView.delegate = self
                placeLargeViewList.append(placeLargeView)
            }
            
            self.setHotPlaceContainer(placeLargeViewList: placeLargeViewList)
        }
    }
    
    func setHotPlaceContainer(placeLargeViewList: [PlaceLargeView]) {
        for (i, placeLargeView) in placeLargeViewList.enumerated() {
            self.hotPlaceContainerView.addSubview(placeLargeView)
            
            placeLargeView.widthAnchor.constraint(equalTo: self.hotPlaceContainerView.widthAnchor).isActive = true
            placeLargeView.leadingAnchor.constraint(equalTo: self.hotPlaceContainerView.leadingAnchor).isActive = true
            placeLargeView.trailingAnchor.constraint(equalTo: self.hotPlaceContainerView.trailingAnchor).isActive = true
            
            if i == 0 {
                placeLargeView.topAnchor.constraint(equalTo: self.hotPlaceContainerView.topAnchor).isActive = true
            } else {
                placeLargeView.topAnchor.constraint(equalTo: placeLargeViewList[i - 1].bottomAnchor, constant: 20).isActive = true
            }
            if i == placeLargeViewList.count - 1 {
                placeLargeView.bottomAnchor.constraint(equalTo: self.hotPlaceContainerView.bottomAnchor).isActive = true
            }
        }
    }
}


// MARK: Extensions
extension HomeViewController: TitleViewProtocol {
    func actionTapped(actionMode: String) {
        print(actionMode)
    }
}


extension HomeViewController: PhotoGroupViewProtocol {
    func photoTapped(pick: Pick) {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        print("pickTapped", pick)
    }
}


extension HomeViewController: PlaceLargeViewProtocol {
    func placeTapped(place: Place) {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        print("placeTapped", place)
    }
}
