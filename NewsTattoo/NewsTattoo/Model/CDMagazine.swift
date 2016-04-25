//
//  CDMagazine.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz Orozco on 16/04/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import Foundation
import CoreData

class CDMagazine {
    
    class func fetchRequest() -> Bool{
        var fetch = false
        //1
        magazineCD.removeAll()
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Magazine")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            magazineCD = results as! [NSManagedObject]
            
            fetch = true
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            fetch = false
        }
        
        return fetch
    }
    
    class func existePortada(magazine magazine:MagazinePortada) -> Bool {
        var isFavorite = false
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Magazine")
        let idEst = magazine.idEstudio
        let idMag = magazine.idMagazine
        fetchRequest.predicate = NSPredicate(format: "idEstudio == %@ AND idMagazine == %@", idEst, idMag)
        do {
            let existPortada = try managedContext.executeFetchRequest(fetchRequest)
            if existPortada.count > 0 {
                isFavorite = true
            }else {
                isFavorite = false
            }
            
        }catch {
            isFavorite = false
        }
        
        return isFavorite
    }
    
    class func saveMagazinePortada(magazine magazine:MagazinePortada) -> Bool{
        var portadaSave = false
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Magazine", inManagedObjectContext:managedContext)
        
        let   magazinePor = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        magazinePor.setValue(magazine.nombre, forKey: "nombre")
        magazinePor.setValue(magazine.idEstudio, forKey: "idEstudio")
        magazinePor.setValue(magazine.idMagazine, forKey: "idMagazine")
        magazinePor.setValue(magazine.mes, forKey: "mes")
        magazinePor.setValue(magazine.anio, forKey: "anio")
        
        //4
        do {
            try managedContext.save()
            //5
            portadaSave = true
            magazineCD.append(magazinePor)
        } catch let error as NSError  {
            portadaSave = false
            //print("Could not save \(error), \(error.userInfo)")
        }
        
        return portadaSave
    }
    
    class func updateContact(magazine magazine:NSManagedObject, newValues:MagazinePortada) -> Bool{
        var contactSave = false
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        //let entity =  NSEntityDescription.entityForName("Contacto", inManagedObjectContext:managedContext)
        
        //let   contact = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        magazine.setValue(newValues.nombre, forKey: "nombre")
        magazine.setValue(newValues.idMagazine, forKey: "apellidos")
        magazine.setValue(newValues.idEstudio, forKey: "telefono")
        magazine.setValue(newValues.mes, forKey: "direccion")
        magazine.setValue(newValues.anio, forKey: "foto")
        
        //4
        do {
            try managedContext.save()
            //5
            contactSave = true
            magazineCD.append(magazine)
        } catch let error as NSError  {
            contactSave = false
            //print("Could not save \(error), \(error.userInfo)")
        }
        
        return contactSave
    }
    
    class func deleteMagazinePortada(index:Int) -> Bool{
        var deleteContact = false
        // 1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        managedContext.deleteObject(magazineCD[index])
        
        // 3
        do {
            try managedContext.save()
            // 4
            magazineCD.removeAtIndex(index)
            deleteContact = true
        } catch let error as NSError  {
            deleteContact = false
            //print("Could not save \(error), \(error.userInfo)")
        }
        
        return deleteContact
        
    }
}