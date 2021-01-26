//
//  ParentLocationView.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/06.
//

import UIKit


// MARK: Protocol
protocol ParentLocationViewProtocol {
    func selectParentLocation(index: Int)
}


class ParentLocationView: UIView {
    
    // MARK: Properties
    var delegate: ParentLocationViewProtocol?
    var index: Int?
    
    var isSelected: Bool = false {
        didSet {
            if (isSelected) {
                backgroundColor = .systemBackground
            } else {
                backgroundColor = .tertiarySystemGroupedBackground
            }
            
            adjustColors()
        }
    }
    
    // MARK: Views
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    init(index: Int, name: String) {
        super.init(frame: CGRect.zero)
        
        self.index = index
        label.text = name
        
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
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
        label.textColor = isSelected ? UIColor.systemBackground.inverted : .systemGray
        
        if self.traitCollection.userInterfaceStyle == .dark {
        } else {
        }
    }
    
    @objc func selfTapped() {
        guard let index = self.index else { return }
        delegate?.selectParentLocation(index: index)
    }
}
