//
//  DinningTable.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 05/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

struct DinningTable:Codable {
    
    
        let id_dinningTable: Int
        let table_number: Int
        let id_restaurant: Int
        //var login: Login!
    

    
    static func downloadOccupiedDinningTables(_ login: Login, _ apiLink: String, completed: @escaping (Result<[DinningTable], Error>) -> ()) -> [DinningTable]{
        var occupiedDinningTables = [DinningTable]()
        let idRest: String
        idRest = "\(String(describing: login.id_restaurant))"
        let urlString = apiLink + "/rest/dinningTable/getOccupiedTables/" + idRest
        let url = URL (string: urlString)
        let jwt = login.jwt
           var request = URLRequest(url: url!)
           request.httpMethod = "GET"
           request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
               let session = URLSession.shared
               let _: Void = session.dataTask(with: request) { (data, response, error) in
                   if error == nil {
                       do {
                           occupiedDinningTables = try JSONDecoder().decode([DinningTable].self, from: data!)
                           //print(self.dinningTable!)
                           DispatchQueue.main.async {
                           completed(.success(occupiedDinningTables))
                           }
                           } catch {
                               print("Json error")
                           }
                   }
               }.resume()
        return occupiedDinningTables
       }
    
    
}
