//
//  ManagerLogin.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 03/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class ManagerLogin: UIViewController {
    var login: Login!
    var apiLink: String!
    @IBOutlet weak var lblWelcom: UILabel!

    @IBOutlet weak var imageLoginManager: UIImageView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageLogin()
        navigationController?.isNavigationBarHidden = false


    }
    func setImageLogin() {
        lblWelcom.text = login.userFirstName
        Image.getImage(login.jwt, login.id_image, apiLink){(result) in switch result {
        case.success(let data):
            let image = UIImage(data: data)
        DispatchQueue.main.async {
            self.imageLoginManager.image = image
        }
        case.failure( _):
            print("nije stigla slika")
        }
        }
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ManagerOffersViewController {
            destination.login = login!
            destination.apiLink = apiLink
        }
        if let destination = segue.destination as? ManagerIngredientsTable {
            destination.login = login!
            destination.apiLink = apiLink
        }
    }

}
