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
    
    var reachability: Reachability?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.createNavigationBar()
        self.location()
        
        self.mapa.showsUserLocation = true
        self.mapa.removeAnnotations(self.mapa.annotations)
        mapa.delegate = self
        
        self.connectionInternet()
//        self.showSucLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        reachability!.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: ReachabilityChangedNotification,
                                                            object: reachability)
    }
    
    func connectionInternet() {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            //print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapaViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
           // print("could not start reachability notifier")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                //Reachable via WiFi
                self.showSucLocation()
            } else {
                //Reachable via Cellular
                self.showSucLocation()
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                Utilidades.alertSinConexion()
            }
        }
    }

    func zoomToRegion() {
        let latitud = arrayEstudiosTattoo[indexEstudio].latitud
        let longitud = arrayEstudiosTattoo[indexEstudio].longitud
        
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
           // print("GPS OFF**********************************")
            break
        case .AuthorizedAlways:
            //print("GPS ON**********************************")
            
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
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! ArtWork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    //MARK: NavigationBar
    func createNavigationBar(){
        self.title = arrayEstudiosTattoo[indexEstudio].nombreEstudio
        
        //Icono Izquierdo
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.setImage(IMAGE_ICON_BACK, forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(MapaViewController.back), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame=CGRectMake(0, 0, 40, 40)
        let barButton = UIBarButtonItem(customView: button)
        //let login = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "login2")
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }

}
