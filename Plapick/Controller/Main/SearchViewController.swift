//
//  SearchViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/25.
//

import UIKit
import CoreLocation


class SearchViewController: UIViewController {
    
    // MARK: Property
    let placeSlideWidth: CGFloat = (SCREEN_WIDTH / 2) + (SPACE_XXS * 2)
    let userSlideHeight: CGFloat = 72
    var app = App()
    var mainVC: MainViewController?
    let locationManager = CLLocationManager()
    
    // MARK: For DEV_DEBUG
    var user: User?
    var place: Place?
    
    
    // MARK: VIew
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
    
    // MARK: View - Place
    lazy var searchPlaceTitleView: TitleView = {
        let tv = TitleView(text: "플레이스", style: .large)
        return tv
    }()
    lazy var searchPlaceContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var searchPlaceKeywordIconButton: IconButton = {
        let ib = IconButton(type: UIButton.ButtonType.system)
        ib.text = "키워드로 검색"
        ib.icon = "keyboard"
        ib.addTarget(self, action: #selector(searchPlaceKeywordTapped), for: UIControl.Event.touchUpInside)
        return ib
    }()
    lazy var searchPlaceGPSIconButton: IconButton = {
        let ib = IconButton(type: UIButton.ButtonType.system)
        ib.text = "내 위치 주변 탐색"
        ib.icon = "scope"
        return ib
    }()
    lazy var searchPlaceLocationIconButton: IconButton = {
        let ib = IconButton(type: UIButton.ButtonType.system)
        ib.text = "지역으로 찾기"
        ib.icon = "location"
        return ib
    }()
    lazy var searchPlaceMapIconButton: IconButton = {
        let ib = IconButton(type: UIButton.ButtonType.system)
        ib.text = "지도에서 찾기"
        ib.icon = "map"
        return ib
    }()
    
    lazy var recentPlaceTitleView: TitleView = {
        let tv = TitleView(text: "최근에 본 플레이스", style: .ultraSmall)
        tv.delegate = self
        return tv
    }()
    lazy var recentPlaceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.register(PlaceCVCell.self, forCellWithReuseIdentifier: "PlaceCVCell")
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: View - User
    lazy var searchUserTitleView: TitleView = {
        let tv = TitleView(text: "다른 사람", style: .large)
        return tv
    }()
    lazy var searchUserNickNameIconButton: IconButton = {
        let ib = IconButton(type: UIButton.ButtonType.system)
        ib.text = "닉네임으로 검색"
        ib.icon = "person.2"
        ib.addTarget(self, action: #selector(searchUserNickNameTapped), for: UIControl.Event.touchUpInside)
        return ib
    }()
    
    lazy var recentUserTitleView: TitleView = {
        let tv = TitleView(text: "최근에 본 사람", style: .ultraSmall)
        tv.delegate = self
        return tv
    }()
    lazy var recentUserCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.showsHorizontalScrollIndicator = false
        cv.register(UserCVCell.self, forCellWithReuseIdentifier: "UserCVCell")
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        // MARK: For DEV_DEBUG
        user = app.getUser()
        guard let user = self.user else { return }
        place = Place(id: 2, kId: 25855305, name: "아침고요수목원", categoryName: "수목원,식물원", categoryGroupName: "", categoryGroupCode: "", address: "", roadAddress: "경기 가평군 상면 수목원로 432", latitude: "", longitude: "", phone: "", plocCode: "", clocCode: "", mostPickList: [MostPick(id: 2101180709242291, uId: user.id, uNickName: user.nickName, uProfileImage: user.profileImage)], likeCnt: 0, commentCnt: 0, pickCnt: 0)
    }
    
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainVC?.title = "검색"
        if mainVC?.navigationItem.leftBarButtonItem != nil { mainVC?.navigationItem.leftBarButtonItem = nil }
        if mainVC?.navigationItem.rightBarButtonItem != nil { mainVC?.navigationItem.rightBarButtonItem = nil }
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
        
        // MARK: ConfigureView - Place
        contentView.addSubview(searchPlaceTitleView)
        searchPlaceTitleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        searchPlaceTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        searchPlaceTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(searchPlaceContainerView)
        searchPlaceContainerView.topAnchor.constraint(equalTo: searchPlaceTitleView.bottomAnchor).isActive = true
        searchPlaceContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        searchPlaceContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        searchPlaceContainerView.addSubview(searchPlaceKeywordIconButton)
        searchPlaceKeywordIconButton.topAnchor.constraint(equalTo: searchPlaceContainerView.topAnchor).isActive = true
        searchPlaceKeywordIconButton.leadingAnchor.constraint(equalTo: searchPlaceContainerView.leadingAnchor).isActive = true
        searchPlaceKeywordIconButton.trailingAnchor.constraint(equalTo: searchPlaceContainerView.trailingAnchor).isActive = true
        
        searchPlaceContainerView.addSubview(searchPlaceGPSIconButton)
        searchPlaceGPSIconButton.topAnchor.constraint(equalTo: searchPlaceKeywordIconButton.bottomAnchor, constant: SPACE_S).isActive = true
        searchPlaceGPSIconButton.leadingAnchor.constraint(equalTo: searchPlaceContainerView.leadingAnchor).isActive = true
        searchPlaceGPSIconButton.trailingAnchor.constraint(equalTo: searchPlaceContainerView.trailingAnchor).isActive = true
        
        searchPlaceContainerView.addSubview(searchPlaceLocationIconButton)
        searchPlaceLocationIconButton.topAnchor.constraint(equalTo: searchPlaceGPSIconButton.bottomAnchor, constant: SPACE_S).isActive = true
        searchPlaceLocationIconButton.leadingAnchor.constraint(equalTo: searchPlaceContainerView.leadingAnchor).isActive = true
        searchPlaceLocationIconButton.trailingAnchor.constraint(equalTo: searchPlaceContainerView.trailingAnchor).isActive = true
        
        searchPlaceContainerView.addSubview(searchPlaceMapIconButton)
        searchPlaceMapIconButton.topAnchor.constraint(equalTo: searchPlaceLocationIconButton.bottomAnchor, constant: SPACE_S).isActive = true
        searchPlaceMapIconButton.leadingAnchor.constraint(equalTo: searchPlaceContainerView.leadingAnchor).isActive = true
        searchPlaceMapIconButton.trailingAnchor.constraint(equalTo: searchPlaceContainerView.trailingAnchor).isActive = true
        searchPlaceMapIconButton.bottomAnchor.constraint(equalTo: searchPlaceContainerView.bottomAnchor).isActive = true
        
        contentView.addSubview(recentPlaceTitleView)
        recentPlaceTitleView.topAnchor.constraint(equalTo: searchPlaceContainerView.bottomAnchor).isActive = true
        recentPlaceTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        recentPlaceTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(recentPlaceCollectionView)
        recentPlaceCollectionView.topAnchor.constraint(equalTo: recentPlaceTitleView.bottomAnchor).isActive = true
        recentPlaceCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        recentPlaceCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        recentPlaceCollectionView.heightAnchor.constraint(equalToConstant: placeSlideWidth).isActive = true
        
        // MARK: ConfigureView - User
        contentView.addSubview(searchUserTitleView)
        searchUserTitleView.topAnchor.constraint(equalTo: recentPlaceCollectionView.bottomAnchor).isActive = true
        searchUserTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        searchUserTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(searchUserNickNameIconButton)
        searchUserNickNameIconButton.topAnchor.constraint(equalTo: searchUserTitleView.bottomAnchor).isActive = true
        searchUserNickNameIconButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        searchUserNickNameIconButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        contentView.addSubview(recentUserTitleView)
        recentUserTitleView.topAnchor.constraint(equalTo: searchUserNickNameIconButton.bottomAnchor).isActive = true
        recentUserTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        recentUserTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(recentUserCollectionView)
        recentUserCollectionView.topAnchor.constraint(equalTo: recentUserTitleView.bottomAnchor).isActive = true
        recentUserCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        recentUserCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        recentUserCollectionView.heightAnchor.constraint(equalToConstant: userSlideHeight).isActive = true
        recentUserCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SPACE_XL).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func searchPlaceKeywordTapped() {
        let searchPlaceVC = SearchPlaceViewController()
        searchPlaceVC.mode = "KEYWORD"
        navigationController?.pushViewController(searchPlaceVC, animated: true)
    }
    
    @objc func searchUserNickNameTapped() {
        let searchUserTVC = SearchUserTableViewController()
        searchUserTVC.mode = "KEYWORD"
        navigationController?.pushViewController(searchUserTVC, animated: true)
    }
    
    @objc func gpsTapped() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            
        } else if status == .restricted || status == .denied {
            requestSettingAlert(title: "위치 액세스 허용하기", message: "'플레픽'에서 사용자의 위치에 접근하고자 합니다.")
            
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            guard let location = locationManager.location else {
                let alert = UIAlertController(title: "위치정보", message: "사용자의 위치 정보를 가져올 수 없습니다. 다시 시도해주세요.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
                present(alert, animated: true, completion: nil)
                return
            }
            let coordinate = location.coordinate
            print(coordinate.latitude, coordinate.longitude)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recentPlaceCollectionView {
            
        } else {
            
        }
    }
}


// MARK: Extension - TitleView
extension SearchViewController: TitleViewProtocol {
    func action(actionMode: String) {
        print(actionMode)
    }
}

// MARK: Extension - RecentPlaceCollection
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recentPlaceCollectionView {
            return 10
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recentPlaceCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCVCell", for: indexPath) as! PlaceCVCell
            cell.place = place
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCVCell", for: indexPath) as! UserCVCell
            cell.user = user
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recentPlaceCollectionView {
            return CGSize(width: placeSlideWidth, height: placeSlideWidth)
        } else {
            return CGSize(width: view.frame.width * 0.3, height: userSlideHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
