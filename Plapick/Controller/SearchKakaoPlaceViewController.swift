//
//  SearchKakaoPlaceViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/26.
//

import UIKit


protocol SearchKakaoPlaceViewControllerProtocol {
    func selectPlace(place: Place?)
}


class SearchKakaoPlaceViewController: UIViewController {
    
    // MARK: Property
    var delegate: SearchKakaoPlaceViewControllerProtocol?
    var prevVC: UIViewController?
    var currentKeyword: String = ""
    var isSelectPlace: Bool = false
    
    // MARK: Property - Request
    let getKakaoPlacesRequest = GetKakaoPlacesRequest()
    let likePlaceRequest = LikePlaceRequest()
//    let addPlaceRequest = AddPlaceRequest()
    
    // MARK: Property - View
    var placeList: [Place] = []
    var placeSmallViewList: [PlaceSmallView] = []
    
    
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
    
    lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    // MARK: View - Indicator
//    lazy var indicatorView: UIActivityIndicatorView = {
//        let aiv = UIActivityIndicatorView()
//        aiv.style = .large
//        aiv.translatesAutoresizingMaskIntoConstraints = false
//        return aiv
//    }()
//    lazy var blurOverlayView: UIVisualEffectView = {
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
//        let vev = UIVisualEffectView(effect: blurEffect)
//        vev.alpha = 0.3
//        vev.translatesAutoresizingMaskIntoConstraints = false
//        return vev
//    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "플레이스 검색"
        
        if let vcCnt = navigationController?.viewControllers.count {
            prevVC = self.navigationController?.viewControllers[vcCnt-2]
        }
        
        let searchController = UISearchController(searchResultsController: nil)
        // 커서 올리면 네비게이션 숨는거 안되게 (취소 눌러야 다시 생김)
//        searchController.hidesNavigationBarDuringPresentation = false
        // 이거 안하면 커서 올라간 상태에서 화면 누르면 검색어 사라짐
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 해도 검색창 안사라지게
        
        configureView()
        
        setEmptyView()
        
        getKakaoPlacesRequest.delegate = self
//        likePlaceRequest.delegate = self
//        addPlaceRequest.delegate = self
        
        // MARK: For DEV_DEBUG
        currentKeyword = "가평"
        navigationItem.searchController?.searchBar.text = "가평"
        getKakaoPlacesRequest.fetch(vc: self, paramDict: ["keyword": "가평"])
    }
    
    
    // MARK: ViewDidDisapear
    override func viewDidDisappear(_ animated: Bool) {
        if !isSelectPlace {
            delegate?.selectPlace(place: nil)
        }
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
    }
    
    func setEmptyView() {
        contentView.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        emptyView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
}


// MARK: Extension
extension SearchKakaoPlaceViewController: UISearchBarDelegate {
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


extension SearchKakaoPlaceViewController: GetKakaoPlacesRequestProtocol {
    func response(placeList: [Place]?, getKakaoPlaces status: String) {
        if status == "OK" {
            if let placeList = placeList {
                contentView.removeAllChildView()
                self.placeList = placeList
                placeSmallViewList.removeAll()
                
                if placeList.count > 0 {
                    for (i, place) in placeList.enumerated() {
                        let psv = PlaceSmallView()
                        psv.index = i
                        psv.place = place
                        psv.delegate = self
                        
                        contentView.addSubview(psv)
                        psv.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
                        psv.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
                        if i == 0 {
                            psv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SPACE_XL).isActive = true
                        } else {
                            psv.topAnchor.constraint(equalTo: contentView.subviews[contentView.subviews.count - 2].bottomAnchor, constant: SPACE_XL).isActive = true
                        }
                        if i == placeList.count - 1 {
                            psv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SPACE_XL).isActive = true
                        }
                        
                        placeSmallViewList.append(psv)
                    }
                } else {
                    setEmptyView()
                }
            }
        }
    }
}


extension SearchKakaoPlaceViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let _ = navigationItem.searchController?.searchBar.isFirstResponder {
            navigationItem.searchController?.searchBar.resignFirstResponder()
        }
    }
}


extension SearchKakaoPlaceViewController: PlaceSmallViewProtocol {
    func openPlace(place: Place) {
        if let _ = navigationItem.searchController?.searchBar.isFirstResponder {
            navigationItem.searchController?.searchBar.resignFirstResponder()
        }

        if prevVC is PostingViewController {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
            alert.addAction(UIAlertAction(title: "선택", style: UIAlertAction.Style.default, handler: { (_) in
                self.isSelectPlace = true
                
//                if place.id == 0 {
//                    self.showIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
//                    self.addPlaceRequest.fetch(vc: self, paramDict: ["kId": String(place.kId), "name": place.name ?? "", "categoryName": place.categoryName ?? "", "categoryGroupCode": place.categoryGroupCode ?? "", "categoryGroupName": place.categoryGroupName ?? "", "address": place.address ?? "", "roadAddress": place.roadAddress ?? "", "latitude": place.latitude ?? "", "longitude": place.longitude ?? "", "phone": place.phone ?? ""])
//
//                } else {
                    self.delegate?.selectPlace(place: place)
                    self.navigationController?.popViewController(animated: true)
//                }
            }))
            alert.addAction(UIAlertAction(title: "자세히 보기", style: UIAlertAction.Style.default, handler: { (_) in
                
            }))
            present(alert, animated: true)
            
        } else {
            print("ff")
        }
    }
        
    
//    func likePlace(place: Place) {
//        if let _ = navigationItem.searchController?.searchBar.isFirstResponder {
//            navigationItem.searchController?.searchBar.resignFirstResponder()
//        }
//
//        // 등록되어있지 않은 플레이스, 등록 필요함
//        if place.id == 0 {
//            showIndicator(idv: indicatorView, bov: blurOverlayView)
//            addPlaceRequest.fetch(vc: self, paramDict: ["kId": String(place.kId), "name": place.name ?? "", "categoryName": place.categoryName ?? "", "categoryGroupCode": place.categoryGroupCode ?? "", "categoryGroupName": place.categoryGroupName ?? "", "address": place.address ?? "", "roadAddress": place.roadAddress ?? "", "latitude": place.latitude ?? "", "longitude": place.longitude ?? "", "phone": place.phone ?? ""])
//            return
//        }
//
//        likePlaceRequest.fetch(paramDict: ["pId": String(place.id)])
//    }
//
//    func openAllComments(place: Place) {
//        if let _ = navigationItem.searchController?.searchBar.isFirstResponder {
//            navigationItem.searchController?.searchBar.resignFirstResponder()
//        }
//
//        print("openAllComments", place.id)
//    }
//
//    func openAllPicks(place: Place) {
//        if let _ = navigationItem.searchController?.searchBar.isFirstResponder {
//            navigationItem.searchController?.searchBar.resignFirstResponder()
//        }
//
//        print("openAllPicks", place.id)
//    }
}


//extension SearchKakaoPlaceViewController: LikePlaceRequestProtocol {
//    func response(likePlace status: String) {
//        // nothing to do
//    }
//}


//extension SearchKakaoPlaceViewController: AddPlaceRequestProtocol {
//    func response(place: Place?, addPlace status: String) {
//        hideIndicator(idv: indicatorView, bov: blurOverlayView)
//        if status == "OK" {
//            if let place = place {
//                delegate?.selectPlace(place: place)
//                navigationController?.popViewController(animated: true)
//
////                for (i, _place) in placeList.enumerated() {
////                    if _place.kId == place.kId {
////                        placeSmallViewList[i].isAllowChangeCnt = false
////                        placeSmallViewList[i].place = place
////                        break
////                    }
////                }
////                likePlaceRequest.fetch(paramDict: ["pId": String(place.id)])
//            }
//        }
//    }
//}
