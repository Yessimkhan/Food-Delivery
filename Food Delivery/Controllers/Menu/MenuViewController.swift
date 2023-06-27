//
//  MenuViewController.swift
//  HammerSystemsTest
//
//  Created by Angelina on 04.02.2021.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController, CollectionViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    private var savedFoods: [AllFoods] = [AllFoods]()
    var selectedCity: String = ""
    
    private let cityes = ["Москва", "Санкт-Петербург", "Новосибирск", "Екатеринбург","Казань", "Нижний Новгород", "Челябинск", "Красноярск", "Самара", "Уфа"]
    
    private var foods: [FoodElement] = [FoodElement]()
    
    private var headerView: BannerView?
    private var headerViewInSection: CategoryView?
    private var cellsCount = 0
    private var cellsCounts = [0]
    
    
    // MARK: - variables
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Almaty"
        label.font = Fonts.SFUIDisplay?.withSize(17)
        label.textColor = Colors.textColor
        return label
    }()
    let chooseCityButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Arrow1")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Colors.textColor
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(chooseCityButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func chooseCityButtonTapped() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let alertController = UIAlertController(title: "Select a city", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(pickerView)
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            self.cityLabel.text = self.selectedCity
        }
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        var height:NSLayoutConstraint = NSLayoutConstraint(
            item: alertController.view, attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1, constant: self.view.frame.height * 0.40)
        alertController.view.addConstraint(height);
        
        pickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity = cityes[row]
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityes.count
    }
    
    let foodsTableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionHeaderTopPadding = 24
        tableView.register(FoodTableViewCell.self, forCellReuseIdentifier: FoodTableViewCell.Identifier)
        tableView.backgroundColor = Colors.backgroundColor
        return tableView
    }()
    
    // MARK: - Private properties
    
    
    var banners = ["dodo1.png", "dodo2.png", "dodo3.png", "dodo4.png", "dodo5.png"]
    
    // MARK: - Lifecycle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundColor
        navigationController?.navigationBar.isHidden = true
        foodsTableView.delegate = self
        foodsTableView.dataSource = self
        headerView = BannerView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 112))
        headerViewInSection = CategoryView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 32))
        headerViewInSection?.delegate = self
        foodsTableView.tableHeaderView = headerView
        setupViews()
        setupConstraints()
        print("zapros na datu")
        APICaller.shared.getFoods{ [weak self] result in
            DispatchQueue.main.async {
                self?.fetchLocalStorageForAllFoods()
                print("zhdem daty")
                switch result{
                case .success(let foods):
                    self?.foods = foods
                    let a = foods.count
                    self?.cellsCount = a
                    let b = (self?.cellsCount ?? 0) / 5
                    for i in 1...5 {
                        self?.cellsCounts.append(b*i)
                    }
                    self?.foodsTableView.reloadData()
                    print(foods)
                    DataPersistenceManager.shared.deleteAllFoodsWith(model: self?.savedFoods ?? [AllFoods]()) { [weak self]
                        result in
                        switch result{
                        case.success:
                            print("Deleded")
                        case.failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    for i in 0...foods.count - 1 {
                        let indexPath = IndexPath(row: i, section: 0)
                        self?.downloadAllFoodsAt(indexPath: indexPath)
                    }
                    self?.cellsCount = foods.count
                case .failure(let error):
                    print("data nety")
                    if let count = self?.savedFoods.count {
                        for i in 0...count - 1 {
                            let indexPath = IndexPath(row: i, section: 0)
                            if let food = self?.savedFoods[indexPath.row]{
                                self?.foods.append(FoodElement(id: Int(food.id), name: food.name ?? "", price: Int(food.price), description: food.descriptions ?? "", quantity: Int(food.quantity), img: food.img ?? ""))
                            }
                        }
                    }
                    
                    self?.foodsTableView.reloadData()
                    print(error.localizedDescription)
                }

            }
        }
    }
    
    // MARK: - Functions
    func didSelectItem(index: Int, all: Int) {
        let a = cellsCount / all
        let indexPath = IndexPath(row: (a+1) * index, section: 0)
        foodsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func downloadTitleAt(indexPath: IndexPath){
        DataPersistenceManager.shared.downloadTitleWith(model: foods[indexPath.row]) { result in
            switch result{
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    private func downloadAllFoodsAt(indexPath: IndexPath){
        DataPersistenceManager.shared.downloadAllFoodsWith(model: foods[indexPath.row]) { result in
            switch result{
            case .success():
                print("saved")
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    private func fetchLocalStorageForAllFoods(){
        DataPersistenceManager.shared.fetchingAllFoodsFromDatabase { [weak self] result in
            switch result{
            case .success(let foods):
                self?.savedFoods = foods
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}

private extension MenuViewController {
    func setupViews(){
        view.addSubview(cityLabel)
        view.addSubview(chooseCityButton)
        view.addSubview(foodsTableView)
    }
    func setupConstraints(){
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        chooseCityButton.snp.makeConstraints { make in
            make.centerY.equalTo(cityLabel.snp.centerY)
            make.leading.equalTo(cityLabel.snp.trailing).inset(-8)
            make.height.equalTo(20)
        }
        foodsTableView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).inset(-24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(83)
        }
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodsTableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.Identifier, for: indexPath) as! FoodTableViewCell
        cell.configure(with: foods[indexPath.row])
        cell.backgroundColor = Colors.whiteBlack
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerViewInSection
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32+24
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let firstVisibleIndexPath = self.foodsTableView.indexPathsForVisibleRows?[0]
        for i in 0...4 {
            let there = IndexPath(row: i, section: 0)
            if let f = firstVisibleIndexPath?.row {
                if f >= cellsCounts[i] && f < cellsCounts[i+1] {
                    let there = IndexPath(row: i, section: 0)
                    headerViewInSection?.categoryCollectionView.scrollToItem(at: there, at: .centeredHorizontally, animated: false)
                    headerViewInSection?.categoryCollectionView.cellForItem(at: there)?.backgroundColor = Colors.tintColor.withAlphaComponent(0.4)
                }
                else{
                    headerViewInSection?.categoryCollectionView.cellForItem(at: there)?.backgroundColor = Colors.backgroundColor
                }
            }
        }
        if scrollView.contentOffset.y <= 112+24 {
            headerViewInSection?.layer.shadowColor = Colors.whiteBlack?.cgColor
        }else{
            headerViewInSection?.layer.shadowColor = Colors.blackWhite?.cgColor
            headerViewInSection?.layer.shadowOpacity = 0.1
            headerViewInSection?.layer.shadowOffset = CGSize(width: 0, height: 10)
            headerViewInSection?.layer.shadowRadius = 4
        }
    }
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){[weak self] _ in
            let downloadAction = UIAction(title: "Add to Basket", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self?.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}

