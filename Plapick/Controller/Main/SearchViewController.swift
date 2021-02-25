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
    let app = App()
    let locationManager = CLLocationManager()
    let placeSlideWidth: CGFloat = (SCREEN_WIDTH / 3) - (2 / 3) + (SPACE_XXS * 2)
    let userSlideHeight: CGFloat = 40 + 12 + (SPACE_XS * 3)
    var recentPlaceList: [Place] = []
    var recentUserList: [User] = []
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Place
    lazy var searchPlaceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "플레이스"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var searchPlaceStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_S
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var searchPlaceKeywordIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "키워드로 검색"
        ib.icon = "keyboard"
        ib.addTarget(self, action: #selector(searchPlaceKeywordTapped), for: .touchUpInside)
        return ib
    }()
    
    // MARK: View - Place - Warning
    lazy var warningContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = LINE_WIDTH
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
        label.font = .systemFont(ofSize: 12)
        label.text = "'내위치주변탐색' '지역으로찾기' '지도에서찾기' 기능은 '플레픽' 데이터베이스에 등록된 플레이스들만 찾을 수 있습니다.\n\n더 많은 검색 결과를 원하신다면 '키워드로 검색' 기능을 이용해주세요!"
//        let mabs = NSMutableAttributedString()
//            .bold("[내 위치 주변 탐색 / 지역으로 찾기 / 지도에서 찾기] ", fontSize: 12)
//            .normal("기능은 픽이", fontSize: 12)
//            .bold(" 1개 이상 ", fontSize: 12)
//            .normal("게시된 플레이스만 찾을 수 있습니다.", fontSize: 12)
//        label.attributedText = mabs
        label.numberOfLines = 0
//        label.setLineSpacing(lineSpacing: SPACE_XXS)
        label.textColor = .mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var searchPlaceGPSIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "내 위치 주변 탐색"
        ib.icon = "scope"
        ib.addTarget(self, action: #selector(searchPlaceGpsTapped), for: .touchUpInside)
        return ib
    }()
    lazy var searchPlaceLocationIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "지역으로 찾기"
        ib.icon = "location"
        ib.addTarget(self, action: #selector(searchPlaceLocationTapped), for: .touchUpInside)
        return ib
    }()
    lazy var searchPlaceMapIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "지도에서 찾기"
        ib.icon = "map"
        ib.addTarget(self, action: #selector(searchPlaceMapTapped), for: .touchUpInside)
        return ib
    }()
    
    // MARK: View - Place - Recent
    lazy var recentPlaceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 본 플레이스"
        label.font = .boldSystemFont(ofSize: 22)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var removeAllRecentPlaceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("모두 삭제", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(removeAllRecentPlaceTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var recentPlaceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceHorizontal = true
        cv.backgroundColor = .systemBackground
        cv.register(PlaceCVCell.self, forCellWithReuseIdentifier: "PlaceCVCell")
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: View - User
    lazy var searchUserTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "다른사람"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var searchUserNickNameIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "닉네임으로 검색"
        ib.icon = "person.2"
        ib.addTarget(self, action: #selector(searchUserNickNameTapped), for: .touchUpInside)
        return ib
    }()
    
    // MARK: View - User - Recent
    lazy var recentUserTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 본 다른사람"
        label.font = .boldSystemFont(ofSize: 22)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var removeAllRecentUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("모두 삭제", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(removeAllRecentUserTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var recentUserCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.alwaysBounceHorizontal = true
        cv.backgroundColor = .systemBackground
        cv.showsHorizontalScrollIndicator = false
        cv.register(UserCVCell.self, forCellWithReuseIdentifier: "UserCVCell")
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
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
        
        recentPlaceList = app.getRecentPlaceList().reversed()
        recentUserList = app.getRecentUserList().reversed()
        recentPlaceCollectionView.reloadData()
        recentUserCollectionView.reloadData()
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_XL).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        // MARK: ConfigureView - Place
        stackView.addArrangedSubview(searchPlaceTitleLabel)
        searchPlaceTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        searchPlaceTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        stackView.addArrangedSubview(searchPlaceStackView)
        searchPlaceStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        searchPlaceStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        searchPlaceStackView.addArrangedSubview(searchPlaceKeywordIconButton)
        searchPlaceKeywordIconButton.leadingAnchor.constraint(equalTo: searchPlaceStackView.leadingAnchor).isActive = true
        searchPlaceKeywordIconButton.trailingAnchor.constraint(equalTo: searchPlaceStackView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Place - Warning
        searchPlaceStackView.addArrangedSubview(warningContainerView)
        warningContainerView.leadingAnchor.constraint(equalTo: searchPlaceStackView.leadingAnchor).isActive = true
        warningContainerView.trailingAnchor.constraint(equalTo: searchPlaceStackView.trailingAnchor).isActive = true
        
        warningContainerView.addSubview(warningImageView)
        warningImageView.centerYAnchor.constraint(equalTo: warningContainerView.centerYAnchor).isActive = true
        warningImageView.leadingAnchor.constraint(equalTo: warningContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        warningImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        warningImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true

        warningContainerView.addSubview(warningLabel)
        warningLabel.topAnchor.constraint(equalTo: warningContainerView.topAnchor, constant: SPACE_XS).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: warningContainerView.leadingAnchor, constant: SPACE_S + 22 + SPACE_S).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: warningContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        warningLabel.bottomAnchor.constraint(equalTo: warningContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        searchPlaceStackView.addArrangedSubview(searchPlaceGPSIconButton)
        searchPlaceGPSIconButton.leadingAnchor.constraint(equalTo: searchPlaceStackView.leadingAnchor).isActive = true
        searchPlaceGPSIconButton.trailingAnchor.constraint(equalTo: searchPlaceStackView.trailingAnchor).isActive = true
        
        searchPlaceStackView.addArrangedSubview(searchPlaceLocationIconButton)
        searchPlaceLocationIconButton.leadingAnchor.constraint(equalTo: searchPlaceStackView.leadingAnchor).isActive = true
        searchPlaceLocationIconButton.trailingAnchor.constraint(equalTo: searchPlaceStackView.trailingAnchor).isActive = true
        
        searchPlaceStackView.addArrangedSubview(searchPlaceMapIconButton)
        searchPlaceMapIconButton.leadingAnchor.constraint(equalTo: searchPlaceStackView.leadingAnchor).isActive = true
        searchPlaceMapIconButton.trailingAnchor.constraint(equalTo: searchPlaceStackView.trailingAnchor).isActive = true
        
        // MARK: View - Place - Recent
        stackView.addArrangedSubview(recentPlaceTitleLabel)
        recentPlaceTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        recentPlaceTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        recentPlaceTitleLabel.addSubview(removeAllRecentPlaceButton)
        removeAllRecentPlaceButton.centerYAnchor.constraint(equalTo: recentPlaceTitleLabel.centerYAnchor).isActive = true
        removeAllRecentPlaceButton.trailingAnchor.constraint(equalTo: recentPlaceTitleLabel.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(recentPlaceCollectionView)
        recentPlaceCollectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        recentPlaceCollectionView.heightAnchor.constraint(equalToConstant: placeSlideWidth).isActive = true
        recentPlaceCollectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - User
        stackView.addArrangedSubview(searchUserTitleLabel)
        searchUserTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        searchUserTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        stackView.addArrangedSubview(searchUserNickNameIconButton)
        searchUserNickNameIconButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        searchUserNickNameIconButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        // MARK: ConfigureView - User - Recent
        stackView.addArrangedSubview(recentUserTitleLabel)
        recentUserTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        recentUserTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        recentUserTitleLabel.addSubview(removeAllRecentUserButton)
        removeAllRecentUserButton.centerYAnchor.constraint(equalTo: recentUserTitleLabel.centerYAnchor).isActive = true
        removeAllRecentUserButton.trailingAnchor.constraint(equalTo: recentUserTitleLabel.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(recentUserCollectionView)
        recentUserCollectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        recentUserCollectionView.heightAnchor.constraint(equalToConstant: userSlideHeight).isActive = true
        recentUserCollectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func searchPlaceKeywordTapped() {
        let searchPlaceVC = SearchPlaceViewController()
        searchPlaceVC.mode = "KEYWORD"
        navigationController?.pushViewController(searchPlaceVC, animated: true)
    }
    
    @objc func searchPlaceGpsTapped() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            
        } else if status == .restricted || status == .denied {
            requestSettingAlert(title: "위치 액세스 허용하기", message: "'플레픽'에서 사용자의 위치에 접근하고자 합니다.")
            
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            guard let location = locationManager.location else {
                let alert = UIAlertController(title: "위치정보", message: "사용자의 위치 정보를 가져올 수 없습니다. 다시 시도해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
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
    
    @objc func searchPlaceLocationTapped() {
        let searchPlacelocationVC = SearchPlaceLocationViewController()
        navigationController?.pushViewController(searchPlacelocationVC, animated: true)
    }
    
    @objc func searchPlaceMapTapped() {
        let searchPlaceMapVC = SearchPlaceMapViewController()
        navigationController?.pushViewController(searchPlaceMapVC, animated: true)
    }
    
    @objc func removeAllRecentPlaceTapped() {
        app.removeAllRecentPlaceList()
        recentPlaceList.removeAll()
        recentPlaceCollectionView.reloadData()
    }
    
    @objc func searchUserNickNameTapped() {
        let searchUserVC = SearchUserViewController()
        searchUserVC.mode = "KEYWORD"
        navigationController?.pushViewController(searchUserVC, animated: true)
    }
    
    @objc func removeAllRecentUserTapped() {
        app.removeAllRecentUserList()
        recentUserList.removeAll()
        recentUserCollectionView.reloadData()
    }
}

// MARK: CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == recentPlaceCollectionView {
            if recentPlaceList.count > 0 { collectionView.backgroundView = nil }
            else {
                let bgView = UIView()
                
                let view = UIView()
                view.layer.cornerRadius = SPACE_XS
                view.backgroundColor = .systemGray6
                view.translatesAutoresizingMaskIntoConstraints = false
                bgView.addSubview(view)
                view.topAnchor.constraint(equalTo: bgView.topAnchor).isActive = true
                view.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
                view.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
                view.bottomAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
                
                let label = UILabel()
                label.text = "최근 본 플레이스가 없습니다."
                label.font = .systemFont(ofSize: 14)
                label.textColor = .systemGray
                label.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(label)
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                
                collectionView.backgroundView = bgView
            }
            return recentPlaceList.count
            
        } else {
            if recentUserList.count > 0 { collectionView.backgroundView = nil }
            else {
                let bgView = UIView()
                
                let view = UIView()
                view.layer.cornerRadius = SPACE_XS
                view.backgroundColor = .systemGray6
                view.translatesAutoresizingMaskIntoConstraints = false
                bgView.addSubview(view)
                view.topAnchor.constraint(equalTo: bgView.topAnchor).isActive = true
                view.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
                view.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
                view.bottomAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
                
                let label = UILabel()
                label.text = "최근 본 다른사람이 없습니다."
                label.font = .systemFont(ofSize: 14)
                label.textColor = .systemGray
                label.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(label)
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                
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
        if collectionView == recentPlaceCollectionView { return CGSize(width: placeSlideWidth, height: placeSlideWidth) }
        else { return CGSize(width: view.frame.width * 0.3, height: userSlideHeight) }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == recentPlaceCollectionView {
            let placeVC = PlaceViewController()
            placeVC.place = recentPlaceList[indexPath.row]
            navigationController?.pushViewController(placeVC, animated: true)
            
        } else {
            let accountVC = AccountViewController()
            accountVC.user = recentUserList[indexPath.row]
            navigationController?.pushViewController(accountVC, animated: true)
        }
    }
}
