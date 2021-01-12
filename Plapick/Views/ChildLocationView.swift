//
//  ChildLocationView.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/06.
//

import UIKit


// MARK: Protocol
protocol ChildLocationViewProtocol {
    func selectChildLocation(index: Int)
}


class ChildLocationView: UIView {
    
    // MARK: Properties
    var delegate: ChildLocationViewProtocol?
    var index: Int?
    
    
    // MARK: Views
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    init(index: Int, name: String) {
        super.init(frame: CGRect.zero)
        
        self.index = index
        label.text = name
        
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Functions
    @objc func selfTapped() {
        guard let index = self.index else { return }
        delegate?.selectChildLocation(index: index)
    }
}
