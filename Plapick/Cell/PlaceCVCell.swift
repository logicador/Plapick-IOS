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
            
            if place.mostPickList.count > 0 {
                noPickLabel.isHidden = true
                let uId = place.mostPickList[0].uId
                let piId = place.mostPickList[0].id
                if let url = URL(string: app.getPickUrl(id: piId, uId: uId)) {
                    photoView.sd_setImage(with: url, completed: nil)
                }
                
            } else {
                photoView.image = nil
                noPickLabel.isHidden = false
            }
            nameLabel.text = place.name
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
    
    lazy var photoView: PhotoView = {
        let pv = PhotoView()
        return pv
    }()
    
    lazy var noPickLabel: UILabel = {
        let label = UILabel()
        label.text = "등록된 픽이 없습니다."
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
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
    func setThemeColor() {
        containerView.layer.borderColor = UIColor.separator.cgColor
        if self.traitCollection.userInterfaceStyle == .dark {
        } else {
        }
    }
    
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE_XXS).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SPACE_XXS).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        photoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        photoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        photoView.addSubview(headerView)
        headerView.bottomAnchor.constraint(equalTo: photoView.bottomAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: photoView.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: photoView.trailingAnchor).isActive = true
        
        headerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: SPACE_S).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: SPACE_S).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -SPACE_S).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -SPACE_S).isActive = true
        
        photoView.addSubview(noPickLabel)
        noPickLabel.centerXAnchor.constraint(equalTo: photoView.centerXAnchor).isActive = true
        noPickLabel.centerYAnchor.constraint(equalTo: photoView.centerYAnchor, constant: -SPACE_S).isActive = true
    }
}
