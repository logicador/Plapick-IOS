//
//  TitleView.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


// MARK: Protocol
protocol TitleViewProtocol {
    func actionTapped(actionMode: String)
}


class TitleView: UIView {
    
    // MARK: Propreties
    var delegate: TitleViewProtocol?
    var actionMode: String?
    
    
    // MARK: Views
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28) // same Large Title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.addTarget(self, action: #selector(actionButtonTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var panel: UIView = {
        let view = UIView()
        
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    lazy var topLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .separator
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    lazy var bottomLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .separator
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    
    // MARK: Init
    init(titleText: String, isAction: Bool = false, actionText: String?, actionMode: String?) {
        super.init(frame: CGRect.zero)
        
        titleLabel.text = titleText
        
        addSubview(panel)
        panel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        panel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        panel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        panel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
//        addSubview(topLineView)
//        topLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        topLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        topLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        topLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
//
//        addSubview(bottomLineView)
//        bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        bottomLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        if isAction {
            panel.addSubview(actionButton)
            actionButton.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
            actionButton.centerYAnchor.constraint(equalTo: panel.centerYAnchor).isActive = true
            actionButton.setTitle(actionText, for: UIControl.State.normal)
            self.actionMode = actionMode
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
//        adjustColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Functions
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        adjustColors()
//    }
//    func adjustColors() {
//        if self.traitCollection.userInterfaceStyle == .dark {
//            backgroundColor = .systemGray6
//        } else {
//            backgroundColor = .systemBackground
//        }
//    }
    
    @objc func actionButtonTapped() {
        guard let actionMode = self.actionMode else { return }
        delegate?.actionTapped(actionMode: actionMode)
    }
}
