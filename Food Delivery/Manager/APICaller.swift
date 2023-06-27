//
//  APICaller.swift
//  Food Delivery
//
//  Created by Yessimkhan Zhumash on 25.06.2023.
//

import Foundation

enum APIError: Error{
    case failedTorgetData
}

class APICaller {
    static let shared = APICaller()
    func getFoods(compeletion: @escaping (Result<[FoodElement], Error>) -> Void){
        let headers = [
            "X-RapidAPI-Key": "f1643413bemshc75206e3f4c74c4p12ae1ejsn9d6c62780641",
            "X-RapidAPI-Host": "pizza-and-desserts.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://pizza-and-desserts.p.rapidapi.com/pizzas")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            let string = String(data: data, encoding: .utf8)
            print(string)
            do{
                let decoder = JSONDecoder()
                print()
                let results = try decoder.decode(Food.self,from: data)
                compeletion(.success(results))
                print("success get Foods")
                
                
            }catch{
                print("Nothing has been retrieved! \(error)")
                compeletion(.failure(APIError.failedTorgetData ))
            }
        }
        
        task.resume()
    }
    
}
