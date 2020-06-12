//
//  BillsViewControllerTableViewController.swift
//  RestoranIOs
//
//  Created by Damnjan Markovic on 10/06/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit
import DatePickerDialog

class BillViewController: UIViewController {
    var login: Login!
    var apiLink: String!
    let paymentTypes = ["CREDIT_CARD", "CASH", "CHECK_PAYMENT", "ALL"]
    var typePicker = UIPickerView()
    @IBOutlet weak var tableViewBills: UITableView!
    
    
    let datePicker = DatePickerDialog(
        textColor: .red,
        buttonColor: .red,
        font: UIFont.boldSystemFont(ofSize: 17),
        showCancelButton: true
    )
    
    
    @IBOutlet weak var tfBegins: UITextField!
    @IBOutlet weak var tfDateEnds: UITextField!
    @IBOutlet weak var tfPaymentType: UITextField!
    
    
    var bills = [Bills]()
    var billsCash = [Bills]()
    var billsCreditCard = [Bills]()
    var billsCheck = [Bills]()
    var finalBIlls = [Bills]()
    var finalBillsTimings = [Bills]()
    var selectedBill: Bills!
    var allOffers: [AvailableOffers]!
    
    var users = [Users]()
    var restaurants = [Restaurant]()
    var paymentType: String?
    
    var dateBeginsSet = Date()
    var dateEndsSet = Date()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfBegins.delegate = self
        tfDateEnds.delegate = self
        createTypePicker()
        tableViewBills.dataSource = self
        tableViewBills.delegate = self
        downloadRestaurants()
        downloadAllUsers()
        registerBillCell()
        getAllBills{
            self.setBills()
            self.tableViewBills.reloadData()
        }

        
        
    }
    
    
    
    
}

extension BillViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func downloadRestaurants() {
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
                        print("stigli restorani")
                        
                    }
                }catch{
                    print("Json restaurant error")
                }
            }
        }.resume()
    }
    func clearBills() {
        billsCheck = []
        billsCreditCard = []
        billsCash = []
        finalBIlls = []
    }
    
    
    
    func setBills() {
        
        clearBills()
        for bill in self.bills {
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateArrived = dateFormatter.date(from:(bill.bill_time.components(separatedBy: "T"))[0])
            
            if ((!tfBegins.text!.isEmpty) && (!tfDateEnds.text!.isEmpty)) {
               if (dateArrived! > dateBeginsSet) &&
                 (dateArrived! < dateEndsSet) {
                    
                finalBIlls.append(bill)
                if (bill.payment_type == "CASH") {
                        self.billsCash.append(bill)
                    }
                    else if (bill.payment_type == "CREDIT_CARD") {
                        self.billsCreditCard.append(bill)
                    }
                    else if (bill.payment_type == "CHECK_PAYMENT") {
                        self.billsCheck.append(bill)
                    }
                }
            
            } else {
                finalBIlls.append(bill)
                if (bill.payment_type == "CASH") {
                    self.billsCash.append(bill)
                }
                else if (bill.payment_type == "CREDIT_CARD") {
                    self.billsCreditCard.append(bill)
                }
                else if (bill.payment_type == "CHECK_PAYMENT") {
                    self.billsCheck.append(bill)
                }

                
            }
            
            
        }
        
    }
            
            func getAllBills(completed: @escaping () -> ()) {
                let jwt = login.jwt
                let urlString = apiLink + "/rest/bills/all"
                let url = URL (string: urlString)
                var request = URLRequest(url: url!)
                request.httpMethod = "GET"
                request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
                let session = URLSession.shared
                let _: Void = session.dataTask(with: request) { (data, response, error) in
                    if error == nil {
                        do {
                            self.bills = try JSONDecoder().decode([Bills].self, from: data!)
                            DispatchQueue.main.async {
                                completed()
                            }
                        }catch{
                            print("Bills Json error")
                        }
                    }
                }.resume()
            }
            
            
            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                if ((!tfPaymentType.text!.isEmpty) && (tfPaymentType.text == "CASH")) {
                    return billsCash.count
                }
                else if ((!tfPaymentType.text!.isEmpty) && (tfPaymentType.text == "CREDIT_CARD")) {
                    return billsCreditCard.count
                }
                else if ((!tfPaymentType.text!.isEmpty) && (tfPaymentType.text == "CHECK_PAYMENT")) {
                    return billsCheck.count
                }
                else {
                    if !finalBIlls.isEmpty {
                        return finalBIlls.count
                        
                    }
                    else {return 0 }
                }
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

                let cell = tableView.dequeueReusableCell(withIdentifier: "billTableCell", for: indexPath) as! BillCell

                
                var billShowing = finalBIlls[indexPath.row]
                if ((!tfPaymentType.text!.isEmpty) && (tfPaymentType.text == "CASH")) {
                    billShowing = billsCash[indexPath.row]
                }
                else if ((!tfPaymentType.text!.isEmpty) && (tfPaymentType.text == "CREDIT_CARD")) {
                    billShowing = billsCreditCard[indexPath.row]
                }
                else if ((!tfPaymentType.text!.isEmpty) && (tfPaymentType.text == "CHECK_PAYMENT")) {
                    billShowing = billsCheck[indexPath.row]
                }
                else {
                    billShowing = bills[indexPath.row]
                }
                
                for user in self.users {
                    if user.id_user == billShowing.id_user {
                        cell.lblWaiterName.text = user.userFirstName!
                    }
                }
               
                for rest in self.restaurants {
                    if rest.id_restaurant == billShowing.id_restaurant {
                        cell.lblRestaurantName.text = rest.name_restaurant
                    }
                }
                
                let timeChar = (String(billShowing.bill_time)).components(separatedBy: "T")
                cell.lblDate.text = timeChar[0]
                
                cell.lblFinalAmount.text = String(billShowing.total_amount)
                
              
                return cell
                
            }
            func registerBillCell() {
                tableViewBills.register(UINib(nibName: "BillCell", bundle: nil), forCellReuseIdentifier: "billTableCell")
            }
            
            func downloadAllUsers() {
                
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
                             print("stigli useri")
                            }
                        }catch{
                            print("USER Json error")
                        }
                    }
                }.resume()
            }
            
            
        }
        
        
        
        extension BillViewController: UITextFieldDelegate {
            func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
                datePickerTapped(textFieldArrived: textField)
                return true
            }
            
            func datePickerTapped(textFieldArrived: UITextField) {
                DatePickerDialog().show("Please select date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date){
                    (date) -> Void in
                    
                    if let dt = date {
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        if (textFieldArrived.placeholder == "start date") {
                            self.tfBegins.text = formatter.string(from: dt)
                            self.dateBeginsSet = formatter.date(from:self.tfBegins.text!)!
                            self.setBills()
                            self.tableViewBills.reloadData()
                            
                        } else {
                            self.tfDateEnds.text = formatter.string(from: dt)
                            self.dateEndsSet = formatter.date(from:self.tfDateEnds.text!)!
                            self.setBills()
                            self.tableViewBills.reloadData()
                            
                        }
                    }
                }
            }
            
            
        }
        
        extension BillViewController: UIPickerViewDelegate, UIPickerViewDataSource {
            
            func createTypePicker() {
                typePicker = UIPickerView()
                typePicker.delegate = self
                tfPaymentType.inputView = typePicker
                typePicker.backgroundColor = .white
            }
            
            func numberOfComponents(in pickerView: UIPickerView) -> Int {
                return 1
            }
            
            func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                paymentTypes.count
            }
            func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
                return paymentTypes[row]
            }
            func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                tfPaymentType.text = paymentTypes[row]
                tableViewBills.reloadData()
            }
            
}

