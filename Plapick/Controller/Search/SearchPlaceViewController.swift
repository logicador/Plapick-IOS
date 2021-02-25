//
//  SearchPlaceViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/26.
//

import UIKit


protocol SearchPlaceViewControllerProtocol {
    func selectPlace(place: Place)
}


class SearchPlaceViewController: UIViewController {
    
    // MARK: Property
    var delegate: SearchPlaceViewControllerProtocol?
    var prevVC: UIViewController?
    var currentKeyword: String = ""
    var selectedPlace: Place?
    let getPlacesRequest = GetPlacesRequest()
    let likePlaceRequest = LikePlaceRequest()
    var paramDict: [String: String] = [:]
    var latitude: String?
    var longitude: String?
    var plocCode: String?
    var clocCode: String?
    var user: User? {
        didSet {
            guard let user = self.user else { return }
            paramDict["uId"] = String(user.id)
        }
    }
    var mode: String? {
        didSet {
            paramDict["mode"] = mode
            
            if mode == "KEYWORD" {
                navigationItem.title = "플레이스 검색"
                
                let searchController = UISearchController(searchResultsController: nil)
                searchController.automaticallyShowsCancelButton = false
                searchController.hidesNavigationBarDuringPresentation = false
                searchController.obscuresBackgroundDuringPresentation = false
                searchController.searchBar.placeholder = "검색어를 입력해주세요."
                searchController.searchBar.delegate = self
                navigationItem.searchController = searchController
                navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 해도 검색창 안사라지게
                
                // MARK: For DEV_DEBUG
                currentKeyword = "가평"
                paramDict["keyword"] = "가평"
                navigationItem.searchController?.searchBar.text = "가평"
                getPlaces()
                
            } else if mode == "LIKE_PLACE" {
                navigationItem.title = "좋아요한 플레이스"
                getPlaces()
            
            } else if mode == "COORD" {
                navigationItem.title = "플레이스 검색"
                
                guard let latitude = self.latitude else { return }
                guard let longitude = self.longitude else { return }
                paramDict["latitude"] = latitude
                paramDict["longitude"] = longitude
                paramDict["zoom"] = "5"
                getPlaces()
                
            } else if mode == "LOCATION" {
                navigationItem.title = "플레이스 검색"
                
                guard let plocCode = self.plocCode else { return }
                guard let clocCode = self.clocCode else { return }
                paramDict["plocCode"] = plocCode
                paramDict["clocCode"] = clocCode
                getPlaces()
            }
        }
    }
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
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
    
    lazy var noPlaceContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noPlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "플레이스가 없습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        getPlacesRequest.delegate = self
        
        guard let vcCnt = navigationController?.viewControllers.count else { return }
        prevVC = navigationController?.viewControllers[vcCnt - 2]
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        stackView.addArrangedSubview(noPlaceContainerView)
        noPlaceContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        noPlaceContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        noPlaceContainerView.addSubview(noPlaceLabel)
        noPlaceLabel.topAnchor.constraint(equalTo: noPlaceContainerView.topAnchor, constant: SPACE_XL + SPACE_XS).isActive = true
        noPlaceLabel.centerXAnchor.constraint(equalTo: noPlaceContainerView.centerXAnchor).isActive = true
        noPlaceLabel.bottomAnchor.constraint(equalTo: noPlaceContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
    }
    
    func getPlaces() {
        getPlacesRequest.fetch(vc: self, paramDict: paramDict)
    }
}


// MARK: SearchBar
extension SearchPlaceViewController: UISearchBarDelegate {
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
        
        paramDict["keyword"] = keyword
        currentKeyword = keyword
        getPlaces()
    }
}

// MARK: HTTP - GetPlaces
extension SearchPlaceViewController: GetPlacesRequestProtocol {
    func response(placeList: [Place]?, getPlaces status: String) {
        print("[HTTP RES]", getPlacesRequest.apiUrl, status)
        
        if status == "OK" {
            guard let placeList = placeList else { return }
                
            for v in stackView.subviews {
                if v == noPlaceContainerView { continue }
                v.removeFromSuperview()
            }
            
            guard let prevVC = self.prevVC else { return }
            let isSelectButtonHidden = !(prevVC is PostingViewController)
        
            if placeList.count > 0 {
                noPlaceContainerView.isHidden = true
                
                for (i, place) in placeList.enumerated() {
                    let pv = PlaceView()
                    pv.vc = self
                    pv.place = place
                    pv.selectButton.isHidden = isSelectButtonHidden
                    pv.delegate = self
                    
                    stackView.addArrangedSubview(pv)
                    pv.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
                    pv.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
                    
                    if i > 0 {
                        let lv = LineView()
                        pv.addSubview(lv)
                        lv.topAnchor.constraint(equalTo: pv.topAnchor).isActive = true
                        lv.leadingAnchor.constraint(equalTo: pv.leadingAnchor).isActive = true
                        lv.trailingAnchor.constraint(equalTo: pv.trailingAnchor).isActive = true
                    }
                }
                
            } else { noPlaceContainerView.isHidden = false }
        }
    }
}

// MARK: PlaceView
extension SearchPlaceViewController: PlaceViewProtocol {
    func detailPlace(place: Place) {
        dismissKeyboard()
        let placeVC = PlaceViewController()
        placeVC.place = place
        placeVC.delegate = self
        navigationController?.pushViewController(placeVC, animated: true)
    }
    
    func selectPlace(place: Place) {
        dismissKeyboard()
        delegate?.selectPlace(place: place)
        navigationController?.popViewController(animated: true)
    }
    
    func detailPick(place: Place, piId: Int) {
        dismissKeyboard()
        
        let pickVC = PickViewController()
        pickVC.navigationItem.title = place.name
        pickVC.order = "POPULAR"
        pickVC.pId = place.id
        pickVC.id = piId
        navigationController?.pushViewController(pickVC, animated: true)
    }
}

// MARK: PlaceVC
extension SearchPlaceViewController: PlaceViewControllerProtocol {
    func likePlace() { getPlaces() }
    func addPlace() { getPlaces() }
    func addComment() { getPlaces() }
    func removeComment() { getPlaces() }
    func addPick() { getPlaces() }
}
