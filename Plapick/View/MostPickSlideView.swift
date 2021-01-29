//
//  MostPickSlideView.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/25.
//

import UIKit
import SDWebImage


protocol MostPickSlideViewProtocol {
    func openPick(piId: Int)
    func openPickUser(uId: Int)
    func openPickStatistics(piId: Int)
}


class MostPickSlideView: UIView {
    
    // MARK: Property
    var delegate: MostPickSlideViewProtocol?
    let app = App()
    var mostPick: MostPick? {
        didSet {
            guard let mostPick = self.mostPick else { return }
            
            nickNameLabel.text = mostPick.uNickName
            cntLabel.text = "좋아요 \(mostPick.likeCnt), 댓글 \(mostPick.commentCnt)"
            
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTapped)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cntLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아요 141, 댓글 22"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cntTapped)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var photoView: PhotoView = {
        let pv = PhotoView()
        pv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoTapped)))
        return pv
    }()
    
    lazy var PhotoViewLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var line: LineView = {
        let lv = LineView(orientation: .vertical)
        return lv
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        headerView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: SPACE_XS).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        headerView.addSubview(nickNameLabel)
        nickNameLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        nickNameLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        nickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: SPACE_XS).isActive = true
        
        headerView.addSubview(cntLabel)
        cntLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        cntLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        cntLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        
        addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        photoView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        photoView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(PhotoViewLine)
        PhotoViewLine.topAnchor.constraint(equalTo: photoView.topAnchor).isActive = true
        PhotoViewLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        PhotoViewLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(line)
        line.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        line.topAnchor.constraint(equalTo: topAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    
    // MARK: Function - @OBJC
    @objc func photoTapped() {
        guard let mostPick = self.mostPick else { return }
        delegate?.openPick(piId: mostPick.id)
    }
    
    @objc func userTapped() {
        guard let mostPick = self.mostPick else { return }
        delegate?.openPickUser(uId: mostPick.uId)
    }
    
    @objc func cntTapped() {
        guard let mostPick = self.mostPick else { return }
        delegate?.openPickStatistics(piId: mostPick.id)
    }
}
