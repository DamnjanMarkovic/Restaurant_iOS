//
//  RestaurantShowController.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 04/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class OwnerRestaurantShow: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    var login: Login!
    var apiLink: String!
    var restaurant: Restaurant!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = restaurant?.name_restaurant
        lblStreet.text = restaurant?.street
        lblCity.text = restaurant?.city
        lblNumber.text = "\((restaurant?.number)!)"
        
        /*
        
        if let url = URL(string: restaurant.image) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            if let data = data {
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.imgView.image = image
            }
        }

        }
    
        }*/
}
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "restaurantToRestaurants", sender: self)
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OwnerRestaurantList {
            destination.login = login!
            destination.apiLink = apiLink
        }

    }
    
}
