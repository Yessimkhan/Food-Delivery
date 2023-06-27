//
//  DataPersistenceManager.swift
//  Food Delivery
//
//  Created by Yessimkhan Zhumash on 25.06.2023.
//


import Foundation
import UIKit
import CoreData

class DataPersistenceManager{
    
    enum DatabaseError: Error{
        case failedToSavedData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: FoodElement, completion: @escaping(Result<Void, Error>)->Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = FoodItem(context: context)
        item.id = Int64(model.id)
        item.descriptions = model.description
        item.img = model.img
        item.name = model.name
        item.price = Int64(model.price)
        item.quantity = Int64(model.quantity)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedToSavedData))
        }
    }
    
    func downloadAllFoodsWith(model: FoodElement, completion: @escaping(Result<Void, Error>)->Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = AllFoods(context: context)
        item.id = Int64(model.id)
        item.descriptions = model.description
        item.img = model.img
        item.name = model.name
        item.price = Int64(model.price)
        item.quantity = Int64(model.quantity)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedToSavedData))
        }
    }
    
    func fetchingTitlesFromDatabase(completion: @escaping (Result<[FoodItem], Error >) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<FoodItem>
        request = FoodItem.fetchRequest()
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        }catch{
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    func fetchingAllFoodsFromDatabase(completion: @escaping (Result<[AllFoods], Error >) -> Void) {
        print("get all foods")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<AllFoods>
        request = AllFoods.fetchRequest()
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        }catch{
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    func deleteTitleWith(model: FoodItem, completion: @escaping (Result<Void, Error >)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
    func deleteAllFoodsWith(model: [AllFoods], completion: @escaping (Result<Void, Error >)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = AllFoods.fetchRequest()
        // Create a batch delete request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try context.execute(batchDeleteRequest)
            try context.save()
        }catch{
            print("Error deleting data: \(error)")
        }
    }
}

