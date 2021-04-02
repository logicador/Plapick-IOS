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
    
    
    // MARK: View
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sw: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .mainColor
        sw.tintColor = .mainColor
        sw.addTarget(self, action: #selector(switching), for: .touchUpInside)
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
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
        addSubview(sw)
        sw.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sw.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        sw.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(label)
        label.centerYAnchor.constraint(equalTo: sw.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func switching(sender: UISwitch) {
        guard let actionMode = self.actionMode else { return }
        delegate?.switching(actionMode: actionMode)
    }
}
