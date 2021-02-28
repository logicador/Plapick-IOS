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
    var kakaoPlaceList: [KakaoPlace] = []
    let getKakaoPlacesRequest = GetKakaoPlacesRequest()
    
    
    // MARK: View
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView()
        sv.backgroundColor = .systemBackground
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var bottomStackTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.setTitle("이 위치에서 찾기", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_S, left: 0, bottom: SPACE_S, right: 0)
        button.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        view.layer.borderWidth = LINE_WIDTH
        view.layer.cornerRadius = SPACE_XS
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gpsTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var gpsImageView: UIImageView = {
        let image = UIImage(systemName: "scope")
        let iv = UIImageView(image: image)
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
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(KakaoPlaceTVCell.self, forCellReuseIdentifier: "KakaoPlaceTVCell")
        tv.separatorInset.left = SPACE
        tv.tableFooterView = UIView(frame: .zero) // 빈 셀 안보이게
        tv.isHidden = true
        tv.alpha = 0
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
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 해도 검색창 안사라지게
        
        configureView()
        
        setThemeColor()
        
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
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() { gpsView.layer.borderColor = UIColor.separator.cgColor }
    
    func configureView() {
        view.addSubview(bottomStackView)
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(bottomStackTopLine)
        bottomStackTopLine.topAnchor.constraint(equalTo: bottomStackView.topAnchor).isActive = true
        bottomStackTopLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomStackTopLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bottomStackView.addArrangedSubview(searchButton)
        searchButton.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
        
        bottomStackView.addArrangedSubview(bottomContainerView)
        bottomContainerView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
        bottomContainerView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
        bottomContainerView.heightAnchor.constraint(equalToConstant: BOTTOM_SPACING).isActive = true
        
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor).isActive = true

        view.addSubview(gpsView)
        gpsView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: SPACE_XS).isActive = true
        gpsView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        gpsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        gpsView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -SPACE_XS).isActive = true

        gpsView.addSubview(gpsImageView)
        gpsImageView.topAnchor.constraint(equalTo: gpsView.topAnchor, constant: 12).isActive = true
        gpsImageView.leadingAnchor.constraint(equalTo: gpsView.leadingAnchor, constant: 12).isActive = true
        gpsImageView.trailingAnchor.constraint(equalTo: gpsView.trailingAnchor, constant: -12).isActive = true
        gpsImageView.bottomAnchor.constraint(equalTo: gpsView.bottomAnchor, constant: -12).isActive = true

        view.addSubview(centerImageView)
        centerImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        centerImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor).isActive = true
        centerImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        centerImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
}


// MARK: SearchBar
extension SearchPlaceMapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if keyword.count < 2 { return }
        
        // 한글 Char 거르기
        let wordList = Array(keyword)
        for word in wordList {
            if KOR_CHAR_LIST.contains(word) { return }
        }
        
        // 이미 검색한 키워드 (리스트에 뿌려놓음)
        if currentKeyword == keyword { return }
        
        currentKeyword = keyword
        getKakaoPlacesRequest.fetch(vc: self, paramDict: ["keyword": keyword])
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.alpha = 1
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.alpha = 0
        }, completion: { (_) in
            self.tableView.isHidden = true
            self.kakaoPlaceList.removeAll()
            self.tableView.reloadData()
            self.currentKeyword = ""
        })
    }
}

// MARK: TableView
extension SearchPlaceMapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if kakaoPlaceList.count > 0 { tableView.backgroundView = nil }
        else {
            let bgView = UIView()
            
            let label = UILabel()
            label.text = "검색 결과가 없습니다."
            label.font = .systemFont(ofSize: 14)
            label.textColor = .systemGray
            label.translatesAutoresizingMaskIntoConstraints = false
            
            bgView.addSubview(label)
            label.topAnchor.constraint(equalTo: bgView.topAnchor, constant: SPACE_XXL).isActive = true
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
        dismissKeyboard()
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.alpha = 0
        }, completion: { (_) in
            self.tableView.isHidden = true
        })
        
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
        print("[HTTP RES]", getKakaoPlacesRequest.apiUrl, status)
        
        if status == "OK" {
            guard let kakaoPlaceList = kakaoPlaceList else { return }
            self.kakaoPlaceList = kakaoPlaceList
            tableView.reloadData()
        }
    }
}
