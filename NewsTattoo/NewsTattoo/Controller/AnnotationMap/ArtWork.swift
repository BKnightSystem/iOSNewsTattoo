//
//  ArtWork.swift
//  mBanking-ios
//
//  Created by Jonathan Cruz on 25/11/15.
//  Copyright © 2015 Planetmedia. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class ArtWork:NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    class func sucursalArt(sucursal:Estudios) -> ArtWork? {
        // 1
        var title: String
        if sucursal.nombreEstudio != "" {
            title = sucursal.nombreEstudio
        } else {
            title = ""
        }
        let locationName = sucursal.nombreEstudio
        let discipline = ""//sucursal.direccion
        
        // 2
        let latitude = sucursal.latitud
        let longitude = sucursal.longitud
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // 3
        return ArtWork(title: title, locationName: locationName, discipline: discipline, coordinate: coordinate)
    }
    
    // annotation callout info button opens this mapItem in Maps app
    // annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [String(kABPersonAddressStreetKey): self.subtitle as! AnyObject]
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDict)
        //MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }
}
