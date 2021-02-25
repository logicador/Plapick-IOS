//
//  PickImageCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/21.
//

import UIKit


class PickImageCVCell: UICollectionViewCell {
    
    // MARK: Property
    let app = App()
    var image: String? {
        didSet {
            guard let image = self.image else { return }
            guard let url = URL(string: image) else { return }
            imageView.sd_setImage(with: url, completed: nil)
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
//        imageView.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH / 3).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH / 3).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

