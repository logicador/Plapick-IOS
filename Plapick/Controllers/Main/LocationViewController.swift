//
//  LocationViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class LocationViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    var mainTabBarController: MainTabBarController?
    var collectionView: UICollectionView?
    
    
    // MARK: Views
    lazy var tabBarView: TabBarView = {
        let view = TabBarView(tabList: ["지역", "지도"])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: Init
    init(mainTabBarController: MainTabBarController) {
        super.init(nibName: nil, bundle: nil)
        self.mainTabBarController = mainTabBarController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
//        navigationItem.title = "플레이스 찾기"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        guard let collectionView = self.collectionView else { return }
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false // 스크롤 막기
        
        collectionView.register(LocationTabViewCVCell.self, forCellWithReuseIdentifier: "LocationTabViewCVCell")
        
        view.addSubview(tabBarView)
        tabBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabBarView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tabBarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tabBarView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: tabBarView.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
    }
    
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        mainTabBarController?.title = "플레이스 찾기"
        if mainTabBarController?.navigationItem.leftBarButtonItem != nil { mainTabBarController?.navigationItem.leftBarButtonItem = nil }
        if mainTabBarController?.navigationItem.rightBarButtonItem != nil { mainTabBarController?.navigationItem.rightBarButtonItem = nil }
    }
}


// MARK: Extensions
extension LocationViewController: TabBarViewProtocol {
    func selectTab(tabIndex: Int) {
        collectionView?.scrollToItem(at: IndexPath(row: tabIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension LocationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationTabViewCVCell", for: indexPath) as! LocationTabViewCVCell
        cell.tabIndex = indexPath.row
        return cell
    }
}

extension LocationViewController: UICollectionViewDelegateFlowLayout {
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // 셀 간 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
