//
//  PlaceMapViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/01.
//

import UIKit
import NMapsMap
import CoreLocation


class PlaceMapViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            navigationItem.title = place.name
        }
    }
    let locationManager = CLLocationManager()
    
    
    // MARK: View
    lazy var mapView: NMFMapView = {
        let nmv = NMFMapView()
        nmv.alpha = 0
        nmv.allowsRotating = false
        nmv.allowsTilting = false
        nmv.logoInteractionEnabled = false
        nmv.translatesAutoresizingMaskIntoConstraints = false
        return nmv
    }()
    
    lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = SPACE_XS
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var markerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(markerTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var markerImageView: UIImageView = {
        let image = UIImage(systemName: "flag")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var gpsView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gpsTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var gpsImageView: UIImageView = {
        let image = UIImage(systemName: "scope")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var buttonLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureView()
        
        setThemeColor()
    }
    
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
            })
        })
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() { buttonContainerView.layer.borderColor = UIColor.separator.cgColor }
    
    func configureView() {
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(buttonContainerView)
        buttonContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SPACE_XS).isActive = true
        buttonContainerView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SPACE_XS).isActive = true
        
        buttonContainerView.addSubview(markerView)
        markerView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor).isActive = true
        markerView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor).isActive = true
        markerView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor).isActive = true
        markerView.heightAnchor.constraint(equalTo: buttonContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        markerView.addSubview(markerImageView)
        markerImageView.topAnchor.constraint(equalTo: markerView.topAnchor, constant: 12).isActive = true
        markerImageView.leadingAnchor.constraint(equalTo: markerView.leadingAnchor, constant: 12).isActive = true
        markerImageView.trailingAnchor.constraint(equalTo: markerView.trailingAnchor, constant: -12).isActive = true
        markerImageView.bottomAnchor.constraint(equalTo: markerView.bottomAnchor, constant: -12).isActive = true
        
        buttonContainerView.addSubview(gpsView)
        gpsView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor).isActive = true
        gpsView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor).isActive = true
        gpsView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor).isActive = true
        gpsView.heightAnchor.constraint(equalTo: buttonContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        gpsView.addSubview(gpsImageView)
        gpsImageView.topAnchor.constraint(equalTo: gpsView.topAnchor, constant: 12).isActive = true
        gpsImageView.leadingAnchor.constraint(equalTo: gpsView.leadingAnchor, constant: 12).isActive = true
        gpsImageView.trailingAnchor.constraint(equalTo: gpsView.trailingAnchor, constant: -12).isActive = true
        gpsImageView.bottomAnchor.constraint(equalTo: gpsView.bottomAnchor, constant: -12).isActive = true
        
        buttonContainerView.addSubview(buttonLine)
        buttonLine.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor).isActive = true
        buttonLine.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor).isActive = true
        buttonLine.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func markerTapped() {
        guard let place = self.place else { return }
        
        guard let latitude = Double(place.latitude) else { return }
        guard let longitude = Double(place.longitude) else { return }
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        mapView.moveCamera(cameraUpdate)
    }
    
    @objc func gpsTapped() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            
        } else if status == .restricted || status == .denied {
            requestSettingAlert(title: "위치 액세스 허용하기", message: "'플레픽'에서 사용자의 위치에 접근하고자 합니다.")
            
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            guard let location = locationManager.location else {
                let alert = UIAlertController(title: "위치정보", message: "사용자의 위치 정보를 가져올 수 없습니다. 다시 시도해주세요.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
                present(alert, animated: true, completion: nil)
                return
            }
            let coord = location.coordinate
            let lat = coord.latitude
            let lng = coord.longitude
            app.setLatitude(latitude: String(lat))
            app.setLongitude(longitude: String(lng))
            
            let locationOverlay = mapView.locationOverlay
            locationOverlay.hidden = false
            locationOverlay.location = NMGLatLng(lat: lat, lng: lng)
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
            cameraUpdate.animation = .fly
            cameraUpdate.animationDuration = 1
            mapView.moveCamera(cameraUpdate)
        }
    }
}
