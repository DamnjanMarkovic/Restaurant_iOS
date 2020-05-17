//
//  ManagerIngredientsTable.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 29/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class ManagerIngredientsTable: UIViewController, UITableViewDelegate, UITableViewDataSource,
UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var lblIngredientName: UILabel!
    @IBOutlet weak var lblIngredientPrice: UILabel!
    @IBOutlet weak var lblIngredientQuantity: UILabel!
    @IBOutlet weak var lblIngredientMeasureType: UILabel!
    
    @IBOutlet weak var lblQuantityAvailableInfo: UILabel!
    
    @IBOutlet weak var btnAddIngredientOutlet: UIButton!

    var login: Login!
    let alertService = AlertService()
    var apiLink: String!
    var availableIngredients = [AvailableIngredients]()
    var allIngredients = [AvailableIngredients]()
    @IBOutlet var tblViewIngredient: UIView!
    
    @IBOutlet weak var tfPickerNameIngredient: UITextField!
    @IBOutlet weak var tfPriceIngredient: UITextField!
    @IBOutlet weak var tfTypeIngredient: UITextField!
    @IBOutlet weak var tfQuantityIngredient: UITextField!
    
    @IBOutlet weak var pickerIngredients: UIPickerView!
   
    
    @IBOutlet weak var lblIngredientNamePicker: UILabel!
    

    
    @IBOutlet weak var tblIngredients: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAppearance()
        selectPickerIngredient()
        downloadAvailableIngredients{
            self.tblIngredients.reloadData()
            
        }
        downloadAllIngredients()

    }
    
    
    

    
    @IBAction func btnAddIngredientAction(_ sender: Any) {
                
        if ((!tfPickerNameIngredient.text!.isEmpty) && (!tfPriceIngredient.text!.isEmpty) && (!tfTypeIngredient.text!.isEmpty) && (!tfQuantityIngredient.text!.isEmpty)) {
        
        let ingred: IngredientSaveRequest = IngredientSaveRequest(ingredient_name: tfPickerNameIngredient.text!, purchase_price: (Double(tfPriceIngredient.text!)!), quantity_measure: (tfTypeIngredient.text!), id_restaurant: login.id_restaurant, quantityUpdating: ((Double(tfQuantityIngredient.text!)!)))
        
        IngredientSaveRequest.saveOrUpdateIngredient(login.jwt, ingred, apiLink)
        } else {
            let alert = self.alertService.alert(message: "Please insert valid information!")
            self.present(alert, animated: true)
        }
       
//        DispatchQueue.main.async {
            self.downloadAvailableIngredients{
                self.tblIngredients.reloadData()

             }
             self.downloadAllIngredients()
//        }
        
        tfPickerNameIngredient.text = ""
        tfPriceIngredient.text = ""
        tfTypeIngredient.text = ""
        tfQuantityIngredient.text = ""
        lblQuantityAvailableInfo.text = ""

        
        
    }
    
    func selectPickerIngredient() {
        pickerIngredients.delegate = self
        pickerIngredients.backgroundColor = .white
        createToolbar()
        tfPickerNameIngredient.inputView = self.pickerIngredients
    }

  
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = .systemBlue
        toolBar.tintColor = .white
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ManagerIngredientsTable.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        tfPickerNameIngredient.inputAccessoryView = toolBar
       
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allIngredients.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allIngredients[row].ingredient_name
    }
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfPickerNameIngredient.text = allIngredients[row].ingredient_name
        var availableString: String?
        for ingr in allIngredients {
            if (ingr.ingredient_name == tfPickerNameIngredient.text){
                tfTypeIngredient.text = ingr.quantity_measure
                tfPriceIngredient.text = "\(ingr.purchase_price)"
                //tfQuantityIngredient.text = ingr.quantityAvailable
                
                for availableIngr in availableIngredients {
                    
                    if (ingr.ingredient_name == availableIngr.ingredient_name){
                        
                        availableString = "\(availableIngr.quantityAvailable)"
                    }
                }
                if (availableString != nil ){
                    lblQuantityAvailableInfo.text = "You have " + availableString! + " " + ingr.quantity_measure
                    + " available"
                }
                else {
                    lblQuantityAvailableInfo.text = "You don't have any quantity available"
                }
                    
            }
        }
        
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        performSegue(withIdentifier: "ingredientsToManager", sender: self)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableIngredients.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIngredients")
        as? ManagerIngredientCell else {
        return UITableViewCell()
        }
        
        cell.lblIngredientName.text = availableIngredients[indexPath.row].ingredient_name.capitalized
        cell.lblIngredientPrice.text = "\(availableIngredients[indexPath.row].purchase_price)"
        cell.lblIngredientQuantityAvailable.text = "\(availableIngredients[indexPath.row].quantityAvailable)"
        cell.lblIngredientMeasureType.text = availableIngredients[indexPath.row].quantity_measure
        
         
          return cell
    }
    
    func downloadAvailableIngredients(completed: @escaping () -> ()) {

        availableIngredients = AvailableIngredients.downloadIngredientsInRestaurant(login.jwt, login.id_restaurant, apiLink) { [weak self] (result) in switch result {

            case.success(let availableIngredients):
                self?.availableIngredients = availableIngredients
                DispatchQueue.main.async {
                    completed()
                }
                
            case.failure( _):
                print("nisu stigli ingridient-i")
            }
        }
    }
    func downloadAllIngredients() {

        allIngredients = AvailableIngredients.downloadAllIngredients(login.jwt, apiLink) { [weak self] (result) in switch result {

            case.success(let allIngredients):
                self?.allIngredients = allIngredients
                DispatchQueue.main.async {
                    //completed()
                }
                
            case.failure( _):
                print("nisu stigli sviIngridient-i")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ManagerLogin {
            destination.login = login!
            destination.apiLink = apiLink
            
        }
    }
    

}
    


extension ManagerIngredientsTable {
    func setButtonAppearance(){
        lblIngredientName.layer.borderColor = UIColor.black.cgColor
        lblIngredientName.layer.borderWidth = 2
        lblIngredientName.layer.cornerRadius = 10
        lblIngredientQuantity.layer.borderColor = UIColor.black.cgColor
        lblIngredientQuantity.layer.borderWidth = 2
        lblIngredientQuantity.layer.cornerRadius = 10
        lblIngredientPrice.layer.borderColor = UIColor.black.cgColor
        lblIngredientPrice.layer.borderWidth = 2
        lblIngredientPrice.layer.cornerRadius = 10
        lblIngredientMeasureType.layer.borderColor = UIColor.black.cgColor
        lblIngredientMeasureType.layer.borderWidth = 2
        lblIngredientMeasureType.layer.cornerRadius = 10
        
        btnAddIngredientOutlet.layer.borderColor = UIColor.black.cgColor

        btnAddIngredientOutlet.layer.borderWidth = 2
        btnAddIngredientOutlet.layer.cornerRadius = 10
        

    
}


    /*
    let ingredient_name: String
      let purchase_price: Double
      let quantity_measure: String
      let quantity: Double
      let quantityAvailable: Double
    */

/*
                   let purchase_price = Double(tfPriceIngredient.text!)
                   let quantityUpdating = Double(tfQuantityIngredient.text!)
           if ((!tfPickerNameIngredient.text!.isEmpty) && (!tfPriceIngredient.text!.isEmpty) && (!tfTypeIngredient.text!.isEmpty) && (!tfQuantityIngredient.text!.isEmpty)) {
           

               
               
     
               
           let ingred: IngredientSaveRequest = IngredientSaveRequest(ingredient_name: tfPickerNameIngredient.text!,
                                                                     purchase_price: purchase_price!,
                                                                     quantity_measure: (tfTypeIngredient.text!),
                                                                     id_restaurant: login.id_restaurant,
                                                                     quantityUpdating: quantityUpdating!)
     */
}
