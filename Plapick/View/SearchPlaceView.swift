//
//  SearchPlaceView.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/06.
//

import UIKit


// MARK: Protocol
protocol SearchPlaceViewProtocol {
    func selectPlace(index: Int, place: Place)
    func detailPlace(index: Int, place: Place)
}


class SearchPlaceView: UIView {
    
    // MARK: Properties
    var delegate: SearchPlaceViewProtocol?
    var index: Int?
    var place: Place?
    var isSelected: Bool = false {
        didSet {
//            placeSmallView?.isSelected = isSelected
            NSLayoutConstraint.deactivate(animConsList)
            
            if isSelected {
////                let placeSmallViewTrailingCons = placeSmallView?.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor)
//                placeSmallViewTrailingCons?.isActive = true
//                animConsList.append(placeSmallViewTrailingCons!)
                
                let detailButtonTrailingCons = detailButton.trailingAnchor.constraint(equalTo: trailingAnchor)
                detailButtonTrailingCons.isActive = true
                animConsList.append(detailButtonTrailingCons)
                
            } else {
                let detailButtonLeadingCons = detailButton.leadingAnchor.constraint(equalTo: trailingAnchor)
                detailButtonLeadingCons.isActive = true
                animConsList.append(detailButtonLeadingCons)
                
//                let placeSmallViewTrailingCons = placeSmallView?.trailingAnchor.constraint(equalTo: trailingAnchor)
//                placeSmallViewTrailingCons?.isActive = true
//                animConsList.append(placeSmallViewTrailingCons!)
            }
            
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
    var animConsList: [NSLayoutConstraint] = []
    
    
    // MARK: Views
//    var placeSmallView: PlaceSmallView?
    
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
    
    lazy var detailButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(systemName: "chevron.right"), for: UIControl.State.normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(detailTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: Init
    init(index: Int, place: Place) {
        super.init(frame: CGRect.zero)
        
        self.index = index
        self.place = place
//        placeSmallView = PlaceSmallView(place: place)
//        placeSmallView = PlaceSmallView()
        
        addSubview(detailButton)
        detailButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        detailButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        detailButton.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        let detailButtonLeadingCons = detailButton.leadingAnchor.constraint(equalTo: trailingAnchor)
        detailButtonLeadingCons.isActive = true
        animConsList.append(detailButtonLeadingCons)
        
//        addSubview(placeSmallView!)
//        placeSmallView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        placeSmallView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        placeSmallView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        let placeSmallViewTrailingCons = placeSmallView?.trailingAnchor.constraint(equalTo: trailingAnchor)
//        placeSmallViewTrailingCons?.isActive = true
//        animConsList.append(placeSmallViewTrailingCons!)
        
        addSubview(topLineView)
        topLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topLineView.leadingAnchor.constraint(equalTo:leadingAnchor).isActive = true
        topLineView.trailingAnchor.constraint(equalTo:trailingAnchor).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
        
        addSubview(bottomLineView)
        bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomLineView.leadingAnchor.constraint(equalTo:leadingAnchor).isActive = true
        bottomLineView.trailingAnchor.constraint(equalTo:trailingAnchor).isActive = true
        bottomLineView.heightAnchor.constraint(equalToConstant: LINE_WIDTH).isActive = true
        
//        placeSmallView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(placeTapped)))
        
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
        if self.traitCollection.userInterfaceStyle == .dark {
            detailButton.backgroundColor = .systemGray6
        } else {
            detailButton.backgroundColor = .systemBackground
        }
    }
    
    @objc func placeTapped() {
        guard let index = self.index else { return }
        guard let place = self.place else { return }
        delegate?.selectPlace(index: index, place: place)
    }
    
    @objc func detailTapped() {
        guard let index = self.index else { return }
        guard let place = self.place else { return }
        delegate?.detailPlace(index: index, place: place)
    }
}
