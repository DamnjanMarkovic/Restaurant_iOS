//
//  Images.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 19/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

class Image: Decodable, Encodable {

    let id_image: Int
    let imageLocation: String
    let imagename: String


    static func getImage(_ jwt: String,_ id_image: Int, _ apiLink:String, completed: @escaping (Result<Data, Error>) -> ()) -> () {


      let urlString = apiLink + "/rest/images/getImageOnID/" + "\(id_image)"
      let url = URL (string: urlString)
      var request = URLRequest(url: url!)
      request.httpMethod = "GET"
      request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
      let session = URLSession.shared
      session.dataTask(with: request) { (data, response, error) in
          if error == nil {
              completed(.success(data!))
          }
      }.resume()
       
    }
    
    
}
