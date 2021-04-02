//
//  IconButton.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit


class IconButton: UIButton {
    
    // MARK: Property
    var text: String? {
        didSet {
            guard let text = self.text else { return }
            setTitle(text, for: .normal)
            titleLabel?.font = .systemFont(ofSize: 16)
        }
    }
    var icon: String? {
        didSet {
            guard let icon = self.icon else { return }
            iconImageView.image = UIImage(systemName: icon)
        }
    }
    
    
    // MARK: View
    lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        layer.borderWidth = LINE_WIDTH
        contentEdgeInsets = UIEdgeInsets(top: SPACE_S, left: 0, bottom: SPACE_S, right: 0)
//        contentHorizontalAlignment = .left
        
        addSubview(iconImageView)
        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE_S).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        setThemeColor()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        layer.borderColor = UIColor.separator.cgColor
    }
}
