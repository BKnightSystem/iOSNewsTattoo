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

    /*func zoomToRegion() {
        let latitud = arrayEstudiosTattoo[indexEstudio].latitud
        let longitud = arrayEstudiosTattoo[indexEstudio].longitud
        
        let location = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        mapa.setRegion(region, animated: true)
    }*/
    
    func showSucLocation(){
        let latitud = arrayEstudiosTattoo[indexEstudio].latitud
        let longitud = arrayEstudiosTattoo[indexEstudio].longitud
        
        if latitud != 0 && longitud != 0 {
            let sucLocation = CLLocationCoordinate2DMake(latitud, longitud)
            
            // Drop a pin
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = sucLocation
            dropPin.title = arrayEstudiosTattoo[indexEstudio].nombreEstudio
            
            mapa.addAnnotation(dropPin)
            let region = MKCoordinateRegionMakeWithDistance(sucLocation, 5000.0, 7000.0)
            
            mapa.setRegion(region, animated: true)
            
            self.loadPinSucursal()
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.alertNotUbication()
            }
        }
    }
    
    func alertNotUbication(){
        let alert = SCLAlertView()
        alert.showWarning("Aviso", subTitle: "No fue posible obtener la ubicación de estudio", closeButtonTitle: "Aceptar", duration: 0, colorStyle: UInt(COLOR_ICONOS), colorTextButton: UInt(COLOR_BLANCO))
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
        
        self.showRouteOnMap()
        
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
    
    func navigateToStudioOptions (location: ArtWork) {
        let alertController = UIAlertController(title: "Elija una opción", message: "", preferredStyle: .ActionSheet)
        
        let mapButton = UIAlertAction(title: "Mapa", style: .Default, handler: { (action) -> Void in
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
        })
        
        let  wazeButton = UIAlertAction(title: "Waze", style: .Destructive, handler: { (action) -> Void in
            let latitud = arrayEstudiosTattoo[self.indexEstudio].latitud
            let longitud = arrayEstudiosTattoo[self.indexEstudio].longitud
            
            let waze = "waze://?ll=\(latitud),\(longitud)&navigate=yes"
            
            UIApplication.sharedApplication().openURL(NSURL(string: waze)!)
        })
        
        let cancelButton = UIAlertAction(title: "Cancelar", style: .Cancel, handler: { (action) -> Void in
            print("Cancel")
        })
        
        alertController.addAction(mapButton)
        alertController.addAction(wazeButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: MAP
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! ArtWork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string: "waze://")!)) {
            navigateToStudioOptions(location)
        }else {
            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func showRouteOnMap(){
        //Coordinate Studio
        let latitud = arrayEstudiosTattoo[indexEstudio].latitud
        let longitud = arrayEstudiosTattoo[indexEstudio].longitud
        let sucLocation = CLLocationCoordinate2DMake(latitud, longitud)
        
        //Coordinate User
        let locationUser = locationManager.location?.coordinate
        
        let request = MKDirectionsRequest()
        
        let source = MKPlacemark(coordinate: sucLocation, addressDictionary: nil)
        let destination = MKPlacemark(coordinate: locationUser!, addressDictionary: nil)
        
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.requestsAlternateRoutes = false
        request.transportType = .Automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
        guard let unwrappedResponse = response else { return }
            if unwrappedResponse.routes.count > 0 {
                self.mapa.addOverlay(unwrappedResponse.routes[0].polyline)
                self.mapa.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    //MARK: NavigationBar
    func createNavigationBar(){
        self.title = arrayEstudiosTattoo[indexEstudio].nombreEstudio
        
        //Icono Izquierdo
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.setImage(IMAGE_ICON_BACK, forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(MapaViewController.back), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame=CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem(customView: button)
        //let login = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "login2")
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }

}
