//
//  PhotoView.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class PhotoView: UIImageView {
    
    // MARK: Init
    init(cons: Bool = false, contentMode: ContentMode = .scaleAspectFill) {
        super.init(frame: CGRect.zero)
        
        backgroundColor = .systemGray6
        
        self.contentMode = contentMode
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        translatesAutoresizingMaskIntoConstraints = cons
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
