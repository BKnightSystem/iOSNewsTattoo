//
//  Extensions.swift
//  Tattoo
//
//  Created by Jonathan Cruz Orozco on 01/03/16.
//  Copyright © 2016 TecnoSoft. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIImageView {
    func circleImage(image:UIImage){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.image = image
    }
    
    override func borderRadius(radius:CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
}

extension UIView {
    func borderRadius(radius:CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
}