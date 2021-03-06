//
//  UploadPostsImageCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/24.
//

import UIKit
import SDWebImage


class UploadPostsImageCVCell: UICollectionViewCell {
    
    // MARK: Property
    var image: UIImage? {
        didSet {
            guard let image = self.image else { return }
            
            imageView.image = nil
            
            imageView.image = image
        }
    }
    var postsImage: PostsImage? {
        didSet {
            guard let postsImage = self.postsImage else { return }
            
            imageView.image = nil
            
            guard let url = URL(string: PLAPICK_URL + postsImage.poi_path) else { return }
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
    lazy var removeImageView: UIImageView = {
        let image = UIImage(systemName: "xmark.circle.fill")
        let iv = UIImageView(image: image)
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .white
        iv.tintColor = .systemRed
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
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        imageView.addSubview(removeImageView)
        removeImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: SPACE_XXXS).isActive = true
        removeImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -SPACE_XXXS).isActive = true
        removeImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        removeImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
}
