//
//  PlaceViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit


protocol PlaceViewControllerProtocol {
    func closePlaceVC()
    func likePlace()
}


class PlaceViewController: UIViewController {
    
    // MARK: Property
    var delegate: PlaceViewControllerProtocol?
    var isOpenedChildVC: Bool = false
    var place: Place?
    var isFetchingGetPlaceRequest: Bool = false
    let getPlaceRequest = GetPlaceRequest()
    let likePlaceRequest = LikePlaceRequest()
    
    
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
    
    lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        guard let place = self.place else { return }
        
        navigationItem.title = place.name
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(likePlaceTapped))
        
        configureView()
        
        setThemeColor()
        
        getPlaceRequest.delegate = self
        likePlaceRequest.delegate = self
        
        getPlace()
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
        
        contentView.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        emptyView.heightAnchor.constraint(equalToConstant: 1600).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func getPlace() {
        guard let place = self.place else { return }
        isFetchingGetPlaceRequest = true
        getPlaceRequest.fetch(vc: self, paramDict: ["pId": String(place.id)])
    }
    
    // MARK: Function - @OBJC
    @objc func likePlaceTapped() {
        if isFetchingGetPlaceRequest { return }
        guard let place = self.place else { return }
        
        self.place?.isLike = ((place.isLike ?? "N") == "N") ? "Y" : "N"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ((place.isLike ?? "N") == "N") ? "heart.fill" : "heart"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(likePlaceTapped))
        likePlaceRequest.fetch(vc: self, paramDict: ["pId": String(place.id)])
    }
}


// MARK: Extension - GetPlaceRequest
extension PlaceViewController: GetPlaceRequestProtocol {
    func response(place: Place?, getPlace status: String) {
        isFetchingGetPlaceRequest = false
        
        if status == "OK" {
            if let place = place {
                self.place = place
                
                // SET
                
                if let isLike = place.isLike {
                    if isLike == "Y" {
                        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(likePlaceTapped))
                        return
                    }
                }
            }
        }
    }
}

// MARK: Extension - LikePlaceRequest
extension PlaceViewController: LikePlaceRequestProtocol {
    func response(likePlace status: String) {
        if status == "OK" {
            delegate?.likePlace()
        }
    }
}
