//
//  bannerCollectionViewCell.swift
//  Food Delivery
//
//  Created by Yessimkhan Zhumash on 23.06.2023.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Public properties
    static let identifier = "BannerCollectionViewCell"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configure(imageName: String){
        imageView.image = UIImage(named: imageName)
    }
    
}

// MARK: - setupViews and Constraints

private extension BannerCollectionViewCell {
    
    func setupViews() {
        addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
