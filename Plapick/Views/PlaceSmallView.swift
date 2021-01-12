//
//  PlaceSmallView.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class PlaceSmallView: UIView {
    
    // MARK: Properties
    var isSelected: Bool = false {
        didSet {
            adjustColors()
        }
    }
    
    
    // MARK: Views
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .link
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var likeCntImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "heart")
        iv.tintColor = .systemRed
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var likeCntLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pickCntImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "camera")
        iv.tintColor = .systemOrange
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var pickCntLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cntContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    init(place: Place) {
        super.init(frame: CGRect.zero)
        
        categoryLabel.text = place.category
        likeCntLabel.text = String(place.likeCnt)
        pickCntLabel.text = String(place.pickCnt)
        nameLabel.text = place.name
        addressLabel.text = place.visibleAddress
        
        addSubview(topView)
        topView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        topView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
        topView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        topView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        topView.addSubview(categoryLabel)
        categoryLabel.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        
        topView.addSubview(cntContainerView)
        cntContainerView.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        cntContainerView.trailingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
        
        cntContainerView.addSubview(pickCntLabel)
        pickCntLabel.trailingAnchor.constraint(equalTo: cntContainerView.trailingAnchor).isActive = true
        pickCntLabel.centerYAnchor.constraint(equalTo: cntContainerView.centerYAnchor).isActive = true
        
        cntContainerView.addSubview(pickCntImageView)
        pickCntImageView.trailingAnchor.constraint(equalTo: pickCntLabel.leadingAnchor, constant: -3).isActive = true
        pickCntImageView.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        pickCntImageView.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        pickCntImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        pickCntImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        cntContainerView.addSubview(likeCntLabel)
        likeCntLabel.trailingAnchor.constraint(equalTo: pickCntImageView.leadingAnchor, constant: -10).isActive = true
        likeCntLabel.centerYAnchor.constraint(equalTo: cntContainerView.centerYAnchor).isActive = true
        
        cntContainerView.addSubview(likeCntImageView)
        likeCntImageView.trailingAnchor.constraint(equalTo: likeCntLabel.leadingAnchor, constant: -3).isActive = true
        likeCntImageView.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        likeCntImageView.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        likeCntImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        likeCntImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        likeCntImageView.leadingAnchor.constraint(equalTo: cntContainerView.leadingAnchor).isActive = true
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
        
        addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        addressLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        translatesAutoresizingMaskIntoConstraints = false
        
        adjustColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            backgroundColor = isSelected ? .tertiarySystemGroupedBackground : .systemGray6
        } else {
            backgroundColor = isSelected ? UIColor(hexString: "#EFEFEF") : .systemBackground
        }
    }
}
