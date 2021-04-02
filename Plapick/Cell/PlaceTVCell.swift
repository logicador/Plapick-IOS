//
//  PlaceTVCell.swift
//  Plapick
//
//  Created by 서원영 on 2021/04/02.
//

import UIKit


class PlaceTVCell: UITableViewCell {
    
    // MARK: Property
    var place: Place? {
        didSet {
            guard let place = self.place else { return }
            
            categoryLabel.text = place.p_category_name.replacingOccurrences(of: ">", with: "-")
            nameLabel.text = place.p_name
            addressLabel.text = (place.p_road_address.isEmpty) ? place.p_address : place.p_road_address
            
            let cntMabs = NSMutableAttributedString()
                .normal("게시물 ", size: 12, color: .systemGray3)
                .bold(String(place.p_posts_cnt), size: 12, color: .systemGray)
                .normal("  좋아요 ", size: 12, color: .systemGray3)
                .bold(String(place.p_like_cnt), size: 12, color: .systemGray)
                .normal("  댓글 ", size: 12, color: .systemGray3)
                .bold(String(place.p_comment_cnt), size: 12, color: .systemGray)
            cntLabel.attributedText = cntMabs
        }
    }
    
    
    // MARK: View
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XXS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemBlue
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
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE).isActive = true
        
        stackView.addArrangedSubview(categoryLabel)
        categoryLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        categoryLabel.addSubview(cntLabel)
        cntLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor).isActive = true
        cntLabel.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(addressLabel)
        addressLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }
}

