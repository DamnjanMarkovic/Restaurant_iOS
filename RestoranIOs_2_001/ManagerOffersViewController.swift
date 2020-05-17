//
//  OffersViewController.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 03/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//


import UIKit

class ManagerOffersViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if  pickerView == self.offerTypePicker {
            return offerTypes.count
        } else {
            return allIngredients.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if  pickerView == self.offerTypePicker {
                 return offerTypes[row]
             } else {
                 return allIngredients[row].ingredient_name
         }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if  pickerView == self.offerTypePicker {
             tfOfferType.text = offerTypes[row]
             } else {
                lblNewIngredient.text = allIngredients[row].ingredient_name
            for ing in allIngredients {
                if (ing.ingredient_name == lblNewIngredient.text) {
                    lblNewIngredientMeasureType.text = ing.quantity_measure
                }
            }
         }
    }
    /*
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Mengo-Regular", size: 17)
        
        if  pickerView == offerTypePicker {
              label.text = offerTypes[row]
        } else {
               label.text = allIngredients[row].ingredient_name
        }
        return label
        
        
    }*/

    @IBOutlet weak var ingridientPickerView: UIPickerView!
    var offerTypePicker = UIPickerView()
    let offerTypes = ["NON_ALCOHOLIC_DRINK", "ALCOHOLIC_DRINK", "FOOD"]
    
    @IBOutlet weak var lblOfferSelectedName: UITextField!
    @IBOutlet weak var tfOfferType: UITextField!

    @IBOutlet weak var lblOfferSelectedPrice: UITextField!
    @IBOutlet weak var tblViewIngredients: UITableView!
    @IBOutlet weak var btnAddNewIngredientOutlet: UIButton!

    @IBOutlet weak var lblNewIngredientQuantity: UITextField!
    @IBOutlet weak var lblNewIngredientMeasureType: UILabel!

    @IBOutlet weak var lblNewIngredient: UITextField!
    

    @IBOutlet weak var imageSelectedOffer: UIImageView!
    @IBOutlet weak var tableViewAlcohol: UITableView!
    @IBOutlet weak var tableViewNonAlcohol: UITableView!
    @IBOutlet weak var tableViewFood: UITableView!

    @IBOutlet weak var btnAddOffer: UIButton!

    @IBOutlet weak var btnSelectImage: UIButton!
    var availableOffers = [AvailableOffers]()
    var allIngredients = [AvailableIngredients]()
    var offers = [Offers]()
    var login: Login!
    var apiLink: String!
    var picImport: UIImage?
    var alertService = AlertService()
    var imageTaken: UIImage?

    var ingredientsOfferSelected = [AvailableIngredients]()
    var ingredientSelectedName: String?
    var ingredientSelectedMeasureType: String?
    var imagePickerController = UIImagePickerController()
    var offersAlcohol: [AvailableOffers] = []
    var offersNoN_Alcohol: [AvailableOffers] = []
    var offersFood: [AvailableOffers] = []
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewIngredients.tableFooterView = UIView(frame: CGRect.zero)
        setButtonAppearance()
        createIngredientPicker()
        createOfferTypePicker()
        downloadOffers {
            self.tableViewAlcohol.reloadData()
            self.tableViewNonAlcohol.reloadData()
            self.tableViewFood.reloadData()
        }
       downloadAllIngredients()
    }
    
    @IBAction func btnDeleteOrder(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tblViewIngredients)
        guard let indexpath = tblViewIngredients.indexPathForRow(at: point)
            else {return}
        ingredientsOfferSelected.remove(at: indexpath.row)
        tblViewIngredients.beginUpdates()
        tblViewIngredients.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .left)
        tblViewIngredients.endUpdates()
    }
    func createOfferTypePicker() {
        offerTypePicker.delegate = self
        offerTypePicker.backgroundColor = .white
        tfOfferType.inputView = offerTypePicker
        createToolbar()
    }
    
    func createIngredientPicker() {

        ingridientPickerView.delegate = self
       ingridientPickerView.backgroundColor = .white
        lblNewIngredient.inputView = ingridientPickerView
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
        lblNewIngredient.inputAccessoryView = toolBar
        tfOfferType.inputAccessoryView = toolBar
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func btnAddINewIngredient(_ sender: Any) {
        if ((!lblNewIngredient.text!.isEmpty) && (!lblNewIngredientMeasureType.text!.isEmpty) && (!lblNewIngredientQuantity.text!.isEmpty))  {
            let ingred: AvailableIngredients = AvailableIngredients(ingredient_name: lblNewIngredient.text!, purchase_price: 0.0, quantity_measure: lblNewIngredientMeasureType.text!, quantity: (Double(lblNewIngredientQuantity.text!)!), quantityAvailable: 0.0)
            ingredientsOfferSelected.append(ingred)
            tblViewIngredients.reloadData()
            lblNewIngredient.text = ""
            lblNewIngredientMeasureType.text = ""
            lblNewIngredientQuantity.text = ""
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

    @IBAction func btnAddOffer(_ sender: Any) {
        
        var updateOfferStart: String = ""
        var offerNames: [String] = []
        for off in availableOffers {
            offerNames.append(off.restaurant_offer_name.capitalized)
        }
        let offerNameSelected: String = lblOfferSelectedName.text!.capitalized
        if (offerNames.contains(offerNameSelected)) {
            print("ima tog ofera")
            updateOfferStart = "You are about to update restaurant offer " + lblOfferSelectedName.text! + ". Are you sure?"
        }
        
        else {
            print ("nema tog ofera ")
        
            updateOfferStart = "You are about to save restaurant offer " + lblOfferSelectedName.text! + ". Are you sure?"
        }
        
        let actionSheet = UIAlertController(title: "Restaurant offer", message: updateOfferStart, preferredStyle: .alert)
          actionSheet.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action:UIAlertAction) in
       
            if (!self.tfOfferType.text!.isEmpty) {
             var specialMessage: String = ""
                   for ingrFinal in self.ingredientsOfferSelected {
                specialMessage += ingrFinal.ingredient_name +  ";\(ingrFinal.quantity);"
            }
                   let newOffer: OffersSaveRequest = OffersSaveRequest(restaurant_offer_name: self.lblOfferSelectedName.text!, restaurant_offer_price: (Double(self.lblOfferSelectedPrice.text!)!), offer_type: self.tfOfferType.text!, id_image: 12, specialMessage: specialMessage)
                   let newImage: Media = Media(withImage: self.imageTaken!, forKey: "imageFile", filename: newOffer.restaurant_offer_name + ".Image.jpeg")!
                   OffersSaveRequest.saveOffer(self.login.jwt, newImage, newOffer, self.apiLink)
            
                   let updateOfferFinished: String = "You have updated restaurant offer " + self.lblOfferSelectedName.text!
            
            let alert = self.alertService.alert(message: updateOfferFinished)
             self.present(alert, animated: true)
            }
            else {
                let alert = self.alertService.alert(message: "Please select offer type")
                 self.present(alert, animated: true)
            }

 

          }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)

    }
    
    
    @IBAction func btnImagePicker(_ sender: Any) {
  
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
                 imageSelectedOffer.image = image
             }
        dismiss(animated: true, completion: nil)
    }
     
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func back(_ sender: Any) {
         performSegue(withIdentifier: "offerShowTOManager", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if((tableViewAlcohol != nil) && (tableView  == tableViewAlcohol)) {
                return offersAlcohol.count
            }
            else if((tableViewNonAlcohol != nil) && (tableView  == tableViewNonAlcohol)) {

                return offersNoN_Alcohol.count
            }
             else if((tableViewFood != nil) && (tableView  == tableViewFood)) {
              return offersFood.count
            }
            else if((tblViewIngredients != nil) && (tableView  == tblViewIngredients)) {
                return ingredientsOfferSelected.count
            }
            else {
                return 0
            }
        }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView == tableViewAlcohol {
            ingredientsOfferSelected.removeAll()
            for ingr in offersAlcohol[(tableView.indexPathForSelectedRow?.row)!].ingredientsInOffer {
                let ingred: AvailableIngredients = AvailableIngredients(ingredient_name: ingr.ingredient_name, purchase_price: 0.0, quantity_measure: ingr.quantity_measure, quantity: ingr.quantity, quantityAvailable: 0.0)
                ingredientsOfferSelected.append(ingred)
            }
            tblViewIngredients.reloadData()
                
            lblOfferSelectedName.text!.removeAll()
            lblOfferSelectedName.text = offersAlcohol[(tableView.indexPathForSelectedRow?.row)!].restaurant_offer_name
            lblOfferSelectedPrice.text!.removeAll()
            lblOfferSelectedPrice.text = "\(offersAlcohol[(tableView.indexPathForSelectedRow?.row)!].restaurant_offer_price)"
                tfOfferType.text!.removeAll()
                tfOfferType.text = offersAlcohol[(tableView.indexPathForSelectedRow?.row)!].offer_type
            Image.getImage(login.jwt, offersAlcohol[indexPath.row].id_image, apiLink){(result) in switch result {
            case.success(let data):
                self.imageTaken = UIImage(data: data)
            DispatchQueue.main.async {
                self.imageSelectedOffer.image = self.imageTaken
                //self.imagePickerView.image = self.imageTaken
            }
            case.failure( _):
                print("nije stigla slika")
            }
            }
        }
        else if tableView == tableViewNonAlcohol {
          ingredientsOfferSelected.removeAll()
             
            for ingr in offersNoN_Alcohol[(tableView.indexPathForSelectedRow?.row)!].ingredientsInOffer {
              let ingred: AvailableIngredients = AvailableIngredients(ingredient_name: ingr.ingredient_name, purchase_price: 0.0, quantity_measure: ingr.quantity_measure, quantity: ingr.quantity, quantityAvailable: 0.0)
                    ingredientsOfferSelected.append(ingred)
                }
            tblViewIngredients.reloadData()
                
            lblOfferSelectedName.text!.removeAll()
            lblOfferSelectedName.text = offersNoN_Alcohol[(tableView.indexPathForSelectedRow?.row)!].restaurant_offer_name
            lblOfferSelectedPrice.text!.removeAll()
            lblOfferSelectedPrice.text = "\(offersNoN_Alcohol[(tableView.indexPathForSelectedRow?.row)!].restaurant_offer_price)"
                tfOfferType.text!.removeAll()
                tfOfferType.text = offersNoN_Alcohol[(tableView.indexPathForSelectedRow?.row)!].offer_type
                Image.getImage(login.jwt, offersNoN_Alcohol[indexPath.row].id_image, apiLink){(result) in switch result {
                case.success(let data):
                    self.imageTaken = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageSelectedOffer.image = self.imageTaken
                }
                case.failure( _):
                    print("nije stigla slika")
                }
                }
            }
        else if tableView == tableViewFood {
               ingredientsOfferSelected.removeAll()
                for ingr in offersFood[(tableView.indexPathForSelectedRow?.row)!].ingredientsInOffer {
               let ingred: AvailableIngredients = AvailableIngredients(ingredient_name: ingr.ingredient_name, purchase_price: 0.0, quantity_measure: ingr.quantity_measure, quantity: ingr.quantity, quantityAvailable: 0.0)
                ingredientsOfferSelected.append(ingred)
                }
             tblViewIngredients.reloadData()
               lblOfferSelectedName.text!.removeAll()
               lblOfferSelectedName.text = offersFood[(tableView.indexPathForSelectedRow?.row)!].restaurant_offer_name
               lblOfferSelectedPrice.text!.removeAll()
               lblOfferSelectedPrice.text = "\(offersFood[(tableView.indexPathForSelectedRow?.row)!].restaurant_offer_price)"
                tfOfferType.text!.removeAll()
                tfOfferType.text = offersFood[(tableView.indexPathForSelectedRow?.row)!].offer_type
                Image.getImage(login.jwt, offersFood[indexPath.row].id_image, apiLink){(result) in switch result {
                case.success(let data):
                    self.imageTaken = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageSelectedOffer.image = self.imageTaken
                }
                case.failure( _):
                    print("nije stigla slika")
                }
                }
            }
        else if tableView == tblViewIngredients {
          }
    }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OffersViewCell") as? ManagerOffersViewCell else {
                return UITableViewCell()
                
            }
            if((tableViewAlcohol != nil) && (tableView  == tableViewAlcohol)) {
                cell.offerName.text = offersAlcohol[indexPath.row].restaurant_offer_name
                Image.getImage(login.jwt, offersAlcohol[indexPath.row].id_image, apiLink){(result) in switch result {
                        case.success(let data):
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                             cell.imgVIew.image = image
                             }
                        case.failure( _):
                            print("nije stigla slika")
                        }
                }
                
            }
            else if((tableViewNonAlcohol != nil) && (tableView  == tableViewNonAlcohol)) {
                cell.nameNonAlcohol.text = offersNoN_Alcohol[indexPath.row].restaurant_offer_name
                  Image.getImage(login.jwt, offersNoN_Alcohol[indexPath.row].id_image, apiLink){(result) in switch result {
                            case.success(let data):
                                let image = UIImage(data: data)
                                DispatchQueue.main.async {
                                    cell.imageNonAlcohol.image = image
                                 }
                            case.failure( _):
                                print("nije stigla slika")
                            }
                }
            }
            else if((tableViewFood != nil) && (tableView  == tableViewFood)) {
               cell.nameFood.text = offersFood[indexPath.row].restaurant_offer_name
               Image.getImage(login.jwt, offersFood[indexPath.row].id_image, apiLink){(result) in switch result {
                             case.success(let data):
                                 let image = UIImage(data: data)
                                 DispatchQueue.main.async {
                                     cell.imageFood.image = image
                                  }
                             case.failure( _):
                                 print("nije stigla slika")
                     }
               }

            }
            else if((tblViewIngredients != nil) && (tableView  == tblViewIngredients)) {
                
     
               cell.lblIngredientNameCell.text = ingredientsOfferSelected[indexPath.row].ingredient_name
               cell.lblIngredientMeasureCell.text = ingredientsOfferSelected[indexPath.row].quantity_measure
                cell.lblIngredientQuantityCell.text = "\(ingredientsOfferSelected[indexPath.row].quantity)"
         }
             return cell
        }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ManagerLogin {
            destination.login = login!
            destination.apiLink = apiLink
        }
    }
    
      func downloadOffers(completed: @escaping () -> ()) {
          availableOffers = AvailableOffers.downloadAllOffers(login.jwt, apiLink) { [weak self] (result) in switch result {
              case.success(let availableOffers):
                  self?.availableOffers = availableOffers
                  for ofr in availableOffers {
                  if (ofr.offer_type == "ALCOHOLIC_DRINK"){
                      self!.offersAlcohol.append(ofr)
                  }
                  else if (ofr.offer_type == "NON_ALCOHOLIC_DRINK"){
                      self!.offersNoN_Alcohol.append(ofr)
                  }
                  else if (ofr.offer_type == "FOOD"){
                      self!.offersFood.append(ofr)
                  }
                  DispatchQueue.main.async {
                      completed()
                  }
                      
              }
              case.failure( _):
                  print("nisu stigli offer-i")
              }
          }
      }
    @IBOutlet weak var btnAddOfferOutlet: UIButton!
    func setButtonAppearance(){
      
            lblNewIngredientQuantity.layer.cornerRadius = 10
            lblNewIngredientQuantity.layer.borderWidth = 3
            lblNewIngredientQuantity.layer.borderColor = UIColor.gray.cgColor
            lblNewIngredientMeasureType.layer.borderWidth = 3
            lblNewIngredientMeasureType.layer.cornerRadius = 10
            lblNewIngredientMeasureType.layer.borderColor = UIColor.gray.cgColor
            lblNewIngredient.layer.borderWidth = 3
            lblNewIngredient.layer.borderColor = UIColor.gray.cgColor
            lblNewIngredient.layer.cornerRadius = 10
            lblOfferSelectedPrice.layer.borderWidth = 3
            lblOfferSelectedPrice.layer.borderColor = UIColor.gray.cgColor
            lblOfferSelectedPrice.layer.cornerRadius = 10
            lblOfferSelectedName.layer.borderWidth = 3
            lblOfferSelectedName.layer.borderColor = UIColor.gray.cgColor
            lblOfferSelectedName.layer.cornerRadius = 10
            btnAddOffer.layer.borderWidth = 3
            btnAddOffer.layer.cornerRadius = 10
            btnAddOffer.layer.borderColor = UIColor.gray.cgColor
            btnSelectImage.layer.borderWidth = 3
            btnSelectImage.layer.cornerRadius = 10
            btnSelectImage.layer.borderColor = UIColor.gray.cgColor
        btnAddOfferOutlet.layer.borderWidth = 3
        btnAddOfferOutlet.layer.cornerRadius = 10
        btnAddOfferOutlet.layer.borderColor = UIColor.gray.cgColor
        tfOfferType.layer.borderWidth = 3
            tfOfferType.layer.cornerRadius = 10
            tfOfferType.layer.borderColor = UIColor.gray.cgColor
            
 
    }
}


