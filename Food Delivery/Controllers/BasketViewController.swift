//
//  BasketViewController.swift
//  Food Delivery
//
//  Created by Yessimkhan Zhumash on 22.06.2023.
//

import UIKit

class BasketViewController: UIViewController {
    
    private var foods: [FoodItem] = [FoodItem]()
    
    private let downloadedTable: UITableView = {
        let table = UITableView()
        table.register(FoodTableViewCell.self, forCellReuseIdentifier: FoodTableViewCell.Identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundColor
        title = "Basket"
        view.addSubview(downloadedTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    private func fetchLocalStorageForDownload(){
        DataPersistenceManager.shared.fetchingTitlesFromDatabase { [weak self] result in
            switch result{
            case .success(let foods):
                self?.foods = foods
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    override func viewDidLayoutSubviews() {
        downloadedTable.frame = view.bounds
    }
    
    
}
extension BasketViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.Identifier, for: indexPath) as? FoodTableViewCell else {
            return UITableViewCell()
        }
        let foods = foods[indexPath.row]
        cell.configure(with: FoodElement(id: Int(foods.id), name: foods.name ?? "noname", price: Int(foods.price), description: foods.descriptions ?? "", quantity: Int(foods.quantity), img: foods.img ?? ""))
        cell.backgroundColor = Colors.whiteBlack
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: foods[indexPath.row]) { [weak self]
                result in
                switch result{
                case.success:
                    print("Deleded")
                case.failure(let error):
                    print(error.localizedDescription)
                }
                self?.foods.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .insert:
            print("tapped insert")
        default:
            break;
        }
    }
}
