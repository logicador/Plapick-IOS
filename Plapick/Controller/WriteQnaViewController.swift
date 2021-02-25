//
//  WriteQnaViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/20.
//

import UIKit


protocol WriteQnaViewControllerProtocol {
    func addQna(qna: Qna)
}


class WriteQnaViewController: UIViewController {
    
    // MARK: Property
    var delegate: WriteQnaViewControllerProtocol?
    let addQnaRequest = AddQnaRequest()
    
    
    // MARK: View
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var titleTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XS
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var titleTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.addTarget(self, action: #selector(titleTextChanged), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var titleCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 20"
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var contentTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XS
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var contentTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .systemGray6
        tv.font = .systemFont(ofSize: 15)
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    lazy var contentCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 100"
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "문의"
        
        configureView()
        
        hideKeyboardWhenTappedAround()
        
        addQnaRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SPACE_XL).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        view.addSubview(titleTextContainerView)
        titleTextContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SPACE_S).isActive = true
        titleTextContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleTextContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        titleTextContainerView.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: titleTextContainerView.topAnchor, constant: SPACE_XS).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: titleTextContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: titleTextContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        titleTextField.bottomAnchor.constraint(equalTo: titleTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        view.addSubview(titleCntLabel)
        titleCntLabel.topAnchor.constraint(equalTo: titleTextContainerView.bottomAnchor, constant: SPACE_XS).isActive = true
        titleCntLabel.trailingAnchor.constraint(equalTo: titleTextContainerView.trailingAnchor).isActive = true
        
        view.addSubview(contentTitleLabel)
        contentTitleLabel.topAnchor.constraint(equalTo: titleTextContainerView.bottomAnchor, constant: SPACE_XL).isActive = true
        contentTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentTitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        view.addSubview(contentTextContainerView)
        contentTextContainerView.topAnchor.constraint(equalTo: contentTitleLabel.bottomAnchor, constant: SPACE_S).isActive = true
        contentTextContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentTextContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        contentTextContainerView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        contentTextContainerView.addSubview(contentTextView)
        contentTextView.topAnchor.constraint(equalTo: contentTextContainerView.topAnchor, constant: SPACE_XS).isActive = true
        contentTextView.leadingAnchor.constraint(equalTo: contentTextContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        contentTextView.trailingAnchor.constraint(equalTo: contentTextContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        contentTextView.bottomAnchor.constraint(equalTo: contentTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        view.addSubview(contentCntLabel)
        contentCntLabel.topAnchor.constraint(equalTo: contentTextContainerView.bottomAnchor, constant: SPACE_XS).isActive = true
        contentCntLabel.trailingAnchor.constraint(equalTo: contentTextContainerView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func titleTextChanged() {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        titleCntLabel.text = "\(title.count) / 20"
        titleCntLabel.textColor = (title.count < 4 || title.count > 20) ? .systemRed : .systemBlue
        navigationItem.rightBarButtonItem = (titleCntLabel.textColor == .systemBlue && contentCntLabel.textColor == .systemBlue) ? UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeTapped)) : nil
    }
    
    @objc func completeTapped() {
        dismissKeyboard()
        
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        let content = contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    
        addQnaRequest.fetch(vc: self, paramDict: ["title": title, "content": content])
    }
}


// MARK: TextView
extension WriteQnaViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let content = contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        contentCntLabel.text = "\(content.count) / 100"
        contentCntLabel.textColor = (content.count < 20 || content.count > 100) ? .systemRed : .systemBlue
        navigationItem.rightBarButtonItem = (titleCntLabel.textColor == .systemBlue && contentCntLabel.textColor == .systemBlue) ? UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeTapped)) : nil
    }
}

// MARK: HTTP - AddQna
extension WriteQnaViewController: AddQnaRequestProtocol {
    func response(qna: Qna?, addQna status: String) {
        print("[HTTP RES]", addQnaRequest.apiUrl, status)
        
        if status == "OK" {
            guard let qna = qna else { return }
            
            delegate?.addQna(qna: qna)
            let alert = UIAlertController(title: "문의하기", message: "문의하기가 완료되었습니다. 빠른 시일 내에 답변을 드리겠습니다. 감사합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
