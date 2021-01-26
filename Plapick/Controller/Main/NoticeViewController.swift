//
//  NoticeViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/12.
//

import UIKit


class NoticeViewController: UIViewController {
    
    // MARK: Properties
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
        
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.title = "알림"
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "설정", style: UIBarButtonItem.Style.plain, target: self, action: nil)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "모두 삭제", style: UIBarButtonItem.Style.plain, target: self, action: nil)
    }
    
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        mainVC?.title = "알림"
        mainVC?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "설정", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        mainVC?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "모두 삭제", style: UIBarButtonItem.Style.plain, target: self, action: nil)
    }
}
