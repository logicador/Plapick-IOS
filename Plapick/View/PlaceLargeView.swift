//
//  PlaceLargeView.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit
import SDWebImage


protocol PlaceLargeViewProtocol {
    func openPlace(place: Place)
    func openPlaceAllComments(place: Place)
    func openPlaceAllPicks(place: Place)
    func openUser(uId: Int)
    func openPick(piId: Int)
}


class PlaceLargeView: UIView {
    
    // MARK: Property
    let slideWidth = SCREEN_WIDTH
    let slideHeight = SCREEN_WIDTH
    var app = App()
    var delegate: PlaceLargeViewProtocol?
    var mostPickList: [MostPick] = []
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            let categoryName = app.getCategoryName(categoryName: place.categoryName)
            categoryNameLabel.text = categoryName
            
            nameLabel.text = place.name
            
            addressLabel.text = (place.roadAddress.isEmpty) ? place.address : place.roadAddress
            
            likeCntButton.setTitle("좋아요 \(place.likeCnt)개", for: UIControl.State.normal)
            commentCntButton.setTitle("댓글 \(place.commentCnt)개", for: UIControl.State.normal)
            pickCntButton.setTitle("픽 \(place.pickCnt)개", for: UIControl.State.normal)
            
//            mostPickList = place.mostPickList
            collectionView.reloadData()
//            pageControl.numberOfPages = place.mostPickList.count
        }
    }
    
    
    // MARK: View
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.isPagingEnabled = true
        cv.register(MostPickLargeCVCell.self, forCellWithReuseIdentifier: "MostPickLargeCVCell")
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        
        // 이거 안해주면 pageControl에 패딩이 잡혀있음
        if #available(iOS 14.0, *) {
            pc.backgroundStyle = .minimal
            pc.allowsContinuousInteraction = false
        }
        
        pc.isEnabled = false // clickable
        pc.pageIndicatorTintColor = .separator
        
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
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
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var detailButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.setTitle("자세히", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = SPACE_S
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XXS, left: SPACE_S, bottom: SPACE_XXS, right: SPACE_S)
        button.addTarget(self, action: #selector(detailTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: VIEW - Footer
    lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var likeCntButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var commentCntButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(commentCntTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var pickCntButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(pickCntTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Line
    lazy var collectionTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var collectionBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var footerBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var footerTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var footerLeftLine: LineView = {
        let lv = LineView(orientation: .vertical)
        return lv
    }()
    lazy var footerRightLine: LineView = {
        let lv = LineView(orientation: .vertical)
        return lv
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        
        setThemeColor()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        pageControl.currentPageIndicatorTintColor = UIColor.systemBackground.inverted
        likeCntButton.tintColor = UIColor.systemBackground.inverted
        commentCntButton.tintColor = UIColor.systemBackground.inverted
        pickCntButton.tintColor = UIColor.systemBackground.inverted
    }
    
    func configureView() {
        // MARK: ConfigureView - Header
        addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE_XS).isActive = true
        headerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        headerView.addSubview(categoryNameLabel)
        categoryNameLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        categoryNameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        
        headerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: SPACE_XXXXS).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        
        headerView.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XXXXS).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        headerView.addSubview(detailButton)
        detailButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        detailButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH + 40 + (SPACE_XS * 2)).isActive = true
        
        addSubview(pageControl)
        pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: SPACE_S).isActive = true
        pageControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        // MARK: ConfigureView - Footer
        addSubview(footerView)
        footerView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: SPACE_S).isActive = true
        footerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        footerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        footerView.addSubview(likeCntButton)
        likeCntButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: SPACE_XS).isActive = true
        likeCntButton.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 1 / 3).isActive = true
        likeCntButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        likeCntButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor).isActive = true

        footerView.addSubview(commentCntButton)
        commentCntButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: SPACE_XS).isActive = true
        commentCntButton.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 1 / 3).isActive = true
        commentCntButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        commentCntButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true

        footerView.addSubview(pickCntButton)
        pickCntButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: SPACE_XS).isActive = true
        pickCntButton.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 1 / 3).isActive = true
        pickCntButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        pickCntButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Line
        addSubview(collectionTopLine)
        collectionTopLine.topAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        collectionTopLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionTopLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(collectionBottomLine)
        collectionBottomLine.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        collectionBottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionBottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(footerTopLine)
        footerTopLine.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        footerTopLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        footerTopLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        addSubview(footerBottomLine)
        footerBottomLine.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
        footerBottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        footerBottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(footerLeftLine)
        footerLeftLine.leadingAnchor.constraint(equalTo: commentCntButton.leadingAnchor).isActive = true
        footerLeftLine.topAnchor.constraint(equalTo: footerView.topAnchor, constant: SPACE_XS).isActive = true
        footerLeftLine.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        addSubview(footerRightLine)
        footerRightLine.trailingAnchor.constraint(equalTo: commentCntButton.trailingAnchor).isActive = true
        footerRightLine.topAnchor.constraint(equalTo: footerView.topAnchor, constant: SPACE_XS).isActive = true
        footerRightLine.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -SPACE_XS).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func detailTapped() {
        guard let place = self.place else { return }
        delegate?.openPlace(place: place)
    }
    
    @objc func commentCntTapped() {
        guard let place = self.place else { return }
        delegate?.openPlaceAllComments(place: place)
    }
    
    @objc func pickCntTapped() {
        guard let place = self.place else { return }
        delegate?.openPlaceAllPicks(place: place)
    }
}


// MARK: Extension - ScrollView
extension PlaceLargeView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / SCREEN_WIDTH)
        pageControl.currentPage = Int(pageIndex)
    }
}

// MARK: Extension - CollectionView
extension PlaceLargeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mostPickList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MostPickLargeCVCell", for: indexPath) as! MostPickLargeCVCell
        cell.mostPick = mostPickList[indexPath.row]
        cell.delegate = self
        
        if indexPath.row == mostPickList.count - 1 {
            let lv = LineView(orientation: .vertical)
            cell.addSubview(lv)
            lv.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            lv.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            lv.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH + 40 + (SPACE_XS * 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: Extension - PickWithUserCVCell
extension PlaceLargeView: MostPickLargeCVCellProtocol {
    func openUser(uId: Int) {
        delegate?.openUser(uId: uId)
    }
    
    func openPick(piId: Int) {
        delegate?.openPick(piId: piId)
    }
}
