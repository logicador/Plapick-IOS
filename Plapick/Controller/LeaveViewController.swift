//
//  LeaveViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/31.
//

import UIKit


class LeaveViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let leaveRequest = LeaveRequest()
    
    
    // MARK: View
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
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var logoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var logoTextImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "LogoText")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var leaveAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "플레픽으로부터 탈퇴합니다.\n\n탈퇴한 계정의 모든 데이터가 삭제되며\n다시 복구하실 수 없습니다.\n\n탈퇴하시겠습니까?"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var leaveContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var leaveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원탈퇴", for: .normal)
        button.tintColor = .systemRed
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(leaveTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "회원탈퇴"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        leaveRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(logoContainerView)
        logoContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        logoContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        logoContainerView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4).isActive = true
        
        logoContainerView.addSubview(logoTextImageView)
        logoTextImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor).isActive = true
        logoTextImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor).isActive = true
        logoTextImageView.widthAnchor.constraint(equalTo: logoContainerView.widthAnchor, multiplier: 0.3).isActive = true
    
        stackView.addArrangedSubview(leaveAgreeLabel)
        leaveAgreeLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        leaveAgreeLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(leaveContainerView)
        leaveContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        leaveContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        leaveContainerView.addSubview(leaveButton)
        leaveButton.topAnchor.constraint(equalTo: leaveContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        leaveButton.centerXAnchor.constraint(equalTo: leaveContainerView.centerXAnchor).isActive = true
        leaveButton.bottomAnchor.constraint(equalTo: leaveContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func leaveTapped() {
        leaveRequest.fetch(vc: self, paramDict: [:])
    }
}


// MARK: Leave
extension LeaveViewController: LeaveRequestProtocol {
    func response(leave status: String) {
        print("[HTTP RES]", leaveRequest.apiUrl, status)
        
        if status == "OK" {
            app.logout()
            changeRootViewController(rootViewController: UINavigationController(rootViewController: LoginViewController()))
        }
    }
}
