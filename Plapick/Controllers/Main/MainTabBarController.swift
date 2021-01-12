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
    var homeViewController: UINavigationController?
    var locationViewController: UINavigationController?
    var postingViewController: PostingViewController?
    var noticeViewController: UINavigationController?
    var accountViewController: UINavigationController?
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        homeViewController = UINavigationController(rootViewController: HomeViewController())
        locationViewController = UINavigationController(rootViewController: LocationViewController())
        postingViewController = PostingViewController()
        noticeViewController = UINavigationController(rootViewController: NoticeViewController())
        accountViewController = UINavigationController(rootViewController: AccountViewController())
        
        homeViewController?.tabBarItem.image = UIImage(systemName: "house")
        locationViewController?.tabBarItem.image = UIImage(systemName: "location.north")
        postingViewController?.tabBarItem.image = UIImage(systemName: "plus.circle")
        noticeViewController?.tabBarItem.image = UIImage(systemName: "bell")
        accountViewController?.tabBarItem.image = UIImage(systemName: "person")
        
        setViewControllers([
            homeViewController!,
            locationViewController!,
            postingViewController!,
            noticeViewController!,
            accountViewController!
        ], animated: false)
        
        self.delegate = self
        postingViewController?.delegate = self
        
        adjustColors()
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        // bottom tab bar 컬러 변경 inverted(반대 색상)
        homeViewController?.tabBarItem.selectedImage = UIImage(systemName: "house.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        locationViewController?.tabBarItem.selectedImage = UIImage(systemName: "location.north.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
//        postingViewController?.tabBarItem.selectedImage = UIImage(systemName: "plus.circle.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        noticeViewController?.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        accountViewController?.tabBarItem.selectedImage = UIImage(systemName: "person.fill")?.withTintColor(UIColor.systemBackground.inverted, renderingMode: UIImage.RenderingMode.alwaysOriginal)

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
            self.postingViewController?.tabBarItem.image = UIImage(systemName: "plus.circle")
            self.viewControllers?.insert(self.postingViewController!, at: 2) // 원위치에 삽입
            self.postingViewController?.delegate = self
            
            self.adjustColors()
        })
    }
}
