//
//  PlaceCommentViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/23.
//

import UIKit


class PlaceCommentViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            getPlaceCommentsRequest.fetch(vc: self, paramDict: ["pId": String(place.p_id)])
        }
    }
    var placeCommentList: [PlaceComment] = []
    let getPlaceCommentsRequest = GetPlaceCommentsRequest()
    let addPlaceCommentRequest = AddPlaceCommentRequest()
    let removePlaceCommentRequest = RemovePlaceCommentRequest()
    var bottomContainerBottomCons: NSLayoutConstraint?
    var commentTextTrailingCons: NSLayoutConstraint?
    
    
    // MARK: View
    lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var commentTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var commentTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.placeholder = "이곳에 댓글을 입력합니다. (100자 까지)"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.alpha = 0
        button.setTitle("게시", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var bottomButtonTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(PlaceCommentTVCell.self, forCellReuseIdentifier: "PlaceCommentTVCell")
        tv.separatorInset.left = 0
        tv.tableFooterView = UIView(frame: .zero) // 빈 셀 안보이게
        tv.dataSource = self
        tv.delegate = self
        tv.alwaysBounceVertical = true
        tv.refreshControl = UIRefreshControl()
        tv.refreshControl?.addTarget(self, action: #selector(refreshed), for: .valueChanged)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        navigationItem.title = "댓글"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        configureView()
        
        setThemeColor()
        
        getPlaceCommentsRequest.delegate = self
        addPlaceCommentRequest.delegate = self
        removePlaceCommentRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        commentTextContainerView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        commentTextContainerView.layer.borderColor = UIColor.separator.cgColor
        tableView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(bottomContainerView)
        bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomContainerBottomCons = bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomContainerBottomCons?.isActive = true
        
        bottomContainerView.addSubview(commentTextContainerView)
        commentTextContainerView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: SPACE_XS).isActive = true
        commentTextContainerView.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        commentTextContainerView.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        commentTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true
        commentTextContainerView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        commentTextContainerView.addSubview(commentTextField)
        commentTextField.topAnchor.constraint(equalTo: commentTextContainerView.topAnchor).isActive = true
        commentTextField.leadingAnchor.constraint(equalTo: commentTextContainerView.leadingAnchor, constant: 15).isActive = true
        commentTextTrailingCons = commentTextField.trailingAnchor.constraint(equalTo: commentTextContainerView.trailingAnchor, constant: -15)
        commentTextTrailingCons?.isActive = true
        commentTextField.bottomAnchor.constraint(equalTo: commentTextContainerView.bottomAnchor).isActive = true
        
        commentTextContainerView.addSubview(commentButton)
        commentButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor).isActive = true
        commentButton.trailingAnchor.constraint(equalTo: commentTextContainerView.trailingAnchor, constant: -15).isActive = true
        
        view.addSubview(bottomButtonTopLine)
        bottomButtonTopLine.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        bottomButtonTopLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomButtonTopLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomContainerBottomCons?.isActive = false
            bottomContainerBottomCons = bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height)
            bottomContainerBottomCons?.isActive = true
            
            commentTextTrailingCons?.isActive = false
            commentTextTrailingCons = commentTextField.trailingAnchor.constraint(equalTo: commentTextContainerView.trailingAnchor, constant: -60)
            commentTextTrailingCons?.isActive = true
            
            commentButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.commentButton.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomContainerBottomCons?.isActive = false
        bottomContainerBottomCons = bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomContainerBottomCons?.isActive = true
        
        commentTextTrailingCons?.isActive = false
        commentTextTrailingCons = commentTextField.trailingAnchor.constraint(equalTo: commentTextContainerView.trailingAnchor, constant: -15)
        commentTextTrailingCons?.isActive = true
        
        commentTextField.text = ""
        
        UIView.animate(withDuration: 0.2, animations: {
            self.commentButton.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.commentButton.isHidden = true
        })
    }
    
    @objc func commentTapped() {
        guard let comment = commentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if comment.count > 100 {
            let alert = UIAlertController(title: nil, message: "최대 100자 까지 입력 가능합니다.\n\n현재 \(comment.count) / 100", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
            
        } else {
            guard let place = self.place else { return }
            addPlaceCommentRequest.fetch(vc: self, paramDict: ["pId": String(place.p_id), "comment": comment])
        }
    }
    
    @objc func refreshed() {
        guard let place = self.place else { return }
        
        getPlaceCommentsRequest.fetch(vc: self, paramDict: ["pId": String(place.p_id)])
    }
}


// MARK: TableView
extension PlaceCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        placeCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCommentTVCell", for: indexPath) as! PlaceCommentTVCell
        cell.selectionStyle = .none
        cell.placeComment = placeCommentList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard()
    }
}

// MARK: PlaceCommentTVCell
extension PlaceCommentViewController: PlaceCommentTVCellProtocol {
    func selectUser(uId: Int) {
        dismissKeyboard()
        
        if app.getUserId() == uId { return }
        
        let userVC = UserViewController()
        userVC.uId = uId
        navigationController?.pushViewController(userVC, animated: true)
    }
    
    func more(placeComment: PlaceComment) {
        dismissKeyboard()
        
        let alert = UIAlertController(title: nil, message: "다음 중 항목을 선택해주세요.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        
        if placeComment.pc_u_id == app.getUserId() {
            alert.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { (_) in
                let alert = UIAlertController(title: nil, message: "정말 댓글을 삭제하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
                    self.removePlaceCommentRequest.fetch(vc: self, paramDict: ["pcId": String(placeComment.pc_id)])
                }))
                self.present(alert, animated: true, completion: nil)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "신고하기", style: .destructive, handler: { (_) in
                let reportVC = ReportViewController()
                reportVC.targetType = "PLACE_COMMENT"
                reportVC.targetId = placeComment.pc_id
                self.present(UINavigationController(rootViewController: reportVC), animated: true, completion: nil)
            }))
        }
        present(alert, animated: true)
    }
}

// MARK: HTTP - GetPlaceComments
extension PlaceCommentViewController: GetPlaceCommentsRequestProtocol {
    func response(placeCommentList: [PlaceComment]?, getPlaceComments status: String) {
        print("[HTTP RES]", getPlaceCommentsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let placeCommentList = placeCommentList else { return }
            
            self.placeCommentList = placeCommentList
            tableView.reloadData()
        }
        
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: HTTP - AddPlaceComment
extension PlaceCommentViewController: AddPlaceCommentRequestProtocol {
    func response(placeComment: PlaceComment?, addPlaceComment status: String) {
        print("[HTTP RES]", addPlaceCommentRequest.apiUrl, status)
        
        if status == "OK" {
            guard let placeComment = placeComment else { return }
            
            dismissKeyboard()
            
            commentTextField.text = ""
            
            placeCommentList.append(placeComment)
            tableView.reloadData()
            
            tableView.selectRow(at: IndexPath(row: placeCommentList.count - 1, section: 0), animated: true, scrollPosition: .top)
        }
    }
}

// MARK: HTTP - RemovePlaceComment
extension PlaceCommentViewController: RemovePlaceCommentRequestProtocol {
    func response(pcId: Int?, removePlaceComment status: String) {
        print("[HTTP RES]", removePlaceCommentRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pcId = pcId else { return }
            
            for (i, placeComment) in placeCommentList.enumerated() {
                if placeComment.pc_id == pcId {
                    placeCommentList.remove(at: i)
                    break
                }
            }
            tableView.reloadData()
        }
    }
}
