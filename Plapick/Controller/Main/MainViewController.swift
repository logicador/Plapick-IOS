//
//  MainViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/24.
//

import UIKit


class MainViewController: UITabBarController {
    
    // MARK: Property
    var app = App()
    var uId: Int?
    var homeVC: HomeViewController?
    var searchVC: SearchViewController?
    var noticeVC: NoticeViewController?
    var accountVC: AccountViewController?
    var postingVC: PostingViewController?
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // 이거 설정 해줘야 nav가 투명할때 보이는 검정부분 안보임
        UINavigationBar.appearance().barTintColor = .systemBackground // 필수 (nav 배경색)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        uId = app.getUId()
        guard let uId = self.uId else { return }
        
        // 투명도 없애면 크기 다른 nav pushview할때 배경중 일부분 검정색 됨..
//        UINavigationBar.appearance().isTranslucent = false // nav 투명도 없애기
        
        homeVC = HomeViewController(mainVC: self)
        postingVC = PostingViewController()
        searchVC = SearchViewController(mainVC: self)
        noticeVC = NoticeViewController(mainVC: self)
        accountVC = AccountViewController(uId: uId)
        
//        accountNavVC = UINavigationController(rootViewController: accountVC!)
        
        homeVC?.tabBarItem.image = UIImage(systemName: "house")
        searchVC?.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        noticeVC?.tabBarItem.image = UIImage(systemName: "bell")
        accountVC?.tabBarItem.image = UIImage(systemName: "person")
        postingVC?.tabBarItem.image = UIImage(systemName: "plus.circle")
        
        setViewControllers(
            [
                homeVC!,
                searchVC!,
                postingVC!,
                noticeVC!,
                accountVC!
            ], animated: false)
        
//        postingVC?.authAccountVC = accountVC
        
        self.delegate = self
        postingVC?.delegate = self
        accountVC?.delegate = self
        
        setThemeColor()
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        homeVC?.tabBarItem.selectedImage = UIImage(systemName: "house.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        searchVC?.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        noticeVC?.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
    }
}


// MARK: Extension - TabBar
extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is PostingViewController {
            navigationController?.pushViewController(viewController, animated: true)
            return false
        }
        if viewController is AccountViewController {
            present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
            return false
        }
        return true
    }
}

// MARK: Extension - Posting
extension MainViewController: PostingViewControllerProtocol {
    func closePostingVC(isUploaded: Bool) {
        postingVC = PostingViewController()
//        postingVC?.authAccountVC = accountVC
        postingVC?.delegate = self
        postingVC?.tabBarItem.image = UIImage(systemName: "plus.circle")
        viewControllers?.insert(postingVC!, at: 2) // 원위치에 삽입
    }
}

// MARK: Extension - Account
extension MainViewController: AccountViewControllerProtocol {
    func closeAccountVC() {
//        accountVC = AccountViewController(uId: uId!)
        accountVC?.delegate = self
        accountVC?.tabBarItem.image = UIImage(systemName: "person")
        viewControllers?.insert(accountVC!, at: 4) // 원위치에 삽입
    }
    
    func reloadUser() { }
}
