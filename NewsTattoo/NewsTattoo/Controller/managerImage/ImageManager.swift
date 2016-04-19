//
//  ImageManager.swift
//  NewsTattoo
//
//  Created by gigigo on 19/04/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import Foundation

class ImageManager {
    class func saveImage(imageLogo:UIImage, name:String) {
        if let image:UIImage = imageLogo {
            if let data = UIImagePNGRepresentation(image) {
                let filename = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent("\(name).png")
                print("save in \(filename) name \(name)")
                data.writeToFile(filename as String, atomically: true)
            }
        }
    }
    
    
}