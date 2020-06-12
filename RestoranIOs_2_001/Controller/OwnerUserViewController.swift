//
//  UserViewController.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 03/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class OwnerUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if  pickerView == self.rolePicker {
            return roleTypes.count
        } else {
            return restaurants.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if  pickerView == self.rolePicker {
            return roleTypes[row]
        } else {
            return restaurants[row].name_restaurant
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if  pickerView == self.rolePicker {
            role.text = roleTypes[row]
        } else {
            idRestaurant.text = restaurants[row].name_restaurant
            
        }
    }
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var login: Login!
    var apiLink: String!
    var users = [Users]()
    var imageTaken: UIImage?
    var restaurantPicker = UIPickerView()
    var rolePicker = UIPickerView()
    let roleTypes = ["waiter_restaurant", "manager_restaurant"]
    
    
    var restaurants: [Restaurant]!
    var id_restaurant: Int?
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var idRestaurant: UITextField!
    var imagePickerController = UIImagePickerController()
    
    @IBAction func btnSelectNewUserImage(_ sender: UIButton) {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageTaken = image
            imageNewUser.image = imageTaken
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var imageNewUser: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        createRolePicker()
        createRestaurantPicker()
        downloadRestaurants()
        downloadAllUsers {
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    

    func downloadRestaurants() {
        restaurants = Restaurant.downloadRestaurants(login.jwt, apiLink) { [weak self] (result) in switch result {
        case.success(let restaurants):
            self?.restaurants = restaurants
            DispatchQueue.main.async {
                //completed()
            }
        case.failure( _):
            print("nisu stigli restorani")
            }
        }
    }
    
    func createRestaurantPicker() {
        
        restaurantPicker.delegate = self
        restaurantPicker.backgroundColor = .white
        idRestaurant.inputView = restaurantPicker
        createToolbar()
    }
    func createRolePicker() {
        
        rolePicker.delegate = self
        rolePicker.backgroundColor = .white
        role.inputView = rolePicker
        createToolbar()
    }
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = .systemBlue
        toolBar.tintColor = .white
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(WaiterOrderConfirm.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        role.inputAccessoryView = toolBar
        idRestaurant.inputAccessoryView = toolBar
        
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func returnRestaurantName(name: String) -> Int? {
        for rest in restaurants {
            if rest.name_restaurant == name {
                return rest.id_restaurant
            }
        }
        return nil
    }
    
    @IBAction func addNewUser(_ sender: UIButton) {
        if (!username.text!.isEmpty && !password.text!.isEmpty && !firstName.text!.isEmpty && !idRestaurant.text!.isEmpty && !role.text!.isEmpty) {
            let idrestaurant = returnRestaurantName(name: idRestaurant.text!)!
            let newUser:NewUserRequest = NewUserRequest(userName: username.text!, password: password.text!, userFirstName: firstName.text!, id_image: 12, id_restaurant: idrestaurant, role: role.text!)

            let newImage: Media = Media(withImage: self.imageTaken!, forKey: "imageFile", filename: newUser.userFirstName + ".Image.jpeg")!
                    
                Users.saveUser(self.login.jwt, newImage, newUser, self.apiLink)
            username.text = ""
            password.text = ""
            firstName.text = ""
            idRestaurant.text = ""
            role.text = ""
            tableView.reloadData()
        }
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerUserTableViewCell") as? OwnerUserTableViewCell else { return UITableViewCell() }
        
        
        cell.lblName.text = users[indexPath.row].userFirstName
        cell.lblRole.text = users[indexPath.row].role?.first
        
        
        Image.getImage(login.jwt, users[indexPath.row].id_image!, apiLink){(result) in switch result {
        case.success(let data):
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                cell.slika.image = image
            }
        case.failure( _):
            print("nije stigla slika")
            }
            
        }
        return cell
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

