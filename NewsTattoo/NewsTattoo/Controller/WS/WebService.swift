//
//  WebService.swift
//  Tattoo
//
//  Created by Jonathan Cruz on 24/03/16.
//  Copyright © 2016 TecnoSoft. All rights reserved.
//

import Foundation
import UIKit

class WebService {
    //MARK: get studios
    class func estudios(datos:[String:AnyObject], callback: ((isOk:Bool /*NSMutableDictionary*/)-> Void)?)
    {
        let url = NSURL(string: "\(HOST.url)/GetData_Studio.php")
        let theRequest = NSURLRequest(URL: url!)
        
        let urlConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlConfig.timeoutIntervalForRequest = TIMEOUT_REQUEST
        urlConfig.timeoutIntervalForResource = TIMEOUT_RESOURCE
        
        //let session = NSURLSession.sharedSession()
        let session = NSURLSession(configuration: urlConfig)
        
        session.dataTaskWithRequest(theRequest, completionHandler: {(data, response, error) in
        if data != nil && error == nil && response != nil {
            
            arrayEstudiosTattoo.removeAll()
                
            let json = JSON(data: data!)
            print("JSON \(json)")
            let estudio = json["Estudios"].array
            for est in estudio! {
                let datosEstudio = Estudios()
                datosEstudio.idEstudio = est["S_Id"].stringValue
                datosEstudio.nombreEstudio = est["NameStudio"].stringValue
                datosEstudio.direccion = est["Adress"].stringValue
                datosEstudio.telefono = est["PhoneNumber"].stringValue
                datosEstudio.imgLogo = est["Logo"].stringValue
                datosEstudio.latitud = est["Latitude"].doubleValue
                datosEstudio.longitud = est["Longitude"].doubleValue
                
                if datosEstudio.imgLogo != "" {
                    datosEstudio.logo = Utilidades.base64ToImage(datosEstudio.imgLogo)
                }
                
                //let estatus = est["estatus"].intValue
                //if estatus == 1 {
                    arrayEstudiosTattoo.append(datosEstudio)
                //}
                
            }
            
            callback!(isOk:true)
        }else {
            callback!(isOk:false)
            }
        }).resume()
    }
    
    //MARK: get images by studios
    class func galeriaEstudiosById(datos:[String:Int], callback: ((isOk:Bool /*NSMutableDictionary*/)-> Void)?)
    {
        let idEstudio = datos["idEstudio"]
        let idMagazine = datos["idMagazine"]
        print("ID ESTUDIO \(datos["idEstudio"])")
        let url = NSURL(string: "\(HOST.url)/GetData_Galery.php?S_Id=\(idEstudio!)&PM_Id=\(idMagazine!)")
        print("URL DE GALERIA \(url)")
        
        let theRequest = NSURLRequest(URL: url!)
        
//        let urlConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
//        urlConfig.timeoutIntervalForRequest = TIMEOUT_REQUEST
//        urlConfig.timeoutIntervalForResource = TIMEOUT_RESOURCE
        
        let session = NSURLSession.sharedSession()
        //let session = NSURLSession(configuration: urlConfig)
        
        
        //Clear Images
        arrayDetailPages.removeAll()
        
        session.dataTaskWithRequest(theRequest, completionHandler: {(data, response, error) in
            if data != nil && error == nil && response != nil {
                
                let json = JSON(data: data!)
                print("JSON \(json)")
                let estado = json["estado"].stringValue
                print("ESTADO \(estado)")
                arrayDetailPages.removeAll()
                
                if estado != "2" {
                    let imagen = json["Galery"].array
                    for est in imagen! {
                        let page = Magazine()
                        page.idEstudio = est["S_Id"].stringValue
                        page.idMagazine = est["PM_Id"].stringValue
                        page.idImagen = est["GM_Id"].stringValue
                        page.imageB64 = est["Image"].stringValue
                        page.image = Utilidades.base64ToImage(page.imageB64)
                        page.nombreTatuador = est["NameTatuador"].stringValue
                        page.descripcion = est["Description"].stringValue
                        arrayDetailPages.append(page)
                    }
                    
                    callback!(isOk:true)
                }else {
                    callback!(isOk:false)
                }
                
            }else {
                callback!(isOk:false)
            }
        }).resume()
    }
    
    //MARK: get the principal image for magazine
    class func portadaMagazineById(datos:[String:Int], callback: ((isOk:Bool /*NSMutableDictionary*/)-> Void)?)
    {
        let idEstudio = datos["S_Id"]
        print(datos["S_Id"])
        let url = NSURL(string: "\(HOST.url)/GetData_Portada.php?S_Id=\(idEstudio!)")
        
        let theRequest = NSURLRequest(URL: url!)
        
        let urlConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlConfig.timeoutIntervalForRequest = TIMEOUT_REQUEST
        urlConfig.timeoutIntervalForResource = TIMEOUT_RESOURCE
        
        //let session = NSURLSession.sharedSession()
        let session = NSURLSession(configuration: urlConfig)
        
        //Clear Images
        arrayPortadasTattoo.removeAll()
        
        session.dataTaskWithRequest(theRequest, completionHandler: {(data, response, error) in
            if data != nil  && error == nil && response != nil{
                
                let json = JSON(data: data!)
                print("JSON \(json)")
                let estado = json["estado"].stringValue
                print("ESTADO \(estado)")
                arrayPortadasTattoo.removeAll()
                
                if estado != "2" {
                    let imagen = json["Portadas"].array
                    for est in imagen! {
                        let portada = MagazinePortada()
                        portada.idEstudio = est["S_Id"].stringValue
                        portada.idMagazine = est["PM_Id"].stringValue
                        portada.nombre = est["NameMagazine"].stringValue
                        portada.mes = est["MonthMagazine"].stringValue
                        portada.anio = est["YearMagazine"].stringValue
                        let revista = est["Portada"].stringValue
                        portada.imgPortada = Utilidades.base64ToImage(revista)
                        arrayPortadasTattoo.append(portada)
                    }
                    
                    callback!(isOk:true)
                }else {
                    callback!(isOk:false)
                }
                
            }else {
                callback!(isOk:false)
            }
        }).resume()
    }
    
    //MARK: get promotions by studio
    class func promociones(datos:[String:AnyObject], callback: ((isOk:Bool /*NSMutableDictionary*/)-> Void)?)
    {
        let url = NSURL(string: "\(HOST.url)/GetData_Promotion.php")
        let theRequest = NSURLRequest(URL: url!)
        
        let urlConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlConfig.timeoutIntervalForRequest = TIMEOUT_REQUEST
        urlConfig.timeoutIntervalForResource = TIMEOUT_RESOURCE
        
        //let session = NSURLSession.sharedSession()
        let session = NSURLSession(configuration: urlConfig)
        
        session.dataTaskWithRequest(theRequest, completionHandler: {(data, response, error) in
            if data != nil && error == nil && response != nil {
                
                arrayPromociones.removeAll()
                
                let json = JSON(data: data!)
                print("JSON \(json)")
                
                let estado = json["estado"].stringValue
                
                if estado != "2" {
                    
                    let promocion = json["Promotions"].array
                    for promo in promocion! {
                        let datosPromocion = Promociones()
                        datosPromocion.idEstudio = promo["S_Id"].stringValue
                        datosPromocion.idPromocion = promo["Promo_Id"].stringValue
                        datosPromocion.imgPromocion = promo["Imagen"].stringValue
                        datosPromocion.bannerPromocion = promo["BannerPromotion"].stringValue
                        
                        if datosPromocion.imgPromocion != "" {
                            datosPromocion.imgViewPromocion = Utilidades.base64ToImage(datosPromocion.imgPromocion)
                        }
                        if datosPromocion.bannerPromocion != "" {
                            datosPromocion.bannerViewPromocion = Utilidades.base64ToImage(datosPromocion.bannerPromocion)
                        }
                        
                        arrayPromociones.append(datosPromocion)
                    }
                }
                
                callback!(isOk:true)
            }else {
                callback!(isOk:false)
            }
        }).resume()
    }
}
