//
//  PlaceViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit
import NMapsMap


protocol PlaceViewControllerProtocol {
    func addPlace()
    func likePlace()
    func addComment()
    func removeComment()
    func addPick()
}


class PlaceViewController: UIViewController {
    
    // MARK: Property
    var delegate: PlaceViewControllerProtocol?
    let app = App()
    let addPlaceRequest = AddPlaceRequest()
    let likePlaceRequest = LikePlaceRequest()
    let getPlaceRequest = GetPlaceRequest()
    let getPlaceCommentsRequest = GetPlaceCommentsRequest()
    let getPicksRequest = GetPicksRequest()
    let removeCommentRequest = RemoveCommentRequest()
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            categoryLabel.text = place.categoryName.toCategory()
            let cntMabs = NSMutableAttributedString()
                .normal("좋아요 ", size: 14, color: .systemGray)
                .bold(String(place.likeCnt), size: 14)
                .normal("  댓글 ", size: 14, color: .systemGray)
                .bold(String(place.commentCnt), size: 14)
                .normal("  픽 ", size: 14, color: .systemGray)
                .bold(String(place.pickCnt), size: 14)
            cntLabel.attributedText = cntMabs
            nameLabel.text = place.name
            
            roadAddressContainerView.isHidden = (place.roadAddress.isEmpty) ? true : false
            roadAddressLabel.text = place.roadAddress
            addressContainerView.isHidden = (place.address.isEmpty) ? true : false
            addressLabel.text = place.address
            
            if place.id == 0 {
                showIndicator(idv: indicatorView, bov: blurOverlayView)
                addPlaceRequest.fetch(vc: self, paramDict: ["kId": String(place.kId), "name": place.name, "categoryName": place.categoryName, "categoryGroupCode": place.categoryGroupCode, "categoryGroupName": place.categoryGroupName, "address": place.address, "roadAddress": place.roadAddress, "latitude": place.latitude, "longitude": place.longitude, "phone": place.phone])
            }
        }
    }
    var isLike = "N" {
        didSet {
            navigationItem.rightBarButtonItem = (isLike == "Y") ? UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(likeTapped)) : UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeTapped))
        }
    }
    var isEnded = false
    var isLoading = false
    var page = 1
    var isMapLoaded = false
    
    
    // MARK: View
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
        sv.spacing = SPACE_XL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var mapView: NMFMapView = {
        let nmv = NMFMapView()
        nmv.alpha = 0
        nmv.allowsRotating = false
        nmv.allowsTilting = false
        nmv.logoInteractionEnabled = false
        nmv.isScrollGestureEnabled = false
        nmv.isZoomGestureEnabled = false
        nmv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapTapped)))
        nmv.translatesAutoresizingMaskIntoConstraints = false
        return nmv
    }()
    lazy var mapBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Header
    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
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
        label.font = .boldSystemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Address
    lazy var addressStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var roadAddressContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var roadAddressBadgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XXXXXS
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var roadAddressBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "도로명"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var roadAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addressContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var addressBadgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XXXXXS
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var addressBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "지번"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Comment
    lazy var commentTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var commentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        label.font = .boldSystemFont(ofSize: 22)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var allCommentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("모두 보기 / 댓글 쓰기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(allCommentTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var commentStackView: UIStackView = {
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
    lazy var noCommentTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var noCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글이 없습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View- Pick
    lazy var pickTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var pickTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "게시된 픽"
        label.font = .boldSystemFont(ofSize: 22)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var postingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("게시하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(postingTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var pickStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 1
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var noPickContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noPickTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var noPickLabel: UILabel = {
        let label = UILabel()
        label.text = "게시된 픽이 없습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Indicator
    lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    lazy var blurOverlayView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let vev = UIVisualEffectView(effect: blurEffect)
        vev.alpha = 0.3
        vev.translatesAutoresizingMaskIntoConstraints = false
        return vev
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "플레이스"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        addPlaceRequest.delegate = self
        likePlaceRequest.delegate = self
        getPlaceRequest.delegate = self
        getPlaceCommentsRequest.delegate = self
        getPicksRequest.delegate = self
        
        getComments()
        getPicks()
    }
    
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPlace()
    }
    
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isMapLoaded { return }
        
        guard let place = self.place else { return }
        
        guard let latitude = Double(place.latitude) else { return }
        guard let longitude = Double(place.longitude) else { return }

        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        marker.mapView = mapView
    
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 15)
        mapView.moveCamera(cameraUpdate, completion: { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.mapView.alpha = 1
                self.isMapLoaded = true
            })
        })
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(mapView)
        mapView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(mapBottomLine)
        mapBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapBottomLine.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Header
        stackView.addArrangedSubview(headerContainerView)
        headerContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        headerContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        headerContainerView.addSubview(categoryLabel)
        categoryLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        
        headerContainerView.addSubview(cntLabel)
        cntLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor).isActive = true
        cntLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        
        headerContainerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: SPACE_S).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Address
        headerContainerView.addSubview(addressStackView)
        addressStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_S).isActive = true
        addressStackView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        addressStackView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        addressStackView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        
        addressStackView.addArrangedSubview(roadAddressContainerView)
        roadAddressContainerView.leadingAnchor.constraint(equalTo: addressStackView.leadingAnchor).isActive = true
        roadAddressContainerView.trailingAnchor.constraint(equalTo: addressStackView.trailingAnchor).isActive = true
        
        roadAddressContainerView.addSubview(roadAddressBadgeView)
        roadAddressBadgeView.topAnchor.constraint(equalTo: roadAddressContainerView.topAnchor).isActive = true
        roadAddressBadgeView.leadingAnchor.constraint(equalTo: roadAddressContainerView.leadingAnchor).isActive = true
        roadAddressBadgeView.bottomAnchor.constraint(equalTo: roadAddressContainerView.bottomAnchor).isActive = true
        
        roadAddressBadgeView.addSubview(roadAddressBadgeLabel)
        roadAddressBadgeLabel.topAnchor.constraint(equalTo: roadAddressBadgeView.topAnchor, constant: SPACE_XXXXXS).isActive = true
        roadAddressBadgeLabel.leadingAnchor.constraint(equalTo: roadAddressBadgeView.leadingAnchor, constant: SPACE_XS).isActive = true
        roadAddressBadgeLabel.trailingAnchor.constraint(equalTo: roadAddressBadgeView.trailingAnchor, constant: -SPACE_XS).isActive = true
        roadAddressBadgeLabel.bottomAnchor.constraint(equalTo: roadAddressBadgeView.bottomAnchor, constant: -SPACE_XXXXXS).isActive = true
        
        roadAddressContainerView.addSubview(roadAddressLabel)
        roadAddressLabel.centerYAnchor.constraint(equalTo: roadAddressBadgeView.centerYAnchor).isActive = true
        roadAddressLabel.leadingAnchor.constraint(equalTo: roadAddressBadgeView.trailingAnchor, constant: SPACE_XS).isActive = true
        
        addressStackView.addArrangedSubview(addressContainerView)
        addressContainerView.leadingAnchor.constraint(equalTo: addressStackView.leadingAnchor).isActive = true
        addressContainerView.trailingAnchor.constraint(equalTo: addressStackView.trailingAnchor).isActive = true
        
        addressContainerView.addSubview(addressBadgeView)
        addressBadgeView.topAnchor.constraint(equalTo: addressContainerView.topAnchor).isActive = true
        addressBadgeView.leadingAnchor.constraint(equalTo: addressContainerView.leadingAnchor).isActive = true
        addressBadgeView.bottomAnchor.constraint(equalTo: addressContainerView.bottomAnchor).isActive = true
        
        addressBadgeView.addSubview(addressBadgeLabel)
        addressBadgeLabel.topAnchor.constraint(equalTo: addressBadgeView.topAnchor, constant: SPACE_XXXXXS).isActive = true
        addressBadgeLabel.leadingAnchor.constraint(equalTo: addressBadgeView.leadingAnchor, constant: SPACE_XS).isActive = true
        addressBadgeLabel.trailingAnchor.constraint(equalTo: addressBadgeView.trailingAnchor, constant: -SPACE_XS).isActive = true
        addressBadgeLabel.bottomAnchor.constraint(equalTo: addressBadgeView.bottomAnchor, constant: -SPACE_XXXXXS).isActive = true
        
        addressContainerView.addSubview(addressLabel)
        addressLabel.centerYAnchor.constraint(equalTo: addressBadgeView.centerYAnchor).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: addressBadgeView.trailingAnchor, constant: SPACE_XS).isActive = true
        
        // MARK: ConfigureView - Comment
        stackView.addArrangedSubview(commentTopLine)
        commentTopLine.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        commentTopLine.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(commentTitleLabel)
        commentTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        commentTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        commentTitleLabel.addSubview(allCommentButton)
        allCommentButton.centerYAnchor.constraint(equalTo: commentTitleLabel.centerYAnchor).isActive = true
        allCommentButton.trailingAnchor.constraint(equalTo: commentTitleLabel.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(commentStackView)
        commentStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        commentStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        commentStackView.addArrangedSubview(noCommentContainerView)
        noCommentContainerView.leadingAnchor.constraint(equalTo: commentStackView.leadingAnchor).isActive = true
        noCommentContainerView.trailingAnchor.constraint(equalTo: commentStackView.trailingAnchor).isActive = true
        
        noCommentContainerView.addSubview(noCommentTopLine)
        noCommentTopLine.topAnchor.constraint(equalTo: noCommentContainerView.topAnchor).isActive = true
        noCommentTopLine.leadingAnchor.constraint(equalTo: noCommentContainerView.leadingAnchor).isActive = true
        noCommentTopLine.trailingAnchor.constraint(equalTo: noCommentContainerView.trailingAnchor).isActive = true
        
        noCommentContainerView.addSubview(noCommentLabel)
        noCommentLabel.topAnchor.constraint(equalTo: noCommentTopLine.bottomAnchor, constant: SPACE_XL).isActive = true
        noCommentLabel.centerXAnchor.constraint(equalTo: noCommentContainerView.centerXAnchor).isActive = true
        noCommentLabel.bottomAnchor.constraint(equalTo: noCommentContainerView.bottomAnchor, constant: -SPACE_XL).isActive = true
        
        // MARK: ConfigureView - Pick
        stackView.addArrangedSubview(pickTopLine)
        pickTopLine.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        pickTopLine.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(pickTitleLabel)
        pickTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        pickTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        pickTitleLabel.addSubview(postingButton)
        postingButton.centerYAnchor.constraint(equalTo: pickTitleLabel.centerYAnchor).isActive = true
        postingButton.trailingAnchor.constraint(equalTo: pickTitleLabel.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(pickStackView)
        pickStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        pickStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        pickStackView.addArrangedSubview(noPickContainerView)
        noPickContainerView.centerXAnchor.constraint(equalTo: pickStackView.centerXAnchor).isActive = true
        noPickContainerView.widthAnchor.constraint(equalTo: pickStackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        noPickContainerView.addSubview(noPickTopLine)
        noPickTopLine.topAnchor.constraint(equalTo: noPickContainerView.topAnchor).isActive = true
        noPickTopLine.leadingAnchor.constraint(equalTo: noPickContainerView.leadingAnchor).isActive = true
        noPickTopLine.trailingAnchor.constraint(equalTo: noPickContainerView.trailingAnchor).isActive = true
        
        noPickContainerView.addSubview(noPickLabel)
        noPickLabel.topAnchor.constraint(equalTo: noPickTopLine.bottomAnchor, constant: SPACE_XL).isActive = true
        noPickLabel.centerXAnchor.constraint(equalTo: noPickContainerView.centerXAnchor).isActive = true
        noPickLabel.bottomAnchor.constraint(equalTo: noPickContainerView.bottomAnchor, constant: -SPACE_XL).isActive = true
    }
    
    func getPlace() {
        guard let place = self.place else { return }
        if place.id == 0 { return } // 등록되지 않은 플레이스 > 등록 후 getPlace() 따로 호출할거임
        getPlaceRequest.fetch(vc: self, paramDict: ["pId": String(place.id)])
    }
    
    func getPicks() {
        guard let place = self.place else { return }
        if place.id == 0 { return }
        isLoading = true
        getPicksRequest.fetch(vc: self, paramDict: ["order": "POPULAR", "pId": String(place.id), "page": String(page), "limit": "30"])
    }
    
    func getComments() {
        guard let place = self.place else { return }
        if place.id == 0 { return }
        getPlaceCommentsRequest.fetch(vc: self, paramDict: ["pId": String(place.id), "page": "1", "limit": "2"])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isLoading && !isEnded {
                page += 1
                getPicks()
            }
        }
    }
    
    // MARK: Function - @OBJC
    @objc func likeTapped() {
        guard let place = self.place else { return }
        likePlaceRequest.fetch(vc: self, paramDict: ["pId": String(place.id)])
    }
    
    @objc func mapTapped() {
        guard let place = self.place else { return }
        
        let placeMapVC = PlaceMapViewController()
        placeMapVC.place = place
        navigationController?.pushViewController(placeMapVC, animated: true)
    }
    
    @objc func allCommentTapped() {
        guard let place = self.place else { return }
        
        let placeCommentVC = PlaceCommentViewController()
        placeCommentVC.place = place
        placeCommentVC.delegate = self
        navigationController?.pushViewController(placeCommentVC, animated: true)
    }
    
    @objc func postingTapped() {
        guard let place = self.place else { return }
        
        let postingVC = PostingViewController()
        postingVC.selectedPlace = place
        postingVC.searchPlaceButton.isHidden = true
        postingVC.delegate = self
        navigationController?.pushViewController(postingVC, animated: true)
    }
}


// MARK: HTTP - AddPlace
extension PlaceViewController: AddPlaceRequestProtocol {
    func response(place: Place?, addPlace status: String) {
        print("[HTTP RES]", addPlaceRequest.apiUrl, status)
        
        if status == "OK" {
            guard let place = place else { return }
            self.place = place
            
            isLike = place.isLike
            app.addRecentPlace(place: place)
            
            delegate?.addPlace()
        }
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}

// MARK: HTTP - LikePlace
extension PlaceViewController: LikePlaceRequestProtocol {
    func response(likePlace status: String) {
        print("[HTTP RES]", likePlaceRequest.apiUrl, status)
        
        if status == "OK" {
            isLike = (isLike == "Y") ? "N" : "Y"
            place?.isLike = isLike

            delegate?.likePlace()
            getPlace()
        }
    }
}

// MARK: HTTP - GetPlace
extension PlaceViewController: GetPlaceRequestProtocol {
    func response(place: Place?, getPlace status: String) {
        print("[HTTP RES]", getPlaceRequest.apiUrl, status)
        
        if status == "OK" {
            guard let place = place else { return }
            self.place = place
            
            isLike = place.isLike
            app.addRecentPlace(place: place)
        }
    }
}

// MARK: HTTP - GetPlaceComments
extension PlaceViewController: GetPlaceCommentsRequestProtocol {
    func response(placeCommentList: [PlaceComment]?, getPlaceComments status: String) {
        print("[HTTP RES]", getPlaceCommentsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let placeCommentList = placeCommentList else { return }
            
            if placeCommentList.count > 0 {
                noCommentContainerView.isHidden = true
                for placeComment in placeCommentList {
                    let cv = CommentView()
                    cv.id = placeComment.id
                    cv.date = placeComment.createdDate
                    cv.comment = placeComment.comment
                    cv.user = placeComment.user
                    cv.removeButton.isHidden = true
                    cv.delegate = self
                    
                    commentStackView.addArrangedSubview(cv)
                    cv.leadingAnchor.constraint(equalTo: commentStackView.leadingAnchor).isActive = true
                    cv.trailingAnchor.constraint(equalTo: commentStackView.trailingAnchor).isActive = true
                }
            } else { if commentStackView.subviews.count == 1 { noCommentContainerView.isHidden = false } }
        }
    }
}

// MARK: HTTP - GetPicks
extension PlaceViewController: GetPicksRequestProtocol {
    func response(pickList: [Pick]?, getPicks status: String) {
        print("[HTTP RES]", getPicksRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pickList = pickList else { return }
            
            if pickList.count > 0 {
                isEnded = false
                noPickContainerView.isHidden = true
                
                var _pickList: [Pick] = []
                for (i, pick) in pickList.enumerated() {
                    _pickList.append(pick)
                    if ((i + 1) % 3 == 0 || ((i + 1) == pickList.count && _pickList.count > 0)) {
                        let pgv = PhotoGroupView(direction: ((i + 1) == pickList.count && _pickList.count > 0) ? 0 : .random(in: 0...2))
                        pgv.vc = self
                        pgv.pickList = _pickList
                        pgv.delegate = self
                        
                        pickStackView.addArrangedSubview(pgv)
                        pgv.leadingAnchor.constraint(equalTo: pickStackView.leadingAnchor).isActive = true
                        pgv.trailingAnchor.constraint(equalTo: pickStackView.trailingAnchor).isActive = true
                        _pickList.removeAll()
                    }
                }
                
            } else {
                isEnded = true
                if pickStackView.subviews.count == 1 { noPickContainerView.isHidden = false }
            }
        }
        isLoading = false
    }
}

// MARK: CommentView
extension PlaceViewController: CommentViewProtocol {
    func detailUser(user: User) {
        let accountVC = AccountViewController()
        accountVC.user = user
        navigationController?.pushViewController(accountVC, animated: true)
    }
    
    func removeComment(id: Int) { }
}

// MARK: PhotoGroupView
extension PlaceViewController: PhotoGroupViewProtocol {
    func detailPick(pick: Pick) {
        guard let place = self.place else { return }
        
        let pickVC = PickViewController()
        pickVC.navigationItem.title = place.name
//        pickVC.placeContainerView.isHidden = true
//        pickVC.placeView.isHidden = true
//        pickVC.placeTopLine.isHidden = true
        pickVC.order = "POPULAR"
        pickVC.pId = place.id
        pickVC.id = pick.id
        navigationController?.pushViewController(pickVC, animated: true)
    }
}

// MARK: placeCommentVC
extension PlaceViewController: PlaceCommentViewControllerProtocol {
    func addComment() {
        delegate?.addComment()
    }
    
    func removeComment() {
        delegate?.removeComment()
    }
}

// MARK: PostingVC
extension PlaceViewController: PostingViewControllerProtocol {
    func addPick() {
        delegate?.addPick()
    }
}
