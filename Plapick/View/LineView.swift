//
//  LineView.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/25.
//

import UIKit


class LineView: UIView {
    
    public enum OrienTation : Int {
        case horizontal = 0
        case vertical = 1
    }
    
    
    // MARK: Init
    init(orientation: OrienTation = .horizontal, width: CGFloat = LINE_WIDTH, color: UIColor = .separator) {
        super.init(frame: CGRect.zero)
        
        backgroundColor = color
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if orientation == .horizontal {
            heightAnchor.constraint(equalToConstant: width).isActive = true
        } else {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
