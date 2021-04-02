//
//  SearchKakaoPlaceViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/23.
//

import UIKit


protocol SearchKakaoPlaceViewControllerProtocol {
    func selectKakaoPlace(kakaoPlace: KakaoPlace)
}


class SearchKakaoPlaceViewController: UIViewController {
    
    // MARK: Property
    var delegate: SearchKakaoPlaceViewControllerProtocol?
    var mode = "NORMAL" // NORMAL, POSTING, EDIT_POSTS
    var message = ""
    var imageList: [UIImage] = []
    
    var kakaoPlaceList: [KakaoPlace] = []
    var currentKeyword = ""
    var page = 1
    var isLoading = false
    var isEnd = true
    
    let getKakaoPlacesRequest = GetKakaoPlacesRequest()
    let getKakaoPlaceCntRequest = GetKakaoPlaceCntRequest()
    
    
    // MARK: View
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(KakaoPlaceTVCell.self, forCellReuseIdentifier: "KakaoPlaceTVCell")
        tv.separatorInset.left = 0
        tv.tableFooterView = UIView(frame: .zero) // 빈 셀 안보이게
        tv.dataSource = self
        tv.delegate = self
        tv.alwaysBounceVertical = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "플레이스 검색"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 해도 검색창 안사라지게
        
        configureView()
        
        setThemeColor()
        
        getKakaoPlacesRequest.delegate = self
        getKakaoPlaceCntRequest.delegate = self
        
        // MARK: For DEV_DEBUG
//        currentKeyword = "가평"
//        getKakaoPlaces()
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        tableView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func getKakaoPlaces() {
        isLoading = true
        getKakaoPlacesRequest.fetch(vc: self, query: currentKeyword, page: page)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let frameHeight = tableView.frame.height

        if offsetY > contentHeight - frameHeight {
            if !isLoading && !isEnd {
                page += 1
                getKakaoPlaces()
            }
        }
    }
}


// MARK: SearchBar
extension SearchKakaoPlaceViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let keywordRegEx = "[a-zA-Z가-힣0-9 ]{1,20}"
        let keywordTest = NSPredicate(format:"SELF MATCHES %@", keywordRegEx)
        if !keywordTest.evaluate(with: keyword) { return }
        
        if currentKeyword == keyword { return }
        
        currentKeyword = keyword
        page = 1
        isEnd = false
        kakaoPlaceList.removeAll()
        getKakaoPlaces()
    }
}

// MARK: TableView
extension SearchKakaoPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        kakaoPlaceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KakaoPlaceTVCell", for: indexPath) as! KakaoPlaceTVCell
        cell.selectionStyle = .none
        cell.kakaoPlace = kakaoPlaceList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard()
        
        let kakaoPlace = kakaoPlaceList[indexPath.row]
        
        if mode == "POSTING" {
            let alert = UIAlertController(title: "[\(kakaoPlace.place_name)]", message: "다음 중 항목을 선택해주세요.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            alert.addAction(UIAlertAction(title: "이곳에 게시하기", style: .default, handler: { (_) in
                let postingConfirmVC = PostingConfirmViewController()
                postingConfirmVC.message = self.message
                postingConfirmVC.imageList = self.imageList
                postingConfirmVC.kakaoPlace = kakaoPlace
                let postingConfirmNavVC = UINavigationController(rootViewController: postingConfirmVC)
                postingConfirmNavVC.modalPresentationStyle = .fullScreen
                self.present(postingConfirmNavVC, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "자세히 보기", style: .default, handler: { (_) in
                let placeVC = PlaceViewController()
                placeVC.kakaoPlace = kakaoPlace
                self.navigationController?.pushViewController(placeVC, animated: true)
            }))
            present(alert, animated: true)
            
        } else if mode == "EDIT_POSTS" {
            let alert = UIAlertController(title: "[\(kakaoPlace.place_name)]", message: "다음 중 항목을 선택해주세요.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            alert.addAction(UIAlertAction(title: "이곳에 게시하기", style: .default, handler: { (_) in
                self.delegate?.selectKakaoPlace(kakaoPlace: kakaoPlace)
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "자세히 보기", style: .default, handler: { (_) in
                let placeVC = PlaceViewController()
                placeVC.kakaoPlace = kakaoPlace
                self.navigationController?.pushViewController(placeVC, animated: true)
            }))
            present(alert, animated: true)
            
        } else {
            let placeVC = PlaceViewController()
            placeVC.kakaoPlace = kakaoPlace
            navigationController?.pushViewController(placeVC, animated: true)
        }
    }
}

// MARK: HTTP - GetKakaoPlaces
extension SearchKakaoPlaceViewController: GetKakaoPlacesRequestProtocol {
    func response(kakaoPlaceList: [KakaoPlace]?, isEnd: Bool?, getKakaoPlaces status: String) {
        print("[HTTP RES]", getKakaoPlacesRequest.apiUrl, status)
        
        if status == "OK" {
            guard let kakaoPlaceList = kakaoPlaceList else { return }
            guard let isEnd = isEnd else { return }
            
            if kakaoPlaceList.count > 0 {
                var kakaoId = ""
                for (i, kakaoPlace) in kakaoPlaceList.enumerated() {
                    if i > 0 { kakaoId += "|" }
                    kakaoId += kakaoPlace.id
                }
                getKakaoPlaceCntRequest.fetch(vc: self, paramDict: ["kakaoId": kakaoId])
            }
            
            self.kakaoPlaceList.append(contentsOf: kakaoPlaceList)
            self.isEnd = isEnd
            
            tableView.reloadData()
        }
        
        isLoading = false
    }
}

// MARK: HTTP - GetKakaoPlaceCnt
extension SearchKakaoPlaceViewController: GetKakaoPlaceCntRequestProtocol {
    func response(kakaoPlaceCntList: [KakaoPlaceCnt]?, getKakaoPlaceCnt status: String) {
        print("[HTTP RES]", getKakaoPlaceCntRequest.apiUrl, status)
        
        if status == "OK" {
            guard let kakaoPlaceCntList = kakaoPlaceCntList else { return }
            
            for kakaoPlaceCnt in kakaoPlaceCntList {
                for (i, kakaoPlace) in kakaoPlaceList.enumerated() {
                    if String(kakaoPlaceCnt.p_k_id) == kakaoPlace.id {
                        kakaoPlaceList[i].p_like_cnt = kakaoPlaceCnt.p_like_cnt
                        kakaoPlaceList[i].p_comment_cnt = kakaoPlaceCnt.p_comment_cnt
                        kakaoPlaceList[i].p_posts_cnt = kakaoPlaceCnt.p_posts_cnt
                        break
                    }
                }
            }
            
            tableView.reloadData()
        }
    }
}
