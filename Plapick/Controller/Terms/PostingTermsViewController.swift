//
//  PostingTermsViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/27.
//

import UIKit


protocol PostingTermsViewControllerProtocol {
    func agreePosting()
}


class PostingTermsViewController: UIViewController {
    
    // MARK: Property
    var delegate: PostingTermsViewControllerProtocol?
    let app = App()
    
    
    // MARK: View
    lazy var iconImageView: UIImageView = {
        let image = UIImage(systemName: "exclamationmark.circle.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .mainColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.text = "다른 사람에게 불쾌감을 주거나 폭력적 혹은 성적인 게시물을 업로드 시 경고 없이 즉시 게시물이 삭제될 수 있으며 계정과 서비스 이용이 제한될 수 있습니다."
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var agreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = SPACE_XS
        button.setTitle("동의하고 계속하기", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_S, left: 0, bottom: SPACE_S, right: 0)
        button.addTarget(self, action: #selector(agreeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "게시물 업로드 약관 동의"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeTapped))
        
        configureView()
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(iconImageView)
        iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SPACE_XL).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        
        view.addSubview(termsLabel)
        termsLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: SPACE_XL).isActive = true
        termsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        termsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XXXXXS).isActive = true
        
        view.addSubview(agreeButton)
        agreeButton.topAnchor.constraint(equalTo: termsLabel.bottomAnchor, constant: SPACE_XL).isActive = true
        agreeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        agreeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XXXXXS).isActive = true
    }
    
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func agreeTapped() {
        app.setAgreePosting()
        delegate?.agreePosting()
        dismiss(animated: true, completion: nil)
    }
}
