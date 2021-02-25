//
//  NoDataView.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/04.
//

import UIKit


class NoDataView: UIView {
    
    // MARK: View
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    init(size: CGFloat, text: String, isConstant: Bool = true) {
        super.init(frame: .zero)
        
        label.text = text
        label.font = UIFont.systemFont(ofSize: size)
        
        backgroundColor = .systemGray6
        layer.cornerRadius = SPACE_XS
        
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        if isConstant {
            label.topAnchor.constraint(equalTo: topAnchor, constant: NO_DATA_SPACE).isActive = true
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -NO_DATA_SPACE).isActive = true
        } else {
            label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
