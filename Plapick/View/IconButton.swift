//
//  IconButton.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit


class IconButton: UIButton {
    
    // MARK: Property
    let iconWidth: CGFloat = 25
    var text: String? {
        didSet {
            guard let text = self.text else { return }
            setTitle(text, for: UIControl.State.normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 18)
        }
    }
    var icon: String? {
        didSet {
            guard let icon = self.icon else { return }
            iconImageView.image = UIImage(systemName: icon)
//            setImage(UIImage(systemName: icon), for: UIControl.State.normal)
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
        layer.cornerRadius = SPACE_XS
        contentEdgeInsets = UIEdgeInsets(top: SPACE, left: SPACE + iconWidth + SPACE_S, bottom: SPACE, right: 0)
        contentHorizontalAlignment = .left
        
        addSubview(iconImageView)
        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: iconWidth).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: iconWidth).isActive = true
        
//        setThemeColor()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    // MARK: Function
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
//    func setThemeColor() {
//        if self.traitCollection.userInterfaceStyle == .dark {
//            tintColor = .white
//        } else {
//            tintColor = .black
//        }
//    }
}
