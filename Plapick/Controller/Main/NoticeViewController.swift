//
//  NoticeViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/12.
//

import UIKit


class NoticeViewController: UIViewController {
    
    // MARK: Property
    var mainVC: MainViewController?
    
    
    // MARK: VIew
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureView()
    }
    
    
//    // MARK: ViewWillAppear
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        mainVC?.title = "알림"
//        mainVC?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "설정", style: UIBarButtonItem.Style.plain, target: self, action: nil)
//        mainVC?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "모두 삭제", style: UIBarButtonItem.Style.plain, target: self, action: nil)
//    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        for i in 0...12 {
            let v = UIView()
            v.backgroundColor = .systemRed
            v.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(v)
            v.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            v.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            if i == 4 {
                let vv = UIView()
                vv.backgroundColor = .systemBlue
                vv.translatesAutoresizingMaskIntoConstraints = false
                
                stackView.addArrangedSubview(vv)
                vv.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
                
                let label1 = UILabel()
                label1.text = "label1"
                label1.font = UIFont.boldSystemFont(ofSize: 30)
                label1.textAlignment = .center
                
                vv.addSubview(label1)
                label1.translatesAutoresizingMaskIntoConstraints = false
                
                label1.topAnchor.constraint(equalTo: vv.topAnchor, constant: SPACE_XXXL).isActive = true
                label1.leadingAnchor.constraint(equalTo: vv.leadingAnchor).isActive = true
                label1.trailingAnchor.constraint(equalTo: vv.trailingAnchor).isActive = true
//                label1.bottomAnchor.constraint(equalTo: vv.bottomAnchor, constant: -SPACE_XXXL).isActive = true
                
                let label2 = UILabel()
                label2.text = "label2"
                label2.textAlignment = .center

                vv.addSubview(label2)
                label2.translatesAutoresizingMaskIntoConstraints = false

//                label1.bottomAnchor.constraint(equalTo: label2.topAnchor, constant: -SPACE_XL).isActive = true

                label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: SPACE_XL).isActive = true
                label2.leadingAnchor.constraint(equalTo: vv.leadingAnchor).isActive = true
                label2.trailingAnchor.constraint(equalTo: vv.trailingAnchor).isActive = true
                label2.bottomAnchor.constraint(equalTo: vv.bottomAnchor, constant: -SPACE_XL).isActive = true
                
            }
        }
    }
}
