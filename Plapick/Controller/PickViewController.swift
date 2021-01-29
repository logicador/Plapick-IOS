//
//  PickViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/17.
//

import UIKit


class PickViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    var pick: Pick? {
        didSet {
//            getPlaceRequest.fetch(pId: pick!.pId)
//            self.navigationItem.title = pick?.user?.nickName // pick!.uNickName
//
//            if pick?.user?.id == app.getUId() {
//                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(moreTapped))
//            }
        }
    }
//    var getPlaceRequest = GetPlaceRequest()
//    let removePickRequest = RemovePickRequest()
    var accountViewController: AccountViewController?
    
    var isZooming: Bool = false
    var originalImageCenter: CGPoint?
    
    
    // MARK: Views
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var spaceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    var placeSmallView: PlaceSmallView?
    lazy var placeTopLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var placeBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var photoView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var photoTopLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var photoBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let vev = UIVisualEffectView()
        vev.effect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        vev.alpha = 0
        vev.translatesAutoresizingMaskIntoConstraints = false
        return vev
    }()
    
    lazy var figureView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var figureLikeCntLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var figureCommentCntLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var messageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var messageTopLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var messageBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        contentView.addSubview(spaceView)
        spaceView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        spaceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        spaceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        spaceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        spaceView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        spaceView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
//        getPlaceRequest.delegate = self
//        removePickRequest.delegate = self
        
        adjustColors()
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(vc: self)
            return
        }
    }
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .systemBackground
            messageView.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .tertiarySystemGroupedBackground
            messageView.backgroundColor = .systemBackground
        }
    }
    
    @objc func moreTapped() {
        let alert = UIAlertController(title: "고객센터", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
        alert.addAction(UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.destructive, handler: { (_) in
            if !self.app.isNetworkAvailable() {
                self.app.showNetworkAlert(vc: self)
                return
            }
            
            let removeAlert = UIAlertController(title: "삭제하기", message: "정말 해당 픽을 삭제하시겠습니까? 삭제된 픽은 다시 복구하실 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
            removeAlert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel))
            removeAlert.addAction(UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: { (_) in
                let piId = self.pick?.id
//                self.removePickRequest.fetch(vc: self, piId: piId!)
            }))
            self.present(removeAlert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "수정하기", style: UIAlertAction.Style.default, handler: { (_) in
            
        }))
        present(alert, animated: true)
    }
    
    @objc func photoViewPanned(sender: UIPanGestureRecognizer) {
        
        if self.isZooming && sender.state == .began {
            if originalImageCenter == nil { originalImageCenter = photoView.center }
            if scrollView.isScrollEnabled { scrollView.isScrollEnabled = false }
            
        } else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: self.view)
            if let view = sender.view {
                view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.photoView.superview)
        }
    }
    
    @objc func photoViewPinched(sender: UIPinchGestureRecognizer) {
        
        if sender.state == .began {
            if originalImageCenter == nil { originalImageCenter = photoView.center }
            if scrollView.isScrollEnabled { scrollView.isScrollEnabled = false }
            
            let currentScale = self.photoView.frame.size.width / self.photoView.bounds.size.width
            let newScale = currentScale * sender.scale
            if newScale > 1 { self.isZooming = true }
            
        } else if sender.state == .changed {
            guard let view = sender.view else { return }
            
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX, y: sender.location(in: view).y - view.bounds.midY)
            
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y).scaledBy(x: sender.scale, y: sender.scale).translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            
            let currentScale = self.photoView.frame.size.width / self.photoView.bounds.size.width
            
            var newScale = currentScale * sender.scale
            
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.photoView.transform = transform
                sender.scale = 1
                
            } else {
                view.transform = transform
                sender.scale = 1
            }
            
            if newScale > 2.0 { blurView.alpha = 1.0 }
            else { blurView.alpha = newScale - 1.0 }
            
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let center = self.originalImageCenter else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.photoView.transform = CGAffineTransform.identity
                self.photoView.center = center
                self.blurView.alpha = 0
            }, completion: { (_) in
                self.isZooming = false
                self.scrollView.isScrollEnabled = true
            })
        }
    }
    
    @objc func photoViewTapped() {
        let photoViewController = PhotoViewController()
        photoViewController.image = photoView.image
        self.navigationController?.pushViewController(photoViewController, animated: true)
    }
    
    @objc func placeTapped() {
        print("placeTapped")
    }
    
    func configureView(place: Place) {
        guard let pick = self.pick else { return }
        spaceView.removeView()
        
//        placeSmallView = PlaceSmallView(place: place)
//        placeSmallView = PlaceSmallView()
//        placeSmallView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(placeTapped)))
        
//        photoView.image = app.getUrlImage(urlString: pick.photoUrl)
        
        messageLabel.text = pick.message
        figureLikeCntLabel.text = "좋아요 \(String(pick.likeCnt))개"
        figureCommentCntLabel.text = "댓글 \(String(pick.commentCnt))개"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoViewTapped))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(photoViewPanned(sender:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(photoViewPinched(sender:)))
        panGesture.delegate = self
        pinchGesture.delegate = self
        photoView.addGestureRecognizer(tapGesture)
        photoView.addGestureRecognizer(panGesture)
        photoView.addGestureRecognizer(pinchGesture)
        
//        contentView.addSubview(placeSmallView!)
//        placeSmallView?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        placeSmallView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        placeSmallView?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(placeTopLineView)
//        placeTopLineView.topAnchor.constraint(equalTo: placeSmallView!.topAnchor).isActive = true
        placeTopLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        placeTopLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        placeTopLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
        
        contentView.addSubview(placeBottomLineView)
//        placeBottomLineView.bottomAnchor.constraint(equalTo: placeSmallView!.bottomAnchor).isActive = true
        placeBottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        placeBottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        placeBottomLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
        
        contentView.addSubview(photoTopLineView)
//        photoTopLineView.topAnchor.constraint(equalTo: placeSmallView!.bottomAnchor, constant: 20).isActive = true
        photoTopLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        photoTopLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        photoTopLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
        
        contentView.addSubview(photoBottomLineView)
        photoBottomLineView.topAnchor.constraint(equalTo: photoTopLineView.bottomAnchor, constant: view.frame.size.width).isActive = true
        photoBottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        photoBottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        photoBottomLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
        
        contentView.addSubview(figureView)
        figureView.topAnchor.constraint(equalTo: photoBottomLineView.bottomAnchor).isActive = true
        figureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        figureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        figureView.addSubview(figureLikeCntLabel)
        figureLikeCntLabel.topAnchor.constraint(equalTo: figureView.topAnchor, constant: 10).isActive = true
        figureLikeCntLabel.leadingAnchor.constraint(equalTo: figureView.leadingAnchor, constant: 20).isActive = true
        figureLikeCntLabel.bottomAnchor.constraint(equalTo: figureView.bottomAnchor, constant: -10).isActive = true
        
        figureView.addSubview(figureCommentCntLabel)
        figureCommentCntLabel.topAnchor.constraint(equalTo: figureView.topAnchor, constant: 10).isActive = true
        figureCommentCntLabel.leadingAnchor.constraint(equalTo: figureLikeCntLabel.trailingAnchor, constant: 20).isActive = true
        figureCommentCntLabel.bottomAnchor.constraint(equalTo: figureView.bottomAnchor, constant: -10).isActive = true
        
        contentView.addSubview(messageView)
        messageView.topAnchor.constraint(equalTo: figureView.bottomAnchor).isActive = true
        messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        messageView.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 20).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -20).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10).isActive = true
        
        contentView.addSubview(messageTopLineView)
        messageTopLineView.topAnchor.constraint(equalTo: messageView.topAnchor).isActive = true
        messageTopLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        messageTopLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        messageTopLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
        
        contentView.addSubview(messageBottomLineView)
        messageBottomLineView.topAnchor.constraint(equalTo: messageView.bottomAnchor).isActive = true
        messageBottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        messageBottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        messageBottomLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
        
        contentView.addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: photoTopLineView.bottomAnchor).isActive = true
        photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: photoBottomLineView.topAnchor).isActive = true
    }
}


// MARK: Extensions
//extension PickViewController: GetPlaceRequestProtocol {
//    func response(place: Place?, status: String) {
//        if status == "OK" {
//            if let place = place {
//                configureView(place: place)
//            }
//        }
//    }
//}


//extension PickViewController: RemovePickRequestProtocol {
//    func response(status: String) {
//        if status == "OK" {
////            self.accountViewController?.getMyPicks()
//            let alert = UIAlertController(title: "픽 삭제", message: "픽이 삭제되었습니다.", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (_) in
//                self.navigationController?.popViewController(animated: true)
//            }))
//            present(alert, animated: true)
//        }
//    }
//}


extension PickViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
