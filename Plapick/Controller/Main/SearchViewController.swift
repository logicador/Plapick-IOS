//
//  SearchViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/25.
//

import UIKit


class SearchViewController: UIViewController {
    
    // MARK: Property
    var app = App()
    var mainVC: MainViewController?
    
    
    // MARK: Init
    init(mainVC: MainViewController) {
        super.init(nibName: nil, bundle: nil)
        self.mainVC = mainVC
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        mainVC?.title = "검색"
        if mainVC?.navigationItem.leftBarButtonItem != nil { mainVC?.navigationItem.leftBarButtonItem = nil }
        if mainVC?.navigationItem.rightBarButtonItem != nil { mainVC?.navigationItem.rightBarButtonItem = nil }
//        mainVC?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(openSearchViewController))
    }
}
