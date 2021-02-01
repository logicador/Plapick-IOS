//
//  PhotoViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/19.
//

import UIKit


protocol PhotoViewControllerProtocol {
    func closePhotoViewVC()
}


class PhotoViewController: UIViewController {
    
    // MARK: Property
    var delegate: PhotoViewControllerProtocol?
    var app = App()
    var image: UIImage? {
        didSet {
            guard let image = self.image else { return }
            
            let isv = ImageScrollView(frame: view.bounds)
            view.addSubview(isv)
            isv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            isv.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            isv.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            isv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            isv.set(image: image)
        }
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true // 후....
        
        setThemeColor()
    }
    
    
    // MARK: ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.closePhotoViewVC()
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
}
