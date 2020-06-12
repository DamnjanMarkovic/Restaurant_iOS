//
//  NewUserRequest.swift
//  RestoranIOs
//
//  Created by Damnjan Markovic on 10/06/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

class NewUserRequest: Decodable, Encodable {

 
    let userName: String
    let password: String
    let userFirstName: String
    let id_image: Int
    let id_restaurant: Int
    let role: String
    
    
    init(userName: String, password: String, userFirstName: String,
         id_image: Int, id_restaurant: Int, role: String) {
        self.userName = userName
        self.password = password
        self.userFirstName = userFirstName
        self.id_image = id_image
        self.id_restaurant = id_restaurant
        self.role = role
    }
   
}
