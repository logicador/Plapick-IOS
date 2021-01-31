//
//  PickWithUserCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/31.
//

import UIKit


protocol MostPickLargeCVCellProtocol {
    func openUser(uId: Int)
    func openPick(piId: Int)
}


class MostPickLargeCVCell: UICollectionViewCell {
    
    // MARK: Property
    var delegate: MostPickLargeCVCellProtocol?
    let app = App()
    var mostPick: MostPick? {
        didSet {
            guard let mostPick = self.mostPick else { return }
            
            nickNameLabel.text = mostPick.uNickName
            
            if let url = URL(string: ((mostPick.uProfileImage.contains(String(mostPick.uId))) ? (PLAPICK_URL + mostPick.uProfileImage) : mostPick.uProfileImage)) {
                profileImageView.sd_setImage(with: url, completed: nil)
            }
            if let url = URL(string: app.getPickUrl(id: mostPick.id, uId: mostPick.uId)) {
                photoView.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
    
    // MARK: View
    lazy var headerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var photoView: PhotoView = {
        let pv = PhotoView()
        pv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoTapped)))
        return pv
    }()
    
    lazy var leftLine: LineView = {
        let lv = LineView(orientation: .vertical)
        return lv
    }()
    lazy var headerBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 40 + (SPACE_XS * 2)).isActive = true
        
        headerView.addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        headerView.addSubview(nickNameLabel)
        nickNameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        nickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        
        addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        photoView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        photoView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH).isActive = true
        photoView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(leftLine)
        leftLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        leftLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(headerBottomLine)
        headerBottomLine.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        headerBottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerBottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    
    // MARK: Function - @OBJC
    @objc func headerTapped() {
        guard let mostPick = self.mostPick else { return }
        delegate?.openUser(uId: mostPick.uId)
    }
    
    @objc func photoTapped() {
        guard let mostPick = self.mostPick else { return }
        delegate?.openPick(piId: mostPick.id)
    }
}
