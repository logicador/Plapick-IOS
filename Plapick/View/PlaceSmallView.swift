//
//  PlaceSmallView.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/27.
//

import UIKit


class PlaceSmallView: UIView {
    
    // MARK: Property
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            nameLabel.text = place.name
            addressLabel.text = (place.roadAddress.isEmpty) ? place.address : place.roadAddress
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = SPACE_XS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let image = UIImage(systemName: "airplane.circle.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_XL).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XXS).isActive = true
        addressLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        containerView.addSubview(iconImageView)
        iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_XS).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: SPACE_XS).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: SPACE_XL).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: SPACE_XL).isActive = true
    }
}
