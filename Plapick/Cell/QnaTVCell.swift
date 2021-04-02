//
//  QnaTVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/30.
//

import UIKit


class QnaTVCell: UITableViewCell {
    
    // MARK: Property
    var qna: Qna? {
        didSet {
            guard let qna = self.qna else { return }
            
            questionDateLabel.text = String(qna.q_created_date.split(separator: " ")[0].replacingOccurrences(of: "-", with: ". "))
            questionLabel.text = qna.q_question
            
            statusLabel.textColor = (qna.q_status == "Q") ? .systemGray3 : .mainColor
            statusLabel.text = (qna.q_status == "Q") ? "답변대기" : "답변완료"
        }
    }
    
    
    // MARK: View
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XXS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var questionDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .right
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
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE).isActive = true
        
        stackView.addArrangedSubview(questionDateLabel)
        questionDateLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        questionDateLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(questionLabel)
        questionLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        questionLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(statusLabel)
        statusLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }
}
