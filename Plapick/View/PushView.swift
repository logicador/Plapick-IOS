//
//  PushView.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/27.
//

import UIKit


protocol PushViewProtocol {
    func switching(actionMode: String)
}


class PushView: UIView {
    
    // MARK: Property
    var delegate: PushViewProtocol?
    var actionMode: String?
    
    
    // MARK: Views
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var push: UISwitch = {
        let sv = UISwitch()
        sv.onTintColor = .mainColor
        sv.tintColor = .mainColor
        sv.addTarget(self, action: #selector(switching(sender:)), for: UIControl.Event.touchUpInside)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor, constant: SPACE_XS).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE_XS).isActive = true
        
        addSubview(push)
        push.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        push.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    // MARK: Function - @OBJC
    @objc func switching(sender: UISwitch) {
        guard let actionMode = self.actionMode else { return }
        delegate?.switching(actionMode: actionMode)
    }
}
