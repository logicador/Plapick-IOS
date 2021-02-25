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
    var app = App()
    var delegate: PhotoGroupViewProtocol?
    let imageSize = (SCREEN_WIDTH / 3) - (2 / 3)
//    var photoViewList: [PhotoView] = [PhotoView(), PhotoView(), PhotoView()]
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
            
//            for (i, pick) in self.pickList.enumerated() {
//                if let url = URL(string: "\(IMAGE_URL)/users/\(pick.uId)/\(pick.id).jpg") {
//                    photoViewList[i].sd_setImage(with: url, completed: nil)
//                }
//            }
        }
    }
    
    
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
        
//        let emptyPick = Pick(id: 0, uId: 0, pId: 0, message: "", createdDate: "", updatedDate: "")
//        self.pickList = [emptyPick, emptyPick, emptyPick]
        
        configureView(direction: direction)
        
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
//        for photoView in photoViewList {
//            addSubview(photoView)
//        }
        
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
        delegate?.detailPick(pick: pickList[0])
    }
    @objc func iv2Tapped() {
        if pickList.count < 2 { return }
        delegate?.detailPick(pick: pickList[1])
    }
    @objc func iv3Tapped() {
        if pickList.count < 3 { return }
        delegate?.detailPick(pick: pickList[2])
    }
}
