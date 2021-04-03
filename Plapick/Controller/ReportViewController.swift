//
//  ReportViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/04/02.
//

import UIKit


class ReportViewController: UIViewController {
    
    // MARK: Property
    var type: String? {
        didSet {
            let description = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            bottomButton.isEnabled = (description.count > 300) ? false : true
        }
    }
    var targetType: String? {
        didSet {
            guard let targetType = self.targetType else { return }
            
            if targetType == "POSTS" {
                wrongContainerView.isHidden = true
            } else if targetType == "POSTS_COMMENT" || targetType == "POSTS_RE_COMMENT" || targetType == "PLACE_COMMENT" {
                stealContainerView.isHidden = true
                wrongContainerView.isHidden = true
            } else if targetType == "PLACE" {
                abuseContainerView.isHidden = true
                sexualContainerView.isHidden = true
                stealContainerView.isHidden = true
            }
        }
    }
    var targetId: Int?
    var bottomButtonBottomCons: NSLayoutConstraint?
    let reportRequest = ReportRequest()
    
    
    // MARK: View
    lazy var bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("신고완료", for: .normal)
        button.backgroundColor = .systemGray6
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(reportTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var bottomButtonTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
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
        sv.spacing = SPACE_XXL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var reportLabel: UILabel = {
        let label = UILabel()
        label.text = "다음 중 항목을 선택해주세요."
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var typeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_S
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Abuse
    lazy var abuseContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.tag = 1
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var abuseLabel: UILabel = {
        let label = UILabel()
        label.text = "폭력적이며 다른사람을 비방하거나 욕설이 담긴 내용"
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var abuseImageView: UIImageView = {
        let image = UIImage(systemName: "circle.dashed")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Sexual
    lazy var sexualContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.tag = 2
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var sexualLabel: UILabel = {
        let label = UILabel()
        label.text = "다른사람에게 불쾌감을 줄 수 있는 선정적인 내용"
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var sexualImageView: UIImageView = {
        let image = UIImage(systemName: "circle.dashed")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Steal
    lazy var stealContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.tag = 3
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var stealLabel: UILabel = {
        let label = UILabel()
        label.text = "사전에 동의없이 무단으로 도용한 게시물"
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var stealImageView: UIImageView = {
        let image = UIImage(systemName: "circle.dashed")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - WRONG
    lazy var wrongContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.tag = 4
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var wrongLabel: UILabel = {
        let label = UILabel()
        label.text = "잘못된 정보를 제공함"
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var wrongImageView: UIImageView = {
        let image = UIImage(systemName: "circle.dashed")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Description
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "(선택) 부가설명을 입력해주세요."
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var descriptionContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var descriptionTextContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15)
        tv.text = "이곳에 부가설명을 입력합니다."
        tv.backgroundColor = .systemGray6
        tv.textColor = .systemGray3
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    lazy var descriptionCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 300"
        label.textColor = .systemGreen
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        navigationItem.title = "신고하기"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        configureView()
        
        setThemeColor()
        
        hideKeyboardWhenTappedAround()
        
        reportRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        scrollView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        descriptionTextView.textColor = (descriptionTextView.textColor == .systemGray3) ? .systemGray3 : (traitCollection.userInterfaceStyle == .dark) ? .white : .black
    }
    
    func configureView() {
        view.addSubview(bottomButton)
        bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(bottomButtonTopLine)
        bottomButtonTopLine.topAnchor.constraint(equalTo: bottomButton.topAnchor).isActive = true
        bottomButtonTopLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomButtonTopLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_XXL).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        stackView.addArrangedSubview(reportLabel)
        reportLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        stackView.addArrangedSubview(typeStackView)
        typeStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        typeStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        // MARK: Configure - Abuse
        typeStackView.addArrangedSubview(abuseContainerView)
        abuseContainerView.leadingAnchor.constraint(equalTo: typeStackView.leadingAnchor).isActive = true
        abuseContainerView.trailingAnchor.constraint(equalTo: typeStackView.trailingAnchor).isActive = true
        
        abuseContainerView.addSubview(abuseLabel)
        abuseLabel.topAnchor.constraint(equalTo: abuseContainerView.topAnchor, constant: SPACE_S).isActive = true
        abuseLabel.leadingAnchor.constraint(equalTo: abuseContainerView.leadingAnchor, constant: SPACE_S + 25 + SPACE_S).isActive = true
        abuseLabel.trailingAnchor.constraint(equalTo: abuseContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        abuseLabel.bottomAnchor.constraint(equalTo: abuseContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
        
        abuseContainerView.addSubview(abuseImageView)
        abuseImageView.centerYAnchor.constraint(equalTo: abuseLabel.centerYAnchor).isActive = true
        abuseImageView.leadingAnchor.constraint(equalTo: abuseContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        abuseImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        abuseImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // MARK: Configure - Sexual
        typeStackView.addArrangedSubview(sexualContainerView)
        sexualContainerView.leadingAnchor.constraint(equalTo: typeStackView.leadingAnchor).isActive = true
        sexualContainerView.trailingAnchor.constraint(equalTo: typeStackView.trailingAnchor).isActive = true
        
        sexualContainerView.addSubview(sexualLabel)
        sexualLabel.topAnchor.constraint(equalTo: sexualContainerView.topAnchor, constant: SPACE_S).isActive = true
        sexualLabel.leadingAnchor.constraint(equalTo: sexualContainerView.leadingAnchor, constant: SPACE_S + 25 + SPACE_S).isActive = true
        sexualLabel.trailingAnchor.constraint(equalTo: sexualContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        sexualLabel.bottomAnchor.constraint(equalTo: sexualContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
        
        sexualContainerView.addSubview(sexualImageView)
        sexualImageView.centerYAnchor.constraint(equalTo: sexualLabel.centerYAnchor).isActive = true
        sexualImageView.leadingAnchor.constraint(equalTo: sexualContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        sexualImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        sexualImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // MARK: Configure - Steal
        typeStackView.addArrangedSubview(stealContainerView)
        stealContainerView.leadingAnchor.constraint(equalTo: typeStackView.leadingAnchor).isActive = true
        stealContainerView.trailingAnchor.constraint(equalTo: typeStackView.trailingAnchor).isActive = true
        
        stealContainerView.addSubview(stealLabel)
        stealLabel.topAnchor.constraint(equalTo: stealContainerView.topAnchor, constant: SPACE_S).isActive = true
        stealLabel.leadingAnchor.constraint(equalTo: stealContainerView.leadingAnchor, constant: SPACE_S + 25 + SPACE_S).isActive = true
        stealLabel.trailingAnchor.constraint(equalTo: stealContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        stealLabel.bottomAnchor.constraint(equalTo: stealContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
        
        stealContainerView.addSubview(stealImageView)
        stealImageView.centerYAnchor.constraint(equalTo: stealLabel.centerYAnchor).isActive = true
        stealImageView.leadingAnchor.constraint(equalTo: stealContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        stealImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        stealImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // MARK: Configure - Wrong
        typeStackView.addArrangedSubview(wrongContainerView)
        wrongContainerView.leadingAnchor.constraint(equalTo: typeStackView.leadingAnchor).isActive = true
        wrongContainerView.trailingAnchor.constraint(equalTo: typeStackView.trailingAnchor).isActive = true
        
        wrongContainerView.addSubview(wrongLabel)
        wrongLabel.topAnchor.constraint(equalTo: wrongContainerView.topAnchor, constant: SPACE_S).isActive = true
        wrongLabel.leadingAnchor.constraint(equalTo: wrongContainerView.leadingAnchor, constant: SPACE_S + 25 + SPACE_S).isActive = true
        wrongLabel.trailingAnchor.constraint(equalTo: wrongContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        wrongLabel.bottomAnchor.constraint(equalTo: wrongContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
        
        wrongContainerView.addSubview(wrongImageView)
        wrongImageView.centerYAnchor.constraint(equalTo: wrongLabel.centerYAnchor).isActive = true
        wrongImageView.leadingAnchor.constraint(equalTo: wrongContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        wrongImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        wrongImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // MARK: Configure - Description
        stackView.addArrangedSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        stackView.addArrangedSubview(descriptionContainerView)
        descriptionContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        descriptionContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        descriptionContainerView.addSubview(descriptionTextContainerView)
        descriptionTextContainerView.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor).isActive = true
        descriptionTextContainerView.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor).isActive = true
        descriptionTextContainerView.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor).isActive = true
        
        descriptionTextContainerView.addSubview(descriptionTextView)
        descriptionTextView.topAnchor.constraint(equalTo: descriptionTextContainerView.topAnchor, constant: SPACE_XS).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: descriptionTextContainerView.leadingAnchor, constant: SPACE_XS).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: descriptionTextContainerView.trailingAnchor, constant: -SPACE_XS).isActive = true
        descriptionTextView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: descriptionTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        descriptionContainerView.addSubview(descriptionCntLabel)
        descriptionCntLabel.topAnchor.constraint(equalTo: descriptionTextContainerView.bottomAnchor).isActive = true
        descriptionCntLabel.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: SPACE_XS).isActive = true
        descriptionCntLabel.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -SPACE_XS).isActive = true
        descriptionCntLabel.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
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
    
    @objc func reportTapped() {
        dismissKeyboard()
        
        guard let type = self.type else { return }
        guard let targetType = self.targetType else { return }
        guard let targetId = self.targetId else { return }
        let description = (descriptionTextView.textColor == .systemGray3) ? "" : descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        reportRequest.fetch(vc: self, paramDict: ["type": type, "targetType": targetType, "targetId": String(targetId), "description": description])
    }
    
    @objc func typeTapped(gesture: UITapGestureRecognizer) {
        dismissKeyboard()
        
        guard let v = gesture.view else { return }
        
        abuseContainerView.backgroundColor = .systemGray6
        abuseImageView.image = UIImage(systemName: "circle.dashed")
        abuseImageView.tintColor = .systemGray3
        abuseLabel.textColor = .systemGray
        
        sexualContainerView.backgroundColor = .systemGray6
        sexualImageView.image = UIImage(systemName: "circle.dashed")
        sexualImageView.tintColor = .systemGray3
        sexualLabel.textColor = .systemGray
        
        stealContainerView.backgroundColor = .systemGray6
        stealImageView.image = UIImage(systemName: "circle.dashed")
        stealImageView.tintColor = .systemGray3
        stealLabel.textColor = .systemGray
        
        wrongContainerView.backgroundColor = .systemGray6
        wrongImageView.image = UIImage(systemName: "circle.dashed")
        wrongImageView.tintColor = .systemGray3
        wrongLabel.textColor = .systemGray
        
        switch v.tag {
        case 1:
            abuseContainerView.backgroundColor = .mainColor
            abuseImageView.image = UIImage(systemName: "circle.dashed.inset.fill")
            abuseImageView.tintColor = .white
            abuseLabel.textColor = .white
            type = "ABUSE"
        case 2:
            sexualContainerView.backgroundColor = .mainColor
            sexualImageView.image = UIImage(systemName: "circle.dashed.inset.fill")
            sexualImageView.tintColor = .white
            sexualLabel.textColor = .white
            type = "SEXUAL"
        case 3:
            stealContainerView.backgroundColor = .mainColor
            stealImageView.image = UIImage(systemName: "circle.dashed.inset.fill")
            stealImageView.tintColor = .white
            stealLabel.textColor = .white
            type = "STEAL"
        case 4:
            wrongContainerView.backgroundColor = .mainColor
            wrongImageView.image = UIImage(systemName: "circle.dashed.inset.fill")
            wrongImageView.tintColor = .white
            wrongLabel.textColor = .white
            type = "WRONG"
        default: break
        }
    }
}


// MARK: TextView
extension ReportViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let description = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        descriptionCntLabel.text = "\(description.count) / 300"
        
        if description.count > 300 {
            descriptionCntLabel.textColor = .systemRed
            bottomButton.isEnabled = false
            return
        }
        
        descriptionCntLabel.textColor = .systemGreen
        bottomButton.isEnabled = (type == nil) ? false : true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = ""
            textView.textColor = (traitCollection.userInterfaceStyle == .dark) ? .white : .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "이곳에 부가설명을 입력합니다."
            textView.textColor = .systemGray3
        }
    }
}

// MARK: HTTP - Report
extension ReportViewController: ReportRequestProtocol {
    func response(report status: String) {
        print("[HTTP RES]", reportRequest.apiUrl, status)
        
        if status == "OK" {
            let alert = UIAlertController(title: nil, message: "신고가 접수되었습니다. 확인 후 빠른 조치를 취하겠습니다.\n감사합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true)
        }
    }
}
