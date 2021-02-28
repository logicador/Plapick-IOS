//
//  UserCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit
import SDWebImage


class UserCVCell: UICollectionViewCell {
    
    // MARK: Property
    var user: User? {
        didSet {
            guard let user = self.user else { return }
            
            label.text = user.nickName
            
            guard let profileImage = user.profileImage else { return }
            imageView.setProfileImage(uId: user.id, profileImage: profileImage)
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XS
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray6
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        
        setThemeColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        containerView.layer.borderColor = UIColor.separator.cgColor
    }
    
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE_XXS).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SPACE_XXS).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_XS).isActive = true
        imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: SPACE_XXS).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -SPACE_XXS).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -SPACE_XS).isActive = true
    }
}
