//
//  OffersSelectControllerViewController.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 05/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

   class WaiterOffersSelect: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var btnOrder: UIButton!
    
    @IBOutlet weak var tblOrders: UITableView!
    @IBOutlet weak var lblOrderReceived: UILabel!
    
    @IBOutlet weak var prepareOrderAlcohol: UIButton!
    
    @IBOutlet weak var prepareOrderFood: UIButton!
    @IBOutlet weak var prepareOrderNonAlcohol: UIButton!
    var idDinningTable: Int!
    @IBOutlet weak var lblFoodSelectedName: UILabel!
    @IBOutlet weak var lblNonAlcoholSelectedeName: UILabel!
    @IBOutlet weak var lblAlcoholSelectedName: UILabel!
    
    @IBOutlet weak var quantityFood: UITextField!
    @IBOutlet weak var quantityNonAlcohol: UITextField!
    @IBOutlet weak var quantityAlcohol: UITextField!
    
    @IBOutlet weak var itemFood: UILabel!
    @IBOutlet weak var itemNonAlcohol: UILabel!
    @IBOutlet weak var itemAlcohol: UILabel!
    
    @IBOutlet weak var textArea: UITextView!
  
    var offers = [Offers]()
    let alertService = AlertService()
    var login: Login!
    var apiLink: String!
    var dinningTable: DinningTable!
    var tableNumber: Int!
    var offersAlcohol: [AvailableOffers] = []
    var offersNoN_Alcohol: [AvailableOffers] = []
    var offersFood: [AvailableOffers] = []
    var availableOffers: [AvailableOffers] = []
    var orderReceived = [OrdersReceived]()
    var availableOffersAll: [Offers]!
    
   
    
    @IBOutlet weak var btnFoodOut: UIButton!
    @IBOutlet weak var btnNonAlcoholO: UIButton!
    @IBOutlet weak var btnAlcoholO: UIButton!
    
    @IBOutlet weak var tblViewAlcohol: UITableView!
    @IBOutlet weak var tblViewNonAlcohol: UITableView!
    @IBOutlet weak var tblViewFood: UITableView!
 
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewAlcohol.isHidden = true
        tblViewNonAlcohol.isHidden = true
        tblViewFood.isHidden = true
        tblOrders.tableFooterView = UIView(frame: CGRect.zero)
        setButtonAppearance()
        downloadOffers {
            self.tblViewAlcohol.reloadData()
            self.tblViewNonAlcohol.reloadData()
            self.tblViewFood.reloadData()
        }
        downloadAllAvailableOffers() {[weak self] (result) in switch result {
            case.success(let availableOffersAll):
            self?.availableOffersAll = availableOffersAll
            case.failure( _):
            print("e krc")
        }
        }
            
        
            
        downloadDinningTable() { [weak self] (result) in switch result {
                case.success(let dinningTable):
                self?.dinningTable = dinningTable
                case.failure( _):
                print("nije stigao sto")
            }
        }
        
    }
    
    
    
    
    
    
    @IBAction func btnDeleteOrder(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tblOrders)
        guard let indexpath = tblOrders.indexPathForRow(at: point)
            else {return}
        orderReceived.remove(at: indexpath.row)
        tblOrders.beginUpdates()
        tblOrders.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .left)
        tblOrders.endUpdates()
        
    }
    
    
    
    
    @IBAction func btnConfirmOrders(_ sender: Any) {
        //print(orderReceived.count)
        performSegue(withIdentifier: "toConfirmOrders", sender: self)
        
    }
    
    @IBAction func btnOrderAction(_ sender: Any) {
        
        //print(self.orderReceived)
        insertOrder(orderReceived: orderReceived)
            
        }
        
    func getOfferID (offerName: String) -> Int {
        var response = 0
        for offerrr in availableOffers {
            if (offerrr.restaurant_offer_name == offerName) {
                response = offerrr.idOffer
            }
        }
        return response
    }
    func getOfferName (id_Offer: Int) -> String {
        var response = ""
        for offerrr in availableOffers {
            if (offerrr.idOffer == id_Offer) {
                response = offerrr.restaurant_offer_name
            }
        }
        return response
    }
    
    
    
    
    func insertOrder(orderReceived: [OrdersReceived]){
        

        if orderReceived.count>0 {
            
            let alert = self.alertService.alert(message: "Order sent!")
            self.present(alert, animated: true)
            let jsonBody = try? JSONEncoder().encode(orderReceived)
            let urlString = apiLink + "/rest/orders/load"
            let url = URL (string: urlString)!
            let jwt = login.jwt
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody as Data?
                request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
                let session = URLSession.shared
                
                let _: Void = session.dataTask(with: request) { (data, response, error) in
                    if error == nil {
                        do {

                             self.availableOffers.removeAll()
                             self.offersAlcohol.removeAll()
                             self.offersNoN_Alcohol.removeAll()
                             self.offersFood.removeAll()

                            self.downloadOffers {
                                 self.tblViewAlcohol.reloadData()
                                 self.tblViewNonAlcohol.reloadData()
                                 self.tblViewFood.reloadData()
                                     }
                        }
                    } else {
                        print("Json error")

                    }
                }.resume()

        } else {
            let alert = self.alertService.alert(message: "Not orders made!")
            self.present(alert, animated: true)
        }
         self.orderReceived.removeAll()
        self.tblOrders.reloadData()

    }
    
    func downloadAllAvailableOffers(completed: @escaping(Result<[Offers], Error>) -> Void){
        //var availableOffersAll = [AvailableOffers]()
                 let urlString = apiLink + "/rest/offers/allAvailableOffers"
                 let url = URL (string: urlString)
                 var request = URLRequest(url: url!)
                 request.httpMethod = "GET"
        request.addValue("Bearer " + login.jwt, forHTTPHeaderField: "Authorization")
                 let session = URLSession.shared
                 let _: Void = session.dataTask(with: request) { (data, response, error) in
                    if error == nil {
                    do {
                self.availableOffersAll = try JSONDecoder().decode([Offers].self, from: data!)
           //             print(self.availableOffersAll!.first!)

                        DispatchQueue.main.async {
                            completed(.success(self.availableOffersAll))
                            }
                        }catch{
                                print("Json all available offers error")
                            }
                        }
                    }.resume()
       }
    
    
    func downloadDinningTable(completion: @escaping(Result<DinningTable, Error>) -> Void){
        let tableNum: String
        let idRest: String
        tableNum = "\(tableNumber ?? 0)"
        idRest = "\(String(describing: login.id_restaurant))"
        let urlString = apiLink + "/rest/dinningTable/tableID/" + tableNum + "/" + idRest
        let url = URL (string: urlString)
        let jwt = login.jwt
           var request = URLRequest(url: url!)
           request.httpMethod = "GET"
           request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
               let session = URLSession.shared
               let _: Void = session.dataTask(with: request) { (data, response, error) in
                   if error == nil {
                       do {
                           self.dinningTable = try JSONDecoder().decode(DinningTable.self, from: data!)
                           //print(self.dinningTable!)
                           DispatchQueue.main.async {
                           completion(.success(self.dinningTable))
                           }
                           } catch {
                               print("Json error")
                           }
                   }
               }.resume()
       }

    
    @IBAction func prepareOrderAlcohol(_ sender: Any) {
        if((lblAlcoholSelectedName.text != "") && (quantityAlcohol.text != "")) {
           let id_offer = getOfferID(offerName: lblAlcoholSelectedName.text!)
            let quantityRequested = (Int(quantityAlcohol.text!)!)
            
            if quantityRequested > 0 {
                  
                  var quantityInOrders: Int = 0
                  for ordReceiv in orderReceived {
                      if ordReceiv.id_offer == id_offer {
                          quantityInOrders += ordReceiv.quantity
                      }
                  }
                  for off in availableOffers {
                      if (off.idOffer == id_offer) {
                          for ingr in off.ingredientsInOffer {
                                      if ((ingr.quantity * (Double(quantityRequested + quantityInOrders))) <= ingr.quantityAvailable) {
                                          let newOrder = OrdersReceived(id_offer: id_offer, quantity: quantityRequested, id_restaurant: login.id_restaurant, id_table: dinningTable.id_dinningTable)
                                          orderReceived.append(newOrder)
                                      break
                          } else {
                      let alert = self.alertService.alert(message: "Not enough " + off.restaurant_offer_name + " available.")
                      self.present(alert, animated: true)

                        }
                    }
                }
            }
            tblOrders.reloadData()
            lblAlcoholSelectedName.text = ""
            quantityAlcohol.text = ""
                    } else {
                        let alert = self.alertService.alert(message: "Please enter valid quantity!")
                        self.present(alert, animated: true)
                    }
                }
                else {
                    let alert = self.alertService.alert(message: "Please select requested offer and enter quantity!")
                    self.present(alert, animated: true)
                
                }
            }
    
    @IBAction func prepareOrderNonAlcohol(_ sender: Any) {
        if((lblNonAlcoholSelectedeName.text != "") && (quantityNonAlcohol.text != "")) {
            let id_offer = getOfferID(offerName: lblNonAlcoholSelectedeName.text!)
            let quantityRequested = (Int(quantityNonAlcohol.text!)!)
            
            if quantityRequested > 0 {
            
            var quantityInOrders: Int = 0
            for ordReceiv in orderReceived {
                if ordReceiv.id_offer == id_offer {
                    quantityInOrders += ordReceiv.quantity
                }
            }
            for off in availableOffers {
                if (off.idOffer == id_offer) {
                    for ingr in off.ingredientsInOffer {
                                if ((ingr.quantity * (Double(quantityRequested + quantityInOrders))) <= ingr.quantityAvailable) {
                                    let newOrder = OrdersReceived(id_offer: id_offer, quantity: quantityRequested, id_restaurant: login.id_restaurant, id_table: dinningTable.id_dinningTable)
                                    orderReceived.append(newOrder)
                                break
                    } else {
                let alert = self.alertService.alert(message: "Not enough " + off.restaurant_offer_name + " available.")
                self.present(alert, animated: true)
                        }
                    }
                }
            }

            lblNonAlcoholSelectedeName.text = ""
            quantityNonAlcohol.text = ""
            tblOrders.reloadData()
            } else {
                let alert = self.alertService.alert(message: "Please enter valid quantity!")
                self.present(alert, animated: true)
            }
        }
        else {
            let alert = self.alertService.alert(message: "Please select requested offer and enter quantity!")
            self.present(alert, animated: true)
        
        }
    }
    
    
    @IBAction func prepareOrderFood(_ sender: Any) {
        if((lblFoodSelectedName.text != "") && (quantityFood.text != "")) {
       let id_offer = getOfferID(offerName: lblFoodSelectedName.text!)
      let quantityRequested = (Int(quantityFood.text!)!)
            
            if quantityRequested > 0 {
        var quantityInOrders: Int = 0
        for ordReceiv in orderReceived {
            if ordReceiv.id_offer == id_offer {
                quantityInOrders += ordReceiv.quantity
            }
        }
        for off in availableOffers {
            if (off.idOffer == id_offer) {
                for ingr in off.ingredientsInOffer {
                            if ((ingr.quantity * (Double(quantityRequested + quantityInOrders))) <= ingr.quantityAvailable) {
                                let newOrder = OrdersReceived(id_offer: id_offer, quantity: quantityRequested, id_restaurant: login.id_restaurant, id_table: dinningTable.id_dinningTable)
                                orderReceived.append(newOrder)
                            break
                } else {
            let alert = self.alertService.alert(message: "Not enough " + off.restaurant_offer_name + " available.")
            self.present(alert, animated: true)
                    }
                }
            }
        }

        lblFoodSelectedName.text = ""
         quantityFood.text = ""
         tblOrders.reloadData()
                    } else {
                        let alert = self.alertService.alert(message: "Please enter valid quantity!")
                        self.present(alert, animated: true)
                    }
                }
                else {
                    let alert = self.alertService.alert(message: "Please select requested offer and enter quantity!")
                    self.present(alert, animated: true)
                
                }
            }
    @IBAction func btnAlcoholAc(_ sender: Any) {
                if tblViewAlcohol.isHidden {
                animateAlc(toogle: true)
            } else {
                animateAlc(toogle: false)
            }
    }
    
    @IBAction func btnNonAlcoholAc(_ sender: Any) {
            if tblViewNonAlcohol.isHidden {
            animateNonAlc(toogle: true)
        } else {
            animateNonAlc(toogle: false)
        }
    }
    
    @IBAction func btnFoodAct(_ sender: Any) {
        if tblViewFood.isHidden {
            animateFood(toogle: true)
        } else {
            animateFood(toogle: false)
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
         performSegue(withIdentifier: "offersSelectToWaiterLogin", sender: self)
    }
    func animateFood(toogle: Bool) {
        if toogle {
            UIView.animate(withDuration: 0.3) {
                self.tblViewFood.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.tblViewFood.isHidden = true
            }
        }
    }
    
    func animateAlc(toogle: Bool) {
           if toogle {
               UIView.animate(withDuration: 0.3) {
               self.tblViewAlcohol.isHidden = false
               }
           } else {
               UIView.animate(withDuration: 0.3) {
               self.tblViewAlcohol.isHidden = true
               }
           }
    }
    
    
    func animateNonAlc(toogle: Bool) {
            if toogle {
                UIView.animate(withDuration: 0.3) {
                self.tblViewNonAlcohol.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                self.tblViewNonAlcohol.isHidden = true
                }
            }
            
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((tblViewAlcohol != nil) && (tableView  == tblViewAlcohol)) {
            return offersAlcohol.count
        }
        else if((tblViewNonAlcohol != nil) && (tableView  == tblViewNonAlcohol)) {
             return offersNoN_Alcohol.count
        }
        else if((tblViewFood != nil) && (tableView  == tblViewFood)) {
            return offersFood.count
        }
        else if((tblOrders != nil) && (tableView  == tblOrders)) {
            return orderReceived.count
//            return 12
        }
        else {
            return 0
        }
    }
        

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WaiterOffersSelectCell") as? WaiterOffersSelectCell else {
        return UITableViewCell()
        }
        if((tblViewAlcohol != nil) && (tableView  == tblViewAlcohol)) {
            cell.lblAlcoholName.text = offersAlcohol[indexPath.row].restaurant_offer_name
               
            Image.getImage(login.jwt, offersAlcohol[indexPath.row].id_image, apiLink){(result) in switch result {
                       case.success(let data):
                           let image = UIImage(data: data)
                           DispatchQueue.main.async {
                           cell.imgAlcohol.image = image
           
                            }
                       case.failure( _):
                           print("nije stigla slika")
                       }
           }
        }
            
        else if((tblViewNonAlcohol != nil) && (tableView  == tblViewNonAlcohol)) {
             cell.lblNonAlcoholName.text = offersNoN_Alcohol[indexPath.row].restaurant_offer_name
            Image.getImage(login.jwt, offersNoN_Alcohol[indexPath.row].id_image, apiLink){(result) in switch result {
                      case.success(let data):
                          let image = UIImage(data: data)
                          DispatchQueue.main.async {
                              cell.imgNoNAlcohol.image = image
                           }
                      case.failure( _):
                          print("nije stigla slika")
                      }
          }
        }
        else if((tblViewFood != nil) && (tableView  == tblViewFood)) {
            cell.lblFoodName.text = offersFood[indexPath.row].restaurant_offer_name
            Image.getImage(login.jwt, offersFood[indexPath.row].id_image, apiLink){(result) in switch result {
                          case.success(let data):
                              let image = UIImage(data: data)
                              DispatchQueue.main.async {
                                  cell.imgFood.image = image
                               }
                          case.failure( _):
                              print("nije stigla slika")
                          }
            }
        }
        else if(tableView == tblOrders) {
            
        let offerName = getOfferName(id_Offer: orderReceived[indexPath.row].id_offer)
        cell.lblNameOrder.text = offerName
        cell.lblOrderQuantity.text = ("\(orderReceived[indexPath.row].quantity)")
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((tblViewAlcohol != nil) && (tableView  == tblViewAlcohol)) {
            animateAlc(toogle: false)
            let tekst = offersAlcohol[indexPath.row].restaurant_offer_name
            lblAlcoholSelectedName.text = tekst
        }
        else if((tblViewNonAlcohol != nil) && (tableView  == tblViewNonAlcohol)) {
            animateNonAlc(toogle: false)
            let tekst = offersNoN_Alcohol[indexPath.row].restaurant_offer_name
            lblNonAlcoholSelectedeName.text = tekst
        }
        else if((tblViewFood != nil) && (tableView  == tblViewFood)) {
            animateFood(toogle: false)
            let tekst = offersFood[indexPath.row].restaurant_offer_name
            lblFoodSelectedName.text = tekst
        }
        else {
        }
    }

        
  
    func downloadOffers(completed: @escaping () -> ()) {

        availableOffers = AvailableOffers.downloadOffersOnRestaurant(login.jwt, login.id_restaurant, apiLink) { [weak self] (result) in switch result {

            case.success(let availableOffers):
                
                self!.availableOffers = availableOffers
                
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
       
 
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WaiterLogin {
            destination.login = login!
            destination.apiLink = apiLink
        }
        if let destination = segue.destination as? WaiterOrderConfirm {
        
            
            destination.login = login!
            destination.apiLink = apiLink
            destination.dinningTable = dinningTable
            destination.tableNumber = tableNumber
            destination.availableOffersAll = availableOffersAll
            
            
        }
    }

    
    @IBOutlet weak var btnCOnfirmOrdersOutlet: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
}

extension WaiterOffersSelect {
       
    
    
    
    func tableView(tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
        if(tableView == tblOrders) {
            return true
        } else {
            return false
        }
    }

    func tableView(tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: IndexPath) {
     
    if(tableView == tblOrders) {
        if editingStyle == .delete {
                orderReceived.remove(at: indexPath.row)
            tblOrders.beginUpdates()
            tblOrders.deleteRows(at: [indexPath], with: .automatic)
            tblOrders.endUpdates()
     }
    }}
    
    
    
    func setButtonAppearance(){
            btnNonAlcoholO.layer.cornerRadius = 10
            btnAlcoholO.layer.cornerRadius = 10
            btnFoodOut.layer.cornerRadius = 10
            prepareOrderFood.layer.cornerRadius = 10
            prepareOrderAlcohol.layer.cornerRadius = 10
            prepareOrderNonAlcohol.layer.cornerRadius = 10
            lblOrderReceived.layer.cornerRadius = 13
            lblOrderReceived.layer.borderColor = UIColor.gray.cgColor
            lblOrderReceived.layer.borderWidth = 1
            btnOrder.layer.cornerRadius = 20
        

        btnCOnfirmOrdersOutlet.layer.cornerRadius = 20
        btnCOnfirmOrdersOutlet.layer.borderColor = UIColor.black.cgColor
        btnCOnfirmOrdersOutlet.layer.borderWidth = 2
        
//        btnOrderAction.
//        
//        btnConfirmOrders
//        
//        btnDeleteOrder(<#T##sender: UIButton##UIButton#>)
//            
            
            
            
            
            
            
            /*btnFoodOut.layer.borderColor = UIColor.red.cgColor
            btnFoodOut.layer.borderWidth = 4
            btnNonAlcoholO.layer.shadowColor = UIColor.red.cgColor
            btnNonAlcoholO.layer.shadowRadius = 6
            btnNonAlcoholO.layer.shadowOpacity = 1*/

            
        }
    
}
        
