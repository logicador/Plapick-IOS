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
            
            photoView.setProfileImage(uId: user.id, profileImage: user.profileImage)
            
            label.text = user.nickName
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = SPACE_XS
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var photoView: PhotoView = {
        let pv = PhotoView()
        pv.layer.cornerRadius = 20
        return pv
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
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
        
        containerView.addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_XXS).isActive = true
        photoView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        photoView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(label)
        label.topAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: SPACE_XXS).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -SPACE_XXS).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
}
