//
//  PlaceCommentViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/23.
//

import UIKit


protocol PlaceCommentViewControllerProtocol {
    func addComment()
    func removeComment()
}


class PlaceCommentViewController: UIViewController {
    
    // MARK: Property
    var delegate: PlaceCommentViewControllerProtocol?
    let getPlaceCommentsRequest = GetPlaceCommentsRequest()
    let addPlaceCommentRequest = AddPlaceCommentRequest()
    let removePlaceCommentRequest = RemovePlaceCommentRequest()
    let app = App()
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            navigationItem.title = place.name
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "댓글 \(place.commentCnt)개", style: .plain, target: self, action: nil)
            navigationItem.rightBarButtonItem?.isEnabled = false
            setThemeColor()
            
            getComments()
        }
    }
    var isEnded = false
    var isLoading = false
    var page = 1
    
    
    // MARK: View
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView()
        sv.backgroundColor = .systemBackground
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var bottomStackTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var writeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var textContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XS
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var writeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("게시", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(writeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이곳에 댓글을 입력합니다."
        tf.font = .systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_S
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var noCommentContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글이 없습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureView()
        
        setThemeColor()
        
        hideKeyboardWhenTappedAround()
        
        getPlaceCommentsRequest.delegate = self
        addPlaceCommentRequest.delegate = self
        removePlaceCommentRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() { navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBackground.inverted }
    
    func configureView() {
        view.addSubview(bottomStackView)
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(bottomStackTopLine)
        bottomStackTopLine.topAnchor.constraint(equalTo: bottomStackView.topAnchor).isActive = true
        bottomStackTopLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomStackTopLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bottomStackView.addArrangedSubview(writeContainerView)
        writeContainerView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
        writeContainerView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
        
        writeContainerView.addSubview(textContainerView)
        textContainerView.topAnchor.constraint(equalTo: writeContainerView.topAnchor, constant: SPACE_S).isActive = true
        textContainerView.centerXAnchor.constraint(equalTo: writeContainerView.centerXAnchor).isActive = true
        textContainerView.widthAnchor.constraint(equalTo: writeContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        textContainerView.bottomAnchor.constraint(equalTo: writeContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
        
        textContainerView.addSubview(writeButton)
        writeButton.centerYAnchor.constraint(equalTo: textContainerView.centerYAnchor).isActive = true
        writeButton.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor).isActive = true
        writeButton.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH * 0.12).isActive = true
        
        textContainerView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: textContainerView.topAnchor, constant: SPACE_XS).isActive = true
        textField.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        textField.trailingAnchor.constraint(equalTo: writeButton.leadingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        bottomStackView.addArrangedSubview(bottomContainerView)
        bottomContainerView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
        bottomContainerView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
        bottomContainerView.heightAnchor.constraint(equalToConstant: BOTTOM_SPACING).isActive = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_S).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_S).isActive = true
        
        stackView.addArrangedSubview(noCommentContainerView)
        noCommentContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        noCommentContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        noCommentContainerView.addSubview(noCommentLabel)
        noCommentLabel.topAnchor.constraint(equalTo: noCommentContainerView.topAnchor, constant: SPACE_S + SPACE_XS).isActive = true
        noCommentLabel.centerXAnchor.constraint(equalTo: noCommentContainerView.centerXAnchor).isActive = true
        noCommentLabel.bottomAnchor.constraint(equalTo: noCommentContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
    }
    
    func getComments() {
        guard let place = self.place else { return }
        isLoading = true
        getPlaceCommentsRequest.fetch(vc: self, paramDict: ["pId": String(place.id), "page": String(page), "limit": "20"])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isLoading && !isEnded {
                page += 1
                getComments()
            }
        }
    }
    
    // MARK: Function - @OBJC
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        bottomContainerView.isHidden = true
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        bottomContainerView.isHidden = false
    }
    
    @objc func writeTapped() {
        guard let place = self.place else { return }
        
        guard let comment = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if comment.count < 1 || comment.count > 50 {
            let alert = UIAlertController(title: nil, message: "댓글은 1-50자 까지 입력 가능합니다.\n\n\(comment.count) / 50", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
            return
        }
        
        dismissKeyboard()
        textField.text = ""
        addPlaceCommentRequest.fetch(vc: self, paramDict: ["pId": String(place.id), "comment": comment])
    }
}


// MARK: HTTP - GetPlaceComments
extension PlaceCommentViewController: GetPlaceCommentsRequestProtocol {
    func response(placeCommentList: [PlaceComment]?, getPlaceComments status: String) {
        print("[HTTP RES]", getPlaceCommentsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let placeCommentList = placeCommentList else { return }
            
            if placeCommentList.count > 0 {
                isEnded = false
                noCommentContainerView.isHidden = true
                
                let uId = app.getUId()
                
                for placeComment in placeCommentList {
                    let cv = CommentView()
                    cv.id = placeComment.id
                    cv.date = placeComment.createdDate
                    cv.comment = placeComment.comment
                    cv.user = placeComment.user
                    cv.removeButton.isHidden = (uId != placeComment.user.id) ? true: false
                    cv.delegate = self
                    
                    stackView.addArrangedSubview(cv)
                    cv.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
                    cv.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
                }
            } else {
                isEnded = true
                if stackView.subviews.count == 1 { noCommentContainerView.isHidden = false }
            }
        }
        isLoading = false
    }
}

// MARK: HTTP - AddPlaceComment
extension PlaceCommentViewController: AddPlaceCommentRequestProtocol {
    func response(addPlaceComment status: String) {
        print("[HTTP RES]", addPlaceCommentRequest.apiUrl, status)
        
        if status == "OK" {
            delegate?.addComment()
            
            for v in stackView.subviews {
                if v == noCommentContainerView { continue }
                v.removeFromSuperview()
            }
            
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false) // 스크롤 맨 위로
            page = 1
            isEnded = false
            
            guard let place = self.place else { return }
            self.place?.commentCnt = place.commentCnt + 1
            
            let alert = UIAlertController(title: nil, message: "댓글이 게시되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: HTTP - RemovePlaceComment
extension PlaceCommentViewController: RemovePlaceCommentRequestProtocol {
    func response(removePlaceComment status: String) {
        print("[HTTP RES]", removePlaceCommentRequest.apiUrl, status)
        
        if status == "OK" {
            delegate?.removeComment()
            
            for v in stackView.subviews {
                if v == noCommentContainerView { continue }
                v.removeFromSuperview()
            }
            
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false) // 스크롤 맨 위로
            page = 1
            isEnded = false
            
            guard let place = self.place else { return }
            self.place?.commentCnt = place.commentCnt - 1
            
            let alert = UIAlertController(title: nil, message: "댓글이 삭제되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: CommentView
extension PlaceCommentViewController: CommentViewProtocol {
    func detailUser(user: User) {
        dismissKeyboard()
        
        let accountVC = AccountViewController()
        accountVC.user = user
        navigationController?.pushViewController(accountVC, animated: true)
    }
    
    func removeComment(id: Int) {
        dismissKeyboard()
        
        let alert = UIAlertController(title: nil, message: "댓글을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
            self.removePlaceCommentRequest.fetch(vc: self, paramDict: ["mcpId": String(id)])
        }))
        present(alert, animated: true, completion: nil)
    }
}
