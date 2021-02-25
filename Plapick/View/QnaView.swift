//
//  QnaView.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/06.
//

import UIKit


protocol QnaViewProtocol {
    func removeQna(qna: Qna)
}


class QnaView: UIView {
    
    // MARK: Property
    var delegate: QnaViewProtocol?
    var qna: Qna? {
        didSet {
            guard let qna = self.qna else { return }
            
            createdDateLabel.text = qna.createdDate
            titleLabel.text = qna.title
            contentLabel.text = qna.content
            
            if qna.status == "Q" {
                line.isHidden = true
                answerStackView.isHidden = true
                
            } else {
                answerDateLabel.text = qna.answeredDate
                answerContentLabel.text = qna.answer
            }
        }
    }
    
    
    // MARK: View
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var line: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Question
    lazy var questionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XXS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var questionImageView: UIImageView = {
        let image = UIImage(systemName: "arrowshape.turn.up.right.circle.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var dateContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Answer
    lazy var answerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XXS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var answerImageView: UIImageView = {
        let image = UIImage(systemName: "arrowshape.turn.up.backward.circle.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var answerDateContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var answerDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var answerContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
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
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE).isActive = true
        
        stackView.addArrangedSubview(questionStackView)
        questionStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        questionStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        questionStackView.addArrangedSubview(dateContainerView)
        dateContainerView.leadingAnchor.constraint(equalTo: questionStackView.leadingAnchor).isActive = true
        dateContainerView.trailingAnchor.constraint(equalTo: questionStackView.trailingAnchor).isActive = true
        
        dateContainerView.addSubview(questionImageView)
        questionImageView.topAnchor.constraint(equalTo: dateContainerView.topAnchor).isActive = true
        questionImageView.leadingAnchor.constraint(equalTo: dateContainerView.leadingAnchor).isActive = true
        questionImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        questionImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        questionImageView.bottomAnchor.constraint(equalTo: dateContainerView.bottomAnchor).isActive = true
        
        dateContainerView.addSubview(createdDateLabel)
        createdDateLabel.centerYAnchor.constraint(equalTo: questionImageView.centerYAnchor).isActive = true
        createdDateLabel.leadingAnchor.constraint(equalTo: questionImageView.trailingAnchor, constant: SPACE_XXS).isActive = true
        
        dateContainerView.addSubview(removeButton)
        removeButton.centerYAnchor.constraint(equalTo: questionImageView.centerYAnchor).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: dateContainerView.trailingAnchor).isActive = true
        
        questionStackView.addArrangedSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: questionStackView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: questionStackView.trailingAnchor).isActive = true

        questionStackView.addArrangedSubview(contentLabel)
        contentLabel.leadingAnchor.constraint(equalTo: questionStackView.leadingAnchor).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: questionStackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(line)
        line.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(answerStackView)
        answerStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        answerStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        answerStackView.addArrangedSubview(answerDateContainerView)
        answerDateContainerView.leadingAnchor.constraint(equalTo: answerStackView.leadingAnchor).isActive = true
        answerDateContainerView.trailingAnchor.constraint(equalTo: answerStackView.trailingAnchor).isActive = true
        
        answerDateContainerView.addSubview(answerImageView)
        answerImageView.topAnchor.constraint(equalTo: answerDateContainerView.topAnchor).isActive = true
        answerImageView.trailingAnchor.constraint(equalTo: answerDateContainerView.trailingAnchor).isActive = true
        answerImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        answerImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        answerImageView.bottomAnchor.constraint(equalTo: answerDateContainerView.bottomAnchor).isActive = true
        
        answerDateContainerView.addSubview(answerDateLabel)
        answerDateLabel.centerYAnchor.constraint(equalTo: answerImageView.centerYAnchor).isActive = true
        answerDateLabel.trailingAnchor.constraint(equalTo: answerImageView.leadingAnchor, constant: -SPACE_XXS).isActive = true
        
        answerStackView.addArrangedSubview(answerContentLabel)
        answerContentLabel.leadingAnchor.constraint(equalTo: answerStackView.leadingAnchor).isActive = true
        answerContentLabel.trailingAnchor.constraint(equalTo: answerStackView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func removeTapped() {
        guard let qna = self.qna else { return }
        self.delegate?.removeQna(qna: qna)
    }
}
