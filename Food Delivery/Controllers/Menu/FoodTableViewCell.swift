//
//  FoodTableViewCell.swift
//  Food Delivery
//
//  Created by Yessimkhan Zhumash on 24.06.2023.
//

import UIKit
import SDWebImage


class FoodTableViewCell: UITableViewCell {
    
    static let Identifier = "FoodTableViewCell"
    
    var pizzaImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Pizza")
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    var title: UILabel = {
        let label = UILabel()
        label.text = "Пицца"
        label.font = Fonts.SFUIDisplay?.withSize(17)
        label.numberOfLines = 0
        label.textColor = Colors.textColor
        return label
    }()
    var detail: UILabel = {
        let label = UILabel()
        label.text = "Собери свою пиццу"
        label.font = Fonts.SFUIDisplay?.withSize(15)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.setTitleColor(Colors.tintColor, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.tintColor.cgColor
        button.addTarget(self, action: #selector(priceButton), for: .touchUpInside)
        return button
    }()
    
    @objc func priceButton(){
        print("price tapped")
    }
    var noPhoto: UILabel = {
        let label = UILabel()
        label.text = "Изображение отсутвует"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        noPhoto.isHidden = true
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(with food: FoodElement){
        title.text = food.name
        detail.text = food.description
        guard let url = URL(string: food.img) else {
            return
        }
        pizzaImage.sd_setImage(with: url, completed: nil)
        let price = Double(food.price) * 84.62
        button.setTitle("\(price)", for: .normal)
    }
    
}

extension FoodTableViewCell {
    
    //MARK: - Private funcs
    private func setupViews() {
        addSubview(pizzaImage)
        addSubview(title)
        addSubview(detail)
        addSubview(button)
        addSubview(noPhoto)
    }
    private func setupConstraints() {
        pizzaImage.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.height.equalTo(132)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        noPhoto.snp.makeConstraints { make in
            make.edges.equalTo(pizzaImage)
        }
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(pizzaImage.snp.trailing).offset(32)
//            make.height.equalTo(20)
            make.trailing.equalToSuperview().inset(24)
        }
        detail.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).inset(-8)
            make.leading.equalTo(title.snp.leading)
            make.trailing.equalToSuperview().inset(24)
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(detail.snp.bottom).inset(-16)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(87)
            make.height.equalTo(32)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}

extension UITableViewCell {
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        sendSubviewToBack(contentView)
    }
}
