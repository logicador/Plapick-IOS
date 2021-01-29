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
    func pickTapped(pick: Pick)
}


class PhotoGroupView: UIView {
    
    // MARK: Properties
    var app = App()
    var delegate: PhotoGroupViewProtocol?
    let photoSize = (UIScreen.main.bounds.size.width / 3) - (2 / 3)
    var photoViewList: [PhotoView] = [PhotoView(), PhotoView(), PhotoView()]
    var pickList: [Pick] = [] {
        didSet {
            for (i, pick) in self.pickList.enumerated() {
                if let url = URL(string: app.getPickUrl(id: pick.id, uId: pick.uId)) {
                    photoViewList[i].sd_setImage(with: url, completed: nil)
                }
            }
        }
    }
    
    
    // MARK: Init
    init(direction: String = "N") {
        super.init(frame: CGRect.zero)
        
        let emptyPick = Pick(id: 0, pId: 0, uId: 0, likeCnt: 0, commentCnt: 0, createdDate: "", updatedDate: "")
        self.pickList = [emptyPick, emptyPick, emptyPick]
        
        configureView(direction: direction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView(direction: String) {
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
    
    // MARK: Function - @OBJC
    @objc func photoView1Tapped() {
        if pickList.count < 1 { return }
        delegate?.pickTapped(pick: pickList[0])
    }
    @objc func photoView2Tapped() {
        if pickList.count < 2 { return }
        delegate?.pickTapped(pick: pickList[1])
    }
    @objc func photoView3Tapped() {
        if pickList.count < 3 { return }
        delegate?.pickTapped(pick: pickList[2])
    }
}
