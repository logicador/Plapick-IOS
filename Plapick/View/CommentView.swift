//
//  CommentView.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/01.
//

import UIKit
import SDWebImage


protocol CommentViewProtocol {
    func openUser(uId: Int)
    func removeComment(comment: Comment)
}


class CommentView: UIView {
    
    // MARK: Property
    let app = App()
    var delegate: CommentViewProtocol?
    var comment: Comment? {
        didSet {
            guard let comment = self.comment else { return }
            
            photoView.setProfileImage(uId: comment.uId, profileImage: comment.profileImage)
            
            nickNameLabel.text = comment.nickName
            dateLabel.text = String(comment.createdDate.split(separator: " ")[0])
            commentLabel.text = comment.comment
            
            if comment.uId == app.getUId() {
                
            }
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = SPACE_XS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var photoView: PhotoView = {
        let pv = PhotoView()
        pv.layer.cornerRadius = 20
        pv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoTapped)))
        return pv
    }()
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_S).isActive = true
        photoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: SPACE_S).isActive = true
        photoView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(nickNameLabel)
        nickNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_S).isActive = true
        nickNameLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: SPACE_S).isActive = true
        
        containerView.addSubview(dateLabel)
        dateLabel.centerYAnchor.constraint(equalTo: nickNameLabel.centerYAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: nickNameLabel.trailingAnchor, constant: SPACE_XS).isActive = true
        
        containerView.addSubview(removeButton)
        removeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_S).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -SPACE_S).isActive = true
        
        containerView.addSubview(commentLabel)
        commentLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: SPACE_S).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -SPACE_S).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -SPACE_S).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func photoTapped() {
        guard let comment = self.comment else { return }
        delegate?.openUser(uId: comment.uId)
    }
    
    @objc func removeTapped() {
        guard let comment = self.comment else { return }
        delegate?.removeComment(comment: comment)
    }
}
