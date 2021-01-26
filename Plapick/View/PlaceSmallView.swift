//
//  PlaceSmallView.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/26.
//

import UIKit


protocol PlaceSmallViewProtocol {
    func openPlace(place: Place)
//    func likePlace(place: Place)
//    func openAllComments(place: Place)
//    func openAllPicks(place: Place)
}


class PlaceSmallView: UIView {
    
    // MARK: Property
    let slideWidth = SCREEN_WIDTH * 0.33
    let slideHeight = SCREEN_WIDTH * 0.33
    var delegate: PlaceSmallViewProtocol?
    let ICON_WIDTH: CGFloat = 30
    var app = App()
    var index: Int?
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            let categoryName = app.getCategoryString(categoryName: place.categoryName ?? "")
            categoryNameLabel.text = categoryName

            nameLabel.text = place.name

            let address = place.address ?? ""
            let roadAddress = place.roadAddress ?? ""
            addressLabel.text = (roadAddress.isEmpty) ? address : roadAddress
            
            likeCntLabel.text = String(place.likeCnt)
            commentCntLabel.text = String(place.commentCnt)
            pickCntLabel.text = String(place.pickCnt)
            
            guard let mostPickList = place.mostPickList else { return }
            
            if mostPickList.count > 0 {
                noPickLabel.removeView()
                
                scrollView.contentSize = CGSize(width: (slideWidth * CGFloat(mostPickList.count)) + (SPACE_XXS * (CGFloat(mostPickList.count) - 1)), height: slideHeight)
                
                for (i, mostPick) in mostPickList.enumerated() {
                    let pv = PhotoView(cons: true)
                    if let url = URL(string: app.getPickUrl(id: mostPick.id, uId: mostPick.uId)) {
                        pv.sd_setImage(with: url, completed: nil)
                    }
                    pv.frame = CGRect(x: (slideWidth * CGFloat(i)) + (CGFloat(i) * SPACE_XXS) , y: 0, width: slideWidth, height: slideHeight)
                    scrollView.addSubview(pv)
                }
                
            } else {
                addSubview(noPickLabel)
                noPickLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
                noPickLabel.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
            }
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var wrapperView: UIView = {
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
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var scrollTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var scrollBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var noPickLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.text = "아직 등록된 픽이 없습니다"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Cnt
    lazy var cntContainerView: UIView = {
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
        } else {
            commentCntImageView.tintColor = .systemGray
            commentCntLabel.textColor = .systemGray
        }
    }
    
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(wrapperView)
        wrapperView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_L).isActive = true
        wrapperView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        wrapperView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -SPACE_S).isActive = true

        wrapperView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: SPACE_L).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -SPACE_L).isActive = true

        wrapperView.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: SPACE_L).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -SPACE_L).isActive = true
        
        wrapperView.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: SPACE_L).isActive = true
        scrollView.widthAnchor.constraint(equalTo: wrapperView.widthAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: slideHeight).isActive = true
        
        wrapperView.addSubview(scrollTopLine)
        scrollTopLine.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollTopLine.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
        scrollTopLine.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true

        wrapperView.addSubview(scrollBottomLine)
        scrollBottomLine.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollBottomLine.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
        scrollBottomLine.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Cnt
        wrapperView.addSubview(cntContainerView)
        cntContainerView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: SPACE_S).isActive = true
        cntContainerView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: SPACE_L).isActive = true
        cntContainerView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -SPACE_L).isActive = true
        cntContainerView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor).isActive = true
        
        cntContainerView.addSubview(pickCntLabel)
        pickCntLabel.trailingAnchor.constraint(equalTo: cntContainerView.trailingAnchor).isActive = true
        
        cntContainerView.addSubview(pickCntImageView)
        pickCntImageView.trailingAnchor.constraint(equalTo: pickCntLabel.leadingAnchor, constant: -SPACE_XXXXS).isActive = true
        pickCntImageView.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        pickCntImageView.widthAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        pickCntImageView.heightAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        pickCntImageView.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        
        cntContainerView.addSubview(commentCntLabel)
        commentCntLabel.trailingAnchor.constraint(equalTo: pickCntImageView.leadingAnchor, constant: -SPACE_S).isActive = true
        
        cntContainerView.addSubview(commentCntImageView)
        commentCntImageView.trailingAnchor.constraint(equalTo: commentCntLabel.leadingAnchor, constant: -SPACE_XXXXS).isActive = true
        commentCntImageView.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        commentCntImageView.widthAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        commentCntImageView.heightAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        commentCntImageView.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        
        cntContainerView.addSubview(likeCntLabel)
        likeCntLabel.trailingAnchor.constraint(equalTo: commentCntImageView.leadingAnchor, constant: -SPACE_S).isActive = true
        
        cntContainerView.addSubview(likeCntImageView)
        likeCntImageView.trailingAnchor.constraint(equalTo: likeCntLabel.leadingAnchor, constant: -SPACE_XXXXS).isActive = true
        likeCntImageView.topAnchor.constraint(equalTo: cntContainerView.topAnchor).isActive = true
        likeCntImageView.widthAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        likeCntImageView.heightAnchor.constraint(equalToConstant: ICON_WIDTH).isActive = true
        likeCntImageView.bottomAnchor.constraint(equalTo: cntContainerView.bottomAnchor).isActive = true
        
        pickCntLabel.centerYAnchor.constraint(equalTo: pickCntImageView.centerYAnchor).isActive = true
        commentCntLabel.centerYAnchor.constraint(equalTo: commentCntImageView.centerYAnchor).isActive = true
        likeCntLabel.centerYAnchor.constraint(equalTo: likeCntImageView.centerYAnchor).isActive = true
        
        cntContainerView.addSubview(categoryNameLabel)
        categoryNameLabel.centerYAnchor.constraint(equalTo: cntContainerView.centerYAnchor).isActive = true
        categoryNameLabel.leadingAnchor.constraint(equalTo: cntContainerView.leadingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        guard let place = self.place else { return }
        delegate?.openPlace(place: place)
    }
}
