//
//  PickCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/24.
//

import UIKit


class PickCVCell: UICollectionViewCell {
    
    // MARK: Property
    var pick: Pick? {
        didSet {
            guard let pick = self.pick else { return }
            
            guard let url = URL(string: "\(IMAGE_URL)/users/\(pick.uId)/\(pick.id).jpg") else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            overlayView.isHidden = (isSelected) ? false : true
        }
    }
    
    
    // MARK: View
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(overlayView)
        overlayView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        overlayView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
