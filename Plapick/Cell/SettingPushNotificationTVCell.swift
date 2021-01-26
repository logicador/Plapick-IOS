//
//  SettingPushNotificationTVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/17.
//

import UIKit


protocol SettingPushNotificationTVCellProtocol {
    func switching(action: String, isAllowed: String)
}


class SettingPushNotificationTVCell: UITableViewCell {
    
    // MARK: Properties
    var delegate: SettingPushNotificationTVCellProtocol?
    var app = App()
    var settingPushNotification: SettingPushNotification? {
        didSet {
            titleLabel.text = settingPushNotification?.title
            switchView.setOn(settingPushNotification!.isOn, animated: true)
        }
    }
    
    
    // MARK: Views
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var switchView: UISwitch = {
        let sv = UISwitch()
        sv.onTintColor = .mainColor
        sv.tintColor = .mainColor
        sv.addTarget(self, action: #selector(switching(sender:)), for: UIControl.Event.touchUpInside)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.isUserInteractionEnabled = false
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(switchView)
        switchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        switchView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        titleLabel.trailingAnchor.constraint(equalTo: switchView.leadingAnchor, constant: -20).isActive = true
        
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
        if self.traitCollection.userInterfaceStyle == .dark {
            backgroundColor = .systemGray6
        } else {
            backgroundColor = .systemBackground
        }
    }
    
    @objc func switching(sender: UISwitch) {
        guard let settingPushNotification = self.settingPushNotification else { return }
        delegate?.switching(action: settingPushNotification.action, isAllowed: (sender.isOn ? "Y" : "N"))
    }
}
