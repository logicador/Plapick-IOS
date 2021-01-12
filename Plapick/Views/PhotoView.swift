//
//  PhotoView.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class PhotoView: UIImageView {
    
    
    // MARK: Init
    init(photoUrl: String) {
        super.init(frame: CGRect.zero)
        
        contentMode = .scaleAspectFill
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        load(urlString: photoUrl)
        
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
        if self.traitCollection.userInterfaceStyle == .dark {
            backgroundColor = .systemGray6
        } else {
            backgroundColor = .systemBackground
        }
    }
}
