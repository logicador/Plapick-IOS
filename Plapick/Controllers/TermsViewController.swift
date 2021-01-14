//
//  TermsViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/15.
//

import UIKit
import WebKit


class TermsViewController: UIViewController {
    
    // MARK: Properties
    var termsUrl: String? {
        didSet {
            let url = URL(string: termsUrl!)
            let request = URLRequest(url: url!)
            webView.load(request)
        }
    }
    
    
    // MARK: Views
    lazy var webView: WKWebView = {
        let wv = WKWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    
    // MARK: VerDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    
    // MARK: Functions
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
