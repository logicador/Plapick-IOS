//
//  PhotoGroupView.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit
import SDWebImage


// MARK: Protocol
protocol PhotoGroupViewProtocol {
    func detailPick(pick: Pick)
}


class PhotoGroupView: UIView {
    
    // MARK: Property
    var delegate: PhotoGroupViewProtocol?
    var vc: UIViewController?
    var app = App()
    let imageSize = (SCREEN_WIDTH / 3) - (2 / 3)
    var pickList: [Pick] = [] {
        didSet {
            if pickList.count > 0 {
                guard let url = URL(string: "\(IMAGE_URL)/users/\(pickList[0].uId)/\(pickList[0].id).jpg") else { return }
                iv1.sd_setImage(with: url, completed: nil)
            }
            
            if pickList.count > 1 {
                guard let url = URL(string: "\(IMAGE_URL)/users/\(pickList[1].uId)/\(pickList[1].id).jpg") else { return }
                iv2.sd_setImage(with: url, completed: nil)
            }
            
            if pickList.count > 2 {
                guard let url = URL(string: "\(IMAGE_URL)/users/\(pickList[2].uId)/\(pickList[2].id).jpg") else { return }
                iv3.sd_setImage(with: url, completed: nil)
            }
        }
    }
    let checkPickRequest = CheckPickRequest()
    var tempPick: Pick?
    
    
    // MARK: View
    lazy var iv1: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iv1Tapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var iv2: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iv2Tapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var iv3: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iv3Tapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    // MARK: Init
    init(direction: Int = 0) {
        super.init(frame: CGRect.zero)
        
        configureView(direction: direction)
        
        checkPickRequest.delegate = self
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView(direction: Int) {
        addSubview(iv1)
        addSubview(iv2)
        addSubview(iv3)
        
        if direction == 1 {
            configureL()
        } else if direction == 2 {
            configureR()
        } else {
            configureN()
        }
    }
    
    func configureN() {
        iv1.topAnchor.constraint(equalTo: topAnchor).isActive = true
        iv1.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        iv1.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        iv1.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        iv1.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        iv2.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iv2.centerYAnchor.constraint(equalTo: iv1.centerYAnchor).isActive = true
        iv2.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        iv2.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        iv3.centerYAnchor.constraint(equalTo: iv1.centerYAnchor).isActive = true
        iv3.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        iv3.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        iv3.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
    }
    
    func configureL() {
        iv1.topAnchor.constraint(equalTo: topAnchor).isActive = true
        iv1.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        iv1.widthAnchor.constraint(equalToConstant: (imageSize * 2) + 1).isActive = true
        iv1.heightAnchor.constraint(equalToConstant: (imageSize * 2) + 1).isActive = true
        iv1.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        iv2.topAnchor.constraint(equalTo: iv1.topAnchor).isActive = true
        iv2.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        iv2.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        iv2.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        iv3.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        iv3.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        iv3.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        iv3.bottomAnchor.constraint(equalTo: iv1.bottomAnchor).isActive = true
    }
    
    func configureR() {
        iv3.topAnchor.constraint(equalTo: topAnchor).isActive = true
        iv3.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        iv3.widthAnchor.constraint(equalToConstant: (imageSize * 2) + 1).isActive = true
        iv3.heightAnchor.constraint(equalToConstant: (imageSize * 2) + 1).isActive = true
        iv3.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        iv1.topAnchor.constraint(equalTo: iv3.topAnchor).isActive = true
        iv1.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        iv1.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        iv1.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        iv2.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        iv2.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        iv2.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        iv2.bottomAnchor.constraint(equalTo: iv3.bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func iv1Tapped() {
        if pickList.count < 1 { return }
        tempPick = pickList[0]
        
        guard let vc = self.vc else { return }
        checkPickRequest.fetch(vc: vc, paramDict: ["piId": String(pickList[0].id)])
    }
    @objc func iv2Tapped() {
        if pickList.count < 2 { return }
        tempPick = pickList[1]
        
        guard let vc = self.vc else { return }
        checkPickRequest.fetch(vc: vc, paramDict: ["piId": String(pickList[1].id)])
    }
    @objc func iv3Tapped() {
        if pickList.count < 3 { return }
        tempPick = pickList[2]
        
        guard let vc = self.vc else { return }
        checkPickRequest.fetch(vc: vc, paramDict: ["piId": String(pickList[2].id)])
    }
}

// MARK: HTTP - CheckPick
extension PhotoGroupView: CheckPickRequestProtocol {
    func response(checkPick status: String) {
        print("[HTTP RES]", checkPickRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pick = self.tempPick else { return }
            delegate?.detailPick(pick: pick)
            
        } else if status == "NO_PICK" {
            guard let vc = self.vc else { return }
            
            let alert = UIAlertController(title: nil, message: "삭제되었거나 존재하지 않는 픽 입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
