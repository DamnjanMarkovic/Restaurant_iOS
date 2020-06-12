//
//  Restaurant.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 04/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

class Restaurant: Codable {

    
    let id_restaurant: Int
    let name_restaurant: String
    let street: String
    let number: Int
    let city: String
    let id_image: Int
    
       init(name_restaurant: String, street: String, number: Int, city: String, id_image: Int) {
    
        self.id_restaurant = 121
        self.name_restaurant = name_restaurant
       self.street = street
       self.number = number
       self.city = city
       self.id_image = id_image
       }
    
    
    
    
    static func downloadRestaurants(_ jwt: String,_ apiLink: String, completed: @escaping (Result<[Restaurant], Error>) -> ()) -> [Restaurant]{
        var restaurants = [Restaurant]()
        let url = URL (string: apiLink + "/rest/restaurants/all")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let _: Void = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
            do {
                restaurants = try JSONDecoder().decode([Restaurant].self, from: data!)
                DispatchQueue.main.async {
                    completed(.success(restaurants))
                    }
                }catch{
                        print("Json error")
                    }
                }
        }.resume()
        return restaurants
    }
    
    static func saveRestaurant( _ jwt: String, _ imageNew: Media, _ newRestaurant: Restaurant, _ apiLink: String){

        let urlString = apiLink + "/rest/restaurants/loadRestaurant"
        guard let url = URL (string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
       let param = [
         "name_restaurant"          : newRestaurant.name_restaurant,
         "street"          : newRestaurant.street,
         "number"     : newRestaurant.number,
         "city"         : newRestaurant.city,
         "id_image"     : newRestaurant.id_image

       ] as [String : Any]
       
       
       let bodyFinal = Restaurant.createBody(withParameters: param, imageNew: imageNew, boundary: boundary)
        
        request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        request.setValue("(myRequestData.length)", forHTTPHeaderField: "Content-Length")
        request.httpBody = bodyFinal as Data
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
          if error == nil {
                    print("radi, jbt")
                    print(response!)
              }
          else { print (error!)
              }
          }.resume()
    }
    
    static func createBody(withParameters param: Parametars, imageNew: Media, boundary: String) -> Data {
      
       var bodyFinal = Data()
       let mimetype = "neki dodatni opis slike"
        for (key, value) in param {
                       
           bodyFinal.append("--\(boundary)\r\n")
               bodyFinal.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
               bodyFinal.append("\(value)\r\n")
           }

             bodyFinal.append("--\(boundary)\r\n")
             bodyFinal.append("Content-Disposition:form-data; name=\"imageFile\"; filename=\"\(imageNew.filename)\"\r\n")
             bodyFinal.append("Content-Type: \(mimetype)\r\n\r\n")
             bodyFinal.append(imageNew.data)
             bodyFinal.append("\r\n")
             bodyFinal.append("--\(boundary)--\r\n")
           
       return bodyFinal as Data
    }

    
    
    
    
}



