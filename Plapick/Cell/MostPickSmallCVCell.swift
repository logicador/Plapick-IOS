//
//  PickCVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/31.
//

import UIKit


class MostPickSmallCVCell: UICollectionViewCell {
    
    // MARK: Property
    let app = App()
    var mostPick: MostPick? {
        didSet {
            guard let mostPick = self.mostPick else { return }
            
            if let url = URL(string: app.getPickUrl(id: mostPick.id, uId: mostPick.uId)) {
                photoView.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
    
    // MARK: View
    lazy var photoView: PhotoView = {
        let pv = PhotoView()
        return pv
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
        addSubview(photoView)
        photoView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        photoView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        photoView.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH / 3).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH / 3).isActive = true
    }
}
