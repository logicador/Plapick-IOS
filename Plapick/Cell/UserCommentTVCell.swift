//
//  UserCommentTVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/04/01.
//

import UIKit


class UserCommentTVCell: UITableViewCell {
    
    // MARK: Property
    var userComment: UserComment? {
        didSet {
            guard let userComment = self.userComment else { return }
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let nowDate = Date()
            let nowString = df.string(from: nowDate)
            guard let startTime = df.date(from: userComment.createdDate) else { return }
            guard let endTime = df.date(from: nowString) else { return }
            let useDay = Int(endTime.timeIntervalSince(startTime)) / 86400
            
            if useDay == 0 { dateLabel.text = "오늘" }
            else if (useDay > 0 && useDay < 7) || (useDay > 7 && useDay < 14) || (useDay > 14 && useDay < 21) { dateLabel.text = "\(useDay)일 전" }
            else if useDay == 7 || useDay == 14 || useDay == 21 { dateLabel.text = "\(useDay / 7)주 전" }
            else { dateLabel.text = userComment.createdDate.split(separator: " ")[0].replacingOccurrences(of: "-", with: ". ") }
            
            commentLabel.text = userComment.comment
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE).isActive = true
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE).isActive = true
        
        containerView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        containerView.addSubview(commentLabel)
        commentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
}
