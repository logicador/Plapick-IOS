//
//  PlaceCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit


class PlaceCVCell: UICollectionViewCell {
    
    // MARK: Property
    var app = App()
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
//            if place.mostPickList.count > 0 {
//                noPickLabel.isHidden = true
//                let uId = place.mostPickList[0].uId
//                let piId = place.mostPickList[0].id
//                if let url = URL(string: "\(IMAGE_URL)/users/\(uId)/\(piId).jpg") {
//                    photoView.sd_setImage(with: url, completed: nil)
//                }
//                
//            } else {
//                photoView.image = nil
//                noPickLabel.isHidden = false
//            }
            nameLabel.text = place.name
            
            if place.pickImageList.count > 0 {
                guard let url = URL(string: place.pickImageList[0]) else { return }
                imageView.sd_setImage(with: url, completed: nil)
            } else { imageView.image = nil }
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = SPACE_XS
        view.layer.borderWidth = LINE_WIDTH
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 0
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
    func setThemeColor() { containerView.layer.borderColor = UIColor.separator.cgColor }
    
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE_XXS).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SPACE_XXS).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        containerView.addSubview(headerView)
        headerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        headerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: SPACE_XS).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: SPACE_XS).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -SPACE_XS).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -SPACE_XS).isActive = true
    }
}
