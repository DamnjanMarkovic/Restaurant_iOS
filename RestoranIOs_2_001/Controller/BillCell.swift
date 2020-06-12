//
//  BillCell.swift
//  RestoranIOs
//
//  Created by Damnjan Markovic on 10/06/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class BillCell: UITableViewCell {

    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWaiterName: UILabel!
    @IBOutlet weak var lblFinalAmount: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
