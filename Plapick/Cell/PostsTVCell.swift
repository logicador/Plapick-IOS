//
//  PostsTVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/31.
//

import UIKit


protocol PostsTVCellProtocol {
    func more(posts: Posts)
    func selectUser(uId: Int)
    func selectPlace(pId: Int, pName: String)
    func likePosts(posts: Posts)
    func commentPosts(posts: Posts)
}


class PostsTVCell: UITableViewCell {
    
    // MARK: Property
    var delegate: PostsTVCellProtocol?
    var posts: Posts? {
        didSet {
            guard let posts = self.posts else { return }
            
            guard let profileImage = posts.u_profile_image else { return }
            guard let profileImageUrl = URL(string: PLAPICK_URL + profileImage) else { return }
            profileImageView.sd_setImage(with: profileImageUrl, completed: nil)
            
            nicknameLabel.text = posts.u_nickname
            
            likeCntImageView.image = (posts.po_is_like == "Y") ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            likeCntImageView.tintColor = (posts.po_is_like == "Y") ? .systemRed : (traitCollection.userInterfaceStyle == .dark) ? .white : .black
            likeCntLabel.text = String(posts.po_like_cnt)
            commentCntLabel.text = String(posts.po_comment_cnt)
            
            placeNameLabel.text = posts.p_name
            
            postsImageList.removeAll()
            var postsImageList: [PostsImage] = []
            for poi in posts.poi.split(separator: "|") {
                let splitted = poi.split(separator: ":")
                
                guard let poiId = Int(splitted[0]) else { return }
                let poiPath = String(splitted[1])
                
                let postsImage = PostsImage(poi_id: poiId, poi_u_id: posts.po_u_id, poi_po_id: posts.po_id, poi_path: poiPath)
                postsImageList.append(postsImage)
            }
            self.postsImageList = postsImageList
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let nowDate = Date()
            let nowString = df.string(from: nowDate)
            guard let startTime = df.date(from: posts.po_created_date) else { return }
            guard let endTime = df.date(from: nowString) else { return }
            let useDay = Int(endTime.timeIntervalSince(startTime)) / 86400
            
            if useDay == 0 { dateLabel.text = "오늘" }
            else if (useDay > 0 && useDay < 7) || (useDay > 7 && useDay < 14) || (useDay > 14 && useDay < 21) { dateLabel.text = "\(useDay)일 전" }
            else if useDay == 7 || useDay == 14 || useDay == 21 { dateLabel.text = "\(useDay / 7)주 전" }
            else { dateLabel.text = posts.po_created_date.split(separator: " ")[0].replacingOccurrences(of: "-", with: ". ") }
            
            messageLabel.text = posts.po_message
        }
    }
    var postsImageList: [PostsImage] = [] {
        didSet {
            if postsImageList.count > 0 {
                collectionView.reloadData()
                pageLabel.text = "1 / \(postsImageList.count)"
                collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
            }
        }
    }
    
    
    // MARK: View
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Header
    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray6
        iv.layer.borderWidth = LINE_WIDTH
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - SubHeader
    lazy var subHeaderTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var subHeaderContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var placeContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(placeTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var placeImageView: UIImageView = {
        let image = UIImage(systemName: "location.fill")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - SubHeader - Comment
    lazy var commentCntContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var commentCntImageView: UIImageView = {
        let image = UIImage(systemName: "message")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var commentCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - SubHeader - LikeCnt
    lazy var likeCntContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var likeCntImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var likeCntLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Image
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceHorizontal = true
        cv.isPagingEnabled = true
        cv.register(SlideImageCVCell.self, forCellWithReuseIdentifier: "SlideImageCVCell")
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .systemGray6
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: View - Footer
    lazy var footerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var pageLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Message
    lazy var messageTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var messageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        
        configureView()
        
        setThemeColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        profileImageView.layer.borderColor = UIColor.separator.cgColor
        
        commentCntImageView.tintColor = (traitCollection.userInterfaceStyle == .dark) ? .white : .black
        
        guard let posts = self.posts else { return }
        likeCntImageView.tintColor = (posts.po_is_like == "Y") ? .systemRed : (traitCollection.userInterfaceStyle == .dark) ? .white : .black
    }
    
    func configureView() {
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE_XXXXL).isActive = true
        
        // MARK: Configure - Header
        stackView.addArrangedSubview(headerContainerView)
        headerContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        headerContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true

        headerContainerView.addSubview(profileContainerView)
        profileContainerView.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        profileContainerView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        profileContainerView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true

        profileContainerView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: profileContainerView.topAnchor, constant: SPACE_XS).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true

        profileContainerView.addSubview(nicknameLabel)
        nicknameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 7).isActive = true
        nicknameLabel.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor).isActive = true

        headerContainerView.addSubview(moreButton)
        moreButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true

        // MARK: Configure - SubHeader
        stackView.addArrangedSubview(subHeaderTopLine)
        subHeaderTopLine.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        subHeaderTopLine.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true

        stackView.addArrangedSubview(subHeaderContainerView)
        subHeaderContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        subHeaderContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true

        subHeaderContainerView.addSubview(placeContainerView)
        placeContainerView.topAnchor.constraint(equalTo: subHeaderContainerView.topAnchor).isActive = true
        placeContainerView.leadingAnchor.constraint(equalTo: subHeaderContainerView.leadingAnchor).isActive = true
        placeContainerView.bottomAnchor.constraint(equalTo: subHeaderContainerView.bottomAnchor).isActive = true

        placeContainerView.addSubview(placeNameLabel)
        placeNameLabel.topAnchor.constraint(equalTo: placeContainerView.topAnchor, constant: 12).isActive = true
        placeNameLabel.trailingAnchor.constraint(equalTo: placeContainerView.trailingAnchor).isActive = true
        placeNameLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        placeNameLabel.bottomAnchor.constraint(equalTo: placeContainerView.bottomAnchor, constant: -12).isActive = true

        placeContainerView.addSubview(placeImageView)
        placeImageView.centerYAnchor.constraint(equalTo: placeNameLabel.centerYAnchor).isActive = true
        placeImageView.leadingAnchor.constraint(equalTo: placeContainerView.leadingAnchor).isActive = true
        placeImageView.trailingAnchor.constraint(equalTo: placeNameLabel.leadingAnchor, constant: -6).isActive = true
        placeImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        placeImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true

        // MARK: Configure - SubHeader - Comment
        subHeaderContainerView.addSubview(commentCntContainerView)
        commentCntContainerView.topAnchor.constraint(equalTo: placeContainerView.topAnchor).isActive = true
        commentCntContainerView.trailingAnchor.constraint(equalTo: subHeaderContainerView.trailingAnchor).isActive = true
        commentCntContainerView.bottomAnchor.constraint(equalTo: placeContainerView.bottomAnchor).isActive = true

        commentCntContainerView.addSubview(commentCntImageView)
        commentCntImageView.centerYAnchor.constraint(equalTo: placeNameLabel.centerYAnchor).isActive = true
        commentCntImageView.leadingAnchor.constraint(equalTo: commentCntContainerView.leadingAnchor).isActive = true
        commentCntImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        commentCntImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        commentCntContainerView.addSubview(commentCntLabel)
        commentCntLabel.centerYAnchor.constraint(equalTo: placeNameLabel.centerYAnchor).isActive = true
        commentCntLabel.leadingAnchor.constraint(equalTo: commentCntImageView.trailingAnchor, constant: 4).isActive = true
        commentCntLabel.trailingAnchor.constraint(equalTo: commentCntContainerView.trailingAnchor).isActive = true

        // MARK: Configure - SubHeader - Like
        subHeaderContainerView.addSubview(likeCntContainerView)
        likeCntContainerView.topAnchor.constraint(equalTo: commentCntContainerView.topAnchor).isActive = true
        likeCntContainerView.trailingAnchor.constraint(equalTo: commentCntContainerView.leadingAnchor, constant: -16).isActive = true
        likeCntContainerView.bottomAnchor.constraint(equalTo: commentCntContainerView.bottomAnchor).isActive = true

        likeCntContainerView.addSubview(likeCntImageView)
        likeCntImageView.centerYAnchor.constraint(equalTo: placeNameLabel.centerYAnchor).isActive = true
        likeCntImageView.leadingAnchor.constraint(equalTo: likeCntContainerView.leadingAnchor).isActive = true
        likeCntImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        likeCntImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        likeCntContainerView.addSubview(likeCntLabel)
        likeCntLabel.centerYAnchor.constraint(equalTo: placeNameLabel.centerYAnchor).isActive = true
        likeCntLabel.leadingAnchor.constraint(equalTo: likeCntImageView.trailingAnchor, constant: 4).isActive = true
        likeCntLabel.trailingAnchor.constraint(equalTo: likeCntContainerView.trailingAnchor).isActive = true

        // MARK: Configure - Image
        stackView.addArrangedSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true

        // MARK: Configure - Footer
        stackView.addArrangedSubview(footerContainerView)
        footerContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        footerContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true

        footerContainerView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: footerContainerView.topAnchor, constant: SPACE_XS).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: footerContainerView.leadingAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: footerContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        footerContainerView.addSubview(pageLabel)
        pageLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        pageLabel.trailingAnchor.constraint(equalTo: footerContainerView.trailingAnchor).isActive = true

        // MARK: Configure - Message
        stackView.addArrangedSubview(messageTopLine)
        messageTopLine.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        messageTopLine.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true

        stackView.addArrangedSubview(messageContainerView)
        messageContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        messageContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true

        messageContainerView.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: SPACE_XS).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(collectionView.contentOffset.x / SCREEN_WIDTH)
        pageLabel.text = "\(Int(pageIndex + 1)) / \(postsImageList.count)"
    }
    
    // MARK: Function - @OBJC
    @objc func profileTapped() {
        guard let posts = self.posts else { return }
        delegate?.selectUser(uId: posts.po_u_id)
    }
    
    @objc func moreTapped() {
        guard let posts = self.posts else { return }
        delegate?.more(posts: posts)
    }
    
    @objc func placeTapped() {
        guard let posts = self.posts else { return }
        delegate?.selectPlace(pId: posts.po_p_id, pName: posts.p_name)
    }
    
    @objc func likeTapped() {
        guard let posts = self.posts else { return }
        
        delegate?.likePosts(posts: posts)
        
        self.posts?.po_is_like = (posts.po_is_like == "Y") ? "N" : "Y"
        self.posts?.po_like_cnt = (posts.po_is_like == "Y") ? posts.po_like_cnt - 1 : posts.po_like_cnt + 1
        
        likeCntImageView.image = (posts.po_is_like == "Y") ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        likeCntImageView.tintColor = (posts.po_is_like == "Y") ? (traitCollection.userInterfaceStyle == .dark) ? .white : .black : .systemRed
        likeCntLabel.text = (posts.po_is_like == "Y") ? String(posts.po_like_cnt - 1) : String(posts.po_like_cnt + 1)
    }
    
    @objc func commentTapped() {
        guard let posts = self.posts else { return }
        delegate?.commentPosts(posts: posts)
    }
}


// MARK: CollectionView
extension PostsTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideImageCVCell", for: indexPath) as! SlideImageCVCell
        cell.postsImage = postsImageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH)
    }
}

