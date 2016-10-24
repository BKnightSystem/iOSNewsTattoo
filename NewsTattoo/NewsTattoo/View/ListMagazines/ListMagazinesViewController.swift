////
//  ListMagazinesViewController.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz Orozco on 01/04/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import UIKit

class ListMagazinesViewController: UIViewController {

    //@IBOutlet weak var carouselYear:iCarousel!
    @IBOutlet weak var carouselMonthMagazine:iCarousel!
    @IBOutlet weak var viewLineTop:UIView!
    @IBOutlet weak var viewLineDown:UIView!
    @IBOutlet weak var btnMapa:UIButton!
    @IBOutlet weak var btnCall:UIButton!
    @IBOutlet weak var lbMagazine:UILabel!
    
    var reachability: Reachability?
    
    var indexEstudio = 0
    var indexPortada = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createNavigationBar()
        self.configuration()
        
        self.connectionInternet()
    }

    override func viewWillDisappear(animated: Bool) {
        reachability!.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: ReachabilityChangedNotification,
                                                            object: reachability)
    }
    
    func connectionInternet(){
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            //Unable to create Reachability
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ListMagazinesViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
           //could not start reachability notifier
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCarousel(){
//        arrayBanner.removeAll()
//        arrayBanner.append(IMAGE_ICON_BACK!)
//        arrayBanner.append(IMAGE_ICON_BACK!)
//        arrayBanner.append(IMAGE_ICON_BACK!)
//        arrayBanner.append(IMAGE_ICON_BACK!)
//        arrayBanner.append(IMAGE_ICON_BACK!)
//        arrayBanner.append(IMAGE_ICON_BACK!)
        
//        carouselYear.tag = 0
//        carouselYear.bounces = false
//        carouselYear.pagingEnabled = true
//        carouselYear.delegate = self
//        carouselYear.dataSource = self
//        carouselYear.type = .Cylinder
        
        carouselMonthMagazine.tag = 1
        carouselMonthMagazine.bounces = false
        carouselMonthMagazine.pagingEnabled = true
        carouselMonthMagazine.delegate = self
        carouselMonthMagazine.dataSource = self
        carouselMonthMagazine.type = .CoverFlow
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                //Reachable via WiFi
                self.wsGetPortadas()
            } else {
                //Reachable via Cellular
                self.wsGetPortadas()
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                Utilidades.alertSinConexion()
            }
        }
    }
    
    //MARK: WS
    func wsGetPortadas(){
        dispatch_async(dispatch_get_main_queue()) {
            SwiftSpinner.show("Obteniendo información")
        }
        
        let parameters:[String:Int] = ["S_Id":indexEstudio + 1]
        
        WebService.portadaMagazineById(parameters, callback:{(isOK) -> Void in
            if isOK {
                dispatch_async(dispatch_get_main_queue(), {
                    self.indexPortada = 0
                    self.initCarousel()
                    self.updateLabel()
                    //self.carouselMonthMagazine.reloadData()
                })
                
                SwiftSpinner.hide()
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.alertSinInformacion()
                })
                SwiftSpinner.hide()
            }
        })
    }
    
    //MARK: Alert
    func alertSinInformacion(){
        let alert = SCLAlertView()
        alert.showError("Sin información", subTitle: "No fue posible obtener información del estudio", closeButtonTitle: "Aceptar", duration: 0, colorStyle: UInt(COLOR_ICONOS), colorTextButton: UInt(COLOR_BLANCO))
    }
    
    //MARK: Action Buttos
    
    /**
    Show View mapa
    
    - parameter sender: sender typeButton
    */
    
    @IBAction func btnMapa(sender:UIButton){
        let mapa = MapaViewController(nibName:"MapaViewController", bundle:nil)
        mapa.indexEstudio = indexEstudio
        self.navigationController?.pushViewController(mapa, animated: true)
    }
    
    @IBAction func btnLLamar(sender:UIButton){
        Utilidades.callPhone(arrayEstudiosTattoo[indexEstudio].telefono)
    }
    
    //MARK: Configuration
    func configuration(){
        //self.carouselYear.backgroundColor = UIColor.whiteColor()
        self.viewLineTop.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
        self.viewLineDown.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
    }
    
    func updateLabel(){
        self.lbMagazine.text = arrayPortadasTattoo[indexPortada].nombre
    }

    //MARK: NavigationBar
    
    /**
    Configurate navigationBar
    */
    func createNavigationBar(){
        self.title = arrayEstudiosTattoo[indexEstudio].nombreEstudio
        
        //Icono Izquierdo
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.setImage(IMAGE_ICON_BACK, forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(ListMagazinesViewController.back), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame=CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem(customView: button)
        //let login = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "login2")
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }

}

//MARK: Carousel
extension ListMagazinesViewController: iCarouselDataSource, iCarouselDelegate {
    //MARK: Carousel Delegate
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        var newView = view
        //if newView == nil {
        if carousel.tag == 0 { //Year
            //            let imageView = UIImageView(image: arrayBanner[index])
            //            imageView.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
            //            imageView.borderRadius(12)
            //            imageView.frame = CGRect(x: 0, y: 0, width: (carouselYear.frame.width * 0.3), height: (carouselYear.frame.height))
            //            imageView.contentMode = .ScaleAspectFit
            //            newView = imageView
        }else if carousel.tag == 1 {//Magazine
            let imageView = UIImageView(image: arrayPortadasTattoo[index].imgPortada)
            //imageView.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
            imageView.borderRadius(12)
            imageView.backgroundColor = UIColor(netHex: COLOR_NEGRO);
            imageView.frame = CGRect(x: 0, y: 0, width: (carouselMonthMagazine.frame.width * 0.7), height: (carouselMonthMagazine.frame.height))
            imageView.contentMode = .ScaleAspectFit
            newView = imageView
        }
        
        //}
        return newView
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return arrayPortadasTattoo.count
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel!) {
        //pageControl.currentPage = carousel.currentItemIndex
        if carousel.tag == 1 {
            indexPortada = carousel.currentItemIndex
            self.updateLabel()
        }
    }
    
    /*func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .Spacing:
            return value * 1.1
        case .Wrap:
            return 1.0//value + CGFloat(1.0)
        default:
            return value
        }
    }*/
    
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        let pages = PageMagazineViewController(nibName:"PageMagazineViewController", bundle: nil)
        pages.indexEstudio = indexEstudio//index + 1
        pages.indexPortada = index
        pages.idMagazine = Int(arrayPortadasTattoo[index].idMagazine)!
        pages.isFavorito = false
        self.navigationController?.pushViewController(pages, animated: true)
    }
}
