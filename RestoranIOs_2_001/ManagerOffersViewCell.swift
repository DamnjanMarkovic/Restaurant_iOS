//
//  OffersViewCell.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 03/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class ManagerOffersViewCell: UITableViewCell {

    @IBOutlet weak var offerName: UILabel!
    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var offerPrice: UILabel!
    
    @IBOutlet weak var nameNonAlcohol: UILabel!
    @IBOutlet weak var priceNonAlcohol: UILabel!
    @IBOutlet weak var imageNonAlcohol: UIImageView!
    
    @IBOutlet weak var nameFood: UILabel!
    @IBOutlet weak var priceFood: UILabel!
    @IBOutlet weak var imageFood: UIImageView!
    
    
    @IBOutlet weak var btnIngredientDelete: UIButton!
    @IBOutlet weak var lblIngredientQuantityCell: UILabel!
    
    @IBAction func btnDeleteIngredientAction(_ sender: Any) {
    }
    @IBOutlet weak var btnDeleteIngredient: UIButton!
    @IBOutlet weak var lblIngredientMeasureCell: UILabel!
    @IBOutlet weak var lblIngredientNameCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
