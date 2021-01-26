//
//  TestViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/26.
//

import UIKit


class TestViewController: UIViewController {
    
    lazy var testButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("open", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(testTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(testButton)
        testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func testTapped() {
        let alert = UIAlertController(title: "고객센터", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
        alert.addAction(UIAlertAction(title: "문의하기", style: UIAlertAction.Style.default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "이용약관", style: UIAlertAction.Style.default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "개인정보 처리방침", style: UIAlertAction.Style.default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "계정 탈퇴", style: UIAlertAction.Style.destructive, handler: { (_) in
            
        }))
        alert.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alert.view)
        alert.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        alert.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        alert.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        alert.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        alert.view.layoutIfNeeded()
//        present(alert, animated: false)
    }
}
