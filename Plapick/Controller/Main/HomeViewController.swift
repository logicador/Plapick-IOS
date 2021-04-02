//
//  HomeViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class HomeViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let getVersionRequest = GetVersionRequest()
    let getPostsRequest = GetPostsRequest()
    var postsList: [Posts] = []
    var page = 1
    var isLoading = false
    var isEnd = false
    
    
    // MARK: View
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.register(PostsCVCell.self, forCellWithReuseIdentifier: "PostsCVCell")
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.refreshControl = UIRefreshControl()
        cv.refreshControl?.addTarget(self, action: #selector(refreshed), for: .valueChanged)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "최근 게시물"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        getVersionRequest.delegate = self
        getPostsRequest.delegate = self
        
        getVersionRequest.fetch(vc: self, paramDict: [:])
        getPosts()
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        collectionView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func getPosts() {
        isLoading = true
        getPostsRequest.fetch(vc: self, paramDict: ["mode": "ALL", "page": String(page)])
    }
    
    func reloadPosts() {
        postsList.removeAll()
        page = 1
        isEnd = false
        getPosts()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = collectionView.contentOffset.y
        let contentHeight = collectionView.contentSize.height
        let frameHeight = collectionView.frame.height

        if offsetY > contentHeight - frameHeight {
            if !isLoading && !isEnd {
                page += 1
                getPosts()
            }
        }
    }
    
    // MARK: Function - @OBJC
    @objc func refreshed() {
        postsList.removeAll()
        page = 1
        isEnd = false
        getPosts()
    }
    
    @objc func searchTapped() {
        navigationController?.pushViewController(SearchKakaoPlaceViewController(), animated: true)
    }
}


// MARK: CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostsCVCell", for: indexPath) as! PostsCVCell
        cell.posts = postsList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - (4 / 3), height: (view.frame.width / 3) - (4 / 3))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postsVC = PostsViewController()
        postsVC.mode = "ALL"
        postsVC.poId = postsList[indexPath.row].po_id
        postsVC.postsList = postsList
        postsVC.page = page
        postsVC.isEnd = isEnd
        postsVC.delegate = self
        navigationController?.pushViewController(postsVC, animated: true)
    }
}

// MARK: PostsVC
extension HomeViewController: PostsViewControllerProtocol {
    func removePosts(poId: Int) { reloadPosts() }
    func likePosts(poId: Int, isLike: String) { reloadPosts() }
    func editPosts(posts: Posts) { reloadPosts() }
}

// MARK: HTTP - GetVersion
extension HomeViewController: GetVersionRequestProtocol {
    func response(versionCode: Int?, versionName: String?, getVersion status: String) {
        print("[HTTP RES]", getVersionRequest.apiUrl, status)

        if status == "OK" {
            guard let newVersionCode = versionCode else { return }
            guard let newVersionName = versionName else { return }
            app.setNewVersionCode(newVersionCode: newVersionCode)
            app.setNewVersionName(newVersionName: newVersionName)

            guard let infoDictionary = Bundle.main.infoDictionary else { return }
            guard let code = infoDictionary["CFBundleVersion"] as? String else { return }
            guard let curVersionName = infoDictionary["CFBundleShortVersionString"] as? String else { return }
            guard let curVersionCode = Int(code) else { return }
            app.setCurVersionCode(curVersionCode: curVersionCode)
            app.setCurVersionName(curVersionName: curVersionName)

            if newVersionCode > curVersionCode {
                let alert = UIAlertController(title: "업데이트됨", message: "새로운 버전 ver. \(newVersionName) 이 출시되었습니다. 업데이트를 진행해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { (_) in
                    self.changeRootViewController(rootViewController: LaunchViewController())
                }))
                alert.addAction(UIAlertAction(title: "업데이트", style: .default, handler: { (_) in
                    guard let url = URL(string: "itms-apps://itunes.apple.com/app/1548230910") else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    self.changeRootViewController(rootViewController: LaunchViewController())
                }))
                present(alert, animated: true, completion: nil)
                return
            }
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (isAllowed, error) in DispatchQueue.main.async {
                let isDontLookAgainAccessAlarm = self.app.getIsDontLookAgainAccessAlarm()
                
                if let _ = error {
                    if !isDontLookAgainAccessAlarm {
                        let alert = UIAlertController(title: "알림 액세스 허용하기", message: "앱 사용시 중요한 정보를 알려드립니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
                        alert.addAction(UIAlertAction(title: "다시 보지 않기", style: .default, handler: { (_) in
                            self.app.setIsDontLookAgainAccessAlarm(isDontLookAgain: true)
                        }))
                        alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { (_) in
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
                
                if !isAllowed && !isDontLookAgainAccessAlarm {
                    let alert = UIAlertController(title: "알림 액세스 허용하기", message: "앱 사용시 중요한 정보를 알려드립니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
                    alert.addAction(UIAlertAction(title: "다시 보지 않기", style: .default, handler: { (_) in
                        self.app.setIsDontLookAgainAccessAlarm(isDontLookAgain: true)
                    }))
                    alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { (_) in
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                self.app.setIsDontLookAgainAccessAlarm(isDontLookAgain: false)
                UIApplication.shared.registerForRemoteNotifications()
            }})
        }
    }
}

// MARK: HTTP - GetPosts
extension HomeViewController: GetPostsRequestProtocol {
    func response(postsList: [Posts]?, mode: String?, getPosts status: String) {
        print("[HTTP RES]", getPostsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let postsList = postsList else { return }
            
            self.postsList.append(contentsOf: postsList)
            collectionView.reloadData()
            
            if postsList.count < GET_POSTS_LIMIT { isEnd = true }
        }
        
        isLoading = false
        collectionView.refreshControl?.endRefreshing()
    }
}
