//
//  PlaceHeaderCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/04/01.
//

import UIKit
import NMapsMap


protocol PlaceHeaderCVCellProtocol {
    func like()
    func selectMap()
    func selectComment()
}


class PlaceHeaderCVCell: UICollectionReusableView {
    
    // MARK: Property
    var delegate: PlaceHeaderCVCellProtocol?
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            guard let latitude = Double(place.p_latitude) else { return }
            guard let longitude = Double(place.p_longitude) else { return }
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 15)
            mapView.moveCamera(cameraUpdate, completion: { (_) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.mapView.alpha = 1
                    
                }, completion: { (_) in
                    self.marker?.mapView = nil
                    self.marker = nil
                    
                    self.marker = NMFMarker()
                    self.marker?.position = NMGLatLng(lat: latitude, lng: longitude)
                    self.marker?.mapView = self.mapView
                })
            })
            
            categoryLabel.text = place.p_category_name.replacingOccurrences(of: ">", with: "-")
            addressLabel.text = (place.p_road_address.isEmpty) ? place.p_address : place.p_road_address
            
            postsCntLabel.text = "등록된 게시물 \(place.p_posts_cnt)개"
            
            likeCntImageView.image = (place.p_is_like == "Y") ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            likeCntImageView.tintColor = (place.p_is_like == "Y") ? .systemRed : (traitCollection.userInterfaceStyle == .dark) ? .white : .black
            likeCntLabel.text = String(place.p_like_cnt)
            
            commentCntLabel.text = String(place.p_comment_cnt)
        }
    }
    var marker: NMFMarker?
    
    
    // MARK: View
    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var postsCntLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Comment
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
    
    // MARK: View - Like
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
    
    // MARK: View - Other
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
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        
        setThemeColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        commentCntImageView.tintColor = (traitCollection.userInterfaceStyle == .dark) ? .white : .black
        
        guard let place = self.place else { return }
        likeCntImageView.tintColor = (place.p_is_like == "Y") ? .systemRed : (traitCollection.userInterfaceStyle == .dark) ? .white : .black
    }
    
    func configureView() {
        addSubview(headerContainerView)
        headerContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headerContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        headerContainerView.addSubview(postsCntLabel)
        postsCntLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 12).isActive = true
        postsCntLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        postsCntLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        postsCntLabel.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -12).isActive = true
        
        // MARK: Configure - Comment
        headerContainerView.addSubview(commentCntContainerView)
        commentCntContainerView.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        commentCntContainerView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        commentCntContainerView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true

        commentCntContainerView.addSubview(commentCntImageView)
        commentCntImageView.centerYAnchor.constraint(equalTo: postsCntLabel.centerYAnchor).isActive = true
        commentCntImageView.leadingAnchor.constraint(equalTo: commentCntContainerView.leadingAnchor).isActive = true
        commentCntImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        commentCntImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        commentCntContainerView.addSubview(commentCntLabel)
        commentCntLabel.centerYAnchor.constraint(equalTo: postsCntLabel.centerYAnchor).isActive = true
        commentCntLabel.leadingAnchor.constraint(equalTo: commentCntImageView.trailingAnchor, constant: 4).isActive = true
        commentCntLabel.trailingAnchor.constraint(equalTo: commentCntContainerView.trailingAnchor).isActive = true

        // MARK: Configure - Like
        headerContainerView.addSubview(likeCntContainerView)
        likeCntContainerView.topAnchor.constraint(equalTo: commentCntContainerView.topAnchor).isActive = true
        likeCntContainerView.trailingAnchor.constraint(equalTo: commentCntContainerView.leadingAnchor, constant: -16).isActive = true
        likeCntContainerView.bottomAnchor.constraint(equalTo: commentCntContainerView.bottomAnchor).isActive = true

        likeCntContainerView.addSubview(likeCntImageView)
        likeCntImageView.centerYAnchor.constraint(equalTo: postsCntLabel.centerYAnchor).isActive = true
        likeCntImageView.leadingAnchor.constraint(equalTo: likeCntContainerView.leadingAnchor).isActive = true
        likeCntImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        likeCntImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        likeCntContainerView.addSubview(likeCntLabel)
        likeCntLabel.centerYAnchor.constraint(equalTo: postsCntLabel.centerYAnchor).isActive = true
        likeCntLabel.leadingAnchor.constraint(equalTo: likeCntImageView.trailingAnchor, constant: 4).isActive = true
        likeCntLabel.trailingAnchor.constraint(equalTo: likeCntContainerView.trailingAnchor).isActive = true
        
        // MARK: Configure - Other
        addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        addSubview(categoryLabel)
        categoryLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: SPACE_S).isActive = true
        categoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        categoryLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        addressLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addressLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func likeTapped() {
        delegate?.like()
    }
    
    @objc func mapTapped() {
        delegate?.selectMap()
    }
    
    @objc func commentTapped() {
        delegate?.selectComment()
    }
}
