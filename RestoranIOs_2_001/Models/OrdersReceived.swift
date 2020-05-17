//
//  Orders.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 20/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

struct OrdersReceived: Codable {

    
    let id_offer: Int
    let quantity: Int
    let id_restaurant: Int
    let id_table: Int

    init(id_offer: Int, quantity: Int,
         id_restaurant: Int, id_table: Int ) {
        self.id_offer = id_offer
        self.quantity = quantity
        self.id_restaurant = id_restaurant
        self.id_table = id_table

    }
    
     static func downloadOrders(_ jwt: String,_ id_dinningTable: Int, _ apiLink:String, completed: @escaping (Result<[OrdersReceived], Error>) -> ()) -> [OrdersReceived] {
         var orderReceived = [OrdersReceived]()
         let tableNum1: String
        tableNum1 = "\(id_dinningTable)"
         let urlString = apiLink + "/rest/orders/getOpenOrders/" + tableNum1
         let url = URL (string: urlString)
        
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
                let session = URLSession.shared
                let _: Void = session.dataTask(with: request) { (data, response, error) in
                    if error == nil {
                        do {
                            orderReceived = try JSONDecoder().decode([OrdersReceived].self, from: data!)
                           
                            DispatchQueue.main.async {
                            completed(.success(orderReceived))
                            }
                            } catch {
                                print("Json error")
                            }
                    }
                }.resume()
        return orderReceived
        }
    
    
    
    
    
}
