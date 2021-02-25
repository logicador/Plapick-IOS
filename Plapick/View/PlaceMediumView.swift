//
//  PlaceMediumView.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/26.
//

import UIKit


protocol PlaceMediumViewProtocol {
    func openPlace(place: Place)
}


class PlaceMediumView: UIView {
    
    // MARK: Property
    let slideWidth = SCREEN_WIDTH * (1 / 3)
    let slideHeight = SCREEN_WIDTH * (1 / 3)
    var delegate: PlaceMediumViewProtocol?
    let ICON_WIDTH: CGFloat = 30
    var app = App()
    var index: Int?
    var pickImageList: [String] = []
    var mostPickList: [MostPick] = []
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            pickImageList = place.pickImageList
            
            let categoryName = app.getCategoryName(categoryName: place.categoryName)
            categoryNameLabel.text = categoryName

            nameLabel.text = place.name

            addressLabel.text = (place.roadAddress.isEmpty) ? place.address : place.roadAddress
            
            likeCntLabel.text = String(place.likeCnt)
            commentCntLabel.text = String(place.commentCnt)
            pickCntLabel.text = String(place.pickCnt)
            
//            mostPickList = place.mostPickList
            collectionView.reloadData()
            
            var nextBottomAnchor: NSLayoutYAxisAnchor = headerBottomLine.bottomAnchor
            if pickImageList.count > 0 {
                containerView.addSubview(collectionView)
                collectionView.topAnchor.constraint(equalTo: nextBottomAnchor).isActive = true
                collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
                collectionView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH / 3).isActive = true
                
                containerView.addSubview(collectionBottomLine)
                collectionBottomLine.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
                collectionBottomLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                collectionBottomLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
                
                nextBottomAnchor = collectionBottomLine.bottomAnchor
            }
            
            containerView.addSubview(footerView)
            footerView.topAnchor.constraint(equalTo: nextBottomAnchor, constant: SPACE_S).isActive = true
            footerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: SPACE_L).isActive = true
            footerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -SPACE_L).isActive = true
            footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -SPACE_S).isActive = true
            
            footerView.addSubview(pickCntLabel)
            pickCntLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor).isActive = true
            
            footerView.addSubview(pickCntImageView)
            pickCntImageView.trailingAnchor.constraint(equalTo: pickCntLabel.leadingAnchor, constant: -SPACE_XXXXS).isActive = true
            pickCntImageView.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
            pickCntImageView.widthAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
            pickCntImageView.heightAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
            pickCntImageView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
            
            footerView.addSubview(commentCntLabel)
            commentCntLabel.trailingAnchor.constraint(equalTo: pickCntImageView.leadingAnchor, constant: -SPACE_S).isActive = true
            
            footerView.addSubview(commentCntImageView)
            commentCntImageView.trailingAnchor.constraint(equalTo: commentCntLabel.leadingAnchor, constant: -SPACE_XXXXS).isActive = true
            commentCntImageView.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
            commentCntImageView.widthAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
            commentCntImageView.heightAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
            commentCntImageView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
            
            footerView.addSubview(likeCntLabel)
            likeCntLabel.trailingAnchor.constraint(equalTo: commentCntImageView.leadingAnchor, constant: -SPACE_S).isActive = true
            
            footerView.addSubview(likeCntImageView)
            likeCntImageView.trailingAnchor.constraint(equalTo: likeCntLabel.leadingAnchor, constant: -SPACE_XXXXS).isActive = true
            likeCntImageView.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
            likeCntImageView.widthAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
            likeCntImageView.heightAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
            likeCntImageView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
            
            pickCntLabel.centerYAnchor.constraint(equalTo: pickCntImageView.centerYAnchor).isActive = true
            commentCntLabel.centerYAnchor.constraint(equalTo: commentCntImageView.centerYAnchor).isActive = true
            likeCntLabel.centerYAnchor.constraint(equalTo: likeCntImageView.centerYAnchor).isActive = true
            
            footerView.addSubview(categoryNameLabel)
            categoryNameLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
            categoryNameLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor).isActive = true
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Header
    lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .link
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var headerBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - CollectionView
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(MostPickSmallCVCell.self, forCellWithReuseIdentifier: "MostPickSmallCVCell")
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    lazy var collectionBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Footer
    lazy var footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var likeCntImageView: UIImageView = {
        let img = UIImage(systemName: "heart.circle.fill")
        let iv = UIImageView(image: img)
        iv.tintColor = .systemRed
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var likeCntLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var commentCntImageView: UIImageView = {
        let img = UIImage(systemName: "message.circle.fill")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var commentCntLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pickCntImageView: UIImageView = {
        let img = UIImage(systemName: "camera.circle.fill")
        let iv = UIImageView(image: img)
        iv.tintColor = .mainColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var pickCntLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        
        setThemeColor()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        containerView.layer.borderColor = UIColor.separator.cgColor
        if self.traitCollection.userInterfaceStyle == .dark {
            commentCntImageView.tintColor = .lightGray
            commentCntLabel.textColor = .lightGray
            collectionView.backgroundColor = .black
        } else {
            commentCntImageView.tintColor = .systemGray
            commentCntLabel.textColor = .systemGray
            collectionView.backgroundColor = .white
        }
    }
    
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // MARK: ConfigureView - Header
        containerView.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_L).isActive = true
        headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: SPACE_L).isActive = true
        headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -SPACE_L).isActive = true
        
        headerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true

        headerView.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -SPACE_L).isActive = true
        
        containerView.addSubview(headerBottomLine)
        headerBottomLine.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        headerBottomLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        headerBottomLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        guard let place = self.place else { return }
        delegate?.openPlace(place: place)
    }
}


// MARK: CollectionView
extension PlaceMediumView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MostPickSmallCVCell", for: indexPath) as! MostPickSmallCVCell
        cell.mostPick = mostPickList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == mostPickList.count - 1 {
            return CGSize(width: SCREEN_WIDTH / 3, height: SCREEN_WIDTH / 3)
        } else {
            return CGSize(width: (SCREEN_WIDTH / 3) + 1, height: SCREEN_WIDTH / 3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
