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
    var bottomButtonBottomCons: NSLayoutConstraint?
    
    
    // MARK: View
    lazy var bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("작성완료", for: .normal)
        button.backgroundColor = .systemGray6
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(writeTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var bottomButtonTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var questionTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15)
        tv.text = "이곳에 문의내용을 입력합니다. (10자 이상)"
        tv.textColor = .systemGray3
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    lazy var questionBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var questionCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 500"
        label.textColor = .systemRed
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        navigationItem.title = "문의하기"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        configureView()
        
        setThemeColor()
        
        hideKeyboardWhenTappedAround()
        
        addQnaRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        containerView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        questionTextView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        questionTextView.textColor = (questionTextView.textColor == .systemGray3) ? .systemGray3 : (traitCollection.userInterfaceStyle == .dark) ? .white : .black
    }
    
    func configureView() {
        view.addSubview(bottomButton)
        bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomButtonBottomCons = bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomButtonBottomCons?.isActive = true
        
        view.addSubview(bottomButtonTopLine)
        bottomButtonTopLine.topAnchor.constraint(equalTo: bottomButton.topAnchor).isActive = true
        bottomButtonTopLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomButtonTopLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor).isActive = true
        
        containerView.addSubview(questionTextView)
        questionTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_XS).isActive = true
        questionTextView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        questionTextView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        questionTextView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5).isActive = true
        
        containerView.addSubview(questionCntLabel)
        questionCntLabel.topAnchor.constraint(equalTo: questionTextView.bottomAnchor, constant: SPACE_XS).isActive = true
        questionCntLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        questionCntLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        containerView.addSubview(questionBottomLine)
        questionBottomLine.topAnchor.constraint(equalTo: questionCntLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        questionBottomLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        questionBottomLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomButtonBottomCons?.isActive = false
            bottomButtonBottomCons = bottomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height)
            bottomButtonBottomCons?.isActive = true
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomButtonBottomCons?.isActive = false
        bottomButtonBottomCons = bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomButtonBottomCons?.isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func writeTapped() {
        dismissKeyboard()
        
        let question = questionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        addQnaRequest.fetch(vc: self, paramDict: ["question": question])
    }
}


// MARK: TextView
extension WriteQnaViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let question = questionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        questionCntLabel.text = "\(question.count) / 500"
        
        if question.count < 10 {
            questionCntLabel.textColor = .systemRed
            bottomButton.isEnabled = false
        } else if question.count > 500 {
            questionCntLabel.textColor = .systemRed
            bottomButton.isEnabled = false
        } else {
            questionCntLabel.textColor = .systemGreen
            bottomButton.isEnabled = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = ""
            textView.textColor = (traitCollection.userInterfaceStyle == .dark) ? .white : .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "이곳에 문의내용을 입력합니다. (10자 이상)"
            textView.textColor = .systemGray3
        }
    }
}

// MARK: HTTP - AddQna
extension WriteQnaViewController: AddQnaRequestProtocol {
    func response(qna: Qna?, addQna status: String) {
        print("[HTTP RES]", addQnaRequest.apiUrl, status)

        if status == "OK" {
            guard let qna = qna else { return }

            delegate?.addQna(qna: qna)
            let alert = UIAlertController(title: nil, message: "문의하기가 완료되었습니다. 문의내용을 확인한 후 답변을 드리겠습니다. 감사합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
