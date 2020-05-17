//
//  IngredientSaveRequest.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 30/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

class IngredientSaveRequest: Codable {
   
    let ingredient_name: String
    let purchase_price: Double
    let quantity_measure: String
    let id_restaurant: Int
    let quantityUpdating: Double
    
    init(ingredient_name: String, purchase_price: Double,
         quantity_measure: String, id_restaurant: Int,
         quantityUpdating: Double) {
        self.ingredient_name = ingredient_name
        self.purchase_price = purchase_price
        self.quantity_measure = quantity_measure
        self.id_restaurant = id_restaurant
        self.quantityUpdating = quantityUpdating

    }
    

    
    static func saveOrUpdateIngredient( _ jwt: String, _ ingred: IngredientSaveRequest, _ apiLink: String){

        let urlString = apiLink + "/rest/ingredients/save"
        let url = URL (string: urlString)
        let jsonBody = try? JSONEncoder().encode(ingred)
        var request = URLRequest(url: url!)
        request.httpBody = jsonBody as Data?
        request.httpMethod = "POST"
        request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let _: Void = session.dataTask(with: request) { (data, response, error) in
          if error == nil {
                  print("radi, jbt")

              }
              else { print ("krc")
              }
          }.resume()
        
        
    }
    
    
}
