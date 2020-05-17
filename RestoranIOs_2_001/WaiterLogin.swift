//
//  WaiterLogin.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 03/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit
import SSZipArchive

class WaiterLogin: UIViewController {
    
    var image = [Image]()

    @IBOutlet weak var buttonTable1: UIButton!
    @IBOutlet weak var buttonTable2: UIButton!
    @IBOutlet weak var buttonTable3: UIButton!
    @IBOutlet weak var buttonTable4: UIButton!
    @IBOutlet weak var buttonTable5: UIButton!
    @IBOutlet weak var buttonTable6: UIButton!
    @IBOutlet weak var buttonTable7: UIButton!
    @IBOutlet weak var buttonTable8: UIButton!
    @IBOutlet weak var buttonTable9: UIButton!

    let backgroundImageOccupied:UIImage? = UIImage(named: "occupied.jpg")
    let backgroundImageAvailable:UIImage? = UIImage(named: "empty_table2.png")
    var login: Login!
    var apiLink: String!
    var tableNumber: Int! = nil
    var buttonTagsList = [Int]()
    var buttonsAll = [UIButton]()
    @IBOutlet weak var imgSlika: UIImageView!
    @IBOutlet weak var lblLoginName: UILabel!
    var occupiedDinningTables = [DinningTable]()
    
    var samplePath: String!
    var zipPath: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblLoginName.text = login.userFirstName
        setImageLogin()
        getOccupiedDinningTables()
            samplePath = Bundle.main.bundlePath
        
        
 
 
    }
 
    
    func setButtonImages(_ occupiedDinningTables: [DinningTable]) {

        buttonTable1.setBackgroundImage(backgroundImageOccupied, for: UIControl.State.normal)
        buttonTable4.setBackgroundImage(backgroundImageAvailable, for: UIControl.State.normal)
        buttonTable1.tag = 1
        buttonTable2.tag = 2
        buttonTable3.tag = 3
        buttonTable4.tag = 4
        buttonTable5.tag = 5
        buttonTable6.tag = 6
        buttonTable7.tag = 7
        buttonTable8.tag = 8
        buttonTable9.tag = 9
        
        buttonsAll.append(buttonTable1)
        buttonsAll.append(buttonTable2)
        buttonsAll.append(buttonTable3)
        buttonsAll.append(buttonTable4)
        buttonsAll.append(buttonTable5)
        buttonsAll.append(buttonTable6)
        buttonsAll.append(buttonTable7)
        buttonsAll.append(buttonTable8)
        buttonsAll.append(buttonTable9)
        for btn in buttonsAll {
            btn.setBackgroundImage(backgroundImageAvailable, for: UIControl.State.normal)
        }
        for table in occupiedDinningTables {
            for btn in buttonsAll {
                if (table.table_number == btn.tag) {
                    btn.setBackgroundImage(backgroundImageOccupied, for: UIControl.State.normal)
            }
        }
        }
    }
    
    
    func setImageLogin() {
        
        Image.getImage(login.jwt, login.id_image, apiLink){(result) in switch result {
        case.success(let data):
            let image = UIImage(data: data)
        DispatchQueue.main.async {
            self.imgSlika.image = image
        }
        case.failure( _):
            print("nije stigla slika")
        }
        }
    }
        

    
    
    func getOccupiedDinningTables(){
        occupiedDinningTables = DinningTable.downloadOccupiedDinningTables(login, apiLink) { [weak self] (result) in switch result {
        case.success(let occupiedDinningTables):
            self!.setButtonImages(occupiedDinningTables)
        case.failure( _):
            print("nisu stigli zauzeti stolovi")
         }
        }
    }
    @IBAction func btnTable1(_ sender: Any) {
        tableNumber = 1
        performSegue(withIdentifier: "waiterToOffersSelect", sender: self)
    }
    
    
    @IBAction func btnTable2(_ sender: Any) {
        tableNumber = 2
         performSegue(withIdentifier: "waiterToOffersSelect", sender: self)
    }
    
    
    @IBAction func btnTable3(_ sender: Any) {
        tableNumber = 3
         performSegue(withIdentifier: "waiterToOffersSelect", sender: self)
    }
    
    
    @IBAction func btnTable4(_ sender: Any) {
        tableNumber = 4
         performSegue(withIdentifier: "waiterToOffersSelect", sender: self)
    }
    
    @IBAction func btnTable5(_ sender: Any) {
        tableNumber = 5
         performSegue(withIdentifier: "waiterToOffersSelect", sender: self)
    }
    
    @IBAction func btnTable6(_ sender: Any) {
        tableNumber = 6
         performSegue(withIdentifier: "waiterToOffersSelect", sender: self)
    }
    
    @IBAction func btnTable7(_ sender: Any) {
        tableNumber = 7
         performSegue(withIdentifier: "waiterToOffersSelect", sender: self)
    }
    
    
    @IBAction func btnTable8(_ sender: Any) {
        tableNumber = 8
         performSegue(withIdentifier: "waiterToOffersSelect", sender: self)
    }
    
    
    @IBAction func btnTable9(_ sender: Any) {
        tableNumber = 9
         performSegue(withIdentifier: "waiterToOffersSelect", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WaiterOffersSelect {
            destination.login = login!
            destination.tableNumber = tableNumber!
            destination.apiLink = apiLink
        }
    }
    func tempZipPath() -> String {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/\(UUID().uuidString).zip"
        return path
    }
    
    
    func tempUnzipPath(_ data:Data) -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/\(UUID().uuidString)"
        let url = URL(fileURLWithPath: path)

        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        return url.path
    }
    
    
}


