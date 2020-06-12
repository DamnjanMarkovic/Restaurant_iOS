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
        Image.getImage(login.jwt, restaurant.id_image, apiLink){(result) in switch result {
        case.success(let data):
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.imgView.image = image
            }
        case.failure( _):
            print("nije stigla slika")
            }
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
    }
        
}
