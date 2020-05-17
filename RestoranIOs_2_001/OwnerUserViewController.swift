//
//  UserViewController.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 03/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class OwnerUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var login: Login!
    var apiLink: String!
    var users = [Users]()
    //let newUser1: Users! = nil

    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var status: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var imageLink: UITextField!
    @IBOutlet weak var idRestaurant: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadAllUsers {
            self.tableView.reloadData()
        }
     
        tableView.delegate = self
        tableView.dataSource = self
        

    }
    

    
    func savenewUser(newUser: (Users), completion: @escaping() -> ()){
     

     let urlString = apiLink + "/rest/users/load"
     let url = URL (string: urlString)
     let jwt = login.jwt
        let jsonBody = try? JSONEncoder().encode(newUser)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = jsonBody as Data?
        request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     
            let session = URLSession.shared
            let _: Void = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    print("radi, jbt")

                }
                else { print ("krc")
                }
            }.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerUserTableViewCell") as? OwnerUserTableViewCell else { return UITableViewCell() }
        

        cell.lblName.text = users[indexPath.row].userFirstName
        cell.lblRole.text = users[indexPath.row].role?.first


        ImagesData.getImage(login.jwt, (Int) ((users[indexPath.row].imageLink!))!, apiLink){(result) in switch result {
        case.success(let dataZip):
            
            let image = UIImage(data: dataZip)
            
        DispatchQueue.main.async {
            cell.slika.image = image
        }
        case.failure( _):
            print("nije stigla slika")
        }
            
        }
        return cell
    }

    
    @IBAction func back(_ sender: Any) {
     performSegue(withIdentifier: "userToOwnerLogin", sender: self)
    }


    func downloadAllUsers(completed: @escaping () -> ()) {
        
        let jwt = login.jwt
        let url = URL (string: apiLink + "/rest/users/all")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let _: Void = session.dataTask(with: request) { (data, response, error) in
            
            if error == nil {
                do {
                    self.users = try JSONDecoder().decode([Users].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("USER Json error")
                }
            }
        }.resume()
        
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OwnerLogin {
            destination.login = login!
            destination.apiLink = apiLink
        }
        if let destination = segue.destination as? OwnerLogin {
                destination.login = login!
            destination.apiLink = apiLink
        }
    }
}

