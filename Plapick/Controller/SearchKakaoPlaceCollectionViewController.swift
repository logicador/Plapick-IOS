//
//  SearchKakaoPlaceViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/25.
//

import UIKit


protocol SearchKakaoPlaceTableViewControllerProtocol {
    func closeVC(place: Place?)
}


class SearchKakaoPlaceTableViewController: UITableViewController {
    
    // MARK: Property
    var delegate: SearchKakaoPlaceTableViewControllerProtocol?
    var getKakaoPlacesRequest = GetKakaoPlacesRequest()
    var selectedPlace: Place?
    var prevVC: UIViewController?
    var placeList: [Place] = []
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .systemBackground
        
        navigationItem.title = "플레이스 검색"
        
        if let vcCnt = navigationController?.viewControllers.count {
            prevVC = self.navigationController?.viewControllers[vcCnt-2]
            
//            if prevVC is PostingViewController {
//                print("dd")
//            } else {
//                print("ff")
//            }
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
        
        tableView.register(PlaceTVCell.self, forCellReuseIdentifier: "PlaceTVCell")
        tableView.separatorStyle = .none
        
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 100
        
        getKakaoPlacesRequest.delegate = self
        
        // MARK: For DEV_DEBUG
        navigationItem.searchController?.searchBar.text = "가평"
        getKakaoPlacesRequest.fetch(vc: self, paramDict: ["keyword": "가평"])
    }
    
    
    // MARK: ViewDidDisapear
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.closeVC(place: selectedPlace)
    }
    
    
    // MARK: Function
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTVCell", for: indexPath) as! PlaceTVCell
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell.place = placeList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = navigationItem.searchController?.searchBar.isFirstResponder {
            navigationItem.searchController?.searchBar.resignFirstResponder()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let _ = navigationItem.searchController?.searchBar.isFirstResponder {
            navigationItem.searchController?.searchBar.resignFirstResponder()
        }
    }
}


// MARK: Extension
extension SearchKakaoPlaceTableViewController: UISearchBarDelegate {
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
            
        getKakaoPlacesRequest.fetch(vc: self, paramDict: ["keyword": keyword])
    }
}


extension SearchKakaoPlaceTableViewController: GetKakaoPlacesRequestProtocol {
    func response(placeList: [Place]?, getKakaoPlaces status: String) {
        if status == "OK" {
            if let placeList = placeList {
                self.placeList = placeList
            } else {
                self.placeList.removeAll()
            }
        } else {
            self.placeList.removeAll()
        }
        
        tableView.reloadData()
    }
}
