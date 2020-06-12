//
//  RestaurantsList.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 04/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class OwnerRestaurantList: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var restaurants = [Restaurant]()
    var login: Login!
    var apiLink: String!
    var imageTaken: UIImage?
    var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var tfRestaurantName: UITextField!
    @IBOutlet weak var tfRestaurantStreet: UITextField!
    @IBOutlet weak var tfRestaurantNo: UITextField!
    @IBOutlet weak var tfRestaurantCity: UITextField!
    @IBOutlet weak var imgNewRestaurant: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadRestaurants {
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func btnAddImageNewRestaurant(_ sender: UIButton) {
        self.imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action:UIAlertAction) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        imagePickerController.allowsEditing = true
        present(actionSheet, animated: true, completion: nil)
        imagePickerController.allowsEditing = true
        
    }
    @IBAction func btnAddNewRestaurant(_ sender: UIButton) {
        
        if (!tfRestaurantName.text!.isEmpty && !tfRestaurantStreet.text!.isEmpty && !tfRestaurantNo.text!.isEmpty && !tfRestaurantCity.text!.isEmpty) {

            let newRestaurant = Restaurant(name_restaurant: tfRestaurantName.text!, street: tfRestaurantStreet.text!, number: Int(tfRestaurantNo.text!)!, city: tfRestaurantCity.text!, id_image: 12)
   

            let newImage: Media = Media(withImage: self.imageTaken!, forKey: "imageFile", filename: newRestaurant.name_restaurant + ".Image.jpeg")!
                    
            Restaurant.saveRestaurant(self.login.jwt, newImage, newRestaurant, self.apiLink)
            tfRestaurantName.text = ""
            tfRestaurantStreet.text = ""
            tfRestaurantNo.text = ""
            tfRestaurantCity.text = ""
            tableView.reloadData()
        }
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageTaken = image
            imgNewRestaurant.image = imageTaken
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
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
        
    }
    
    
    func downloadRestaurants(completed: @escaping () -> ()) {
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

