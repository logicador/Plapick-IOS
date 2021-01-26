//
//  PlaceSmallView.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class _PlaceSmallView: UIView {
    
    // MARK: Property
    var isSelected: Bool = false {
        didSet {
        }
    }
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
//            let splittedCategoryName = place.categoryName.split(separator: ">")
//            let category = String(splittedCategoryName.last ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            
//            categoryLabel.text = category
//            likeCntLabel.text = String(place.likeCnt)
//            pickCntLabel.text = String(place.pickCnt)
//            nameLabel.text = place.name
//            addressLabel.text = (place.roadAddress.isEmpty) ? place.address : place.roadAddress
        }
    }
    
    
    // MARK: View
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
        iv.tintColor = .mainColor
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
    init() {
        super.init(frame: CGRect.zero)
        
        configureView()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(categoryLabel)
        categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(pickCntLabel)
        pickCntLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(pickCntImageView)
        pickCntImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pickCntImageView.widthAnchor.constraint(equalToConstant: ICON_SIZE_XS).isActive = true
        pickCntImageView.heightAnchor.constraint(equalToConstant: ICON_SIZE_XS).isActive = true
        pickCntImageView.trailingAnchor.constraint(equalTo: pickCntLabel.leadingAnchor, constant: -SPACE_XXXXXS).isActive = true
        
        addSubview(likeCntLabel)
        likeCntLabel.trailingAnchor.constraint(equalTo: pickCntImageView.leadingAnchor, constant: -SPACE_XXS).isActive = true
        
        addSubview(likeCntImageView)
        likeCntImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        likeCntImageView.widthAnchor.constraint(equalToConstant: ICON_SIZE_XS).isActive = true
        likeCntImageView.heightAnchor.constraint(equalToConstant: ICON_SIZE_XS).isActive = true
        likeCntImageView.trailingAnchor.constraint(equalTo: likeCntLabel.leadingAnchor, constant: -SPACE_XXXXXS).isActive = true
        
        categoryLabel.centerYAnchor.constraint(equalTo: pickCntImageView.centerYAnchor).isActive = true
        pickCntLabel.centerYAnchor.constraint(equalTo: pickCntImageView.centerYAnchor).isActive = true
        likeCntLabel.centerYAnchor.constraint(equalTo: pickCntImageView.centerYAnchor).isActive = true
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: pickCntImageView.bottomAnchor, constant: SPACE_XXS).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
