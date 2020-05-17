//
//  OffersSaveRequest.swift
//  
//
//  Created by Damnjan Markovic on 01/05/2020.
//

import Foundation

class OffersSaveRequest: Codable {
    

    let restaurant_offer_name: String
    let restaurant_offer_price: Double
    let offer_type: String
    let id_image: Int
    let specialMessage: String
    
    
    init(restaurant_offer_name: String, restaurant_offer_price: Double, offer_type: String, id_image: Int, specialMessage: String) {
        
      
        self.restaurant_offer_name = restaurant_offer_name
        self.restaurant_offer_price = restaurant_offer_price
        self.offer_type = offer_type
        self.id_image = id_image
        self.specialMessage = specialMessage

    }


     static func saveOffer( _ jwt: String, _ imageNew: Media, _ newOffer: OffersSaveRequest, _ apiLink: String){

         let urlString = apiLink + "/rest/offers/saveOrUpdate"
         guard let url = URL (string: urlString) else { return }
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         let boundary = "Boundary-\(NSUUID().uuidString)"
         request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
         
         let param = [
         "restaurant_offer_name"          : newOffer.restaurant_offer_name,
         "restaurant_offer_price"          : newOffer.restaurant_offer_price,
         "offer_type"     : newOffer.offer_type,
         "id_image"         : newOffer.id_image,
         "specialMessage"     : newOffer.specialMessage
         
         ] as [String : Any]
        
        
        let bodyFinal = OffersSaveRequest.createBody(withParameters: param, imageNew: imageNew, boundary: boundary)
         
         request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
         request.setValue("(myRequestData.length)", forHTTPHeaderField: "Content-Length")
         request.httpBody = bodyFinal as Data
         let session = URLSession.shared
         session.dataTask(with: request) { (data, response, error) in
           if error == nil {
//                     print("radi, jbt")
//                     print(response!)
               }
           else { print (error!)
               }
           }.resume()
     }
     
     static func createBody(withParameters param: Parametars, imageNew: Media, boundary: String) -> Data {
       
        var bodyFinal = Data()
        let mimetype = "neki dodatni opis slike"
         for (key, value) in param {
                        
            bodyFinal.append("--\(boundary)\r\n")
                bodyFinal.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                bodyFinal.append("\(value)\r\n")
            }

              bodyFinal.append("--\(boundary)\r\n")
              bodyFinal.append("Content-Disposition:form-data; name=\"imageFile\"; filename=\"\(imageNew.filename)\"\r\n")
              bodyFinal.append("Content-Type: \(mimetype)\r\n\r\n")
              bodyFinal.append(imageNew.data)
              bodyFinal.append("\r\n")
              bodyFinal.append("--\(boundary)--\r\n")
            
        return bodyFinal as Data
     }

 }

 extension Data {
     mutating func append(_ string: String) {
         if let data = string.data(using: .utf8) {
             append(data)
         }
     }
}
 typealias Parametars = [String: Any]
