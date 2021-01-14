//
//  SearchPlaceViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/06.
//

import UIKit


protocol SearchPlaceViewControllerProtocol {
    func selectPlace(place: Place)
}


class SearchPlaceViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    var delegate: SearchPlaceViewControllerProtocol?
    var searchPlacesRequest = SearchPlacesRequest()
    var isSelectMode: Bool = false
    var searchPlaceViewList: [SearchPlaceView] = []
    var selectedSearchPlaceView: SearchPlaceView?
    
    
    // MARK: Views
    lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
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
    
    lazy var spaceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "플레이스 찾기"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.automaticallyShowsCancelButton = false  // 취소버튼 안보이게
//        searchController.hidesNavigationBarDuringPresentation = false  // 타이틀 가려지는거 안되게
//        searchController.obscuresBackgroundDuringPresentation = false // focus 갔을 때도 스크롤 되게
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 해도 검색창 안사라지게
        
        view.addSubview(indicatorView)
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(scrollView)
        // safeAreaLayoutGuide 안하면 키보드 올라간 상태에서 addsubview 되고 top/bottom 잘림...
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        setSpaceView()
        adjustColors()
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        searchPlacesRequest.delegate = self
        
        indicatorView.startAnimating()
        navigationItem.searchController?.searchBar.text = "가평"
        searchPlacesRequest.fetch(vc: self, keyword: "가평")
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
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextTapped() {
        guard let selectedSearchPlaceView = self.selectedSearchPlaceView else { return }
        guard let place = selectedSearchPlaceView.place else { return }
        delegate?.selectPlace(place: place)
    }
    
    func setSpaceView() {
        contentView.addSubview(spaceView)
        spaceView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        spaceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        spaceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        spaceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        spaceView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        spaceView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
}


// MARK: Extensions
extension SearchPlaceViewController: SearchPlacesRequestProtocol {
    func response(placeList: [Place]?, status: String) {
        indicatorView.stopAnimating()
            
        if status == "OK" {
            searchPlaceViewList.removeAll()
            contentView.removeAllChildView()
            
            if let placeList = placeList {
                if placeList.count > 0 {
                    for (i, place) in placeList.enumerated() {
                        let searchPlaceView = SearchPlaceView(index: i, place: place)
                        searchPlaceView.delegate = self
                        searchPlaceViewList.append(searchPlaceView)
                    }
                    
                    for (i, searchPlaceView) in searchPlaceViewList.enumerated() {
                        contentView.addSubview(searchPlaceView)
                        
                        searchPlaceView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
                        searchPlaceView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
                        searchPlaceView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
                        
                        if i == 0 {
                            searchPlaceView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
                        } else {
                            searchPlaceView.topAnchor.constraint(equalTo: searchPlaceViewList[i - 1].bottomAnchor, constant: 20).isActive = true
                        }
                        if i == searchPlaceViewList.count - 1 {
                            searchPlaceView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
                        }
                    }
                } else {
                    setSpaceView()
                }
            }
            
        } else {
            print(status)
        }
    }
}


extension SearchPlaceViewController: SearchPlaceViewProtocol {
    func selectPlace(index: Int, place: Place) {
        if (isSelectMode) {
            if selectedSearchPlaceView != nil {
                selectedSearchPlaceView?.isSelected = false
                if selectedSearchPlaceView?.index == index {
                    selectedSearchPlaceView = nil
                    navigationItem.rightBarButtonItem = nil
                    return;
                }
            }
            selectedSearchPlaceView = searchPlaceViewList[index]
            selectedSearchPlaceView?.isSelected = true
            
            if navigationItem.rightBarButtonItem == nil {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: UIBarButtonItem.Style.plain, target: self, action: #selector(nextTapped))
            }
            
        } else {
            // TODO: GOGO Detail
            print("place detail")
        }
    }
    
    func detailPlace(index: Int, place: Place) {
        print("place detail")
    }
}


extension SearchPlaceViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        searchPlaceViewList.removeAll()
        contentView.removeAllChildView()
        setSpaceView()
        
        if isSelectMode {
            selectedSearchPlaceView = nil
            navigationItem.rightBarButtonItem = nil
        }
        
        if keyword == "" || keyword.count < 2 {
            
        } else {
            if !app.isNetworkAvailable() {
                app.showNetworkAlert(parentViewController: self)
                return
            }
            
            indicatorView.startAnimating()
            searchPlacesRequest.fetch(vc: self, keyword: keyword)
        }
    }
}
