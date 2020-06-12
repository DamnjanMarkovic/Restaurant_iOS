//
//  OfferSelectCell.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 07/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class WaiterOffersSelectCell: UITableViewCell {



    @IBOutlet weak var lblOrderQuantity: UILabel!
    @IBOutlet weak var lblNameOrder: UILabel!
    @IBOutlet weak var lblNonAlcoholName: UILabel!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblAlcoholName: UILabel!
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var imgNoNAlcohol: UIImageView!
    @IBOutlet weak var imgAlcohol: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        btnDeleteOutlet.layer.cornerRadius = 20
//          btnDeleteOutlet.layer.borderColor = UIColor.black.cgColor
//          btnDeleteOutlet.layer.borderWidth = 2

        // Configure the view for the selected state
        
        
        
    }
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    


}


/*
 import Foundation
 import UIKit

 class AvailableOffers: Decodable {
     
     let idOffer: Int
     let restaurant_offer_name: String?
     let restaurant_offer_price: Double?
     let offer_type: String?
     let image: String
     let ingredientsInOffer: [AvailableIngredients]
     
     
     
     
 }


 /*
  
  
  import Foundation
  import UIKit

  class AvailableIngredients: Decodable, Encodable {
      let ingredient_name: String
      let purchase_price: Double
      let quantity_measure: String
      let quantity: Double
      let quantityAvailable: Double
      
  }
  */
 */
