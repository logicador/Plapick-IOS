//
//  CommentView.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/01.
//

import UIKit
import SDWebImage


protocol CommentViewProtocol {
    func detailUser(user: User)
    func removeComment(id: Int)
}


class CommentView: UIView {
    
    // MARK: Property
    var delegate: CommentViewProtocol?
    var id: Int?
    var date: String? {
        didSet {
            guard let date = self.date else { return }
            dateLabel.text = String(date.split(separator: " ")[0])
        }
    }
    var comment: String? {
        didSet {
            guard let comment = self.comment else { return }
            commentLabel.text = comment
        }
    }
    var user: User? {
        didSet {
            guard let user = self.user else { return }
            
            nickNameLabel.text = user.nickName
            profileImageView.setProfileImage(uId: user.id, profileImage: user.profileImage ?? "")
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        iv.backgroundColor = .systemBackground
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTapped)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.tintColor = .systemRed
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray6
        layer.cornerRadius = SPACE_XS
        
        configureView()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE_XS).isActive = true
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE_XS).isActive = true
        
        containerView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(nickNameLabel)
        nickNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        
        containerView.addSubview(dateLabel)
        dateLabel.centerYAnchor.constraint(equalTo: nickNameLabel.centerYAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: nickNameLabel.trailingAnchor, constant: SPACE_XS).isActive = true
        
        containerView.addSubview(removeButton)
        removeButton.centerYAnchor.constraint(equalTo: nickNameLabel.centerYAnchor).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        containerView.addSubview(commentLabel)
        commentLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor ,constant: -12).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func userTapped() {
        guard let user = self.user else { return }
        delegate?.detailUser(user: user)
    }
    
    @objc func removeTapped() {
        guard let id = self.id else { return }
        delegate?.removeComment(id: id)
    }
}
