//
//  SearchPlaceViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/26.
//

import UIKit


protocol SearchPlaceViewControllerProtocol {
    func closeSearchPlaceVC(place: Place?)
}


class SearchPlaceViewController: UIViewController {
    
    // MARK: Property
    var delegate: SearchPlaceViewControllerProtocol?
    var prevVC: UIViewController?
    var currentKeyword: String = ""
    var selectedPlace: Place?
    let getPlacesRequest = GetPlacesRequest()
    let likePlaceRequest = LikePlaceRequest()
    var isOpenedChildVC: Bool = false
    var paramDict: [String: String] = [:]
    var latitude: String?
    var longitude: String?
    var plocCode: String?
    var clocCode: String?
    var mode: String? {
        didSet {
            paramDict["mode"] = mode
            
            if mode == "KEYWORD" {
                navigationItem.title = "플레이스 검색"
                
                let searchController = UISearchController(searchResultsController: nil)
                searchController.automaticallyShowsCancelButton = false
                // 커서 올리면 네비게이션 숨는거 안되게 (취소 눌러야 다시 생김)
                searchController.hidesNavigationBarDuringPresentation = false
                // 이거 안하면 커서 올라간 상태에서 화면 누르면 검색어 사라짐
                searchController.obscuresBackgroundDuringPresentation = false
        //        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
                searchController.searchBar.placeholder = "검색어를 입력해주세요."
                searchController.searchBar.delegate = self

                navigationItem.searchController = searchController
                navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 해도 검색창 안사라지게
                
                // MARK: For DEV_DEBUG
                currentKeyword = "석모도"
                paramDict["keyword"] = "석모도"
                navigationItem.searchController?.searchBar.text = "석모도"
                getPlaces()
                
            } else if mode == "MY_LIKE_PLACE" {
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
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var placeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var noPlaceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "검색 결과가 없습니다."
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        isModalInPresentation = true
        
        if let vcCnt = navigationController?.viewControllers.count {
            prevVC = navigationController?.viewControllers[vcCnt - 2]
        }
        
        configureView()
        
        setThemeColor()
        
        getPlacesRequest.delegate = self
    }
    
    
    // 이거때매 AccountVC > PostingVC 날라감... 원인모름, 그다지 필요없는 기능이기때문에 폐기
//    // MARK: ViewDidAppear
//    override func viewDidAppear(_ animated: Bool) {
////        super.viewDidAppear(animated) // 이거 하면 becomeFirstResponder 안먹음
////        DispatchQueue.main.async {
////            self.navigationItem.searchController?.searchBar.becomeFirstResponder()
////        }
//    }
    
    
    // MARK: ViewDidDisapear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isOpenedChildVC {
            delegate?.closeSearchPlaceVC(place: selectedPlace)
        }
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setThemeColor()
    }
    func setThemeColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
    }
    
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
        
        contentView.addSubview(placeContainerView)
        placeContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        placeContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        placeContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        placeContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.addSubview(noPlaceLabel)
        noPlaceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: SCREEN_WIDTH / 2).isActive = true
        noPlaceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    func getPlaces() {
        getPlacesRequest.fetch(vc: self, paramDict: paramDict)
    }
}


// MARK: Extension - SearchBar
extension SearchPlaceViewController: UISearchBarDelegate {
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
        
        paramDict["keyword"] = keyword
        currentKeyword = keyword
        getPlaces()
    }
}

// MARK: Extension - GetPlace
extension SearchPlaceViewController: GetPlacesRequestProtocol {
    func response(placeList: [Place]?, getPlaces status: String) {
        if status == "OK" {
            if let placeList = placeList {
                placeContainerView.removeAllChildView()
                
                if placeList.count > 0 {
                    noPlaceLabel.isHidden = true
                    for (i, place) in placeList.enumerated() {
                        let pmv = PlaceMediumView()
                        pmv.index = i
                        pmv.place = place
                        pmv.delegate = self
                        
                        placeContainerView.addSubview(pmv)
                        pmv.centerXAnchor.constraint(equalTo: placeContainerView.centerXAnchor).isActive = true
                        pmv.widthAnchor.constraint(equalTo: placeContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
                        if i == 0 {
                            pmv.topAnchor.constraint(equalTo: placeContainerView.topAnchor, constant: SPACE_XXL).isActive = true
                        } else {
                            pmv.topAnchor.constraint(equalTo: placeContainerView.subviews[placeContainerView.subviews.count - 2].bottomAnchor, constant: SPACE_XXL).isActive = true
                        }
                        if i == placeList.count - 1 {
                            pmv.bottomAnchor.constraint(equalTo: placeContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
                        }
                    }
                    
                } else {
                    noPlaceLabel.isHidden = false
                }
            }
        }
    }
}

// MARK: Extension - ScrollView
extension SearchPlaceViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let _ = navigationItem.searchController?.searchBar.isFirstResponder {
            navigationItem.searchController?.searchBar.resignFirstResponder()
        }
    }
}

// MARK: Extension - PlaceMediumView
extension SearchPlaceViewController: PlaceMediumViewProtocol {
    func openPlace(place: Place) {
        if let _ = navigationItem.searchController?.searchBar.isFirstResponder {
            navigationItem.searchController?.searchBar.resignFirstResponder()
        }

        if prevVC is PostingViewController {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
            alert.addAction(UIAlertAction(title: "선택", style: UIAlertAction.Style.default, handler: { (_) in
                self.selectedPlace = place
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "자세히 보기", style: UIAlertAction.Style.default, handler: { (_) in
                self.isOpenedChildVC = true
                let placeVC = PlaceViewController(place: place)
                placeVC.delegate = self
                self.navigationController?.pushViewController(placeVC, animated: true)
            }))
            present(alert, animated: true)
            
        } else {
            isOpenedChildVC = true
            let placeVC = PlaceViewController(place: place)
            placeVC.delegate = self
            self.navigationController?.pushViewController(placeVC, animated: true)
        }
    }
}

// MARK: Extension - PlaceVC
extension SearchPlaceViewController: PlaceViewControllerProtocol {
    func closePlaceVC() {
        isOpenedChildVC = false
    }
    func reloadPlace() {
        getPlaces()
    }
}
