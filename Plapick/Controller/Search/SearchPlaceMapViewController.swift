//
//  SearchPlaceMapViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/02.
//

import UIKit
import NMapsMap
import CoreLocation


class SearchPlaceMapViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let locationManager = CLLocationManager()
    var currentKeyword: String = ""
    var tableViewBottomCons: NSLayoutConstraint?
    var kakaoPlaceList: [KakaoPlace] = []
    let getKakaoPlacesRequest = GetKakaoPlacesRequest()
    
    
    // MARK: View
    lazy var mapView: NMFMapView = {
        let nmv = NMFMapView()
        nmv.allowsRotating = false
        nmv.allowsTilting = false
        nmv.logoInteractionEnabled = false
        nmv.translatesAutoresizingMaskIntoConstraints = false
        return nmv
    }()
    
    lazy var gpsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = SPACE_XS
        view.layer.shadowOpacity = 0.3 // 그림자 진한정도?
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0) // 그림자 방향?
        view.layer.shadowRadius = SPACE_XS
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gpsTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var gpsImageView: UIImageView = {
        let img = UIImage(systemName: "scope")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var centerImageView: UIImageView = {
        let img = UIImage(systemName: "cursorarrow.click")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = SPACE_XS
        button.layer.shadowOpacity = 0.3 // 그림자 진한정도?
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0) // 그림자 방향?
        button.layer.shadowRadius = SPACE_XS
        button.setTitle("이 위치에서 찾기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.contentEdgeInsets = UIEdgeInsets(top: (SPACE_S + 2), left: 0, bottom: (SPACE_S + 2), right: 0)
        button.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(KakaoPlaceTVCell.self, forCellReuseIdentifier: "KakaoPlaceTVCell")
        tv.separatorInset.left = SPACE
        tv.tableFooterView = UIView(frame: CGRect.zero) // 빈 셀 안보이게
        tv.isHidden = true
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.title = "지도에서 찾기"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 해도 검색창 안사라지게
        
        configureView()
        
        getKakaoPlacesRequest.delegate = self
        
        let latitude = app.getLatitude()
        let longitude = app.getLongitude()
        guard let lat = Double(latitude) else { return }
        guard let lng = Double(longitude) else { return }
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        DispatchQueue.main.async {
            self.mapView.moveCamera(cameraUpdate)
        }
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        view.addSubview(gpsView)
        gpsView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: SPACE_XS).isActive = true
        gpsView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        gpsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        gpsView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -SPACE_XS).isActive = true

        gpsView.addSubview(gpsImageView)
        gpsImageView.topAnchor.constraint(equalTo: gpsView.topAnchor, constant: SPACE_XS + 1).isActive = true
        gpsImageView.leadingAnchor.constraint(equalTo: gpsView.leadingAnchor, constant: SPACE_XS + 1).isActive = true
        gpsImageView.trailingAnchor.constraint(equalTo: gpsView.trailingAnchor, constant: -(SPACE_XS + 1)).isActive = true
        gpsImageView.bottomAnchor.constraint(equalTo: gpsView.bottomAnchor, constant: -(SPACE_XS + 1)).isActive = true

        view.addSubview(centerImageView)
        centerImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        centerImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor).isActive = true
        centerImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        centerImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(searchButton)
        searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(SCREEN_WIDTH * 0.1)).isActive = true
        searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XXXXXXS).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewBottomCons = tableView.bottomAnchor.constraint(equalTo: mapView.topAnchor)
        tableViewBottomCons?.isActive = true
    }
    
    // MARK: Function - @OBJC
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
            
            let locationOverlay = mapView.locationOverlay
            locationOverlay.hidden = false
            locationOverlay.location = NMGLatLng(lat: lat, lng: lng)
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
            cameraUpdate.animation = .fly
            cameraUpdate.animationDuration = 1
            mapView.moveCamera(cameraUpdate)
        }
    }
    
    @objc func searchTapped() {
        let searchPlaceVC = SearchPlaceViewController()
        searchPlaceVC.latitude = String(mapView.cameraPosition.target.lat)
        searchPlaceVC.longitude = String(mapView.cameraPosition.target.lng)
        searchPlaceVC.mode = "COORD"
        navigationController?.pushViewController(searchPlaceVC, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // MARK: For DEV_DEBUG
        currentKeyword = "가평"
        navigationItem.searchController?.searchBar.text = "가평"
        getKakaoPlacesRequest.fetch(vc: self, paramDict: ["keyword": "가평"])
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.isHidden = false
            tableViewBottomCons?.isActive = false
            tableViewBottomCons = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height)
            tableViewBottomCons?.isActive = true
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        tableViewBottomCons?.isActive = false
        tableViewBottomCons = tableView.bottomAnchor.constraint(equalTo: mapView.topAnchor)
        tableViewBottomCons?.isActive = true
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.kakaoPlaceList.removeAll()
            self.tableView.reloadData()
            self.tableView.isHidden = true
        })
    }
}


// MARK: SearchBar
extension SearchPlaceMapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 2자 이상 (영어는 4자)
        if keyword.utf8.count < 4 {
            return
        }
        
        // 한글 Char 거르기
        let wordList = Array(keyword)
        for word in wordList {
            if KOR_CHAR_LIST.contains(word) {
                return
            }
        }
        
        // 이미 검색한 키워드 (리스트에 뿌려놓음)
        if currentKeyword == keyword { return }
        
        currentKeyword = keyword
        getKakaoPlacesRequest.fetch(vc: self, paramDict: ["keyword": keyword])
    }
}

// MARK: TableView
extension SearchPlaceMapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if kakaoPlaceList.count > 0 {
            tableView.backgroundView = nil
        } else {
            let bgView = UIView()
            
            let label = UILabel()
            label.text = "검색 결과가 없습니다."
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .systemGray
            label.translatesAutoresizingMaskIntoConstraints = false
            
            bgView.addSubview(label)
            label.topAnchor.constraint(equalTo: bgView.topAnchor, constant: SCREEN_WIDTH / 2).isActive = true
            label.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
            
            tableView.backgroundView = bgView
        }
        
        return kakaoPlaceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KakaoPlaceTVCell", for: indexPath) as! KakaoPlaceTVCell
        cell.selectionStyle = .none
        cell.kakaoPlace = kakaoPlaceList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32 + (SPACE_S * 2) + SPACE_XS
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32 + (SPACE_S * 2) + SPACE_XS
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.searchController?.isActive = false
        
        let kakaoPlace = kakaoPlaceList[indexPath.row]
        guard let lat = Double(kakaoPlace.latitude) else { return }
        guard let lng = Double(kakaoPlace.longitude) else { return }
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        mapView.moveCamera(cameraUpdate)
    }
}

// MARK: HTTP - GetKakaoPlaces
extension SearchPlaceMapViewController: GetKakaoPlacesRequestProtocol {
    func response(kakaoPlaceList: [KakaoPlace]?, getKakaoPlaces status: String) {
        if status == "OK" {
            guard let kakaoPlaceList = kakaoPlaceList else { return }
            self.kakaoPlaceList = kakaoPlaceList
            tableView.reloadData()
        }
    }
}
