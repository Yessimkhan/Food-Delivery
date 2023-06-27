//
//  CategoryCollectionViewCell.swift
//  Food Delivery
//
//  Created by Yessimkhan Zhumash on 23.06.2023.
//

import UIKit





class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    let categoryaLabel: UILabel = {
        let label = UILabel()
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 16
        label.font = Fonts.SFUIDisplay?.withSize(13)
        label.layer.borderColor = Colors.tintColor.withAlphaComponent(0.4).cgColor
        label.textColor = Colors.tintColor.withAlphaComponent(0.4)
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func configure(labelTitle: String){
        categoryaLabel.text = labelTitle
    }
}

private extension CategoryCollectionViewCell {
    
    func setupViews() {
        addSubview(categoryaLabel)
    }
    
    func setupConstraints() {
        categoryaLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
