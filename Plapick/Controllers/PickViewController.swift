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
            getPlaceRequest.fetch(pId: pick!.pId)
        }
    }
    var getPlaceRequest = GetPlaceRequest()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        
        getPlaceRequest.delegate = self
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
    }
    
    // MARK: Functions
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: Extensions
extension PickViewController: GetPlaceRequestProtocol {
    func response(place: Place?, status: String) {
        if status == "OK" {
            if let place = place {
                navigationItem.title = place.name
            }
        }
    }
}
