//
//  CommentViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/02.
//

import UIKit


protocol CommentViewControllerProtocol {
    func closeCommentVC()
    func reloadComment()
}


class CommentViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var delegate: CommentViewControllerProtocol?
    var mode: String?
    var id: Int?
    let getCommentsRequest = GetCommentsRequest()
    let addCommentRequest = AddCommentRequest()
    let removeCommentRequest = RemoveCommentRequest()
    var commentWriteContainerBottomCons: NSLayoutConstraint?
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var commentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Write
    lazy var commentWriteContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var textFieldView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.placeholder = "이곳에 댓글을 입력합니다."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("게시", for: .normal)
        button.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var commentWriteContainerTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    
    // MARK: Init
    init(mode: String, id: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.mode = mode
        self.id = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "댓글 0개"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureView()
        
        setThemeColor()
        
        getCommentsRequest.delegate = self
        addCommentRequest.delegate = self
        removeCommentRequest.delegate = self
        
        getComments()
    }
    
    
    // MARK: ViewDidDisapear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.closeCommentVC()
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setThemeColor()
    }
    func setThemeColor() {
        textFieldView.layer.borderColor = UIColor.separator.cgColor
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        contentView.addSubview(commentContainerView)
        commentContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        commentContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        commentContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        commentContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        // MARK: View - Write
        view.addSubview(commentWriteContainerView)
        commentWriteContainerBottomCons = commentWriteContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        commentWriteContainerBottomCons?.isActive = true
        commentWriteContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        commentWriteContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.bottomAnchor.constraint(equalTo: commentWriteContainerView.topAnchor).isActive = true
        
        commentWriteContainerView.addSubview(textFieldView)
        textFieldView.topAnchor.constraint(equalTo: commentWriteContainerView.topAnchor, constant: SPACE).isActive = true
        textFieldView.leadingAnchor.constraint(equalTo: commentWriteContainerView.leadingAnchor, constant: SPACE).isActive = true
        textFieldView.trailingAnchor.constraint(equalTo: commentWriteContainerView.trailingAnchor, constant: -SPACE).isActive = true
        textFieldView.bottomAnchor.constraint(equalTo: commentWriteContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        textFieldView.addSubview(commentButton)
        commentButton.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor).isActive = true
        commentButton.topAnchor.constraint(equalTo: textFieldView.topAnchor).isActive = true
        commentButton.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        textFieldView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: SPACE_XS).isActive = true
        textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: SPACE_S).isActive = true
        textField.trailingAnchor.constraint(equalTo: commentButton.leadingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        commentWriteContainerView.addSubview(commentWriteContainerTopLine)
        commentWriteContainerTopLine.topAnchor.constraint(equalTo: commentWriteContainerView.topAnchor).isActive = true
        commentWriteContainerTopLine.leadingAnchor.constraint(equalTo: commentWriteContainerView.leadingAnchor).isActive = true
        commentWriteContainerTopLine.trailingAnchor.constraint(equalTo: commentWriteContainerView.trailingAnchor).isActive = true
    }
    
    func getComments() {
        guard let mode = self.mode else { return }
        guard let id = self.id else { return }
        getCommentsRequest.fetch(vc: self, paramDict: ["mode": mode, "id": String(id)])
    }
    
    func setNoCommentView() {
        let ndv = NoDataView(size: 16, text: "댓글이 없습니다.")
        
        commentContainerView.addSubview(ndv)
        ndv.topAnchor.constraint(equalTo: commentContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        ndv.centerXAnchor.constraint(equalTo: commentContainerView.centerXAnchor).isActive = true
        ndv.widthAnchor.constraint(equalTo: commentContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        ndv.bottomAnchor.constraint(equalTo: commentContainerView.bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func commentTapped() {
        guard let mode = self.mode else { return }
        guard let id = self.id else { return }
        
        guard let comment = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        // 입력하지 않음
        if comment.utf8.count < 1 { return }
        
        // 최대글자
        if comment.count > 50 {
            let alert = UIAlertController(title: "댓글 게시하기", message: "댓글은 최대 50자 까지 입력 가능합니다.\n\n현재 \(comment.count)/50", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
            present(alert, animated: true, completion: nil)
            return
        }
        
        addCommentRequest.fetch(vc: self, paramDict: ["mode": mode, "id": String(id), "comment": comment])
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            commentWriteContainerBottomCons?.isActive = false
            commentWriteContainerBottomCons = commentWriteContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height)
            commentWriteContainerBottomCons?.isActive = true
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        commentWriteContainerBottomCons?.isActive = false
        commentWriteContainerBottomCons = commentWriteContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        commentWriteContainerBottomCons?.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}


// MARK: CommentView
//extension CommentViewController: CommentViewProtocol {
//    func openUser(uId: Int) {
//        if textField.isFirstResponder {
//            textField.resignFirstResponder()
//        }
//        let accountVC = AccountViewController()
////        accountVC.uId = uId
//        present(UINavigationController(rootViewController: accountVC), animated: true, completion: nil)
//    }
//
//    func removeComment(comment: Comment) {
//        if textField.isFirstResponder {
//            textField.resignFirstResponder()
//        }
//
//        guard let mode = self.mode else { return }
//        if comment.uId != app.getUId() { return }
//        let alert = UIAlertController(title: "댓글 삭제", message: "작성하신 댓글을 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel))
//        alert.addAction(UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: { (_) in
//            self.removeCommentRequest.fetch(vc: self, paramDict: ["mode": mode, "id": String(comment.id)])
//        }))
//        present(alert, animated: true, completion: nil)
//    }
//}


// MARK: HTTP - GetComments
extension CommentViewController: GetCommentsRequestProtocol {
    func response(commentList: [Comment]?, getComments status: String) {
        if status == "OK" {
            guard let commentList = commentList else { return }
            
            commentContainerView.removeAllChildView()
            
            navigationItem.title = "댓글 \(commentList.count)개"
            
            if commentList.count > 0 {
                for (i, comment) in commentList.enumerated() {
                    let cv = CommentView()
//                    cv.comment = comment
//                    cv.delegate = self
                    
                    commentContainerView.addSubview(cv)
                    
                    cv.widthAnchor.constraint(equalTo: commentContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
                    cv.centerXAnchor.constraint(equalTo: commentContainerView.centerXAnchor).isActive = true
                    
                    if i == 0 {
                        cv.topAnchor.constraint(equalTo: commentContainerView.topAnchor, constant: SPACE_S).isActive = true
                    } else {
                        cv.topAnchor.constraint(equalTo: commentContainerView.subviews[commentContainerView.subviews.count - 2].bottomAnchor, constant: SPACE_S).isActive = true
                    }
                    if i == commentList.count - 1 {
                        cv.bottomAnchor.constraint(equalTo: commentContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
                    }
                }
                
            } else {
                setNoCommentView()
            }
        }
    }
}

// MARK: HTTP - AddComment
extension CommentViewController: AddCommentRequestProtocol {
    func response(addComment status: String) {
        if status == "OK" {
            getComments()
            textField.text = ""
            textField.resignFirstResponder()
            delegate?.reloadComment()
            
            let alert = UIAlertController(title: "댓글 게시하기", message: "새로운 댓글이 게시되었습니다.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
            present(alert, animated: true)
        }
    }
}

// MARK: HTTP - RemoveComment
extension CommentViewController: RemoveCommentRequestProtocol {
    func response(removeComment status: String) {
        if status == "OK" {
            getComments()
            delegate?.reloadComment()
        }
    }
}
