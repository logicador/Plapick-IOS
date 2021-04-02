//
//  JoinAgreeViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/18.
//

import UIKit


class JoinAgreeViewController: UIViewController {
    
    // MARK: Property
    var userType: String?
    var socialId: String?
    var email: String?
    
    
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
    
    lazy var titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "약관 동의"
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Agreement
    lazy var agreementContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(agreementTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var agreementImageView: UIImageView = {
        let image = UIImage(systemName: "circle")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var agreementLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스 이용약관 동의"
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var termsAgreementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("보기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(termsAgreementTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var agreementTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Privacy
    lazy var privacyContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var privacyImageView: UIImageView = {
        let image = UIImage(systemName: "circle")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보 처리방침 동의"
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var termsPrivacyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("보기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(termsPrivacyTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var privacyTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - AllAgree
    lazy var allAgreeContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allAgreeTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var allAgreeImageView: UIImageView = {
        let image = UIImage(systemName: "circle")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var allAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "모두 동의하기"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .systemGray3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var allAgreeTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "회원가입"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
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
        
        stackView.addArrangedSubview(titleContainerView)
        titleContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        titleContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        titleContainerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        // MARK: ConfigureView - Agreement
        stackView.addArrangedSubview(agreementTopLine)
        agreementTopLine.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        agreementTopLine.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        stackView.addArrangedSubview(agreementContainerView)
        agreementContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        agreementContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        agreementContainerView.addSubview(agreementImageView)
        agreementImageView.topAnchor.constraint(equalTo: agreementContainerView.topAnchor, constant: SPACE).isActive = true
        agreementImageView.leadingAnchor.constraint(equalTo: agreementContainerView.leadingAnchor).isActive = true
        agreementImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        agreementImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        agreementImageView.bottomAnchor.constraint(equalTo: agreementContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        agreementContainerView.addSubview(agreementLabel)
        agreementLabel.centerYAnchor.constraint(equalTo: agreementImageView.centerYAnchor).isActive = true
        agreementLabel.leadingAnchor.constraint(equalTo: agreementImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        
        agreementContainerView.addSubview(termsAgreementButton)
        termsAgreementButton.centerYAnchor.constraint(equalTo: agreementImageView.centerYAnchor).isActive = true
        termsAgreementButton.trailingAnchor.constraint(equalTo: agreementContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Privacy
        stackView.addArrangedSubview(privacyTopLine)
        privacyTopLine.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        privacyTopLine.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        stackView.addArrangedSubview(privacyContainerView)
        privacyContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        privacyContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        privacyContainerView.addSubview(privacyImageView)
        privacyImageView.topAnchor.constraint(equalTo: privacyContainerView.topAnchor, constant: SPACE).isActive = true
        privacyImageView.leadingAnchor.constraint(equalTo: privacyContainerView.leadingAnchor).isActive = true
        privacyImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        privacyImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        privacyImageView.bottomAnchor.constraint(equalTo: privacyContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        privacyContainerView.addSubview(privacyLabel)
        privacyLabel.centerYAnchor.constraint(equalTo: privacyImageView.centerYAnchor).isActive = true
        privacyLabel.leadingAnchor.constraint(equalTo: privacyImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        
        privacyContainerView.addSubview(termsPrivacyButton)
        termsPrivacyButton.centerYAnchor.constraint(equalTo: privacyImageView.centerYAnchor).isActive = true
        termsPrivacyButton.trailingAnchor.constraint(equalTo: privacyContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - AllAgree
        stackView.addArrangedSubview(allAgreeTopLine)
        allAgreeTopLine.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        allAgreeTopLine.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        stackView.addArrangedSubview(allAgreeContainerView)
        allAgreeContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        allAgreeContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
    
        allAgreeContainerView.addSubview(allAgreeLabel)
        allAgreeLabel.topAnchor.constraint(equalTo: allAgreeContainerView.topAnchor, constant: SPACE).isActive = true
        allAgreeLabel.centerXAnchor.constraint(equalTo: allAgreeContainerView.centerXAnchor).isActive = true
        allAgreeLabel.bottomAnchor.constraint(equalTo: allAgreeContainerView.bottomAnchor, constant: -SPACE).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func agreementTapped() {
        if agreementImageView.tintColor == .systemGray3 {
            agreementImageView.tintColor = .mainColor
            agreementImageView.image = UIImage(systemName: "checkmark.circle")
            if privacyImageView.tintColor == .mainColor {
                allAgreeLabel.textColor = .mainColor
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextTapped))
            }
        } else {
            agreementImageView.tintColor = .systemGray3
            agreementImageView.image = UIImage(systemName: "circle")
            allAgreeLabel.textColor = .systemGray3
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func termsAgreementTapped() {
        let termsVC = TermsViewController()
        termsVC.path = "agreement"
        navigationController?.pushViewController(termsVC, animated: true)
    }
    
    @objc func privacyTapped() {
        if privacyImageView.tintColor == .systemGray3 {
            privacyImageView.tintColor = .mainColor
            privacyImageView.image = UIImage(systemName: "checkmark.circle")
            if agreementImageView.tintColor == .mainColor {
                allAgreeLabel.textColor = .mainColor
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextTapped))
            }
        } else {
            privacyImageView.tintColor = .systemGray3
            privacyImageView.image = UIImage(systemName: "circle")
            allAgreeLabel.textColor = .systemGray3
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func termsPrivacyTapped() {
        let termsVC = TermsViewController()
        termsVC.path = "privacy"
        navigationController?.pushViewController(termsVC, animated: true)
    }
    
    @objc func allAgreeTapped() {
        if allAgreeLabel.textColor == .systemGray3 {
            agreementImageView.tintColor = .mainColor
            agreementImageView.image = UIImage(systemName: "checkmark.circle")
            privacyImageView.tintColor = .mainColor
            privacyImageView.image = UIImage(systemName: "checkmark.circle")
            allAgreeLabel.textColor = .mainColor
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextTapped))
        } else {
            agreementImageView.tintColor = .systemGray3
            agreementImageView.image = UIImage(systemName: "circle")
            privacyImageView.tintColor = .systemGray3
            privacyImageView.image = UIImage(systemName: "circle")
            allAgreeLabel.textColor = .systemGray3
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func nextTapped() {
        guard let userType = self.userType else { return }
        let joinPhoneVC = JoinPhoneViewController()
        joinPhoneVC.userType = userType
        joinPhoneVC.socialId = socialId
        joinPhoneVC.email = email
        navigationController?.pushViewController(joinPhoneVC, animated: true)
    }
}
