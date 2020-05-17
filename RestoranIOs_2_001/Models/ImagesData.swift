//
//  ImagesData.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 21/04/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import Foundation
import SSZipArchive

class ImagesData: Decodable, Encodable {
    var image: [Image]


    static func getImage(_ jwt: String,_ id_image: Int, _ apiLink:String, completed: @escaping (Result<Data, Error>) -> ()) -> () {
      

      let urlString = apiLink + "/rest/users/getUserImages"
      let url = URL (string: urlString)
      var request = URLRequest(url: url!)
      request.httpMethod = "GET"
      request.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
      let session = URLSession.shared
      session.dataTask(with: request) { (data, response, error) in
          if error == nil {
//            SSZipArchive.unzipFile(atPath: data, toDestination: "slike.zip")
              completed(.success(data!))
            print(data!)
          }
      }.resume()
       
    }
}

   /*

 static func unzipData(objectData: Data) {
    var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    var documentsDir = paths[0]
    let zipPath: () = documentsDir.append("MyZipFiles")
    let folderPath: () = documentsDir.append("/docLibFiles") // My folder name in document directory
    var optData = Data(objectData.valueForKey("image") as! Data)
     print(objectData.valueForKey("imageUrl") as! String)
     optData.writeToFile(zipPath, atomically: true)
     let success = fileManager.fileExistsAtPath(zipPath) as Bool
     if success == false {
         do {
             try! fileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
         }
     }
     queue.addOperationWithBlock { () -> Void in
         let operation1 = NSBlockOperation(block: {
             let unZipped = SSZipArchive.unzipFileAtPath(zipPath, toDestination: folderPath)

         })
         operation1.completionBlock = {
             if queue.operationCount == 0 {
                 dispatch_async(dispatch_get_main_queue(), {
                     if queue.operationCount == 0 {
                         self.retrieveFiles()
                     }
                 })
             }
         }
         queue.addOperation(operation1)

     }
 }

 func getDocumentsURL() -> NSURL {
     let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
     return documentsURL
 }

 func fileInDocumentsDirectory(filename: String) -> String {
     let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
     return fileURL.path!
 }

 func retrieveFiles() {
     var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
     let documentsDir = paths[0]
     let zipPath = documentsDir.stringByAppendingString("MyZipFiles")
     let folderPath = documentsDir.stringByAppendingString("/docLibFiles") // My folder name in document directory
     do {
         let filelist = try fileManager.contentsOfDirectoryAtPath(folderPath)
         print(filelist)
         print("filename")
         for filename in filelist {

             fileNameArray.append(filename)
         }
     } catch let error as NSError  {
         print("Could not save \(error)")
     }
     do {
         for item in fileNameArray {
             print("item \(item)")
             let imagePath = fileInDocumentsDirectory("docLibFiles/\(item)")
             imageArray.append(UIImage(contentsOfFile: imagePath)!)
         }
         print("filename array \(fileNameArray)")
         print("image array \(imageArray)")
         unzipDelegate!.unzipSet(imageArray)
     }
 }
 
*/
