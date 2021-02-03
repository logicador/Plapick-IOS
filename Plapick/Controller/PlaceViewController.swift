//
//  PlaceViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit
import NMapsMap


protocol PlaceViewControllerProtocol {
    func closePlaceVC()
    func reloadPlace()
}


class PlaceViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var delegate: PlaceViewControllerProtocol?
    var isOpenedChildVC: Bool = false
    var isFetchingRequest: Bool = false // 플레이스 호출전 좋아요 누름 방지
    let addPlaceRequest = AddPlaceRequest()
    let likePlaceRequest = LikePlaceRequest()
    let getPlaceRequest = GetPlaceRequest()
    let getPicksRequest = GetPicksRequest()
    let getCommentsRequest = GetCommentsRequest()
    let removeCommentRequest = RemoveCommentRequest()
    var place: Place?
    
    
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
    
    lazy var categoryBadgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XXS
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var categoryBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .link
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var categoryBadgeTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var mapView: NMFMapView = {
        let nmv = NMFMapView()
        nmv.allowsRotating = false
        nmv.allowsTilting = false
        nmv.logoInteractionEnabled = false
        nmv.isScrollGestureEnabled = false
        nmv.isZoomGestureEnabled = false
        nmv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapTapped)))
        nmv.translatesAutoresizingMaskIntoConstraints = false
        return nmv
    }()
    
    // MARK: View - Address
    lazy var addressContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var roadAddressBadgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XXS
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var roadAddressBadgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .link
        label.text = "도로명"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var roadAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addressBadgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XXS
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var addressBadgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .link
        label.text = "지번"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addressBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Comment
    lazy var commentTitleView: TitleView = {
        let tv = TitleView(text: "댓글", style: .large, isAction: true, actionText: "모두 보기", actionMode: "ALL_PLACE_COMMENT")
        tv.delegate = self
        return tv
    }()
    lazy var commentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noCommentContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "등록된 댓글이 없습니다."
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Pick
    lazy var pickTitleView: TitleView = {
        let tv = TitleView(text: "게시된 픽", style: .large, isAction: true, actionText: "새로운 픽", actionMode: "ADD_PICK")
        tv.delegate = self
        return tv
    }()
    lazy var pickContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noPickContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var noPickLabel: UILabel = {
        let label = UILabel()
        label.text = "등록된 픽이 없습니다."
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
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
    
    
    // MARK: Init
    init(place: Place) {
        super.init(nibName: nil, bundle: nil)
        self.place = place
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        addPlaceRequest.delegate = self
        likePlaceRequest.delegate = self
        getPlaceRequest.delegate = self
        getPicksRequest.delegate = self
        getCommentsRequest.delegate = self
        removeCommentRequest.delegate = self
        
        guard let place = self.place else { return }
        
        // save userdefaults
        app.addRecentPlace(place: place)
        
        // 변하지 않는 값
        navigationItem.title = place.name
        
        // 변하지 않는 값
        categoryBadgeLabel.text = place.categoryName.replacingOccurrences(of: ">", with: "-")
        roadAddressLabel.text = place.roadAddress
        addressLabel.text = place.address
        
        // getPlace() 호출후 변할 수 있음
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "0", style: UIBarButtonItem.Style.plain, target: self, action: #selector(likePlaceTapped)),
            UIBarButtonItem(image: UIImage(systemName: "heart"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(likePlaceTapped))
        ]
        commentTitleView.label.text = "댓글 \(place.commentCnt)개"
        pickTitleView.label.text = "게시된 픽 \(place.pickCnt)개"
        
        isFetchingRequest = true
        if place.id == 0 { // 등록되지 않은 플레이스 > 등록
            showIndicator(idv: indicatorView, bov: blurOverlayView)
            addPlaceRequest.fetch(vc: self, paramDict: ["kId": String(place.kId), "name": place.name, "categoryName": place.categoryName, "categoryGroupCode": place.categoryGroupCode, "categoryGroupName": place.categoryGroupName, "address": place.address, "roadAddress": place.roadAddress, "latitude": place.latitude, "longitude": place.longitude, "phone": place.phone])
        }
        
        guard let lat = Double(place.latitude) else { return }
        guard let lng = Double(place.longitude) else { return }
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.mapView = mapView
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: 15)
        DispatchQueue.main.async {
            self.mapView.moveCamera(cameraUpdate)
        }
    }
    
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let place = self.place else { return }
        navigationItem.title = place.name
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getPlace()
        getComments()
        getPicks()
    }
    
    
    // MARK: ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    // MARK: ViewDidDisapear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isOpenedChildVC {
            delegate?.closePlaceVC()
        }
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setThemeColor()
    }
    func setThemeColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        contentView.addSubview(categoryBadgeTopLine)
        categoryBadgeTopLine.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SPACE_XL).isActive = true
        categoryBadgeTopLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        categoryBadgeTopLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(categoryBadgeView)
        categoryBadgeView.topAnchor.constraint(equalTo: categoryBadgeTopLine.bottomAnchor, constant: SPACE_S).isActive = true
        categoryBadgeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(SCREEN_WIDTH * ((1 - CONTENTS_RATIO) / 2))).isActive = true
        
        categoryBadgeView.addSubview(categoryBadgeLabel)
        categoryBadgeLabel.topAnchor.constraint(equalTo: categoryBadgeView.topAnchor, constant: SPACE_XXXS).isActive = true
        categoryBadgeLabel.leadingAnchor.constraint(equalTo: categoryBadgeView.leadingAnchor, constant: SPACE_XS).isActive = true
        categoryBadgeLabel.trailingAnchor.constraint(equalTo: categoryBadgeView.trailingAnchor, constant: -SPACE_XS).isActive = true
        categoryBadgeLabel.bottomAnchor.constraint(equalTo: categoryBadgeView.bottomAnchor, constant: -SPACE_XXXS).isActive = true
        
        contentView.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: categoryBadgeView.bottomAnchor, constant: SPACE_S).isActive = true
        mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH / 2).isActive = true
        
        // MARK: ConfigureView - Address
        contentView.addSubview(addressContainerView)
        addressContainerView.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        addressContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        addressContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        addressContainerView.addSubview(roadAddressBadgeView)
        roadAddressBadgeView.topAnchor.constraint(equalTo: addressContainerView.topAnchor, constant: SPACE_S).isActive = true
        roadAddressBadgeView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        roadAddressBadgeView.leadingAnchor.constraint(equalTo: addressContainerView.leadingAnchor).isActive = true
    
        roadAddressBadgeView.addSubview(roadAddressBadgeLabel)
        roadAddressBadgeLabel.topAnchor.constraint(equalTo: roadAddressBadgeView.topAnchor, constant: SPACE_XXXS).isActive = true
        roadAddressBadgeLabel.centerXAnchor.constraint(equalTo: roadAddressBadgeView.centerXAnchor).isActive = true
        roadAddressBadgeLabel.bottomAnchor.constraint(equalTo: roadAddressBadgeView.bottomAnchor, constant: -SPACE_XXXS).isActive = true
        
        addressContainerView.addSubview(addressBadgeView)
        addressBadgeView.topAnchor.constraint(equalTo: roadAddressBadgeView.bottomAnchor, constant: SPACE_XXS).isActive = true
        addressBadgeView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addressBadgeView.leadingAnchor.constraint(equalTo: addressContainerView.leadingAnchor).isActive = true
        addressBadgeView.bottomAnchor.constraint(equalTo: addressContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
    
        addressBadgeView.addSubview(addressBadgeLabel)
        addressBadgeLabel.topAnchor.constraint(equalTo: addressBadgeView.topAnchor, constant: SPACE_XXXS).isActive = true
        addressBadgeLabel.centerXAnchor.constraint(equalTo: addressBadgeView.centerXAnchor).isActive = true
        addressBadgeLabel.bottomAnchor.constraint(equalTo: addressBadgeView.bottomAnchor, constant: -SPACE_XXXS).isActive = true
        
        addressContainerView.addSubview(roadAddressLabel)
        roadAddressLabel.leadingAnchor.constraint(equalTo: roadAddressBadgeView.trailingAnchor, constant: SPACE_XS).isActive = true
        roadAddressLabel.centerYAnchor.constraint(equalTo: roadAddressBadgeView.centerYAnchor).isActive = true
        roadAddressLabel.trailingAnchor.constraint(equalTo: addressContainerView.trailingAnchor).isActive = true
        
        addressContainerView.addSubview(addressLabel)
        addressLabel.leadingAnchor.constraint(equalTo: addressBadgeView.trailingAnchor, constant: SPACE_XS).isActive = true
        addressLabel.centerYAnchor.constraint(equalTo: addressBadgeView.centerYAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: addressContainerView.trailingAnchor).isActive = true
        
        contentView.addSubview(addressBottomLine)
        addressBottomLine.topAnchor.constraint(equalTo: addressContainerView.bottomAnchor).isActive = true
        addressBottomLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        addressBottomLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Comment
        contentView.addSubview(commentTitleView)
        commentTitleView.topAnchor.constraint(equalTo: addressBottomLine.bottomAnchor).isActive = true
        commentTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        commentTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(commentContainerView)
        commentContainerView.topAnchor.constraint(equalTo: commentTitleView.bottomAnchor).isActive = true
        commentContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        commentContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Pick
        contentView.addSubview(pickTitleView)
        pickTitleView.topAnchor.constraint(equalTo: commentContainerView.bottomAnchor).isActive = true
        pickTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pickTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(pickContainerView)
        pickContainerView.topAnchor.constraint(equalTo: pickTitleView.bottomAnchor).isActive = true
        pickContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pickContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pickContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.addSubview(noPickContainerView)
        noPickContainerView.topAnchor.constraint(equalTo: pickTitleView.bottomAnchor).isActive = true
        noPickContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        noPickContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        noPickContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        noPickContainerView.addSubview(noPickLabel)
        noPickLabel.topAnchor.constraint(equalTo: noPickContainerView.topAnchor, constant: NO_DATA_SPACE).isActive = true
        noPickLabel.centerXAnchor.constraint(equalTo: noPickContainerView.centerXAnchor).isActive = true
        noPickLabel.bottomAnchor.constraint(equalTo: noPickContainerView.bottomAnchor, constant: -NO_DATA_SPACE).isActive = true
    }
    
    func setNoCommentView() {
        commentContainerView.addSubview(noCommentContainerView)
        noCommentContainerView.topAnchor.constraint(equalTo: commentContainerView.topAnchor).isActive = true
        noCommentContainerView.centerXAnchor.constraint(equalTo: commentContainerView.centerXAnchor).isActive = true
        noCommentContainerView.widthAnchor.constraint(equalTo: commentContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        noCommentContainerView.bottomAnchor.constraint(equalTo: commentContainerView.bottomAnchor).isActive = true

        noCommentContainerView.addSubview(noCommentLabel)
        noCommentLabel.topAnchor.constraint(equalTo: noCommentContainerView.topAnchor, constant: NO_DATA_SPACE).isActive = true
        noCommentLabel.centerXAnchor.constraint(equalTo: noCommentContainerView.centerXAnchor).isActive = true
        noCommentLabel.bottomAnchor.constraint(equalTo: noCommentContainerView.bottomAnchor, constant: -NO_DATA_SPACE).isActive = true
    }
    
    func getPlace() {
        guard let place = self.place else { return }
        if place.id == 0 { return } // 등록되지 않은 플레이스 > 등록 후 getPlace() 따로 호출할거임
        getPlaceRequest.fetch(vc: self, paramDict: ["pId": String(place.id)])
    }
    
    func getPicks() {
        guard let place = self.place else { return }
        if place.id == 0 { // 등록되지 않은 플레이스
            noPickContainerView.isHidden = false
            return
        }
        getPicksRequest.fetch(vc: self, paramDict: ["pId": String(place.id)])
    }
    
    func getComments() {
        guard let place = self.place else { return }
        if place.id == 0 { // 등록되지 않은 플레이스
            setNoCommentView()
            return
        }
        getCommentsRequest.fetch(vc: self, paramDict: ["mode": "PLACE", "limit": "2", "id": String(place.id)])
    }
    
    // MARK: Function - @OBJC
    @objc func likePlaceTapped() {
        if isFetchingRequest { return }
        guard let place = self.place else { return }
        isFetchingRequest = true
        
        let isLike = place.isLike ?? "N"
        
        self.place?.isLike = (isLike == "N") ? "Y" : "N"
        
        var cnt = place.likeCnt
        if isLike == "N" { cnt += 1 }
        else { cnt -= 1 }
        
        self.place?.likeCnt = cnt
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: String(cnt), style: UIBarButtonItem.Style.plain, target: self, action: #selector(likePlaceTapped)),
            UIBarButtonItem(image: UIImage(systemName: ((place.isLike ?? "N") == "N") ? "heart.fill" : "heart"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(likePlaceTapped))
        ]
        
        likePlaceRequest.fetch(vc: self, paramDict: ["pId": String(place.id)])
    }
    
    @objc func mapTapped() {
        guard let place = self.place else { return }
        
        isOpenedChildVC = true
        let placeMapVC = PlaceMapViewController(latitude: place.latitude, longitude: place.longitude)
        placeMapVC.navigationItem.title = place.name
        placeMapVC.delegate = self
        navigationController?.pushViewController(placeMapVC, animated: true)
    }
}


// MARK: MapVC
extension PlaceViewController: PlaceMapViewControllerProtocol {
    func closePlaceMapVC() {
        isOpenedChildVC = false
    }
}

// MARK: PostingVC
extension PlaceViewController: PostingViewControllerProtocol {
    func closePostingVC(isUploaded: Bool) {
        isOpenedChildVC = false
        if isUploaded { delegate?.reloadPlace() } // 플레이스 상태가 변했으므로 재호출 시그널 (픽 업로드)
    }
}

// MARK: CommentVC
extension PlaceViewController: CommentViewControllerProtocol {
    func closeCommentVC() {
        isOpenedChildVC = false
    }
    
    func reloadComment() {
        delegate?.reloadPlace()
    }
}


// MARK: TitleView
extension PlaceViewController: TitleViewProtocol {
    func action(actionMode: String) {
        isOpenedChildVC = true
        guard let place = self.place else { return }
        
        if actionMode == "ALL_PLACE_COMMENT" {
            let commentVC = CommentViewController(mode: "PLACE", id: place.id)
            commentVC.delegate = self
            navigationController?.pushViewController(commentVC, animated: true)
            
        } else if actionMode == "ADD_PICK" {
            let postingVC = PostingViewController()
            postingVC.selectedPlace = place
            postingVC.delegate = self
            navigationController?.pushViewController(postingVC, animated: true)
        }
    }
}

// MARK: CommentView
extension PlaceViewController: CommentViewProtocol {
    func openUser(uId: Int) {
        present(UINavigationController(rootViewController: AccountViewController(uId: uId)), animated: true, completion: nil)
    }
    
    func removeComment(comment: Comment) {
        if comment.uId != app.getUId() { return }
        let alert = UIAlertController(title: "댓글 삭제", message: "작성하신 댓글을 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: { (_) in
            self.removeCommentRequest.fetch(vc: self, paramDict: ["mode": "PLACE", "id": String(comment.id)])
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: PhotoGroupView
extension PlaceViewController: PhotoGroupViewProtocol {
    func openPick(pick: Pick) {
        print("openPick", pick.id)
    }
}


// MARK: HTTP - AddPlace
extension PlaceViewController: AddPlaceRequestProtocol {
    func response(place: Place?, addPlace status: String) {
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
        
        if status == "OK" {
            guard let place = place else { return }
            self.place = place
            getPlace()
            delegate?.reloadPlace() // 플레이스 상태가 변했으므로 재호출 시그널 (추가)
        }
    }
}

// MARK: HTTP - LikePlace
extension PlaceViewController: LikePlaceRequestProtocol {
    func response(likePlace status: String) {
        isFetchingRequest = false
        if status == "OK" {
            delegate?.reloadPlace() // 플레이스 상태가 변했으므로 재호출 시그널 (좋아요)
        }
    }
}

// MARK: HTTP - GetPicks
extension PlaceViewController: GetPicksRequestProtocol {
    func response(pickList: [Pick]?, getPicks status: String) {
        if status == "OK" {
            guard let pickList = pickList else { return }
            pickContainerView.removeAllChildView()
            
            if pickList.count > 0 {
                noPickContainerView.isHidden = true
                var _pickList: [Pick] = []
                for (i, pick) in pickList.enumerated() {
                    let index = i + 1
                    _pickList.append(pick)
                    
                    if _pickList.count == 3 { // 3개가 쌓였을때
                        let pgv = PhotoGroupView()
                        pgv.pickList = _pickList
                        pgv.delegate = self

                        pickContainerView.addSubview(pgv)
                        pgv.leadingAnchor.constraint(equalTo: pickContainerView.leadingAnchor).isActive = true
                        pgv.trailingAnchor.constraint(equalTo: pickContainerView.trailingAnchor).isActive = true
                        
                        if index / 3 == 1 { // 첫번째 pgv
                            pgv.topAnchor.constraint(equalTo: pickContainerView.topAnchor).isActive = true
                        } else { // 그 이후 pgv
                            pgv.topAnchor.constraint(equalTo: pickContainerView.subviews[pickContainerView.subviews.count - 2].bottomAnchor, constant: 1).isActive = true
                        }
                        
                        _pickList = []
                    }
                    
                    if index == pickList.count { // 마지막 픽
                        if _pickList.count > 0 { // 쌓아둔 픽이 있다면
                            let pgv = PhotoGroupView()
                            pgv.pickList = _pickList
                            pgv.delegate = self
                            pickContainerView.addSubview(pgv)
                            pgv.leadingAnchor.constraint(equalTo: pickContainerView.leadingAnchor).isActive = true
                            pgv.trailingAnchor.constraint(equalTo: pickContainerView.trailingAnchor).isActive = true
                            
                            if pickContainerView.subviews.count == 1 { // 첫번째 pgv
                                pgv.topAnchor.constraint(equalTo: pickContainerView.topAnchor, constant: 1).isActive = true
                            } else {
                                pgv.topAnchor.constraint(equalTo: pickContainerView.subviews[pickContainerView.subviews.count - 2].bottomAnchor, constant: 1).isActive = true
                            }
                            
                            pgv.bottomAnchor.constraint(equalTo: pickContainerView.bottomAnchor).isActive = true
                            
                        } else { // 없다면 마지막 pgv bottom cons 잡아주기
                            pickContainerView.subviews[pickContainerView.subviews.count - 1].bottomAnchor.constraint(equalTo: pickContainerView.bottomAnchor).isActive = true
                        }
                    }
                }
                
            } else {
                noPickContainerView.isHidden = false
            }
        }
    }
}

// MARK: HTTP - GetComments
extension PlaceViewController: GetCommentsRequestProtocol {
    func response(commentList: [Comment]?, getComments status: String) {
        if status == "OK" {
            guard let commentList = commentList else { return }
            commentContainerView.removeAllChildView()
            
            if commentList.count > 0 {
                for (i, comment) in commentList.enumerated() {
                    let cv = CommentView()
                    cv.comment = comment
                    cv.delegate = self
                    
                    commentContainerView.addSubview(cv)
                    
                    cv.widthAnchor.constraint(equalTo: commentContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
                    cv.centerXAnchor.constraint(equalTo: commentContainerView.centerXAnchor).isActive = true
                    
                    if i == 0 {
                        cv.topAnchor.constraint(equalTo: commentContainerView.topAnchor).isActive = true
                    } else {
                        cv.topAnchor.constraint(equalTo: commentContainerView.subviews[commentContainerView.subviews.count - 2].bottomAnchor, constant: SPACE_S).isActive = true
                    }
                    if i == commentList.count - 1 {
                        cv.bottomAnchor.constraint(equalTo: commentContainerView.bottomAnchor).isActive = true
                    }
                }
                
            } else {
                setNoCommentView()
            }
        }
    }
}

// MARK: HTTP - GetPlace
extension PlaceViewController: GetPlaceRequestProtocol {
    func response(place: Place?, getPlace status: String) {
        isFetchingRequest = false
        
        if status == "OK" {
            guard let place = place else { return }
            self.place = place

            let isLike = place.isLike ?? "N"
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: String(place.likeCnt), style: UIBarButtonItem.Style.plain, target: self, action: #selector(likePlaceTapped)),
                UIBarButtonItem(image: UIImage(systemName: (isLike == "Y") ? "heart.fill" : "heart"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(likePlaceTapped))
            ]
            commentTitleView.label.text = "댓글 \(place.commentCnt)개"
            pickTitleView.label.text = "게시된 픽 \(place.pickCnt)개"
        }
    }
}

// MARK: HTTP - RemoveComment
extension PlaceViewController: RemoveCommentRequestProtocol {
    func response(removeComment status: String) {
        if status == "OK" {
            getPlace()
            getComments()
        }
    }
}
