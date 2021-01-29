//
//  PlaceSmallView.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/27.
//

import UIKit


class PlaceSmallView: UIView {
    
    // MARK: Property
    var place: Place? {
        didSet {
            
        }
    }
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
