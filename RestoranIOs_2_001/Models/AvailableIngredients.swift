//
//  AvailableIngredients.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 11/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation
import UIKit



class AvailableIngredients: Decodable, Encodable {
    let ingredient_name: String
    let purchase_price: Double
    let quantity_measure: String
    let quantity: Double
    let quantityAvailable: Double
    
 init(ingredient_name: String, purchase_price: Double,
      quantity_measure: String,
      quantity: Double, quantityAvailable: Double) {
     self.ingredient_name = ingredient_name
     self.purchase_price = purchase_price
     self.quantity_measure = quantity_measure
     self.quantity = quantity
     self.quantityAvailable = quantityAvailable
    
    }
    
    static func downloadIngredientsInRestaurant(_ jwt: String,_ idRest: Int, _ apiLink:String, completed: @escaping (Result<[AvailableIngredients], Error>) -> ()) -> [AvailableIngredients] {
        var availableIngredients = [AvailableIngredients]()
        let idRest = "\(String(describing: idRest))"
        let urlString = apiLink + "/rest/ingredients/restaurant/" + idRest
        let url = URL (string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let _: Void = session.dataTask(with: request) { (data, response, error) in
           if error == nil {
           do {
               availableIngredients = try JSONDecoder().decode([AvailableIngredients].self, from: data!)

               DispatchQueue.main.async {
                completed(.success(availableIngredients))
                   }
               }catch{
                       print("Json error")
                   }
               }
           }.resume()
        return availableIngredients
    }
    static func downloadAllIngredients(_ jwt: String, _ apiLink:String, completed: @escaping (Result<[AvailableIngredients], Error>) -> ()) -> [AvailableIngredients] {
        var allIngredients = [AvailableIngredients]()
        let urlString = apiLink + "/rest/ingredients/all"
        let url = URL (string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let _: Void = session.dataTask(with: request) { (data, response, error) in
           if error == nil {
           do {
               allIngredients = try JSONDecoder().decode([AvailableIngredients].self, from: data!)

               DispatchQueue.main.async {
                completed(.success(allIngredients))
                   }
               }catch{
                       print("Json error")
                   }
               }
           }.resume()
        return allIngredients
    }
    
    
}


