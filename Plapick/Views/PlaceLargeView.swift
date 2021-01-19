//
//  PlaceLargeView.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


// MARK: Protocol
protocol PlaceLargeViewProtocol {
    func placeTapped(place: Place)
}


class PlaceLargeView: UIView {
    
    // MARK: Properties
    var app = App()
    var delegate: PlaceLargeViewProtocol?
    var fullSize = UIScreen.main.bounds.size
    var place: Place?
    
    
    // MARK: Views
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.isPagingEnabled = true
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var scrollTopLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scrollBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    
    // MARK: Init
    init(place: Place) {
        super.init(frame: CGRect.zero)
        
        self.place = place
        let placeSmallView = PlaceSmallView(place: place)
        let hotPickList = place.hotPickList
        scrollView.contentSize = CGSize(width: fullSize.width * CGFloat(hotPickList.count), height: fullSize.width * (2 / 3))
        pageControl.numberOfPages = hotPickList.count
        
        addSubview(placeSmallView)
        placeSmallView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        placeSmallView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        placeSmallView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        placeSmallView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: placeSmallView.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: fullSize.width * (2 / 3)).isActive = true
        
        addSubview(scrollTopLineView)
        scrollTopLineView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollTopLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollTopLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollTopLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollTopLineView.heightAnchor.constraint(equalToConstant: LINE_VIEW_HEIGHT).isActive = true

        addSubview(scrollBottomLineView)
        scrollBottomLineView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollBottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollBottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollBottomLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollBottomLineView.heightAnchor.constraint(equalToConstant: LINE_VIEW_HEIGHT).isActive = true
        
        addSubview(pageControl)
        if #available(iOS 14.0, *) {
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        } else {
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        addSubview(topLineView)
        topLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topLineView.leadingAnchor.constraint(equalTo:leadingAnchor).isActive = true
        topLineView.trailingAnchor.constraint(equalTo:trailingAnchor).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: LINE_VIEW_HEIGHT).isActive = true
        
        addSubview(bottomLineView)
        bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomLineView.leadingAnchor.constraint(equalTo:leadingAnchor).isActive = true
        bottomLineView.trailingAnchor.constraint(equalTo:trailingAnchor).isActive = true
        bottomLineView.heightAnchor.constraint(equalToConstant: LINE_VIEW_HEIGHT).isActive = true
        
        for (i, pick) in hotPickList.enumerated() {
            let pv = PhotoView(isConstraints: false)
            pv.image = app.getUrlImage(urlString: pick.photoUrl)
            scrollView.addSubview(pv)
            pv.frame = CGRect(x: fullSize.width * CGFloat(i), y: 0, width: fullSize.width, height: fullSize.width * (2 / 3))
        }
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
        translatesAutoresizingMaskIntoConstraints = false
        
        adjustColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        pageControl.currentPageIndicatorTintColor = UIColor.systemBackground.inverted
        
        if self.traitCollection.userInterfaceStyle == .dark {
            backgroundColor = .systemGray6
        } else {
            backgroundColor = .systemBackground
        }
    }
    
    @objc func selfTapped() {
        guard let place = self.place else { return }
        delegate?.placeTapped(place: place)
    }
}


// MARK: Extensions
extension PlaceLargeView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / fullSize.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
