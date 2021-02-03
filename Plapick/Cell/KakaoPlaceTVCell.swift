//
//  KakaoPlaceTVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/03.
//

import UIKit


class KakaoPlaceTVCell: UITableViewCell {
    
    // MARK: Property
    var kakaoPlace: KakaoPlace? {
        didSet {
            guard let kakaoPlace = self.kakaoPlace else { return }
            nameLabel.text = kakaoPlace.placeName
            addressLabel.text = (kakaoPlace.roadAddressName.isEmpty) ? kakaoPlace.addressName : kakaoPlace.roadAddressName
        }
    }
    
    
    // MARK: View
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: SPACE_S).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SPACE).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        addSubview(addressLabel)
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SPACE).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE_S).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
}
