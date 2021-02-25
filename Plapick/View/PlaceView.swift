//
//  PlaceView.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/21.
//

import UIKit


protocol PlaceViewProtocol {
    func detailPlace(place: Place)
    func selectPlace(place: Place)
    func detailPick(place: Place, piId: Int)
}


class PlaceView: UIView {
    
    // MARK: Property
    var delegate: PlaceViewProtocol?
    let imageSize = (SCREEN_WIDTH / 3) - (2 / 3)
    var pickImageList: [String] = []
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            categoryLabel.text = place.categoryName.toCategory()
            let cntMabs = NSMutableAttributedString()
                .normal("좋아요 ", size: 12, color: .systemGray)
                .bold(String(place.likeCnt), size: 12)
                .normal("  댓글 ", size: 12, color: .systemGray)
                .bold(String(place.commentCnt), size: 12)
                .normal("  픽 ", size: 12, color: .systemGray)
                .bold(String(place.pickCnt), size: 12)
            cntLabel.attributedText = cntMabs
            nameLabel.text = place.name
            addressLabel.text = (place.roadAddress.isEmpty) ? place.address : place.roadAddress
            pickImageList = place.pickImageList
            
            if pickImageList.count > 0 { collectionView.reloadData() }
            else { collectionContainerView.isHidden = true }
        }
    }
    
    
    // MARK: View
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var cntLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceHorizontal = true
        cv.backgroundColor = .systemBackground
        cv.register(PickImageCVCell.self, forCellWithReuseIdentifier: "PickImageCVCell")
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var footerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("자세히 보기", for: .normal)
        let size: CGFloat = 15
        button.titleLabel?.font = .systemFont(ofSize: size)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = size * 0.4
        button.contentEdgeInsets = UIEdgeInsets(top: size * 0.4, left: size * 0.8, bottom: size * 0.4, right: size * 0.8)
        button.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택하기", for: .normal)
        let size: CGFloat = 15
        button.titleLabel?.font = .systemFont(ofSize: size)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = size * 0.4
        button.contentEdgeInsets = UIEdgeInsets(top: size * 0.4, left: size * 0.8, bottom: size * 0.4, right: size * 0.8)
        button.addTarget(self, action: #selector(selectTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        configureView()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE_XS).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(headerContainerView)
        headerContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        headerContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        
        headerContainerView.addSubview(categoryLabel)
        categoryLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        
        headerContainerView.addSubview(cntLabel)
        cntLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor).isActive = true
        cntLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        
        headerContainerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: SPACE_XXS).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        
        headerContainerView.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XXS).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(collectionContainerView)
        collectionContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        collectionContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        collectionContainerView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: collectionContainerView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: collectionContainerView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: collectionContainerView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: collectionContainerView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(footerContainerView)
        footerContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        footerContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        
        footerContainerView.addSubview(detailButton)
        detailButton.topAnchor.constraint(equalTo: footerContainerView.topAnchor).isActive = true
        detailButton.trailingAnchor.constraint(equalTo: footerContainerView.trailingAnchor).isActive = true
        detailButton.bottomAnchor.constraint(equalTo: footerContainerView.bottomAnchor).isActive = true
        
        footerContainerView.addSubview(selectButton)
        selectButton.centerYAnchor.constraint(equalTo: detailButton.centerYAnchor).isActive = true
        selectButton.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -SPACE_XS).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func detailTapped() {
        guard let place = self.place else { return }
        delegate?.detailPlace(place: place)
    }
    
    @objc func selectTapped() {
        guard let place = self.place else { return }
        delegate?.selectPlace(place: place)
    }
}


// MARK: CollectionView
extension PlaceView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickImageCVCell", for: indexPath) as! PickImageCVCell
        cell.image = pickImageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageSize, height: imageSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let place = self.place else { return }
        let splitted = pickImageList[indexPath.row].split(separator: "/")
        let piId = splitted[splitted.count - 1].replacingOccurrences(of: ".jpg", with: "")
        guard let id = Int(piId) else { return }
        delegate?.detailPick(place: place, piId: id)
    }
}
