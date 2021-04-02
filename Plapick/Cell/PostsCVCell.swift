//
//  PostsCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/24.
//

import UIKit
import SDWebImage


class PostsCVCell: UICollectionViewCell {
    
    // MARK: Property
    var posts: Posts? {
        didSet {
            guard let posts = self.posts else { return }
            
            let splittedPoi = posts.poi.split(separator: "|")
            
            iconImageView.isHidden = (splittedPoi.count > 1) ? false : true
            
            guard let firstPoi = splittedPoi.first else { return }
            guard let url = URL(string: PLAPICK_URL + String(firstPoi.split(separator: ":")[1])) else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    var postsImageList: [PostsImage] = []
    
    
    // MARK: View
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var iconImageView: UIImageView = {
        let image = UIImage(systemName: "square.stack.3d.down.forward.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
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
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        imageView.addSubview(iconImageView)
        iconImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: SPACE_XXS).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -SPACE_XXS).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
