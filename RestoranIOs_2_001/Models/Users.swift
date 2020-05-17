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
    var imageLink: String?
    let role: [String]?
    let id_restaurant: Int
    
    
    init(id_user:Int, userFirstName: String, imageLink: String, roles: [String], id_restaurant: Int) {
        self.id_user = id_user
        self.userFirstName = userFirstName
        self.imageLink = imageLink
        self.role = roles
        self.id_restaurant = id_restaurant

    }
    
}

 
/*

 import UIKit
 import Foundation

 class LocationModel: NSObject {
     
     var id: Float?
     var name: String?
     var address: String?
     var latitude: String?
     var longitude: String?
     
     override init(){
         
     }
     
     init(id: Float, name: String, address: String, latitude: String, longitude: String){
         self.id = id
         self.name = name
         self.address = address
         self.latitude = latitude
         self.longitude = longitude
         
     }
     
     override var description: String {
         
         return "name: \(String(describing: name)), id: \(String(describing: id)), address: \(String(describing: address)), latitude: \(String(describing: latitude)), longitude: \(String(describing: longitude))"
         
     }
     
     
     
     

 }
 */
