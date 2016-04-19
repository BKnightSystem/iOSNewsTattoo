//
//  MapaViewController.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz Orozco on 01/04/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa:MKMapView!
    var locationManager: CLLocationManager!
    var indexEstudio:Int! = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.createNavigationBar()
        self.location()
        
        self.mapa.showsUserLocation = true
        self.mapa.removeAnnotations(self.mapa.annotations)
        mapa.delegate = self
        
        self.showSucLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func zoomToRegion() {
        let latitud = arrayEstudiosTattoo[indexEstudio].latitud
        let longitud = arrayEstudiosTattoo[indexEstudio].longitud
        print("Latitud y longitud \(latitud) \(longitud)")
        
        let location = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        mapa.setRegion(region, animated: true)
    }
    
    func showSucLocation(){
        let latitud = arrayEstudiosTattoo[indexEstudio].latitud
        let longitud = arrayEstudiosTattoo[indexEstudio].longitud
        let sucLocation = CLLocationCoordinate2DMake(latitud, longitud)
        
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = sucLocation
        dropPin.title = arrayEstudiosTattoo[indexEstudio].nombreEstudio
        
        mapa.addAnnotation(dropPin)
        let region = MKCoordinateRegionMakeWithDistance(sucLocation, 5000.0, 7000.0)
        
        mapa.setRegion(region, animated: true)
        
        self.loadPinSucursal()
    }
    
    var artworks = [ArtWork]()
    
    func loadPinSucursal() {
        artworks.removeAll()
        self.mapa.removeAnnotations(self.mapa.annotations)
        
        artworks.removeAll()
        
        let estudio = arrayEstudiosTattoo[indexEstudio]
        let artwork = ArtWork.sucursalArt(estudio)
        artworks.append(artwork!)
        
        mapa.addAnnotations(artworks)
        
        
        self.mapa.delegate = self
    }
    
    //MARK: - Location Manager
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = manager.location //locations.last as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapa.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Denied:
            print("GPS OFF**********************************")
            self.alertGPS()
            break
        case .AuthorizedAlways:
            print("GPS ON**********************************")
            
            break
        default:
            break
        }
    }
    //Location
    func location(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    //        if let annotation = annotation as? ArtWork {
    //            let identifier = "pin"
    //            var view: MKPinAnnotationView
    //            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
    //                as? MKPinAnnotationView { // 2
    //                    dequeuedView.annotation = annotation
    //                    view = dequeuedView
    //            } else {
    //                // 3
    //                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    //                view.canShowCallout = true
    //                view.calloutOffset = CGPoint(x: -5, y: 5)
    //                view.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIView
    //            }
    //            return view
    //        }
    //        return nil
    //    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! ArtWork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    //MARK: Alerts
    func alertGPS(){
        //let alert = UIAlertView()
        
    }
    
    //MARK: NavigationBar
    func createNavigationBar(){
        self.title = arrayEstudiosTattoo[indexEstudio].nombreEstudio
        
        //self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        
        //Icono Izquierdo
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.setImage(IMAGE_ICON_BACK, forState: UIControlState.Normal)
        button.addTarget(self, action:"back", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame=CGRectMake(0, 0, 40, 40)
        let barButton = UIBarButtonItem(customView: button)
        //let login = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "login2")
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }

}
