//
//  UserTVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit
import SDWebImage


class UserTVCell: UITableViewCell {
    
    // MARK: Property
    var user: User? {
        didSet {
            guard let user = self.user else { return }
            
            guard let profileImage = user.u_profile_image else { return }
            guard let url = URL(string: PLAPICK_URL + profileImage) else { return }
            profileImageView.sd_setImage(with: url, completed: nil)
            
            let cntMabs = NSMutableAttributedString()
                .normal("게시물 ", size: 12, color: .systemGray3)
                .bold(String(user.u_posts_cnt), size: 12, color: .systemGray)
                .normal("  플레이스 ", size: 12, color: .systemGray3)
                .bold(String(user.u_place_cnt), size: 12, color: .systemGray)
                .normal("  팔로워 ", size: 12, color: .systemGray3)
                .bold(String(user.u_follower_cnt), size: 12, color: .systemGray)
                .normal("  팔로잉 ", size: 12, color: .systemGray3)
                .bold(String(user.u_following_cnt), size: 12, color: .systemGray)
            cntLabel.attributedText = cntMabs
            
            nicknameLabel.text = user.u_nickname
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
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = LINE_WIDTH
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var cntLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
        setThemeColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        profileImageView.layer.borderColor = UIColor.separator.cgColor
    }
    
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(labelContainerView)
        labelContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        labelContainerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        labelContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        labelContainerView.addSubview(cntLabel)
        cntLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor).isActive = true
        cntLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        cntLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor).isActive = true
        
        labelContainerView.addSubview(nicknameLabel)
        nicknameLabel.topAnchor.constraint(equalTo: cntLabel.bottomAnchor, constant: SPACE_XXS).isActive = true
        nicknameLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        nicknameLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor).isActive = true
        nicknameLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor).isActive = true
    }
}
