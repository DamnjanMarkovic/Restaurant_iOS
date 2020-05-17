//
//  AvailableOffers.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 11/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

import UIKit

class AvailableOffers: Decodable {
    
    let idOffer: Int
    let restaurant_offer_name: String
    let restaurant_offer_price: Double
    let offer_type: String
    let id_image: Int
    let ingredientsInOffer: [AvailableIngredients]
    
    
    static func downloadOffersOnRestaurant(_ jwt: String,_ idRest: Int, _ apiLink:String, completed: @escaping (Result<[AvailableOffers], Error>) -> ()) -> [AvailableOffers] {
        var availableOffers = [AvailableOffers]()
        let idRest = "\(String(describing: idRest))"
        let urlString = apiLink + "/rest/offers/availableOffers/" + idRest
        let url = URL (string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let _: Void = session.dataTask(with: request) { (data, response, error) in
           if error == nil {
           do {
               availableOffers = try JSONDecoder().decode([AvailableOffers].self, from: data!)

               DispatchQueue.main.async {
                completed(.success(availableOffers))
                   }
               }catch{
                       print("Json error")
                   }
               }
           }.resume()
        return availableOffers
    }
    
    
    static func downloadAllOffers(_ jwt: String, _ apiLink:String, completed: @escaping (Result<[AvailableOffers], Error>) -> ()) -> [AvailableOffers] {
           var availableOffers = [AvailableOffers]()
           let urlString = apiLink + "/rest/offers/allAvailableOffers"
           let url = URL (string: urlString)
           var request = URLRequest(url: url!)
           request.httpMethod = "GET"
           request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
           let session = URLSession.shared
           let _: Void = session.dataTask(with: request) { (data, response, error) in
              if error == nil {
              do {
                  availableOffers = try JSONDecoder().decode([AvailableOffers].self, from: data!)

                  DispatchQueue.main.async {
                   completed(.success(availableOffers))
                      }
                  }catch{
                          print("Json error")
                      }
                  }
              }.resume()
           return availableOffers
       }
    
}

