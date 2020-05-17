//
//  Offers.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 03/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation

struct Offers:Decodable {
    
        let idOffer: Int
        let restaurant_offer_name:String
        let restaurant_offer_price: Double
        let offer_type: String
        let id_image: Int

}



//bilo je let id: Int
