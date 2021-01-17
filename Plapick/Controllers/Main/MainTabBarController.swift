//
//  MainViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    // MARK: Properties
    var app = App()
    
    var homeViewController: HomeViewController?
    var locationViewController: LocationViewController?
    var postingViewController: PostingViewController?
    var noticeViewController: NoticeViewController?
    var accountViewController: AccountViewController?
    
    var homeNavViewController: UINavigationController?
    var locationNavViewController: UINavigationController?
    var noticeNavViewController: UINavigationController?
    var accountNavViewController: UINavigationController?
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        homeViewController = HomeViewController()
        locationViewController = LocationViewController()
        postingViewController = PostingViewController()
        noticeViewController = NoticeViewController()
        accountViewController = AccountViewController()
        
        postingViewController?.delegate = self
        postingViewController?.accountViewController = accountViewController
        
        homeNavViewController = UINavigationController(rootViewController: homeViewController!)
        locationNavViewController = UINavigationController(rootViewController: locationViewController!)
        noticeNavViewController = UINavigationController(rootViewController: noticeViewController!)
        accountNavViewController = UINavigationController(rootViewController: accountViewController!)
        
        homeNavViewController?.tabBarItem.image = UIImage(systemName: "house")
        locationNavViewController?.tabBarItem.image = UIImage(systemName: "location.north")
        postingViewController?.tabBarItem.image = UIImage(systemName: "plus.circle")
        noticeNavViewController?.tabBarItem.image = UIImage(systemName: "bell")
        accountNavViewController?.tabBarItem.image = UIImage(systemName: "person")
        
        setViewControllers([
            homeNavViewController!,
            locationNavViewController!,
            postingViewController!,
            noticeNavViewController!,
            accountNavViewController!
        ], animated: false)
        
        self.delegate = self
        
        adjustColors()
        
        // Navigation Back Button Global
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.left")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
        // Specific
//        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        // bottom tab bar 컬러 변경 inverted(반대 색상)
        homeNavViewController?.tabBarItem.selectedImage = UIImage(systemName: "house.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        locationNavViewController?.tabBarItem.selectedImage = UIImage(systemName: "location.north.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        noticeNavViewController?.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        accountNavViewController?.tabBarItem.selectedImage = UIImage(systemName: "person.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)

        if self.traitCollection.userInterfaceStyle == .dark {
            // 다크모드
        } else {
            // 라이트모드
        }
    }
}


// MARK: Extensions
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return false
        }
        
        if viewController is PostingViewController {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
            return false
        }
        return true
    }
}


extension MainTabBarController: PostingViewControllerProtocol {
    func closeViewController() {
        // 종료 시그널을 받았으므로 dismiss 해줌
        self.postingViewController?.dismiss(animated: true, completion: {
            // 콜백을 받으면 다시 postingViewController 세팅해줌
            self.postingViewController = PostingViewController()
            self.postingViewController?.delegate = self
            self.postingViewController?.accountViewController = self.accountViewController
            self.postingViewController?.tabBarItem.image = UIImage(systemName: "plus.circle")
            self.viewControllers?.insert(self.postingViewController!, at: 2) // 원위치에 삽입
            
//            self.adjustColors()
        })
    }
}
