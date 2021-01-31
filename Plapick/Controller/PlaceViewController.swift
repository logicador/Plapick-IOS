//
//  PlaceViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit


protocol PlaceViewControllerProtocol {
    func closePlaceVC()
}


class PlaceViewController: UIViewController {
    
    // MARK: Property
    var delegate: PlaceViewControllerProtocol?
    var isOpenedChildVC: Bool = false
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            navigationItem.title = place.name
        }
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        
        configureView()
        
        setThemeColor()
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
        
    }
}
