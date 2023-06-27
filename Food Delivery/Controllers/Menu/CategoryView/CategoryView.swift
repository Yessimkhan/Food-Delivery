//
//  categoryView.swift
//  Food Delivery
//
//  Created by Yessimkhan Zhumash on 23.06.2023.
//

import UIKit

protocol CollectionViewDelegate: AnyObject {
    func didSelectItem(index: Int, all: Int)
}

class CategoryView: UIView {
    
    var categories = ["Пицца", "Комбо", "Десерты", "Напитки", "Суши"]
    weak var delegate: CollectionViewDelegate?
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 88, height: 32)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.backgroundColor
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

private extension CategoryView {
    func setupViews(){
        addSubview(categoryCollectionView)
    }
    func setupConstraints(){
        categoryCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CategoryView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.layer.cornerRadius = 16
        cell.configure(labelTitle: "\(categories[indexPath.item])")
        if indexPath.item == 0{
            cell.layer.backgroundColor = Colors.tintColor.withAlphaComponent(0.4).cgColor
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        cell.backgroundColor = Colors.tintColor.withAlphaComponent(0.4)
        delegate?.didSelectItem(index: indexPath.row, all: categories.count)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        cell.backgroundColor = Colors.backgroundColor
    }
}
