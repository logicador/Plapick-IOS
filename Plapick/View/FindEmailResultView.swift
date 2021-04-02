//
//  FindEmailView.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/21.
//

import UIKit
import SDWebImage


class FindEmailResultView: UIView {
    
    // MARK: Property
    var user: User? {
        didSet {
            guard let user = self.user else { return }
            
            if let createdDate = user.u_created_date {
                headerLabel.text = "\(user.u_nickname), \(String(createdDate.split(separator: " ")[0]).replacingOccurrences(of: "-", with: ". ")) 가입"
            } else {
                headerLabel.text = user.u_nickname
            }
            emailLabel.text = user.u_email ?? ""
            
            guard let profileImage = user.u_profile_image else { return }
            guard let url = URL(string: PLAPICK_URL + profileImage) else { return }
            profileImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray6
        iv.layer.borderWidth = LINE_WIDTH
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        configureView()
        
        setThemeColor()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        profileImageView.layer.borderColor = UIColor.separator.cgColor
    }
    
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_XS).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        containerView.addSubview(labelContainerView)
        labelContainerView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        labelContainerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        labelContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        labelContainerView.addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        
        labelContainerView.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 2).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor).isActive = true
    }
}
