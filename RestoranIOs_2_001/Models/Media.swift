//
//  Media.swift
//  RestoranIOs_2_001
//
//  Created by Damnjan Markovic on 01/05/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String, filename: String) {
        
        self.key = key
        self.mimeType = "image/jpg"
        self.filename = filename
    
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
        
        
        
        
    }
}

