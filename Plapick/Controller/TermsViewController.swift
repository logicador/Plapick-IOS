//
//  TermsViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/26.
//

import UIKit
import WebKit


class TermsViewController: UIViewController {
    
    // MARK: Property
    var path: String? {
        didSet {
            guard let path = self.path else { return }
            
            navigationItem.title = (path == "agreement") ? "서비스 이용약관" : "개인정보 처리방침"
            guard let url = URL(string: "\(PLAPICK_URL)/mobile/terms/\(path)?theme=\((traitCollection.userInterfaceStyle == .dark) ? "dark" : "light")") else { return }
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    
    // MARK: View
    lazy var webView: WKWebView = {
        let wv = WKWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        setThemeColor()
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setThemeColor()
        guard let path = self.path else { return }
        guard let url = URL(string: "\(PLAPICK_URL)/mobile/terms/\(path)?theme=\((traitCollection.userInterfaceStyle == .dark) ? "dark" : "light")") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
