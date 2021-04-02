//
//  PlaceCommentTVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/04/01.
//

import UIKit
import SDWebImage


protocol PlaceCommentTVCellProtocol {
    func selectUser(uId: Int)
    func more(placeComment: PlaceComment)
}


class PlaceCommentTVCell: UITableViewCell {
    
    // MARK: Property
    var delegate: PlaceCommentTVCellProtocol?
    var placeComment: PlaceComment? {
        didSet {
            guard let placeComment = self.placeComment else { return }
            
            guard let profileImage = placeComment.u_profile_image else { return }
            guard let url = URL(string: PLAPICK_URL + profileImage) else { return }
            profileImageView.sd_setImage(with: url, completed: nil)
            
            nicknameLabel.text = placeComment.u_nickname
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let nowDate = Date()
            let nowString = df.string(from: nowDate)
            guard let startTime = df.date(from: placeComment.pc_created_date) else { return }
            guard let endTime = df.date(from: nowString) else { return }
            let useDay = Int(endTime.timeIntervalSince(startTime)) / 86400
            
            if useDay == 0 { dateLabel.text = "오늘" }
            else if (useDay > 0 && useDay < 7) || (useDay > 7 && useDay < 14) || (useDay > 14 && useDay < 21) { dateLabel.text = "\(useDay)일 전" }
            else if useDay == 7 || useDay == 14 || useDay == 21 { dateLabel.text = "\(useDay / 7)주 전" }
            else { dateLabel.text = placeComment.pc_created_date.split(separator: " ")[0].replacingOccurrences(of: "-", with: ". ") }
            
            commentLabel.text = placeComment.pc_comment
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XXS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray6
        iv.layer.borderWidth = LINE_WIDTH
        iv.layer.cornerRadius = 20
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTapped)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var moreContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moreTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var moreImageView: UIImageView = {
        let image = UIImage(systemName: "ellipsis")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        
        configureView()
        
        setThemeColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        profileImageView.layer.borderColor = UIColor.separator.cgColor
    }
    
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE).isActive = true
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE).isActive = true
        
        containerView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40 + SPACE_XS).isActive = true
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(headerContainerView)
        headerContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        headerContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        headerContainerView.addSubview(nicknameLabel)
        nicknameLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        nicknameLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        nicknameLabel.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        
        headerContainerView.addSubview(dateLabel)
        dateLabel.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: SPACE_XXS).isActive = true
        
        headerContainerView.addSubview(moreContainerView)
        moreContainerView.topAnchor.constraint(equalTo: nicknameLabel.topAnchor).isActive = true
        moreContainerView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        moreContainerView.bottomAnchor.constraint(equalTo: nicknameLabel.bottomAnchor).isActive = true
        
        moreContainerView.addSubview(moreImageView)
        moreImageView.centerYAnchor.constraint(equalTo: moreContainerView.centerYAnchor).isActive = true
        moreImageView.leadingAnchor.constraint(equalTo: moreContainerView.leadingAnchor, constant: SPACE_XXS).isActive = true
        moreImageView.trailingAnchor.constraint(equalTo: moreContainerView.trailingAnchor).isActive = true
        moreImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        moreImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        stackView.addArrangedSubview(commentLabel)
        commentLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        containerView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func userTapped() {
        guard let placeComment = self.placeComment else { return }
        delegate?.selectUser(uId: placeComment.pc_u_id)
    }
    
    @objc func moreTapped() {
        guard let placeComment = self.placeComment else { return }
        delegate?.more(placeComment: placeComment)
    }
}
