//
//  PostsPlaceCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/24.
//

import UIKit


protocol PostsPlaceTVCellProtocol {
    func selectPlace(place: Place)
    func selectPosts(isMoveInitPosition: Bool, poId: Int, postsList: [Posts])
}


class PostsPlaceTVCell: UITableViewCell {
    
    // MARK: Property
    var delegate: PostsPlaceTVCellProtocol?
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            categoryLabel.text = place.p_category_name.replacingOccurrences(of: ">", with: "-")
            nameLabel.text = place.p_name
            addressLabel.text = (place.p_road_address.isEmpty) ? place.p_address : place.p_road_address
            
            guard let postsList = place.postsList else { return }
            self.postsList = postsList
            collectionView.reloadData()
            
            let cntMabs = NSMutableAttributedString()
                .normal("게시물 ", size: 12, color: .systemGray3)
                .bold(String(place.p_posts_cnt), size: 12, color: .systemGray)
                .normal("  좋아요 ", size: 12, color: .systemGray3)
                .bold(String(place.p_like_cnt), size: 12, color: .systemGray)
                .normal("  댓글 ", size: 12, color: .systemGray3)
                .bold(String(place.p_comment_cnt), size: 12, color: .systemGray)
            cntLabel.attributedText = cntMabs
        }
    }
    var postsList: [Posts] = []
    
    
    // MARK: View
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XXS
        sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(placeTapped)))
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var cntLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceHorizontal = true
        cv.register(PostsCVCell.self, forCellWithReuseIdentifier: "PostsCVCell")
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
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
        collectionView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE_XXL).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        stackView.addArrangedSubview(categoryLabel)
        categoryLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        categoryLabel.addSubview(cntLabel)
        cntLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor).isActive = true
        cntLabel.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(addressLabel)
        addressLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: SPACE_XS).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: (SCREEN_WIDTH / 3) - (4 / 3)).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func placeTapped() {
        guard let place = self.place else { return }
        delegate?.selectPlace(place: place)
    }
}


// MARK: CollectionView
extension PostsPlaceTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostsCVCell", for: indexPath) as! PostsCVCell
        cell.posts = postsList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (SCREEN_WIDTH / 3) - (4 / 3), height: (SCREEN_WIDTH / 3) - (4 / 3))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let poId = postsList[indexPath.row].po_id
        delegate?.selectPosts(isMoveInitPosition: (indexPath.row == 0) ? false : true, poId: poId, postsList: postsList)
    }
}
