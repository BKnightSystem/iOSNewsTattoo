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
    
    class func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //MARK: Alert
    class func alertSinConexion() {
        let alert = SCLAlertView()
        alert.showCloseButton = false
        alert.addButton("Aceptar", action: {
            
        })
        
        alert.showInfo("Sin Conexión", subTitle: "No cuenta con conexión a Internet", closeButtonTitle: "Cancelar", duration: 0, colorStyle: UInt(COLOR_ICONOS), colorTextButton: UInt(COLOR_BLANCO))
    }
    
    //MARK: Validate email
    class func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = email.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
}
