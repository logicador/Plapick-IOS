//
//  QnaViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/06.
//

import UIKit


class QnaViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let getQnasRequest = GetQnasRequest()
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
        sv.spacing = SPACE_L
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var noQnaContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noQnaLabel: UILabel = {
        let label = UILabel()
        label.text = "문의내역이 없습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "문의하기 / 피드백"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "문의", style: .plain, target: self, action: #selector(qnaTapped))
        
        configureView()
        
        getQnasRequest.delegate = self
        removeQnaRequest.delegate = self
        
        getQnas()
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_L).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_L).isActive = true
        
        stackView.addArrangedSubview(noQnaContainerView)
        noQnaContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        noQnaContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        noQnaContainerView.addSubview(noQnaLabel)
        noQnaLabel.topAnchor.constraint(equalTo: noQnaContainerView.topAnchor, constant: SPACE_XS).isActive = true
        noQnaLabel.centerXAnchor.constraint(equalTo: noQnaContainerView.centerXAnchor).isActive = true
        noQnaLabel.bottomAnchor.constraint(equalTo: noQnaContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
    }
    
    func getQnas() {
        getQnasRequest.fetch(vc: self, paramDict: [:])
    }
    
    // MARK: @OBJC
    @objc func qnaTapped() {
        let writeQnaVC = WriteQnaViewController()
        writeQnaVC.delegate = self
        navigationController?.pushViewController(writeQnaVC, animated: true)
    }
}


// MARK: WriteQnaVC
extension QnaViewController: WriteQnaViewControllerProtocol {
    func addQna(qna: Qna) {
        noQnaContainerView.isHidden = true
        
        let qv = QnaView()
        qv.qna = qna
        
        stackView.addArrangedSubview(qv)
        qv.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        qv.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
    }
}

// MARK: HTTP - GetQnas
extension QnaViewController: GetQnasRequestProtocol {
    func response(qnaList: [Qna]?, getQnas status: String) {
        print("[HTTP RES]", getQnasRequest.apiUrl, status)
        
        if status == "OK" {
            guard let qnaList = qnaList else { return }
            
            for v in stackView.subviews {
                if v == noQnaContainerView { continue }
                v.removeFromSuperview()
            }
            
            if qnaList.count > 0 {
                noQnaContainerView.isHidden = true
                
                for qna in qnaList {
                    let qv = QnaView()
                    qv.qna = qna
                    qv.delegate = self
                    
                    stackView.addArrangedSubview(qv)
                    qv.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
                    qv.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
                }
            } else { noQnaContainerView.isHidden = false }
        }
    }
}

// MARK: HTTP - RemoveQna
extension QnaViewController: RemoveQnaRequestProtocol {
    func response(removeQna status: String) {
        print("[HTTP RES]", removeQnaRequest.apiUrl, status)
        
        if status == "OK" { getQnas() }
    }
}

// MARK: QnaView
extension QnaViewController: QnaViewProtocol {
    func removeQna(qna: Qna) {
        let alert = UIAlertController(title: nil, message: "문의글을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
            self.removeQnaRequest.fetch(vc: self, paramDict: ["qId": String(qna.id)])
        }))
        present(alert, animated: true, completion: nil)
    }
}
