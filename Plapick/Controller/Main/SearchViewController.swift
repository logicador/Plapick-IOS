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
    var recentPlaceList: [Place] = []
    var recentUserList: [User] = []
    
    
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
    
    lazy var warningContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.mainColor.cgColor
        view.layer.cornerRadius = SPACE_XS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var warningImageView: UIImageView = {
        let img = UIImage(systemName: "exclamationmark.circle.fill")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .mainColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var warningLabel: UILabel = {
        let label = UILabel()

        let attrString = NSMutableAttributedString()
            .thin("[", fontSize: 14)
            .bold("내 위치 주변 탐색", fontSize: 14)
            .thin(" / ", fontSize: 14)
            .bold("지역으로 찾기", fontSize: 14)
            .thin(" / ", fontSize: 14)
            .bold("지도에서 찾기", fontSize: 14)
            .thin("] 기능은 픽이 ", fontSize: 14)
            .bold("1개 이상", fontSize: 14)
            .thin(" 게시된 플레이스만 찾을 수 있습니다.", fontSize: 14)

        label.attributedText = attrString
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: SPACE_XXS)
        label.textColor = .mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var searchPlaceGPSIconButton: IconButton = {
        let ib = IconButton(type: UIButton.ButtonType.system)
        ib.text = "내 위치 주변 탐색"
        ib.icon = "scope"
        ib.addTarget(self, action: #selector(gpsTapped), for: UIControl.Event.touchUpInside)
        return ib
    }()
    lazy var searchPlaceLocationIconButton: IconButton = {
        let ib = IconButton(type: UIButton.ButtonType.system)
        ib.text = "지역으로 찾기"
        ib.icon = "location"
        ib.addTarget(self, action: #selector(locationTapped), for: UIControl.Event.touchUpInside)
        return ib
    }()
    lazy var searchPlaceMapIconButton: IconButton = {
        let ib = IconButton(type: UIButton.ButtonType.system)
        ib.text = "지도에서 찾기"
        ib.icon = "map"
        ib.addTarget(self, action: #selector(mapTapped), for: UIControl.Event.touchUpInside)
        return ib
    }()
    
    lazy var recentPlaceTitleView: TitleView = {
        let tv = TitleView(text: "최근 본 플레이스", style: .ultraSmall, isAction: true, actionText: "모두 삭제", actionMode: "REMOVE_RECENT_PLACES")
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
        let tv = TitleView(text: "다른사람", style: .large)
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
        let tv = TitleView(text: "최근 본 다른사람", style: .ultraSmall, isAction: true, actionText: "모두 삭제", actionMode: "REMOVE_RECENT_USERS")
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
    }
    
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainVC?.title = "검색"
        if mainVC?.navigationItem.leftBarButtonItem != nil { mainVC?.navigationItem.leftBarButtonItem = nil }
        if mainVC?.navigationItem.rightBarButtonItem != nil { mainVC?.navigationItem.rightBarButtonItem = nil }
        
        recentPlaceList = app.getRecentPlaceList().reversed()
        recentPlaceCollectionView.reloadData()
        
        recentUserList = app.getRecentUserList().reversed()
        recentUserCollectionView.reloadData()
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
        
        searchPlaceContainerView.addSubview(warningContainerView)
        warningContainerView.topAnchor.constraint(equalTo: searchPlaceKeywordIconButton.bottomAnchor, constant: SPACE_L).isActive = true
        warningContainerView.leadingAnchor.constraint(equalTo: searchPlaceContainerView.leadingAnchor).isActive = true
        warningContainerView.trailingAnchor.constraint(equalTo: searchPlaceContainerView.trailingAnchor).isActive = true

        warningContainerView.addSubview(warningImageView)
        warningImageView.leadingAnchor.constraint(equalTo: warningContainerView.leadingAnchor, constant: SPACE).isActive = true
        warningImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        warningImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true

        warningContainerView.addSubview(warningLabel)
        warningLabel.topAnchor.constraint(equalTo: warningContainerView.topAnchor, constant: SPACE_XS).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: warningImageView.trailingAnchor, constant: SPACE_S).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: warningContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        warningLabel.bottomAnchor.constraint(equalTo: warningContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true

        warningImageView.centerYAnchor.constraint(equalTo: warningLabel.centerYAnchor).isActive = true
        
        searchPlaceContainerView.addSubview(searchPlaceGPSIconButton)
        searchPlaceGPSIconButton.topAnchor.constraint(equalTo: warningContainerView.bottomAnchor, constant: SPACE_S).isActive = true
//        searchPlaceGPSIconButton.topAnchor.constraint(equalTo: searchPlaceKeywordIconButton.bottomAnchor, constant: SPACE_S).isActive = true
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
            let coord = location.coordinate
            let lat = coord.latitude
            let lng = coord.longitude
            app.setLatitude(latitude: String(lat))
            app.setLongitude(longitude: String(lng))
            
            let searchPlaceVC = SearchPlaceViewController()
            searchPlaceVC.latitude = String(lat)
            searchPlaceVC.longitude = String(lng)
            searchPlaceVC.mode = "COORD"
            navigationController?.pushViewController(searchPlaceVC, animated: true)
        }
    }
    
    @objc func locationTapped() {
        let locationVC = LocationViewController()
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @objc func mapTapped() {
        let searchPlaceMapVC = SearchPlaceMapViewController()
        navigationController?.pushViewController(searchPlaceMapVC, animated: true)
    }
}


// MARK: TitleView
extension SearchViewController: TitleViewProtocol {
    func action(actionMode: String) {
        if actionMode == "REMOVE_RECENT_PLACES" {
            app.removeAllRecentPlaceList()
            recentPlaceList.removeAll()
            recentPlaceCollectionView.reloadData()
            
        } else if actionMode == "REMOVE_RECENT_USERS" {
            app.removeAllRecentUserList()
            recentUserList.removeAll()
            recentUserCollectionView.reloadData()
        }
    }
}

// MARK: CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recentPlaceCollectionView {
            if recentPlaceList.count > 0 {
                collectionView.backgroundView = nil
            } else {
                let bgView = UIView()
                
                let label = UILabel()
                label.text = "최근 본 플레이스가 없습니다."
                label.font = UIFont.systemFont(ofSize: 14)
                label.textColor = .systemGray
                label.translatesAutoresizingMaskIntoConstraints = false
                
                bgView.addSubview(label)
                label.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
                
                collectionView.backgroundView = bgView
            }
            return recentPlaceList.count
            
        } else {
            if recentUserList.count > 0 {
                collectionView.backgroundView = nil
            } else {
                let bgView = UIView()
                
                let label = UILabel()
                label.text = "최근 본 다른사람이 없습니다."
                label.font = UIFont.systemFont(ofSize: 14)
                label.textColor = .systemGray
                label.translatesAutoresizingMaskIntoConstraints = false
                
                bgView.addSubview(label)
                label.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
                
                collectionView.backgroundView = bgView
            }
            return recentUserList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recentPlaceCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCVCell", for: indexPath) as! PlaceCVCell
            cell.place = recentPlaceList[indexPath.row]
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCVCell", for: indexPath) as! UserCVCell
            cell.user = recentUserList[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recentPlaceCollectionView {
            return CGSize(width: placeSlideWidth, height: placeSlideWidth)
        } else {
            return CGSize(width: view.frame.width * 0.3, height: userSlideHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recentPlaceCollectionView {
            let placeVC = PlaceViewController(place: recentPlaceList[indexPath.row])
            navigationController?.pushViewController(placeVC, animated: true)
        } else {
            let accountVC = AccountViewController(uId: recentUserList[indexPath.row].id)
            present(UINavigationController(rootViewController: accountVC), animated: true, completion: nil)
        }
    }
}
