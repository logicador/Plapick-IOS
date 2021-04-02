//
//  QnaViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/31.
//

import UIKit


protocol QnaViewControllerProtocol {
    func removeQna()
}


class QnaViewController: UIViewController {
    
    // MARK: Property
    var delegate: QnaViewControllerProtocol?
    var qna: Qna? {
        didSet {
            guard let qna = self.qna else { return }
            
            questionDateLabel.text = String(qna.q_created_date.split(separator: " ")[0].replacingOccurrences(of: "-", with: ". "))
            questionLabel.text = qna.q_question
            
            if qna.q_status == "Q" {
                answerContainerView.isHidden = true
                
            } else {
                noAnserContainerView.isHidden = true
                answerDateLabel.text = String(qna.q_answered_date.split(separator: " ")[0].replacingOccurrences(of: "-", with: ". "))
                answerLabel.text = qna.q_answer ?? ""
            }
        }
    }
    let removeQnaRequest = RemoveQnaRequest()
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Question
    lazy var questionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var questionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "문의내용"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var questionDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var topLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Answer
    lazy var answerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var answerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "답변"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var answerDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - NoAnswer
    lazy var noAnserContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noAnswerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "답변을 기다리는중입니다."
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "문의글"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(removeTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
        
        configureView()
        
        setThemeColor()
        
        removeQnaRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    
        // MARK: Configure - Question
        stackView.addArrangedSubview(questionContainerView)
        questionContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        questionContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        questionContainerView.addSubview(questionTitleLabel)
        questionTitleLabel.topAnchor.constraint(equalTo: questionContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        questionTitleLabel.centerXAnchor.constraint(equalTo: questionContainerView.centerXAnchor).isActive = true
        questionTitleLabel.widthAnchor.constraint(equalTo: questionContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        questionTitleLabel.addSubview(questionDateLabel)
        questionDateLabel.centerYAnchor.constraint(equalTo: questionTitleLabel.centerYAnchor).isActive = true
        questionDateLabel.trailingAnchor.constraint(equalTo: questionTitleLabel.trailingAnchor).isActive = true
        
        questionContainerView.addSubview(questionLabel)
        questionLabel.topAnchor.constraint(equalTo: questionTitleLabel.bottomAnchor, constant: SPACE_S).isActive = true
        questionLabel.centerXAnchor.constraint(equalTo: questionContainerView.centerXAnchor).isActive = true
        questionLabel.widthAnchor.constraint(equalTo: questionContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        questionLabel.bottomAnchor.constraint(equalTo: questionContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        stackView.addArrangedSubview(topLine)
        topLine.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        topLine.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        // MARK: Configure - Answer
        stackView.addArrangedSubview(answerContainerView)
        answerContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        answerContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        answerContainerView.addSubview(answerTitleLabel)
        answerTitleLabel.topAnchor.constraint(equalTo: answerContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        answerTitleLabel.centerXAnchor.constraint(equalTo: answerContainerView.centerXAnchor).isActive = true
        answerTitleLabel.widthAnchor.constraint(equalTo: answerContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        answerTitleLabel.addSubview(answerDateLabel)
        answerDateLabel.centerYAnchor.constraint(equalTo: answerTitleLabel.centerYAnchor).isActive = true
        answerDateLabel.trailingAnchor.constraint(equalTo: answerTitleLabel.trailingAnchor).isActive = true
        
        answerContainerView.addSubview(answerLabel)
        answerLabel.topAnchor.constraint(equalTo: answerTitleLabel.bottomAnchor, constant: SPACE_S).isActive = true
        answerLabel.centerXAnchor.constraint(equalTo: answerContainerView.centerXAnchor).isActive = true
        answerLabel.widthAnchor.constraint(equalTo: answerContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        answerLabel.bottomAnchor.constraint(equalTo: answerContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        // MARK: Configure - NoAnswer
        stackView.addArrangedSubview(noAnserContainerView)
        noAnserContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        noAnserContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        noAnserContainerView.addSubview(noAnswerTitleLabel)
        noAnswerTitleLabel.topAnchor.constraint(equalTo: noAnserContainerView.topAnchor, constant: SPACE).isActive = true
        noAnswerTitleLabel.centerXAnchor.constraint(equalTo: noAnserContainerView.centerXAnchor).isActive = true
        noAnswerTitleLabel.bottomAnchor.constraint(equalTo: noAnserContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        stackView.addArrangedSubview(bottomLine)
        bottomLine.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func removeTapped() {
        let alert = UIAlertController(title: nil, message: "정말 문의글을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
            guard let qna = self.qna else { return }
            self.removeQnaRequest.fetch(vc: self, paramDict: ["qId": String(qna.q_id)])
        }))
        present(alert, animated: true, completion: nil)
    }
}


// MARK: HTTP - RemoveQna
extension QnaViewController: RemoveQnaRequestProtocol {
    func response(removeQna status: String) {
        print("[HTTP RES]", removeQnaRequest.apiUrl, status)
        
        if status == "OK" {
            delegate?.removeQna()
            navigationController?.popViewController(animated: true)
        }
    }
}
