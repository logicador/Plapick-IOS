//
//  PhotoViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/19.
//

import UIKit


class PhotoViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    var image: UIImage? {
        didSet {
            let imageScrollView = ImageScrollView(frame: view.bounds)
            imageScrollView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageScrollView)
            imageScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            imageScrollView.set(image: image!)
        }
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        
        adjustColors()
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .tertiarySystemGroupedBackground
        }
    }
    
//    @objc func backTapped() {
//        self.dismiss(animated: true, completion: nil)
//    }
}
