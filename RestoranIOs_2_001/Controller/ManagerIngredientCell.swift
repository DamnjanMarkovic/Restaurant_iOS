//
//  ManagerIngredientCell.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 29/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class ManagerIngredientCell: UITableViewCell {

    @IBOutlet weak var lblIngredientName: UILabel!
    @IBOutlet weak var lblIngredientPrice: UILabel!
    
    @IBOutlet weak var lblIngredientQuantityAvailable: UILabel!
    
    @IBOutlet weak var lblIngredientMeasureType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
