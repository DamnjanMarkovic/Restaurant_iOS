//
//  ViewController.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 03/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit
import SVProgressHUD
import SSZipArchive

class ViewController: UIViewController {

    @IBOutlet weak var usernameLbl: UITextField!
    @IBOutlet weak var passwordfield: UITextField!
    var login: Login!
    let alertService = AlertService()
//    let apiLink = "https://restaurant-ios.herokuapp.com"
    let apiLink = "http://192.168.0.14:8080"
//    `heroku_915c4766c2c8a9a`
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginbtn(_ sender: Any) {
        guard
           let username = usernameLbl.text,
           let password = passwordfield.text
           else {return}
        let parameters = ["username": username, "password": password]
        loginUser(parametars: parameters as [String : Any]) { [weak self] (result) in
            switch result {
              case.success(let login):
                if login.role.first == "owner" {
                    self?.performSegue(withIdentifier: "loginToOwnerLogin", sender: login)
                } else if login.role.first == "manager_restaurant" {
                    self?.performSegue(withIdentifier: "loginToManagerLogin", sender: login);
                } else if login.role.first == "waiter_restaurant"{
                    self?.performSegue(withIdentifier: "loginToWaiterLogin", sender: login);
                }
                self!.usernameLbl.text = ""
                self!.passwordfield.text = ""
                
            case.failure(let error):
                guard let alert = self?.alertService.alert(message: error.localizedDescription) else {
                return
                }
                self?.present(alert, animated: true)
              }
            }
        }
          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let destination = segue.destination as? OwnerLogin, let login = sender as? Login {
                    destination.login = login
                    destination.apiLink = apiLink
            
              }
           if let destination = segue.destination as? ManagerLogin, let login = sender as? Login {
                    destination.login = login
                    destination.apiLink = apiLink
              }
            if let destination = segue.destination as? WaiterLogin, let login = sender as? Login {
                    destination.login = login
                    destination.apiLink = apiLink
               }
          }
        
        func loginUser(parametars: [String: Any], completion: @escaping(Result<Login, Error>) -> Void){
            let url = URL (string: apiLink + "/login")
            let jsonBody = try? JSONSerialization.data(withJSONObject: parametars, options: .prettyPrinted)
            var request = URLRequest(url: url!)
            request.httpBody = jsonBody
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                            
                guard (response as? HTTPURLResponse) != nil else {
                        completion(.failure(NetworkingError.badResponse))
                        return
                    }
                    if let unwrappedError = error {
                        completion(.failure(unwrappedError))
                        return
                    }
                    if let unwrappedData = data {
                        do {
                            _ = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                            if let login = try? JSONDecoder().decode(Login.self, from: unwrappedData) {
                                completion(.success(login))
                                    } else {
                                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                                        completion(.failure(errorResponse))
                                    }
                                } catch {
                                    completion(.failure(error))
                                }
                            }
                        }
                    }
                    task.resume()
    }
}


enum NetworkingError: Error {
    case badUrl
    case badResponse
    case badEncoding
}


/*
 import Cocoa

 class ViewController: NSViewController {

     @IBOutlet weak var imgPass: NSImageView!
     @IBOutlet weak var imgUsername: NSImageView!
     @IBOutlet weak var usernameLbl: NSTextField!
     @IBOutlet weak var passwordfield: NSSecureTextField!
     
     
     let alertService = AlertService()
     var login: Login!
     //let apiLink = "https://restaurant-ios.herokuapp.com"
     let apiLink = "http://192.168.0.14:8080"
     
     override func viewDidLoad() {
         super.viewDidLoad()

         // Do any additional setup after loading the view.
     }

  

     @IBAction func loginBtn(_ sender: Any) {
         let username = usernameLbl.stringValue
         let password = passwordfield.stringValue
           
         let parameters = ["username": username, "password": password]
         loginUser(parametars: parameters as [String : Any]) { [weak self] (result) in
             switch result {
               case.success(let login):
                 if login.role.first == "owner" {
                    self?.performSegue(withIdentifier: "toEntryForm", sender: login)
                 } else  {
                    self?.performSegue(withIdentifier: "toManager", sender: login);
                 }
                 case.failure(let error):
                     print(error.localizedDescription)
                 return
             }
         }

     }

   
     
     override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
         if let destination = segue.destinationController as? OwnerEntryForm {
             destination.login = login
             destination.apiLink = apiLink
         }
         if let destination = segue.destinationController as? ManagerEntryForm {
             destination.login = login
             destination.apiLink = apiLink
         }
     }
     func loginUser(parametars: [String: Any], completion: @escaping(Result<Login, Error>) -> Void){

         let url = URL (string: apiLink + "/login")
         let jsonBody = try? JSONSerialization.data(withJSONObject: parametars, options: .prettyPrinted)
         var request = URLRequest(url: url!)
         request.httpBody = jsonBody
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         let session = URLSession.shared
         let task = session.dataTask(with: request) { (data, response, error) in
             DispatchQueue.main.async {
                 guard (response as? HTTPURLResponse) != nil else {
                         completion(.failure(NetworkingError.badResponse))
                         return
                     }
                     if let unwrappedError = error {
                         completion(.failure(unwrappedError))
                         return
                     }
                     if let unwrappedData = data {
                         do {
                             _ = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                             if let login = try? JSONDecoder().decode(Login.self, from: unwrappedData) {
                                 completion(.success(login))
                                     } else {
                                         let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                                         completion(.failure(errorResponse))
                                     }
                                 } catch {
                                     completion(.failure(error))
                                 }
                             }
                         }
                     }
                     task.resume()
     }
 }

 enum NetworkingError: Error {
     case badUrl
     case badResponse
     case badEncoding
 }
 */


/*
     
     
     if error == nil {
         do {
             self.login = try JSONDecoder().decode(Login.self, from: data!)
             //print(self.login!)
             DispatchQueue.main.async {
                 completion(.success(self.login))
             }
             } catch {
                 print("krc")
             }
     }
     else {
         print(error!.localizedDescription)
     }
 }.resume()
 */
