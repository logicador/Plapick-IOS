//
//  PhotoView.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class PhotoView: UIImageView {
    
    // MARK: Properties
    var isBackGround: Bool = true // for traitCollectionDidChange
    
    
    // MARK: Init
    init(isBackGround: Bool = true, isConstraints: Bool = true) {
        super.init(frame: CGRect.zero)
        
        self.isBackGround = isBackGround
        
        contentMode = .scaleAspectFill
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        if isConstraints { translatesAutoresizingMaskIntoConstraints = false }
        if isBackGround { adjustColors() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if isBackGround { adjustColors() }
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            backgroundColor = .systemGray6
        } else {
            backgroundColor = .systemBackground
        }
    }
}
