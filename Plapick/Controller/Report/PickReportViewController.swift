//
//  PickReportViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/28.
//

import UIKit


class PickReportViewController: UIViewController {
    
    // MARK: Property
    let reportPickRequest = ReportPickRequest()
    var pick: Pick?
    
    
    // MARK: View
    lazy var reasonTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "신고 사유"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var reasonTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XS
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var reasonTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .systemGray6
        tv.font = .systemFont(ofSize: 15)
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    lazy var reasonCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 100"
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = SPACE_XS
        button.setTitle("신고하기", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_S, left: 0, bottom: SPACE_S, right: 0)
        button.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "픽 신고하기"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeTapped))
    
        configureView()
        
        hideKeyboardWhenTappedAround()
        
        reportPickRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(reasonTitleLabel)
        reasonTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SPACE_XL).isActive = true
        reasonTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reasonTitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        view.addSubview(reasonTextContainerView)
        reasonTextContainerView.topAnchor.constraint(equalTo: reasonTitleLabel.bottomAnchor, constant: SPACE_S).isActive = true
        reasonTextContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reasonTextContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        reasonTextContainerView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        reasonTextContainerView.addSubview(reasonTextView)
        reasonTextView.topAnchor.constraint(equalTo: reasonTextContainerView.topAnchor, constant: SPACE_XS).isActive = true
        reasonTextView.leadingAnchor.constraint(equalTo: reasonTextContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        reasonTextView.trailingAnchor.constraint(equalTo: reasonTextContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        reasonTextView.bottomAnchor.constraint(equalTo: reasonTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        view.addSubview(reasonCntLabel)
        reasonCntLabel.topAnchor.constraint(equalTo: reasonTextContainerView.bottomAnchor, constant: SPACE_XS).isActive = true
        reasonCntLabel.trailingAnchor.constraint(equalTo: reasonTextContainerView.trailingAnchor).isActive = true
        
        view.addSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: reasonCntLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func submitTapped() {
        guard let pick = self.pick else { return }
        
        if reasonCntLabel.textColor == .systemRed {
            let alert = UIAlertController(title: "신고하기", message: "신고 사유를 10-100자 이내로 작성해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let reason = reasonTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        reportPickRequest.fetch(vc: self, paramDict: ["piId": String(pick.id), "reason": reason])
    }
}


// MARK: TextView
extension PickReportViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let reason = reasonTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        reasonCntLabel.text = "\(reason.count) / 100"
        reasonCntLabel.textColor = (reason.count < 10 || reason.count > 100) ? .systemRed : .systemBlue
    }
}

// MARK: HTTP - ReportUser
extension PickReportViewController: ReportPickRequestProtocol {
    func response(reportPick status: String) {
        print("[HTTP RES]", reportPickRequest.apiUrl, status)
        
        if status == "OK" {
            let alert = UIAlertController(title: "신고하기", message: "신고가 성공적으로 접수되었습니다. 신고 사유 확인 후 24시간 내에 조치하도록 하겠습니다. 감사합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}

