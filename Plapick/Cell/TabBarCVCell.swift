//
//  TabBarCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class TabBarCVCell: UICollectionViewCell {
    
    // MARK: Properties
    override var isSelected: Bool {
        didSet {
            adjustColors()
        }
    }
    
    
    // MARK: Views
    lazy var tabLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(tabLabel)
        tabLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tabLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
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
        tabLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 17) : UIFont.systemFont(ofSize: 17)
        tabLabel.textColor = isSelected ? UIColor.systemBackground.inverted : .systemGray
        
        if self.traitCollection.userInterfaceStyle == .dark {
        } else {
        }
    }
}
