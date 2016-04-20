//
//  CDGaleria.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz Orozco on 16/04/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import Foundation
import CoreData

class CDGaleria {
    
    class func fetchRequest() -> Bool{
        var fetch = false
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Galeria")
        
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
    
    class func existeGaleria(magazine magazine:MagazinePortada) -> Bool {
        var isFavorite = false
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Galeria")
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
    
    class func saveMagazinePage(pageMagazine pageMagazine:Magazine) -> Bool {
        var portadaSave = false
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Galeria", inManagedObjectContext:managedContext)
        
        let   magazinePage = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        magazinePage.setValue(pageMagazine.idImagen, forKey: "idImagen")
        magazinePage.setValue(pageMagazine.idEstudio, forKey: "idEstudio")
        magazinePage.setValue(pageMagazine.idMagazine, forKey: "idMagazine")
        magazinePage.setValue(pageMagazine.nombreTatuador, forKey: "tatuador")
        magazinePage.setValue(pageMagazine.descripcion, forKey: "texto")
        
        //4
        do {
            try managedContext.save()
            //5
            portadaSave = true
            galeriaCD.append(magazinePage)
        } catch let error as NSError  {
            portadaSave = false
            print("Could not save \(error), \(error.userInfo)")
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
            print("Could not save \(error), \(error.userInfo)")
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
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return deleteContact
        
    }
    
    class func initPageMagazine(idEstudio:String, idMagazine:Int){
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Galeria")

        fetchRequest.predicate = NSPredicate(format: "idEstudio == \(idEstudio) AND idMagazine == \(idMagazine)")
        
        do {
            let existPortada = try managedContext.executeFetchRequest(fetchRequest)
            galeriaCD = existPortada as! [NSManagedObject]
            
        }catch {
            
        }
    }
}
