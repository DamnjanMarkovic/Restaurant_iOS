//
//  RestaurantsList.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 04/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class OwnerRestaurantList: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    @IBOutlet weak var tableView: UITableView!
    
        var restaurants = [Restaurant]()
        var login: Login!
        var apiLink: String!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            downloadJSON {
                self.tableView.reloadData()
            }
         
            tableView.delegate = self
            tableView.dataSource = self
        }
        
    
    
    @IBAction func back(_ sender: Any) {
         performSegue(withIdentifier: "restaurantsToOwnerLogin", sender: self)
    }
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = restaurants[indexPath.row].name_restaurant.capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "toShowRestaurant", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OwnerRestaurantShow {
            destination.restaurant = restaurants[(tableView.indexPathForSelectedRow?.row)!]
            destination.login = login!
            destination.apiLink = apiLink
        }
        if let destination = segue.destination as? OwnerLogin {
                destination.login = login!
            destination.apiLink = apiLink
        }
    }

        
    func downloadJSON(completed: @escaping () -> ()) {
        let jwt = login.jwt
        let url = URL (string: apiLink + "/rest/restaurants/all")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let _: Void = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
            do {
                self.restaurants = try JSONDecoder().decode([Restaurant].self, from: data!)
                DispatchQueue.main.async {
                completed()
                    }
                }catch{
                        print("Json error")
                    }
                }
        }.resume()
    }

}

