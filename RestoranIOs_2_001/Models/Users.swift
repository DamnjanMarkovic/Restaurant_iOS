//
//  UserOriginal.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 03/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//
import UIKit
import Foundation


class Users: Decodable, Encodable {

    let id_user: Int
    var userFirstName: String?
    var id_image: Int?
    let role: [String]?
    let id_restaurant: Int
    
    
    init(id_user:Int, userFirstName: String, id_image: Int, roles: [String], id_restaurant: Int) {
        self.id_user = id_user
        self.userFirstName = userFirstName
        self.id_image = id_image
        self.role = roles
        self.id_restaurant = id_restaurant

    }
    
    static func saveUser( _ jwt: String, _ imageNew: Media, _ newUser: NewUserRequest, _ apiLink: String){

             let urlString = apiLink + "/rest/users/loadUser"
             guard let url = URL (string: urlString) else { return }
             var request = URLRequest(url: url)
             request.httpMethod = "POST"
             let boundary = "Boundary-\(NSUUID().uuidString)"
             request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let param = [
            "userName"          : newUser.userName,
            "password"          : newUser.password,
            "userFirstName"     : newUser.userFirstName,
            "id_image"         :  newUser.id_image,
            "id_restaurant"     : newUser.id_restaurant,
            "role"              : newUser.role
            ] as [String : Any]
            
            
            let bodyFinal = Users.createBody(withParameters: param, imageNew: imageNew, boundary: boundary)
             
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

//     extension Data {
//         mutating func append(_ string: String) {
//             if let data = string.data(using: .utf8) {
//                 append(data)
//             }
//         }
//    }
//     typealias Parametars = [String: Any]
//
