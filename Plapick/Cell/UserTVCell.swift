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
            
            let cntMabs = NSMutableAttributedString()
                .normal("게시한 픽 ", size: 12, color: .systemGray)
                .bold(String(user.pickCnt), size: 12)
                .normal("  팔로워 ", size: 12, color: .systemGray)
                .bold(String(user.followerCnt), size: 12)
            cntLabel.attributedText = cntMabs
            nickNameLabel.text = user.nickName
            
            guard let profileImage = user.profileImage else { return }
            profileImageView.setProfileImage(uId: user.id, profileImage: profileImage)
        }
    }
    
    
    // MARK: View
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 25
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
    
    lazy var cntLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(labelContainerView)
        labelContainerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        labelContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        labelContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        labelContainerView.addSubview(cntLabel)
        cntLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor).isActive = true
        cntLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        
        labelContainerView.addSubview(nickNameLabel)
        nickNameLabel.topAnchor.constraint(equalTo: cntLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        nickNameLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        nickNameLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor).isActive = true
    }
}
