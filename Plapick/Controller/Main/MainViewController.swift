//
//  MainViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/24.
//

import UIKit


class MainViewController: UITabBarController {
    
    // MARK: Property
    let app = App()
    let homeVC = HomeViewController()
    let searchVC = SearchViewController()
    var postingVC = PostingViewController()
    let noticeVC = NoticeViewController()
    let accountVC = AccountViewController()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "플레픽"
        
        // 이거 설정 해줘야 nav가 투명할때 보이는 검정부분 안보임
        UINavigationBar.appearance().barTintColor = .systemBackground // 필수 (nav 배경색)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        noticeVC.mainVC = self
        
        accountVC.user = app.getUser()
        
        // 투명도 없애면 크기 다른 nav pushview할때 배경중 일부분 검정색 됨..
//        UINavigationBar.appearance().isTranslucent = false // nav 투명도 없애기
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        postingVC.tabBarItem.image = UIImage(systemName: "plus.circle")
        noticeVC.tabBarItem.image = UIImage(systemName: "bell")
        accountVC.tabBarItem.image = UIImage(systemName: "person")
        
        setViewControllers([homeVC, searchVC, postingVC, noticeVC, accountVC], animated: false)
        
        delegate = self
        postingVC.delegate = self
        
        setThemeColor()
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        noticeVC.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
        accountVC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
    }
    
    // MARK: Function - @OBJC
    @objc func settingTapped() {
        navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    @objc func removeAllNoticeTapped() {
        
    }
}


// MARK: TabBar
extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is HomeViewController {
            title = "플레픽"
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
            
        } else if viewController is PostingViewController {
            postingVC = PostingViewController()
            postingVC.delegate = self
            navigationController?.pushViewController(postingVC, animated: true)
            return false
            
        } else if viewController is SearchViewController {
            title = "검색"
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
            
        } else if viewController is NoticeViewController {
            title = "알림"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(settingTapped))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "모두 삭제", style: .plain, target: self, action: #selector(removeAllNoticeTapped))
        
        } else if viewController is AccountViewController {
            title = "사용자"
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(settingTapped))
        }
        
        return true
    }
}

// MARK: PostingVC
extension MainViewController: PostingViewControllerProtocol {
    func addPick() {
        for v in accountVC.pickStackView.subviews {
            if v == accountVC.noPickContainerView { continue }
            v.removeFromSuperview()
        }
        
        accountVC.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false) // 스크롤 맨 위로
        accountVC.page = 1
        accountVC.isEnded = false
        accountVC.getPicks()
    }
}
