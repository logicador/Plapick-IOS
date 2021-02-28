//
//  HomeViewController.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


class HomeViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let getPicksRequest = GetPicksRequest()
    let getVersionRequest = GetVersionRequest()
    var isEnded = false
    var isLoading = false
    var page = 1
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var recentPickStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 1
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        getPicksRequest.delegate = self
        getVersionRequest.delegate = self
        
        checkPushNotificationAvailable(allow: {
            UIApplication.shared.registerForRemoteNotifications()
        })
        
        getPicks()
        getVersionRequest.fetch(vc: self, paramDict: [:])
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(recentPickStackView)
        recentPickStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        recentPickStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }
    
    func getPicks() {
        isLoading = true
        getPicksRequest.fetch(vc: self, paramDict: ["page": String(page), "limit": "30"])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isLoading && !isEnded {
                page += 1
                getPicks()
            }
        }
    }
}

// MARK: PhotoGroupView
extension HomeViewController: PhotoGroupViewProtocol {
    func detailPick(pick: Pick) {
        let pickVC = PickViewController()
        pickVC.navigationItem.title = "최신 픽"
        pickVC.id = pick.id
        navigationController?.pushViewController(pickVC, animated: true)
    }
}

// MARK: HTTP - GetPicks
extension HomeViewController: GetPicksRequestProtocol {
    func response(pickList: [Pick]?, getPicks status: String) {
        print("[HTTP RES]", getPicksRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pickList = pickList else { return }
            
            if pickList.count > 0 {
                isEnded = false
                
                var _pickList: [Pick] = []
                for (i, pick) in pickList.enumerated() {
                    
                    _pickList.append(pick)
                    if ((i + 1) % 3 == 0) {
                        let pgv = PhotoGroupView(direction: .random(in: 0...2))
                        pgv.vc = self
                        pgv.pickList = _pickList
                        pgv.delegate = self
                        
                        recentPickStackView.addArrangedSubview(pgv)
                        pgv.leadingAnchor.constraint(equalTo: recentPickStackView.leadingAnchor).isActive = true
                        pgv.trailingAnchor.constraint(equalTo: recentPickStackView.trailingAnchor).isActive = true
                        _pickList.removeAll()
                        
                    } else {
                        if ((i + 1) == pickList.count && _pickList.count > 0) {
                            // 마지막 direction은 무조건 0
                            let pgv = PhotoGroupView()
                            pgv.vc = self
                            pgv.pickList = _pickList
                            pgv.delegate = self
                            
                            recentPickStackView.addArrangedSubview(pgv)
                            pgv.leadingAnchor.constraint(equalTo: recentPickStackView.leadingAnchor).isActive = true
                            pgv.trailingAnchor.constraint(equalTo: recentPickStackView.trailingAnchor).isActive = true
                        }
                    }
                }
            } else { isEnded = true }
        }
        isLoading = false
    }
}

// MARK: HTTP - GetVersion
extension HomeViewController: GetVersionRequestProtocol {
    func response(versionCode: Int?, versionName: String?, getVersion status: String) {
        print("[HTTP RES]", getVersionRequest.apiUrl, status)
        
        if status == "OK" {
            guard let newVersionCode = versionCode else { return }
            guard let newVersionName = versionName else { return }
            app.setNewVersionCode(newVersionCode: newVersionCode)
            app.setNewVersionName(newVersionName: newVersionName)
            
            guard let infoDictionary = Bundle.main.infoDictionary else { return }
            guard let code = infoDictionary["CFBundleVersion"] as? String else { return }
            guard let curVersionName = infoDictionary["CFBundleShortVersionString"] as? String else { return }
            guard let curVersionCode = Int(code) else { return }
            app.setCurVersionCode(curVersionCode: curVersionCode)
            app.setCurVersionName(curVersionName: curVersionName)
            
            if newVersionCode > curVersionCode {
                
            }
        }
    }
}
