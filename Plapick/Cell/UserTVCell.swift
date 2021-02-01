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
            
            photoView.setProfileImage(uId: user.id, profileImage: user.profileImage)
            
            nickNameLabel.text = user.nickName
            followerCntLabel.text = String(user.followerCnt)
            pickCntLabel.text = String(user.pickCnt)
        }
    }
    
    
    // MARK: View
    lazy var photoView: PhotoView = {
        let pv = PhotoView()
        pv.layer.cornerRadius = 25
        return pv
    }()
    
    lazy var labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cntContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var pickCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "게시한 픽 "
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var pickCntLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var followerCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로워 "
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followerCntLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
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
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setThemeColor()
    }
    func setThemeColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            backgroundColor = .black
        } else {
            backgroundColor = .white
        }
    }
    
    func configureView() {
        addSubview(photoView)
        photoView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        photoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE).isActive = true
        photoView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(labelContainerView)
        labelContainerView.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: SPACE).isActive = true
        labelContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        labelContainerView.addSubview(cntContainerView)
        cntContainerView.topAnchor.constraint(equalTo: labelContainerView.topAnchor).isActive = true
        cntContainerView.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        
        cntContainerView.addSubview(pickCntTitleLabel)
        pickCntTitleLabel.centerYAnchor.constraint(equalTo: cntContainerView.centerYAnchor).isActive = true
        pickCntTitleLabel.leadingAnchor.constraint(equalTo: cntContainerView.leadingAnchor).isActive = true
        
        cntContainerView.addSubview(pickCntLabel)
        pickCntLabel.leadingAnchor.constraint(equalTo: pickCntTitleLabel.trailingAnchor).isActive = true
        pickCntLabel.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        pickCntLabel.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        
        cntContainerView.addSubview(followerCntTitleLabel)
        followerCntTitleLabel.leadingAnchor.constraint(equalTo: pickCntLabel.trailingAnchor, constant: SPACE_XXS).isActive = true
        followerCntTitleLabel.centerYAnchor.constraint(equalTo: cntContainerView.centerYAnchor).isActive = true
        
        cntContainerView.addSubview(followerCntLabel)
        followerCntLabel.leadingAnchor.constraint(equalTo: followerCntTitleLabel.trailingAnchor).isActive = true
        followerCntLabel.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        followerCntLabel.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        
        labelContainerView.addSubview(nickNameLabel)
        nickNameLabel.topAnchor.constraint(equalTo: cntContainerView.bottomAnchor, constant: SPACE_XXS).isActive = true
        nickNameLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor).isActive = true
        nickNameLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor).isActive = true
    }
}
