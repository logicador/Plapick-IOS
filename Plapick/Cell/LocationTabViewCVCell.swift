//
//  LocationTabViewCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class LocationTabViewCVCell: UICollectionViewCell {
    
    // MARK: Properties
    var tabIndex: Int? {
        didSet {
//            let viewController: UIViewController?
//            
//            if tabIndex == 0 {
////                viewController = LocationListViewController()
//            } else {
//                viewController = LocationMapViewController()
//            }
            
//            guard let vc = viewController else { return }
//            
//            vc.view.translatesAutoresizingMaskIntoConstraints = false
//            addSubview(vc.view)
//            vc.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
//            vc.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//            vc.view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//            vc.view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//            vc.view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//            vc.view.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
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
