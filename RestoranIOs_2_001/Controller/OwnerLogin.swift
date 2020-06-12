//
//  OwnerLogin.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 03/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class OwnerLogin: UIViewController {
    var login: Login!
    var apiLink: String!
    @IBOutlet weak var lblWelcom: UILabel!
    @IBOutlet weak var loginImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        lblWelcom.text = "Welcome, \n " + login.userFirstName.capitalized
        
        
        Image.getImage(login.jwt, login.id_image, apiLink){(result) in switch result {
        case.success(let data):
            let image = UIImage(data: data)
        DispatchQueue.main.async {
            self.loginImage.image = image
        }
        case.failure( _):
            print("nije stigla slika")
        }
        }
        
        
    }
    
    @IBAction func btnBills(_ sender: UIButton) {
    performSegue(withIdentifier: "ownerToBills", sender: self)
    }
    
    @IBAction func btnRestaurant(_ sender: UIButton) {
        performSegue(withIdentifier: "ownerToRestaurantList", sender: self)
    }
    @IBAction func btnUsers(_ sender: Any) {
        performSegue(withIdentifier: "ownerToUsers", sender: self)
    }


 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OwnerUserViewController {
            destination.login = login!
            destination.apiLink = apiLink
        }
        else if let destination = segue.destination as? OwnerRestaurantList {
            destination.login = login!
            destination.apiLink = apiLink
        }
        else if let destination = segue.destination as? BillViewController {
            destination.login = login!
            destination.apiLink = apiLink
        }
    }

}
