//
//  Roles.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 09/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

class Roles: Decodable, Encodable {
    
        //var roleId: Int?
        var role: String?

    init(){
        
    }
    
    init(role: String) {
        //self.roleId = roleId
        self.role = role

    }
    
    
}
