//
//  WaiterOrderConfirm.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 24/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

extension WaiterOrderConfirm: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if  pickerView == self.typePicker {
            return paymentTypes.count
        } else {
            return discountTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if  pickerView == self.typePicker {
            return paymentTypes[row]
        } else {
            return discountTypes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if  pickerView == self.typePicker {
            selectedPaymentType = paymentTypes[row]
            tfPicker.text = selectedPaymentType
        } else {
        selectSpecialDiscount = discountTypes[row]
        tfDiscountPicker.text = selectSpecialDiscount
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = .green
        label.textAlignment = .center
        label.font = UIFont(name: "Mengo-Regular", size: 17)
        if  pickerView == self.typePicker {
            label.text = paymentTypes[row]
        } else {
            label.text = discountTypes[row]
        }
        return label
        
        
    }
    
    
    
}


class WaiterOrderConfirm: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var availableOffersAll: [Offers]!
    var login: Login!
    var apiLink: String!
    var dinningTable: DinningTable!
    var orderReceived = [OrdersReceived]()
    var availableOfferRequested: Offers!
    var tableNumber: Int!
    var bill: Bill!
    var returnedBill: BillComplete!
    let alertService = AlertService()
    
    var selectedPaymentType: String?
    var selectSpecialDiscount: String?
    
    var typePicker = UIPickerView()
    var discountPicker = UIPickerView()
    
    
    @IBOutlet weak var lblFinalAmount2: UILabel!
    @IBOutlet var lblTotalAmount: UIView!
    @IBOutlet weak var tableOrders: UITableView!
    
      
    override func viewDidLoad() {
        super.viewDidLoad()
        createPaymentTypePicker()
        createDiscountTypePicker()
        createToolbar()
        tableOrders.tableFooterView = UIView(frame: CGRect.zero)
        downloadOrders {
            self.tableOrders.reloadData()
        }
    }
    

    let paymentTypes = ["CREDIT CARD", "CASH", "CHECK PAYMENT"]
    @IBOutlet weak var tfPicker: UITextField!
    
    let discountTypes = ["REGULAR CUSTOMER", "SPECIAL DISCOUNT", "NO REDUCTION"]
    @IBOutlet weak var tfDiscountPicker: UITextField!
    
    
    func createPaymentTypePicker() {
        typePicker = UIPickerView()
        typePicker.delegate = self
        tfPicker.inputView = typePicker
        typePicker.backgroundColor = .black
    }
    func createDiscountTypePicker() {
         discountPicker = UIPickerView()
        discountPicker.delegate = self
        tfDiscountPicker.inputView = discountPicker
        discountPicker.backgroundColor = .black
    }
    

    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(WaiterOrderConfirm.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        tfPicker.inputAccessoryView = toolBar
        tfDiscountPicker.inputAccessoryView = toolBar
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    @IBOutlet weak var lblPickerResult: UILabel!
    
    
    
    @IBOutlet var btnBillOutlet: UIView!
    
    
    @IBAction func btnBill(_ sender: Any) {
        
        sendBill(orderReceived: orderReceived){ [weak self] (result) in switch result {
                case.success(let returnedBill):
                self?.returnedBill = returnedBill
                self!.lblFinalAmount2.text = "\(returnedBill.total_amount) din."
                case.failure( _):
                print("nije stigao sto")
            }
        }
    }
    
    
    
    func sendBill(orderReceived: [OrdersReceived], completion: @escaping(Result<BillComplete, Error>) -> Void) {
        
        var paymentFinal: String?
        
        switch tfPicker.text {
        case "CREDIT CARD":
            paymentFinal = "CREDIT_CARD"
        case "CASH":
            paymentFinal = "CASH"
        case "CHECK PAYMENT":
            paymentFinal = "CHECK_PAYMENT"
        case "":
            paymentFinal = "MORA BREJK"

        case .none:
            print("ovo")
        case .some(_):
            print("ono")
        }
              
        let reduction = calculateReduction()
        
        if paymentFinal == "MORA BREJK" {
            let alert = self.alertService.alert(message: "Please select payment type!")
            self.present(alert, animated: true)
            return
        } else {
        
        
        let newBill = Bill(id_dinning_table: dinningTable.id_dinningTable, id_user: login.id_user, payment_type: paymentFinal!, reduction: reduction, id_restaurant: login.id_restaurant, orders: orderReceived)
        
        
        let jsonBody = try? JSONEncoder().encode(newBill)
        
        let urlString = apiLink + "/rest/bills/load"
        let url = URL (string: urlString)!
        let jwt = login.jwt
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody as Data?
        request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let _: Void  = session.dataTask(with: request) { (data, response, error) in
            
            if error == nil {
                do {
                self.returnedBill = try JSONDecoder().decode(BillComplete.self, from: data!)
                DispatchQueue.main.async {
                completion(.success(self.returnedBill))
                }
                } catch {
                    print("Json error")
                }
            }
        }
         .resume()

        }
    }
    func calculateReduction() -> Double {
        
        var discountReduction: Double = 0.0
        var dicountPaymentType: Double = 0.0 
        
        if (tfDiscountPicker.text == "REGULAR CUSTOMER"){
            discountReduction = 0.1
        } else if (tfDiscountPicker.text == "SPECIAL DISCOUNT"){
            discountReduction = 0.2
        } else if (tfDiscountPicker.text == "NO REDUCTION"){
            discountReduction = 0.0
        }
        
        if (tfPicker.text == "CREDIT CARD"){
            dicountPaymentType = 0.2
        } else if (tfPicker.text == "CASH"){
           dicountPaymentType = 0.1
        } else {
           dicountPaymentType = 0.0
        }
        
        return (1 - discountReduction - dicountPaymentType)
    }
    
    
        
    @IBOutlet var btnBack: UIView!
    
    @IBAction func btnBackAction(_ sender: Any) {
        performSegue(withIdentifier: "backToOffersSelect", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? WaiterOffersSelect {
            destination.login = login!
            destination.apiLink = apiLink!
            destination.tableNumber = tableNumber!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderReceived.count

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WaiterOrdersCell") as? WaiterOrdersCell else {
        return UITableViewCell()
            
        }
        availableOfferRequested = getOffer(id_Offer: orderReceived[indexPath.row].id_offer)

        cell.lblName.text = availableOfferRequested.restaurant_offer_name
        cell.lblQuantity.text = "\(orderReceived[indexPath.row].quantity)"
        cell.lblPrice.text = "\(availableOfferRequested.restaurant_offer_price)"
        
        let fullPrice = Double (orderReceived[indexPath.row].quantity) * availableOfferRequested.restaurant_offer_price
        
        cell.lblTotalPrice.text = "\(fullPrice)"
        

        return cell
    }
    
    func getOffer (id_Offer: Int) -> Offers {
        for offerrr in availableOffersAll {
            if (offerrr.idOffer == id_Offer) {
                availableOfferRequested = offerrr
            }
        }
        return availableOfferRequested
    }
    
    
    

    func getOfferID (offerName: String) -> Int {
        var response = 0
        for offerrr in availableOffersAll {
            if (offerrr.restaurant_offer_name == offerName) {
                response = offerrr.idOffer
            }
        }
        return response
    }
    func getOfferName (id_Offer: Int) -> String {
        var response = ""
        for offerrr in availableOffersAll {
            if (offerrr.idOffer == id_Offer) {
                response = offerrr.restaurant_offer_name
            }
        }
        return response
    }
    
    
    
    
    
    func downloadOrders(completed: @escaping () -> ()) {
        
        orderReceived = OrdersReceived.downloadOrders(login.jwt, dinningTable.id_dinningTable, apiLink) { [weak self] (result) in switch result {
      case.success(let orderReceived):
      self?.orderReceived = orderReceived
      
      for _ in orderReceived {
            DispatchQueue.main.async {
                      completed()
                  }
        }
      case.failure( _):
      print("nisu stile porudzbine")
        }
    }
    

    }
    

}
