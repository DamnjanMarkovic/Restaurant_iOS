//
//  User.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 03/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

class Login: Decodable {

    let id_user: Int
    let jwt: String
    let userName: String
    let userFirstName: String
    let id_image: Int
    let role: [String]
    let id_restaurant: Int
   
}
