//
//  MainViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/24.
//

import UIKit


class MainViewController: UITabBarController {
    
    // MARK: Property
    var homeVC: HomeViewController?
    var searchVC: SearchViewController?
//    var locationVC: LocationViewController?
    var noticeVC: NoticeViewController?
    var accountVC: AccountViewController?
    var postingVC: PostingViewController?
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        UINavigationBar.appearance().isTranslucent = false
        
        homeVC = HomeViewController(mainVC: self)
        searchVC = SearchViewController(mainVC: self)
//        locationVC = LocationViewController(mainVC: self)
        noticeVC = NoticeViewController(mainVC: self)
        accountVC = AccountViewController(mainVC: self)
        postingVC = PostingViewController(accountVC: accountVC!)
        
        homeVC?.tabBarItem.image = UIImage(systemName: "house")
        searchVC?.tabBarItem.image = UIImage(systemName: "magnifyingglass")
//        locationVC?.tabBarItem.image = UIImage(systemName: "location.north")
        noticeVC?.tabBarItem.image = UIImage(systemName: "bell")
        accountVC?.tabBarItem.image = UIImage(systemName: "person")
        postingVC?.tabBarItem.image = UIImage(systemName: "plus.circle")
        
        setViewControllers([homeVC!, searchVC!, postingVC!, noticeVC!, accountVC!], animated: false)
        
        self.delegate = self
        postingVC?.delegate = self
        
        setThemeColor()
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        homeVC?.tabBarItem.selectedImage = UIImage(systemName: "house.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        searchVC?.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
//        locationVC?.tabBarItem.selectedImage = UIImage(systemName: "location.north.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        noticeVC?.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        accountVC?.tabBarItem.selectedImage = UIImage(systemName: "person.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
    }
}


// MARK: Extension
extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == postingVC {
            self.navigationController?.pushViewController(viewController, animated: true)
            return false
        }
        return true
    }
}

extension MainViewController: PostingViewControllerProtocol {
    func closeVC() {
        postingVC = PostingViewController(accountVC: accountVC!)
        postingVC?.delegate = self
        postingVC?.accountVC = accountVC
        postingVC?.tabBarItem.image = UIImage(systemName: "plus.circle")
        viewControllers?.insert(postingVC!, at: 2) // 원위치에 삽입
    }
}
