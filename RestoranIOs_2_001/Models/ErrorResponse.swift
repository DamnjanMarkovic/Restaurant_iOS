//
//  ErrorResponse.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 22/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable, LocalizedError {
    
    let message: String
    
    var errorDescription: String? { return message }
    
//    let NSLocalizedDescription : String
//    var errorDescription: String? { return message }
    
    
}
