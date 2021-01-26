//
//  PlaceCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/25.
//

import UIKit


class PlaceTVCell: UITableViewCell {
    
    // MARK: Property
    let ICON_WIDTH: CGFloat = 30
    var app = App()
    var index: Int?
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            let categoryName = app.getCategoryString(categoryName: place.categoryName ?? "")
            categoryNameLabel.text = categoryName

            nameLabel.text = place.name

            let address = place.address ?? ""
            let roadAddress = place.roadAddress ?? ""
            addressLabel.text = (roadAddress.isEmpty) ? address : roadAddress

            likeCntLabel.text = String(place.likeCnt)
            commentCntLabel.text = String(place.commentCnt)
            pickCntLabel.text = String(place.pickCnt)
        }
    }
    
    
    // MARK: View
    lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var wrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .link
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Cnt
    lazy var cntContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Cnt - Like
    lazy var likeCntContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var likeCntWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var likeCntImageView: UIImageView = {
        let img = UIImage(systemName: "heart.circle")
        let iv = UIImageView(image: img)
        iv.tintColor = .systemRed
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var likeCntLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Cnt - Comment
    lazy var commentCntContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var commentCntWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var commentCntImageView: UIImageView = {
        let img = UIImage(systemName: "message.circle")
        let iv = UIImageView(image: img)
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var commentCntLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Cnt - Pick
    lazy var pickCntContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var pickCntWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var pickCntImageView: UIImageView = {
        let img = UIImage(systemName: "camera.circle")
        let iv = UIImageView(image: img)
        iv.tintColor = .mainColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var pickCntLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(view)
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: SPACE_S).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -SPACE_S).isActive = true
        
        containerView.addSubview(wrapperView)
        wrapperView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE).isActive = true
        wrapperView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: SPACE_L).isActive = true
        wrapperView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -SPACE_L).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -SPACE).isActive = true
        
        wrapperView.addSubview(categoryNameLabel)
        categoryNameLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor).isActive = true
        categoryNameLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
        categoryNameLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
        categoryNameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true // sibal cell

        wrapperView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        wrapperView.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        // MARK: ConfigureView - Cnt
        wrapperView.addSubview(cntContainerView)
        cntContainerView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: SPACE_S).isActive = true
        cntContainerView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
        cntContainerView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
        cntContainerView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor).isActive = true
        
        // MARK: Cnt - Like
        cntContainerView.addSubview(likeCntContainerView)
        likeCntContainerView.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        likeCntContainerView.widthAnchor.constraint(equalTo: cntContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        likeCntContainerView.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        likeCntContainerView.leadingAnchor.constraint(equalTo: cntContainerView.leadingAnchor).isActive = true

        likeCntContainerView.addSubview(likeCntWrapperView)
        likeCntWrapperView.topAnchor.constraint(equalTo: likeCntContainerView.topAnchor).isActive = true
        likeCntWrapperView.leadingAnchor.constraint(equalTo: likeCntContainerView.leadingAnchor).isActive = true
        likeCntWrapperView.bottomAnchor.constraint(equalTo: likeCntContainerView.bottomAnchor).isActive = true

        likeCntWrapperView.addSubview(likeCntImageView)
        likeCntImageView.topAnchor.constraint(equalTo: likeCntWrapperView.topAnchor).isActive = true
        likeCntImageView.leadingAnchor.constraint(equalTo: likeCntWrapperView.leadingAnchor).isActive = true
        likeCntImageView.widthAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        likeCntImageView.heightAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        likeCntImageView.bottomAnchor.constraint(equalTo: likeCntWrapperView.bottomAnchor).isActive = true

        likeCntWrapperView.addSubview(likeCntLabel)
        likeCntLabel.centerYAnchor.constraint(equalTo: likeCntImageView.centerYAnchor).isActive = true
        likeCntLabel.leadingAnchor.constraint(equalTo: likeCntImageView.trailingAnchor, constant: SPACE_XXS).isActive = true
        likeCntLabel.trailingAnchor.constraint(equalTo: likeCntWrapperView.trailingAnchor).isActive = true

        // MARK: Cnt - Comment
        cntContainerView.addSubview(commentCntContainerView)
        commentCntContainerView.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        commentCntContainerView.widthAnchor.constraint(equalTo: cntContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        commentCntContainerView.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        commentCntContainerView.centerXAnchor.constraint(equalTo: cntContainerView.centerXAnchor).isActive = true

        commentCntContainerView.addSubview(commentCntWrapperView)
        commentCntWrapperView.topAnchor.constraint(equalTo: commentCntContainerView.topAnchor).isActive = true
        commentCntWrapperView.centerXAnchor.constraint(equalTo: commentCntContainerView.centerXAnchor).isActive = true
        commentCntWrapperView.bottomAnchor.constraint(equalTo: commentCntContainerView.bottomAnchor).isActive = true

        commentCntWrapperView.addSubview(commentCntImageView)
        commentCntImageView.topAnchor.constraint(equalTo: commentCntWrapperView.topAnchor).isActive = true
        commentCntImageView.leadingAnchor.constraint(equalTo: commentCntWrapperView.leadingAnchor).isActive = true
        commentCntImageView.widthAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        commentCntImageView.heightAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        commentCntImageView.bottomAnchor.constraint(equalTo: commentCntWrapperView.bottomAnchor).isActive = true

        commentCntWrapperView.addSubview(commentCntLabel)
        commentCntLabel.centerYAnchor.constraint(equalTo: commentCntImageView.centerYAnchor).isActive = true
        commentCntLabel.leadingAnchor.constraint(equalTo: commentCntImageView.trailingAnchor, constant: SPACE_XXS).isActive = true
        commentCntLabel.trailingAnchor.constraint(equalTo: commentCntWrapperView.trailingAnchor).isActive = true

        // MARK: Cnt - Pick
        cntContainerView.addSubview(pickCntContainerView)
        pickCntContainerView.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        pickCntContainerView.widthAnchor.constraint(equalTo: cntContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        pickCntContainerView.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        pickCntContainerView.trailingAnchor.constraint(equalTo: cntContainerView.trailingAnchor).isActive = true

        pickCntContainerView.addSubview(pickCntWrapperView)
        pickCntWrapperView.topAnchor.constraint(equalTo: pickCntContainerView.topAnchor).isActive = true
        pickCntWrapperView.trailingAnchor.constraint(equalTo: pickCntContainerView.trailingAnchor).isActive = true
        pickCntWrapperView.bottomAnchor.constraint(equalTo: pickCntContainerView.bottomAnchor).isActive = true

        pickCntWrapperView.addSubview(pickCntImageView)
        pickCntImageView.topAnchor.constraint(equalTo: pickCntWrapperView.topAnchor).isActive = true
        pickCntImageView.leadingAnchor.constraint(equalTo: pickCntWrapperView.leadingAnchor).isActive = true
        pickCntImageView.widthAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        pickCntImageView.heightAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        pickCntImageView.bottomAnchor.constraint(equalTo: pickCntWrapperView.bottomAnchor).isActive = true

        pickCntWrapperView.addSubview(pickCntLabel)
        pickCntLabel.centerYAnchor.constraint(equalTo: pickCntImageView.centerYAnchor).isActive = true
        pickCntLabel.leadingAnchor.constraint(equalTo: pickCntImageView.trailingAnchor, constant: SPACE_XXS).isActive = true
        pickCntLabel.trailingAnchor.constraint(equalTo: pickCntWrapperView.trailingAnchor).isActive = true
    }
}
