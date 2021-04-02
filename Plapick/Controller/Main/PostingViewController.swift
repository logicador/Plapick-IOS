//
//  PostingViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/21.
//

import UIKit


class PostingViewController: UIViewController {
    
    // MARK: Property
    var imageList: [UIImage] = []
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Message
    lazy var messageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "메시지"
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var messageTopLine: UIView = {
        let lv = LineView()
        return lv
    }()
    lazy var messageTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15)
        tv.text = "이곳에 메시지를 입력합니다."
        tv.textColor = .systemGray3
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    lazy var messageBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var messageCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 300"
        label.textColor = .systemGreen
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Image
    lazy var imageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사진"
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var imageOrderLabel: UILabel = {
        let label = UILabel()
        label.text = "길게눌러 순서변경"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var imageOrderImageView: UIImageView = {
        let image = UIImage(systemName: "square.grid.3x3.topleft.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.register(UploadPostsImageCVCell.self, forCellWithReuseIdentifier: "UploadPostsImageCVCell")
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(imageCollectionViewLongPressed)))
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    lazy var imageTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "새로운 게시물"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextTapped))
        
        configureView()
        
        setThemeColor()
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        messageTextView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        messageTextView.textColor = (messageTextView.textColor == .systemGray3) ? .systemGray3 : (traitCollection.userInterfaceStyle == .dark) ? .white : .black
        
        imageCollectionView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Message
        containerView.addSubview(messageTitleLabel)
        messageTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_XXL).isActive = true
        messageTitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        messageTitleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        containerView.addSubview(messageTopLine)
        messageTopLine.topAnchor.constraint(equalTo: messageTitleLabel.bottomAnchor, constant: SPACE).isActive = true
        messageTopLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        messageTopLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        containerView.addSubview(messageTextView)
        messageTextView.topAnchor.constraint(equalTo: messageTopLine.bottomAnchor, constant: SPACE_XS).isActive = true
        messageTextView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        messageTextView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3).isActive = true
        
        containerView.addSubview(messageCntLabel)
        messageCntLabel.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: SPACE_XS).isActive = true
        messageCntLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        messageCntLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        containerView.addSubview(messageBottomLine)
        messageBottomLine.topAnchor.constraint(equalTo: messageCntLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        messageBottomLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        messageBottomLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Image
        containerView.addSubview(imageTitleLabel)
        imageTitleLabel.topAnchor.constraint(equalTo: messageBottomLine.bottomAnchor, constant: SPACE_XXL).isActive = true
        imageTitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageTitleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        imageTitleLabel.addSubview(imageOrderLabel)
        imageOrderLabel.centerYAnchor.constraint(equalTo: imageTitleLabel.centerYAnchor).isActive = true
        imageOrderLabel.trailingAnchor.constraint(equalTo: imageTitleLabel.trailingAnchor).isActive = true
        
        imageTitleLabel.addSubview(imageOrderImageView)
        imageOrderImageView.centerYAnchor.constraint(equalTo: imageTitleLabel.centerYAnchor).isActive = true
        imageOrderImageView.trailingAnchor.constraint(equalTo: imageOrderLabel.leadingAnchor, constant: -7).isActive = true
        imageOrderImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageOrderImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.addSubview(imageCollectionView)
        imageCollectionView.topAnchor.constraint(equalTo: imageTitleLabel.bottomAnchor, constant: SPACE).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imageCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        containerView.addSubview(imageTopLine)
        imageTopLine.topAnchor.constraint(equalTo: imageCollectionView.topAnchor).isActive = true
        imageTopLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageTopLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismissKeyboard()
        
        let alert = UIAlertController(title: nil, message: "작성중이던 내용이 저장되지 않습니다. 계속하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
        alert.addAction(UIAlertAction(title: "예", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true)
    }
    
    @objc func nextTapped() {
        dismissKeyboard()
        
        let lineHeight = messageTextView.font?.lineHeight ?? 0
        let line = Int((messageTextView.contentSize.height - 16) / lineHeight)
        if line > POSTS_MESSAGE_LINE_LIMIT {
            let alert = UIAlertController(title: nil, message: "최대 \(POSTS_MESSAGE_LINE_LIMIT)줄까지 입력 가능합니다.\n\n현재 \(line) / \(POSTS_MESSAGE_LINE_LIMIT)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let message = (messageTextView.textColor == .systemGray3) ? "" : messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let searchKakaoPlaceVC = SearchKakaoPlaceViewController()
        searchKakaoPlaceVC.mode = "POSTING"
        searchKakaoPlaceVC.message = message
        searchKakaoPlaceVC.imageList = imageList
        navigationController?.pushViewController(searchKakaoPlaceVC, animated: true)
    }
    
    @objc func imageCollectionViewLongPressed(gesture: UILongPressGestureRecognizer) {
        dismissKeyboard()

        switch gesture.state {
        case .began:
            guard let targetIndexPath = imageCollectionView.indexPathForItem(at: gesture.location(in: imageCollectionView)) else { return }
            imageCollectionView.beginInteractiveMovementForItem(at: targetIndexPath)

        case .changed:
            imageCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: imageCollectionView))
        case .ended:
            imageCollectionView.endInteractiveMovement()
        default:
            imageCollectionView.cancelInteractiveMovement()
        }
    }
}


// MARK: TextView
extension PostingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let message = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        messageCntLabel.text = "\(message.count) / 300"
        
        if message.count > 300 {
            messageCntLabel.textColor = .systemRed
            navigationItem.rightBarButtonItem = nil
        } else {
            messageCntLabel.textColor = .systemGreen
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextTapped))
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
            textView.text = "이곳에 메시지를 입력합니다."
            textView.textColor = .systemGray3
        }
    }
}

// MARK: CollectionView
extension PostingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadPostsImageCVCell", for: indexPath) as! UploadPostsImageCVCell
        cell.image = imageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - (4 / 3), height: (view.frame.width / 3) - (4 / 3))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissKeyboard()
        
        if imageList.count == 1 {
            let alert = UIAlertController(title: nil, message: "1개 이상의 사진을 게시해야됩니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let alert = UIAlertController(title: nil, message: "사진을 제거하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "제거", style: .destructive, handler: { (_) in
            self.imageList.remove(at: indexPath.row)
            self.imageCollectionView.reloadData()
        }))
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = imageList.remove(at: sourceIndexPath.row)
        imageList.insert(item, at: destinationIndexPath.row)
    }
}
