//
//  QnaListViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/06.
//

import UIKit


class QnaListViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let getQnasRequest = GetQnasRequest()
    let removeQnaRequest = RemoveQnaRequest()
    var qnaList: [Qna] = []
    
    
    // MARK: View
    lazy var bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("문의하기", for: .normal)
        button.backgroundColor = .systemGray6
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(qnaTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var bottomButtonTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(QnaTVCell.self, forCellReuseIdentifier: "QnaTVCell")
        tv.separatorInset.left = 0
        tv.tableFooterView = UIView(frame: .zero) // 빈 셀 안보이게
        tv.dataSource = self
        tv.delegate = self
        tv.refreshControl = UIRefreshControl()
        tv.refreshControl?.addTarget(self, action: #selector(refreshed), for: .valueChanged)
        tv.alwaysBounceVertical = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        navigationItem.title = "1:1 문의"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        getQnasRequest.delegate = self
        removeQnaRequest.delegate = self
        
        getQnasRequest.fetch(vc: self, paramDict: [:])
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        tableView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
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
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func qnaTapped() {
        let writeQnaVC = WriteQnaViewController()
        writeQnaVC.delegate = self
        navigationController?.pushViewController(writeQnaVC, animated: true)
    }
    
    @objc func refreshed() {
        getQnasRequest.fetch(vc: self, paramDict: [:])
    }
}


// MARK: TableView
extension QnaListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        qnaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QnaTVCell", for: indexPath) as! QnaTVCell
        cell.selectionStyle = .none
        cell.qna = qnaList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "정말 문의글을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
            let qna = self.qnaList[indexPath.row]
            self.removeQnaRequest.fetch(vc: self, paramDict: ["qId": String(qna.q_id)])
            self.qnaList.remove(at: indexPath.row)
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let qna = qnaList[indexPath.row]
        let qnaVC = QnaViewController()
        qnaVC.qna = qna
        qnaVC.delegate = self
        navigationController?.pushViewController(qnaVC, animated: true)
    }
}

// MARK: WriteQnaVC
extension QnaListViewController: WriteQnaViewControllerProtocol {
    func addQna(qna: Qna) {
        qnaList.insert(qna, at: 0)
        tableView.reloadData()
    }
}

// MARK: QnaVC
extension QnaListViewController: QnaViewControllerProtocol {
    func removeQna() {
        getQnasRequest.fetch(vc: self, paramDict: [:])
    }
}

// MARK: HTTP - GetQnas
extension QnaListViewController: GetQnasRequestProtocol {
    func response(qnaList: [Qna]?, getQnas status: String) {
        print("[HTTP RES]", getQnasRequest.apiUrl, status)
        
        if status == "OK" {
            guard let qnaList = qnaList else { return }
            self.qnaList = qnaList
            tableView.reloadData()
        }
        
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: HTTP - RemoveQna
extension QnaListViewController: RemoveQnaRequestProtocol {
    func response(removeQna status: String) {
        print("[HTTP RES]", removeQnaRequest.apiUrl, status)
    }
}
