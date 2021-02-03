//
//  LocationMapViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit
import NMapsMap


class LocationMapViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    
    
    // MARK: Views
    lazy var searchPlaceFromLocationButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = UIColor.systemBackground
        button.setTitle("이 위치에서 찾기", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.layer.shadowOpacity = 0.3 // 그림자 진한정도?
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0) // 그림자 방향?
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var scopeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "scope")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "location.north.fill")
        iv.contentMode = .scaleAspectFit
        iv.transform = iv.transform.rotated(by: .pi)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var naverMap: NMFMapView = {
        let map = NMFMapView()
        map.allowsRotating = false
        map.allowsTilting = false
        map.logoInteractionEnabled = false
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        view.addSubview(naverMap)
        naverMap.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        naverMap.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        naverMap.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        naverMap.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        naverMap.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        naverMap.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        view.addSubview(scopeImageView)
        scopeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scopeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scopeImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        scopeImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(arrowImageView)
        arrowImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        arrowImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(searchPlaceFromLocationButton)
        searchPlaceFromLocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        searchPlaceFromLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        searchPlaceFromLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        searchPlaceFromLocationButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -120).isActive = true
        searchPlaceFromLocationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        adjustColors()
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(vc: self)
            return
        }
    }
    
    
    // MARK: Functions
    override func viewDidAppear(_ animated: Bool) {
        searchPlaceFromLocationButton.layer.shadowPath = UIBezierPath(rect: searchPlaceFromLocationButton.bounds).cgPath
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        searchPlaceFromLocationButton.tintColor = UIColor.systemBackground.inverted
        
        if self.traitCollection.userInterfaceStyle == .dark {
        } else {
        }
    }
}
