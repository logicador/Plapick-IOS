//
//  TitleView.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


// MARK: Protocol
protocol TitleViewProtocol {
    func action(actionMode: String)
}


class TitleView: UIView {
    
    // MARK: Proprety
    var delegate: TitleViewProtocol?
    var actionMode: String?
    public enum Style : Int {
        case ultraSmall = 0
        case small = 1
        case medium = 2
        case large = 3
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.addTarget(self, action: #selector(actionTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: Init
    init(text: String, style: Style = .large, isAction: Bool = false, actionText: String? = nil, actionMode: String? = nil) {
        super.init(frame: CGRect.zero)
        
        label.text = text
        
        var topConstant = SPACE_XXXL
        var bottomConstant = -SPACE_XXL
        
        if style == .ultraSmall {
            label.font = UIFont.boldSystemFont(ofSize: 20)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            topConstant = SPACE_L
            bottomConstant = -SPACE
            
        } else if style == .small {
            label.font = UIFont.boldSystemFont(ofSize: 24)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            topConstant = SPACE_XL
            bottomConstant = -SPACE_L
            
        } else if style == .medium {
            label.font = UIFont.boldSystemFont(ofSize: 28)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            topConstant = SPACE_XXL
            bottomConstant = -SPACE_XL
            
        } else {
            label.font = UIFont.boldSystemFont(ofSize: 32)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        }
        
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(label)
        label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topConstant).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: bottomConstant).isActive = true
        
        if isAction {
            self.actionMode = actionMode
            button.setTitle(actionText, for: UIControl.State.normal)
            
            containerView.addSubview(button)
            button.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        }
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function
    // MARK: Function - @OBJC
    @objc func actionTapped() {
        guard let actionMode = self.actionMode else { return }
        delegate?.action(actionMode: actionMode)
    }
}
