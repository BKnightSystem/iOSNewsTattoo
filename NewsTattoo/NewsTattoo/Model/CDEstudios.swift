//
//  CDEstudios.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz Orozco on 16/04/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import Foundation
import CoreData

class CDEstudios {
    
    class func fetchRequest() -> Bool{
        var fetch = false
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Estudios")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            estudios = results as! [NSManagedObject]
            
            fetch = true
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            fetch = false
        }
        
        return fetch
    }
    
    class func saveStudio(dataEstudio dataEstudio:Estudios) -> Bool{
        var estudiotSave = false
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Estudios", inManagedObjectContext:managedContext)
        
        let estudio = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        estudio.setValue(dataEstudio.idEstudio, forKey: "idEstudio")
        estudio.setValue(dataEstudio.nombreEstudio, forKey: "nombre")
        estudio.setValue(dataEstudio.telefono, forKey: "telefono")
        estudio.setValue(dataEstudio.direccion, forKey: "direccion")
        estudio.setValue(dataEstudio.latitud, forKey: "latitud")
        estudio.setValue(dataEstudio.longitud, forKey: "longitud")
        //estudio.setValue(dataEstudio.imgLogo, forKey: "logo")
        
        //4
        do {
            try managedContext.save()
            //5
            estudiotSave = true
            estudios.append(estudio)
        } catch let error as NSError  {
            estudiotSave = false
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return estudiotSave
    }
    
    class func getNamesEstudio(idEstudio:String) -> String {
        var isFavorite: String = ""
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Estudios")
//        let idEst = magazine.idEstudio
//        let idMag = magazine.idMagazine
        fetchRequest.predicate = NSPredicate(format: "idEstudio == %@", idEstudio)
        do {
            let existPortada = try managedContext.executeFetchRequest(fetchRequest)
            if existPortada.count > 0 {
                isFavorite =  existPortada[0].valueForKey("nombre") as! String
            }else {
                isFavorite = ""
            }
            
        }catch {
            isFavorite = ""
        }
        
        return isFavorite
    }
    
    class func getTelephoneEstudio(idEstudio:String) -> String {
        var telephone: String = ""
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Estudios")
        //        let idEst = magazine.idEstudio
        //        let idMag = magazine.idMagazine
        fetchRequest.predicate = NSPredicate(format: "idEstudio == %@", idEstudio)
        do {
            let existPortada = try managedContext.executeFetchRequest(fetchRequest)
            if existPortada.count > 0 {
                telephone =  existPortada[0].valueForKey("telefono") as! String
            }else {
                telephone = ""
            }
            
        }catch {
            telephone = ""
        }
        
        return telephone
    }
    
    class func updateContact(estudio estudio:NSManagedObject, newValues:Estudios) -> Bool{
        var estudioSave = false
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        //let entity =  NSEntityDescription.entityForName("Contacto", inManagedObjectContext:managedContext)
        
        //let   contact = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        estudio.setValue(newValues.idEstudio, forKey: "idEstudio")
        estudio.setValue(newValues.nombreEstudio, forKey: "nombre")
        estudio.setValue(newValues.telefono, forKey: "telefono")
        estudio.setValue(newValues.direccion, forKey: "direccion")
        estudio.setValue(newValues.latitud, forKey: "latitud")
        estudio.setValue(newValues.longitud, forKey: "longitud")
        //estudio.setValue(newValues.imgLogo, forKey: "logo")
        
        //4
        do {
            try managedContext.save()
            //5
            estudioSave = true
            estudios.append(estudio)
        } catch let error as NSError  {
            estudioSave = false
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return estudioSave
    }
    
    class func deleteEstudio(index:Int) -> Bool{
        var deleteContact = false
        // 1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        managedContext.deleteObject(estudios[index])
        
        // 3
        do {
            try managedContext.save()
            // 4
            estudios.removeAtIndex(index)
            deleteContact = true
        } catch let error as NSError  {
            deleteContact = false
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return deleteContact
        
    }
    
    class func deleteAllEstudios() {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        //let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "Estudios")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let incidents = try context.executeFetchRequest(fetchRequest)
            
            if incidents.count > 0 {
                
                for result: AnyObject in incidents{
                    context.deleteObject(result as! NSManagedObject)
                    //print("NSManagedObject has been Deleted")
                }
                try context.save()
            }
        } catch {}
    }
}