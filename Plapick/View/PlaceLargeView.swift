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
    func openPick(piId: Int)
    func openPickUser(uId: Int)
    func openPickCnt(piId: Int)
}


class PlaceLargeView: UIView {
    
    // MARK: Property
    let slideWidth = SCREEN_WIDTH
    let slideHeight = SCREEN_WIDTH
    var app = App()
    var delegate: PlaceLargeViewProtocol?
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            let categoryName = app.getCategoryString(categoryName: place.categoryName ?? "")
            categoryNameLabel.text = categoryName
            
            nameLabel.text = place.name
            
            let address = place.address ?? ""
            let roadAddress = place.roadAddress ?? ""
            addressLabel.text = (roadAddress.isEmpty) ? address : roadAddress
            
            likeCntButton.setTitle("좋아요 \(place.likeCnt)개", for: UIControl.State.normal)
            commentCntButton.setTitle("댓글 \(place.commentCnt)개", for: UIControl.State.normal)
            pickCntButton.setTitle("픽 \(place.pickCnt)개", for: UIControl.State.normal)
            
            guard let mostPickList = place.mostPickList else { return }
            
            scrollView.contentSize = CGSize(width: slideWidth * CGFloat(mostPickList.count), height: slideHeight)
            pageControl.numberOfPages = mostPickList.count
            
            for (i, mostPick) in mostPickList.enumerated() {
                let mpsv = MostPickSlideView()
                mpsv.mostPick = mostPick
                mpsv.frame = CGRect(x: ((slideWidth - 1) * CGFloat(i)) + (1 * CGFloat(i)), y: 0, width: (slideWidth - 1), height: slideHeight)
                mpsv.delegate = self
                scrollView.addSubview(mpsv)
            }
        }
    }
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        sv.showsHorizontalScrollIndicator = false
        sv.isPagingEnabled = true
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
//        view.layer.shadowOpacity = 0.2
//        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var likeCntButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.addTarget(self, action: #selector(likeTapped), for: UIControl.Event.touchUpInside)
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
    lazy var topLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var scrollTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var scrollBottomLine: LineView = {
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
    lazy var leftLine: LineView = {
        let lv = LineView(orientation: .vertical)
        return lv
    }()
    lazy var rightLine: LineView = {
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
        addressLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        headerView.addSubview(detailButton)
        detailButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        detailButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: SPACE_XS).isActive = true
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: slideHeight).isActive = true
        
        addSubview(pageControl)
        pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: SPACE_S).isActive = true
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
//        likeImageView.centerXAnchor.constraint(equalTo: likeCntButton.centerXAnchor).isActive = true

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
        addSubview(topLine)
        topLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(scrollTopLine)
        scrollTopLine.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollTopLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollTopLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(scrollBottomLine)
        scrollBottomLine.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollBottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollBottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        addSubview(footerTopLine)
        footerTopLine.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        footerTopLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        footerTopLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        addSubview(footerBottomLine)
        footerBottomLine.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
        footerBottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        footerBottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(leftLine)
        leftLine.leadingAnchor.constraint(equalTo: commentCntButton.leadingAnchor).isActive = true
        leftLine.topAnchor.constraint(equalTo: footerView.topAnchor, constant: SPACE_XS).isActive = true
        leftLine.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        addSubview(rightLine)
        rightLine.trailingAnchor.constraint(equalTo: commentCntButton.trailingAnchor).isActive = true
        rightLine.topAnchor.constraint(equalTo: footerView.topAnchor, constant: SPACE_XS).isActive = true
        rightLine.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -SPACE_XS).isActive = true
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


// MARK: Extension
extension PlaceLargeView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / SCREEN_WIDTH)
        pageControl.currentPage = Int(pageIndex)
    }
}


extension PlaceLargeView: MostPickSlideViewProtocol {
    func openPick(piId: Int) {
        delegate?.openPick(piId: piId)
    }
    
    func openPickUser(uId: Int) {
        delegate?.openPickUser(uId: uId)
    }
    
    func openPickStatistics(piId: Int) {
        delegate?.openPickCnt(piId: piId)
    }
}
