//
//  WaiterCellOrders.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 20/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class WaiterOrdersCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
