//
//  MainViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/24.
//

import UIKit
import PhotosUI


class MainViewController: UITabBarController {
    
    // MARK: Property
//    let app = App()
//    let homeVC = HomeViewController()
//    let searchVC = SearchViewController()
//    var postingVC = PostingViewController()
//    let noticeVC = NoticeViewController()
//    let accountVC = AccountViewController()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setThemeColor()
        
        let homeVC = HomeViewController()
        let postingVC = PostingViewController()
        let accountVC = AccountViewController()
        
        homeVC.tabBarItem.image = UIImage(systemName: "square.grid.3x2")
        postingVC.tabBarItem.image = UIImage(systemName: "plus.diamond.fill")
        accountVC.tabBarItem.image = UIImage(systemName: "person")
        
        setViewControllers([
            UINavigationController(rootViewController: homeVC),
            postingVC,
            UINavigationController(rootViewController: accountVC)
        ], animated: true)
        
        delegate = self
        
//        view.backgroundColor = .systemBackground
        
//        title = "플레픽"
        
//        // 이거 설정 해줘야 nav가 투명할때 보이는 검정부분 안보임
////        UINavigationBar.appearance().barTintColor = .systemBackground // 필수 (nav 배경색)
////
////        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//
////        noticeVC.mainVC = self
////        accountVC.isAuth = true
//
//        accountVC.user = app.getUser()
//
//        // 투명도 없애면 크기 다른 nav pushview할때 배경중 일부분 검정색 됨..
////        UINavigationBar.appearance().isTranslucent = false // nav 투명도 없애기
//
//        homeVC.tabBarItem.image = UIImage(systemName: "house")
//        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
//        postingVC.tabBarItem.image = UIImage(systemName: "plus.circle")
////        noticeVC.tabBarItem.image = UIImage(systemName: "bell")
//        accountVC.tabBarItem.image = UIImage(systemName: "person")
//
//        setViewControllers([homeVC, searchVC, postingVC, accountVC], animated: false)
//
//        delegate = self
////        searchVC.delegate = self
////        postingVC.delegate = self
//
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
//        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
//        noticeVC.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
//        accountVC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
    }
    
//    func reloadUserPicks() {
//        for v in accountVC.pickStackView.subviews {
//            if v == accountVC.noPickContainerView { continue }
//            v.removeFromSuperview()
//        }
//        
//        accountVC.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false) // 스크롤 맨 위로
//        accountVC.page = 1
//        accountVC.isEnded = false
//        accountVC.getPicks()
//    }
    
//    // MARK: Function - @OBJC
//    @objc func settingTapped() {
//        navigationController?.pushViewController(SettingViewController(), animated: true)
//    }
//
//    @objc func removeAllNoticeTapped() {
//
//    }
}


// MARK: TabBar
extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is PostingViewController {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                DispatchQueue.main.async {
                    if status == .limited || status == .authorized {
                        var configuration = PHPickerConfiguration()
                        configuration.selectionLimit = 12
                        configuration.filter = .any(of: [.images])
                        let picker = PHPickerViewController(configuration: configuration)
                        picker.delegate = self
                        picker.modalPresentationStyle = .fullScreen
                        self.present(picker, animated: true, completion: nil)
                        
                    } else {
                        self.requestSettingAlert(title: "앨범 액세스 허용하기", message: "게시물 이미지 업로드를 위해 앨범에 접근합니다.")
                    }
                }
            }
            return false
        }
        
        return true
    }
}


//// MARK: TabBar
//extension MainViewController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController is HomeViewController {
//            title = "플레픽"
//            navigationItem.leftBarButtonItem = nil
//            navigationItem.rightBarButtonItem = nil
//
//        } else if viewController is PostingViewController {
//            let isAgreePosting = app.isAgreePosting()
//            if isAgreePosting {
//                postingVC = PostingViewController()
//                navigationController?.pushViewController(postingVC, animated: true)
//
//            } else {
//                let postingTermsVC = PostingTermsViewController()
//                postingTermsVC.delegate = self
//                present(UINavigationController(rootViewController: postingTermsVC), animated: true, completion: nil)
//            }
//
//            return false
//
//        } else if viewController is SearchViewController {
//            title = "검색"
//            navigationItem.leftBarButtonItem = nil
//            navigationItem.rightBarButtonItem = nil
//
//        } else if viewController is NoticeViewController {
//            title = "알림"
//            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(settingTapped))
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "모두 읽음", style: .plain, target: self, action: #selector(removeAllNoticeTapped))
//
//        } else if viewController is AccountViewController {
//            title = "사용자"
//            navigationItem.leftBarButtonItem = nil
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(settingTapped))
//        }
//
//        return true
//    }
//}
//
//
//// MARK: PostingTermsVC
//extension MainViewController: PostingTermsViewControllerProtocol {
//    func agreePosting() {
//        postingVC = PostingViewController()
//        navigationController?.pushViewController(postingVC, animated: true)
//    }
//}


// MARK: PHPicker
extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if results.count == 0 {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        var imageList: [UIImage] = []
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                guard let image = image else { return }
                let resImage = image as! UIImage
                imageList.append(resImage)
                
                if imageList.count == results.count {
                    DispatchQueue.main.async {
                        picker.dismiss(animated: true, completion: {
                            let postingVC = PostingViewController()
                            postingVC.imageList = imageList
                            let postingNavVC = UINavigationController(rootViewController: postingVC)
                            postingNavVC.modalPresentationStyle = .fullScreen
                            self.present(postingNavVC, animated: true, completion: nil)
                        })
                    }
                }
            })
        }
    }
}
