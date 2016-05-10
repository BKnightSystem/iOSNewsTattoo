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
        let url = NSURL(string: "http://canastadedulces.com.mx/obtener_estudios.php")
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
                datosEstudio.idEstudio = est["idEstudio"].stringValue
                datosEstudio.nombreEstudio = est["nombre"].stringValue
                datosEstudio.direccion = est["direccion"].stringValue
                datosEstudio.telefono = est["telefono"].stringValue
                datosEstudio.imgLogo = est["logo"].stringValue
                datosEstudio.latitud = est["latitud"].doubleValue
                datosEstudio.longitud = est["longitud"].doubleValue
                
                if datosEstudio.imgLogo != "" {
                    datosEstudio.logo = Utilidades.base64ToImage(datosEstudio.imgLogo)
                }
                
                arrayEstudiosTattoo.append(datosEstudio)
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
        let url = NSURL(string: "http://canastadedulces.com.mx/obtener_galeria.php?idEstudio=\(idEstudio!)&idMagazine=\(idMagazine!)")
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
                    let imagen = json["imagenes"].array
                    for est in imagen! {
                        let page = Magazine()
                        page.idEstudio = est["idEstudio"].stringValue
                        page.idMagazine = est["idMagazine"].stringValue
                        page.idImagen = est["idImagen"].stringValue
                        page.imageB64 = est["imagen"].stringValue
                        page.image = Utilidades.base64ToImage(page.imageB64)
                        page.nombreTatuador = est["nombre"].stringValue
                        page.descripcion = est["texto"].stringValue
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
        let idEstudio = datos["idEstudio"]
        print(datos["idEstudio"])
        let url = NSURL(string: "http://canastadedulces.com.mx/obtener_portadas.php?idEstudio=\(idEstudio!)")
        
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
                    let imagen = json["portadas"].array
                    for est in imagen! {
                        let portada = MagazinePortada()
                        portada.idEstudio = est["idEstudio"].stringValue
                        portada.idMagazine = est["idMagazine"].stringValue
                        portada.nombre = est["nombre"].stringValue
                        portada.mes = est["mes"].stringValue
                        portada.anio = est["anio"].stringValue
                        let revista = est["portada"].stringValue
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
        let url = NSURL(string: "http://www.canastadedulces.com.mx/obtener_promociones.php")
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
                    
                    let promocion = json["Promociones"].array
                    for promo in promocion! {
                        let datosPromocion = Promociones()
                        datosPromocion.idEstudio = promo["idEstudio"].stringValue
                        datosPromocion.idPromocion = promo["idPromocion"].stringValue
                        datosPromocion.imgPromocion = promo["imagen"].stringValue
                        datosPromocion.bannerPromocion = promo["bannerPromocion"].stringValue
                        
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