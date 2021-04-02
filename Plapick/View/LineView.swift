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
    init(orientation: OrienTation = .horizontal, width: CGFloat = LINE_WIDTH) {
        super.init(frame: CGRect.zero)
        
        layer.borderWidth = width / 2
        
        setThemeColor()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if orientation == .horizontal { heightAnchor.constraint(equalToConstant: width).isActive = true }
        else { widthAnchor.constraint(equalToConstant: width).isActive = true }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        layer.borderColor = UIColor.separator.cgColor
    }
}
