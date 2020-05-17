//
//  Bill.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 25/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

struct Bill: Codable {

    let id_dinning_table: Int
    let id_user: Int
    let payment_type: String
    let reduction: Double
    let id_restaurant: Int
    let orders: [OrdersReceived]
    

  init(id_dinning_table: Int, id_user: Int, payment_type: String, reduction: Double, id_restaurant: Int, orders: [OrdersReceived] ) {
      self.id_dinning_table = id_dinning_table
      self.id_user = id_user
      self.payment_type = payment_type
      self.reduction = reduction
    self.id_restaurant = id_restaurant
    self.orders = orders
  }

}
  
