//
//  ImageManager.swift
//  NewsTattoo
//
//  Created by gigigo on 19/04/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import Foundation

class ImageManager {
    
    class func deleteDirectory(nameDirectory:String){
        let path = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent(nameDirectory)
        let filemgr = NSFileManager.defaultManager()
        
        do {
            try filemgr.removeItemAtPath(path)
        }catch {
           // print("Failed to delete directory:\(path)")
        }
        
    }
    
    class func deletePortada(namePortada:String){
        let path = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent(namePortada)
        let filemgr = NSFileManager.defaultManager()
        
        do {
            try filemgr.removeItemAtPath(path)
        }catch {
            //print("Failed to delete directory:\(path)")
        }
    }
    
    //MARK: Image Logo Estudio
    class func createDirectoryImage() {
        let nameDirectory = "/LogosEstudio"
        let pathLogos = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent(nameDirectory)
        let manager = NSFileManager.defaultManager()
        
        if !(manager.fileExistsAtPath(pathLogos)) {
            do {
                try (manager.createDirectoryAtPath(pathLogos, withIntermediateDirectories: false, attributes: nil))
            }catch {
                //print("Directory LogosEstudio not create")
            }
        }
    }
    
    class func saveImage(imageLogo:UIImage, name:String) {
        if let image:UIImage = imageLogo {
            if let data = UIImagePNGRepresentation(image) {
                let filename = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent("/LogosEstudio/\(name).png")
                
                //print("save in \(filename) name \(name)")
                data.writeToFile(filename as String, atomically: true)
            }
        }
    }
    
    class func getLogoByID(idEstudio:String) -> UIImage? {
        let pathImage = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent("/LogosEstudio/\(idEstudio).png")
        let manager = NSFileManager.defaultManager()
        
        if (manager.fileExistsAtPath(pathImage)) {
            let dataImg = NSData(contentsOfFile: pathImage)
            let image:UIImage = UIImage(data: dataImg!)!
            
            return image
        }
        
        return nil
    }
    
    //MARK: Image Portada Magazine
    class func createDirectoryImagePortada() {
        let nameDirectory = "/PortadaMagazine"
        let pathLogos = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent(nameDirectory)
        let manager = NSFileManager.defaultManager()
        
        if !(manager.fileExistsAtPath(pathLogos)) {
            do {
                try (manager.createDirectoryAtPath(pathLogos, withIntermediateDirectories: false, attributes: nil))
            }catch {
               // print("Directory PortadaMagazine not create")
            }
        }
    }
    
    class func saveImagePortada(imagePortada:UIImage, name:String) {
        if let image:UIImage = imagePortada {
            if let data = UIImagePNGRepresentation(image) {
                let filename = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent("/PortadaMagazine/\(name).png")
                
                //print("save in \(filename) name \(name)")
                data.writeToFile(filename as String, atomically: true)
            }
        }
    }
    
    class func getPortadaByID(idPortada:String) -> UIImage? {
        let pathImage = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent("/PortadaMagazine/\(idPortada).png")
        let manager = NSFileManager.defaultManager()
        
        if (manager.fileExistsAtPath(pathImage)) {
            let dataImg = NSData(contentsOfFile: pathImage)
            let image:UIImage = UIImage(data: dataImg!)!
            
            return image
        }
        
        return nil
    }
    
    //MARK: Image page for magazine
    class func createDirectoryImagePage(nameDirectory:String) {
        let nameDirectory = "/PagesMagazine\(nameDirectory)"
        let pathLogos = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent(nameDirectory)
        print("Directory \(pathLogos)")
        
        let manager = NSFileManager.defaultManager()
        
        if !(manager.fileExistsAtPath(pathLogos)) {
            do {
                try (manager.createDirectoryAtPath(pathLogos, withIntermediateDirectories: false, attributes: nil))
            }catch {
                //print("Directory PagesMagazine not create")
            }
        }
    }
    
    class func saveImagePage(imagePage:UIImage, nameImage:String, nameDirectory:String) {
        if let image:UIImage = imagePage {
            if let data = UIImagePNGRepresentation(image) {
                let filename = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent("/PagesMagazine\(nameDirectory)/\(nameImage).png")
                
                //print("save in \(filename) name \(nameImage)")
                data.writeToFile(filename as String, atomically: true)
            }
        }
    }
    
    class func listPagesMagazine(nameDirectory:String) -> Int {
        
        var elementsPages = 0
        
        let pathDoc = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent("/PagesMagazine\(nameDirectory)")
        
        let manager = NSFileManager.defaultManager()
        do {
            let allItems = try manager.contentsOfDirectoryAtPath(pathDoc)
            elementsPages = allItems.count
        }catch {
            elementsPages = 0
        }
        
        return elementsPages
    }
    
    class func getPageByID(idPage:String, nameDirectory:String) -> UIImage? {
        let pathImage = Utilidades.getDocumentsDirectory().stringByAppendingPathComponent("/PagesMagazine\(nameDirectory)/\(idPage).png")
        
        let manager = NSFileManager.defaultManager()
        
        if (manager.fileExistsAtPath(pathImage)) {
            let dataImg = NSData(contentsOfFile: pathImage)
            let image:UIImage = UIImage(data: dataImg!)!
            
            return image
        }
        
        return nil
    }
}