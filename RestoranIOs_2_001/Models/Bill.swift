//
//  Bill.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 25/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

struct Bill: Codable {

    let id_dinning_table: Int
    let id_user: Int
    let payment_type: String
    let reduction: Double
    let id_restaurant: Int
    let orders: [OrdersReceived]
    

  init(id_dinning_table: Int, id_user: Int, payment_type: String, reduction: Double, id_restaurant: Int, orders: [OrdersReceived] ) {
      self.id_dinning_table = id_dinning_table
      self.id_user = id_user
      self.payment_type = payment_type
      self.reduction = reduction
    self.id_restaurant = id_restaurant
    self.orders = orders
  }

}
  
class Bills: Decodable {

    let id_bill: Int
    let bill_time: String
    let id_user: Int
    let payment_type: String
    let reduction: Double
    let total_amount: Double
    let id_restaurant: Int
    let orders: [Orders]
   
    static func downloadBills(_ login: Login, _ apiLink: String, completed: @escaping (Result<[Bills], Error>) -> ()) -> [Bills] {
        var bills = [Bills]()
        let jwt = login.jwt
        
        let urlString = apiLink + "/rest/bills/all"
        let url = URL (string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let _: Void = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
            do {
                bills = try JSONDecoder().decode([Bills].self, from: data!)
                DispatchQueue.main.async {
                    completed(.success(bills))
                }
                }catch{
                    print("Bills Json error")
                }
            }
        }.resume()
        return bills
    }
    
    
}

class Orders: Decodable, Encodable {
    
    let id_order: Int
    let id_offer: Int
    let quantity: Double

    
}
