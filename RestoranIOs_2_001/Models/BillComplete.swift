//
//  BillComplete.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 25/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation


struct BillComplete: Codable {

    let id_bill: Int
    let id_dinning_table: Int
    let bill_time: String
    let id_user: Int
    let payment_type: String
    let reduction: Double
    let total_amount: Double
    let id_restaurant: Int

    
}


