//
//  SettingTVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/12.
//

import UIKit


class SettingTVCell: UITableViewCell {
    
    // MARK: Properties
    var settingMenu: SettingMenu? {
        didSet {
            titleLabel.text = settingMenu?.title
            iconImageView.image = UIImage(systemName: settingMenu!.icon)
            
//            if settingMenu!.isHeader {
//                iconImageView.removeView()
//                titleLabel.removeView()
//            }
//
//            adjustColors()
        }
    }
    
    
    // MARK: Views
    lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
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
            backgroundColor = .systemGray6
        } else {
            backgroundColor = .systemBackground
        }
    }
}
