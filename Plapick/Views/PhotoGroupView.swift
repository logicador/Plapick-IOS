//
//  PhotoGroupView.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit


// MARK: Protocol
protocol PhotoGroupViewProtocol {
    func photoTapped(pick: Pick)
}


class PhotoGroupView: UIView {
    
    // MARK: Properties
    var delegate: PhotoGroupViewProtocol?
    var pickList: [Pick] = []
    let photoSize = (UIScreen.main.bounds.size.width / 3) - (2 / 3)
    var photoViewList: [PhotoView] = []
    
    
    // MARK: Init
    init(direction: String = "N", isBackGround: Bool = true, pickList: [Pick]) {
        super.init(frame: CGRect.zero)
        
        self.pickList = pickList
        
        let photoView = PhotoView(photoUrl: pickList[0].photoUrl)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.isBackGround = isBackGround
        photoViewList.append(photoView)
        if pickList.count > 1 {
            let photoView = PhotoView(photoUrl: pickList[1].photoUrl)
            photoView.translatesAutoresizingMaskIntoConstraints = false
            photoView.isBackGround = isBackGround
            photoViewList.append(photoView)
        } else {
            let photoView1 = PhotoView(photoUrl: "")
            photoView1.translatesAutoresizingMaskIntoConstraints = false
            photoView1.isBackGround = isBackGround
            photoViewList.append(photoView1)
            let photoView2 = PhotoView(photoUrl: "")
            photoView2.translatesAutoresizingMaskIntoConstraints = false
            photoView2.isBackGround = isBackGround
            photoViewList.append(photoView2)
        }
        if pickList.count > 2 {
            let photoView = PhotoView(photoUrl: pickList[2].photoUrl)
            photoView.translatesAutoresizingMaskIntoConstraints = false
            photoView.isBackGround = isBackGround
            photoViewList.append(photoView)
        } else {
            let photoView = PhotoView(photoUrl: "")
            photoView.translatesAutoresizingMaskIntoConstraints = false
            photoView.isBackGround = isBackGround
            photoViewList.append(photoView)
        }
        
//        for pick in pickList {
//            let photoView = PhotoView(photoUrl: pick.photoUrl)
//            photoViewList.append(photoView)
//        }
        
        for photoView in photoViewList {
            addSubview(photoView)
        }
        
        if direction == "L" {
            configureL()
        } else if direction == "R" {
            configureR()
        } else {
            configureN()
        }
        
        photoViewList[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoView1Tapped)))
        photoViewList[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoView2Tapped)))
        photoViewList[2].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoView3Tapped)))
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Functions
    @objc func photoView1Tapped() {
        if pickList.count < 1 { return }
        delegate?.photoTapped(pick: self.pickList[0])
    }
    @objc func photoView2Tapped() {
        if pickList.count < 2 { return }
        delegate?.photoTapped(pick: self.pickList[1])
    }
    @objc func photoView3Tapped() {
        if pickList.count < 3 { return }
        delegate?.photoTapped(pick: self.pickList[2])
    }
    
    func configureN() {
        photoViewList[0].topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoViewList[0].bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        photoViewList[0].widthAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[0].heightAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[0].leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        photoViewList[1].topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoViewList[1].bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        photoViewList[1].widthAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[1].heightAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[1].centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        photoViewList[2].topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoViewList[2].bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        photoViewList[2].widthAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[2].heightAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[2].trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func configureL() {
        photoViewList[0].topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoViewList[0].bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        photoViewList[0].widthAnchor.constraint(equalToConstant: (photoSize * 2) + 1).isActive = true
        photoViewList[0].heightAnchor.constraint(equalToConstant: (photoSize * 2) + 1).isActive = true
        photoViewList[0].leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        photoViewList[1].topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoViewList[1].widthAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[1].heightAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[1].trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        photoViewList[2].topAnchor.constraint(equalTo: photoViewList[1].bottomAnchor, constant: 1).isActive = true
        photoViewList[2].widthAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[2].heightAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[2].trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func configureR() {
        photoViewList[0].topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoViewList[0].widthAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[0].heightAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[0].leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        photoViewList[1].topAnchor.constraint(equalTo: photoViewList[0].bottomAnchor, constant: 1).isActive = true
        photoViewList[1].widthAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[1].heightAnchor.constraint(equalToConstant: photoSize).isActive = true
        photoViewList[1].leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        photoViewList[2].topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoViewList[2].bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        photoViewList[2].widthAnchor.constraint(equalToConstant: (photoSize * 2) + 1).isActive = true
        photoViewList[2].heightAnchor.constraint(equalToConstant: (photoSize * 2) + 1).isActive = true
        photoViewList[2].trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
