//
//  Utilidades.swift
//  Tattoo
//
//  Created by Jonathan Cruz on 24/03/16.
//  Copyright © 2016 TecnoSoft. All rights reserved.
//

import Foundation
import UIKit

class Utilidades {
    class func base64ToImage(base64String:String) -> UIImage {
        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedimage = UIImage(data: decodedData!)
        
        return decodedimage!
    }
    
    class func callPhone(telephone:String){
        let phone = "tel://\(telephone)"
        let url:NSURL = NSURL(string:phone)!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}