//
//  PageMagazineViewController.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz on 01/04/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import UIKit

class PageMagazineViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet weak var carouselPages:iCarousel!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var viewTop:UIView!
    @IBOutlet weak var viewDown:UIView!
    
    var reachability: Reachability?
    
    var isFavorito = false
    
    var indexEstudio = 0
    var idMagazine = 0
    var indexPortada = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createNavigationBar()
        self.configuration()
        self.initCarousel()
        
        if isFavorito {
            let idEstudio = arrayFavoritos[indexEstudio].idEstudio
            CDGaleria.initPageMagazine(idEstudio, idMagazine: idMagazine)
            self.initPageFavourite()
            
        }else {
            self.connectionInternet()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        if !isFavorito {
            reachability!.stopNotifier()
            NSNotificationCenter.defaultCenter().removeObserver(self,
                                                                name: ReachabilityChangedNotification,
                                                                object: reachability)
        }
    }

    func connectionInternet() {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PageMagazineViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCarousel(){
        carouselPages.tag = 1
        carouselPages.bounces = false
        carouselPages.clipsToBounds = true
        carouselPages.pagingEnabled = true
        carouselPages.delegate = self
        carouselPages.dataSource = self
        carouselPages.type = .Linear
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                //via WiFi
                self.wsGetPages()
            } else {
                //via Cellular
                self.wsGetPages()
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                Utilidades.alertSinConexion()
            }
        }
    }
    
    func initPageFavourite() {
        //Load information
        arrayDetailPages.removeAll()
        for i in 0 ..< galeriaCD.count {
            let dataPage = galeriaCD[i]
            let detailPage = Magazine()
            
            detailPage.idEstudio = dataPage.valueForKey("idEstudio") as! String
            detailPage.idMagazine = dataPage.valueForKey("idMagazine") as! String
            detailPage.nombreTatuador = dataPage.valueForKey("tatuador") as! String
            detailPage.descripcion = dataPage.valueForKey("texto") as! String
            
            let nameDirectory = "\(detailPage.idEstudio)\(detailPage.idMagazine)"
            
            let imgLogo = ImageManager.getPageByID("\(i)", nameDirectory: nameDirectory)
            if  imgLogo != nil {
                detailPage.image = imgLogo!
            }
            
            arrayDetailPages.append(detailPage)
        }
        
        SwiftSpinner.show("Cargando páginas")
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(PageMagazineViewController.hola), userInfo: nil, repeats: false)
        
    }
    
    func hola(){
        self.createPagesMagazine()
        self.carouselPages.reloadData()
        SwiftSpinner.hide()
    }
    
    func createPagesMagazine(){
        arrayPagesMagazine.removeAll()
        
        if arrayDetailPages.count > 0 {
            for i in 0  ..< arrayDetailPages.count  {
                let pageView  = PageDesign()
//                let pageView2 = PageDesign2()
//                let pageView3 = PageDesign3()
                
                //Dinamic page
                let stylepage = i % 3
                var viewMa = UIView()
                
                switch stylepage {
                case 0://Page 1
                    viewMa = pageView.createPage(self.carouselPages.bounds.size.width, height: self.carouselPages.bounds.size.height, index: i)
                    break
                case 1://Page 2
                    viewMa = pageView.createPage(self.carouselPages.bounds.size.width, height: self.carouselPages.bounds.size.height, index: i)
                    break
                default://Page3
                    viewMa = pageView.createPage(self.carouselPages.bounds.size.width, height: self.carouselPages.bounds.size.height, index: i)
                    break
                }
                
                arrayPagesMagazine.append(viewMa)
            }
        }
    }
    
    //MARK: WS
    func wsGetPages(){
        dispatch_async(dispatch_get_main_queue()) {
            SwiftSpinner.show("Obteniendo información")
        }
        
        let parameters:[String:Int] = ["idEstudio":indexEstudio + 1, "idMagazine":idMagazine]
        
        WebService.galeriaEstudiosById(parameters, callback:{(isOK) -> Void in
            if isOK {
                dispatch_async(dispatch_get_main_queue(), {
                    self.createPagesMagazine()
                    self.carouselPages.reloadData()
                })
                SwiftSpinner.hide()
            }
            else {
                arrayPagesMagazine.removeAll()
                self.carouselPages.reloadData()
                SwiftSpinner.hide()
            }
        })
    }
    
    //MARK: Carousel Delegate and Datasource
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        self.pageControl.numberOfPages = arrayPagesMagazine.count
        return arrayPagesMagazine.count
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        //let newView = view
        return arrayPagesMagazine[index]
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .Spacing:
            return value * 1.1
        case .Wrap:
            return value + CGFloat(1.0)
        default:
            return value
        }
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel!) {
        self.pageControl.currentPage = carousel.currentItemIndex
    }
    
    //MARK: Configuration
    func configuration(){
        carouselPages.backgroundColor = UIColor(netHex: COLOR_BACKGROUND_PAGE)
        viewTop.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
        viewDown.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
    }

    //MARK: NavigationBar
    func createNavigationBar(){
        //print("INDEX \(indexEstudio) MAGAZINE \(idMagazine)")
        if isFavorito {
            self.title = arrayFavoritos[indexEstudio].nombre
        }else {
            self.title = arrayEstudiosTattoo[indexEstudio].nombreEstudio
        }
        
        
        //Icono Izquierdo
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.setImage(IMAGE_ICON_BACK, forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(PageMagazineViewController.back), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame=CGRectMake(0, 0, 40, 40)
        let barButton = UIBarButtonItem(customView: button)
        //let login = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "login2")
        self.navigationItem.leftBarButtonItem = barButton
        
        //Icono Derecho only if doesnt favorito
        if !isFavorito {
            let buttonDer = UIButton(type: UIButtonType.Custom) as UIButton
            buttonDer.setImage(IMAGE_ICON_FAVORITO, forState: UIControlState.Normal)
            buttonDer.addTarget(self, action:#selector(PageMagazineViewController.addFavorite), forControlEvents: UIControlEvents.TouchUpInside)
            buttonDer.frame=CGRectMake(0, 0, 40, 40)
            let barButtonDer = UIBarButtonItem(customView: buttonDer)
            //let login = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "login2")
            self.navigationItem.rightBarButtonItem = barButtonDer
        }
        
    }
    
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: Save information for Estudio
    func addFavorite() {
        CDMagazine.fetchRequest()
        if magazineCD.count > 5 {
            self.alertNoGuardarMagazine()
        }else {
            if arrayDetailPages.count > 0 {
                self.alertSaveMagazine()
            }else {
                self.alertError()
            }
        }
    }
    
    
    
    func saveInformationEstudio() {
        //Validate if magazine is or not favourite
        if !(CDMagazine.existePortada(magazine: arrayPortadasTattoo[indexPortada])) {
            //Crear los directorios para guardar las imagenes
            ImageManager.createDirectoryImagePortada()
            
            let portada = arrayPortadasTattoo[indexPortada]
            
            if CDMagazine.saveMagazinePortada(magazine: portada) {
                let namePortada = "\(portada.idEstudio)\(portada.idMagazine)"
                
                ImageManager.createDirectoryImagePage(namePortada)
                
                ImageManager.saveImagePortada(portada.imgPortada, name: namePortada)
                //Save Pages magazine
                
                for i in 0 ..< arrayDetailPages.count {
                    let pages = arrayDetailPages[i]
                    if CDGaleria.saveMagazinePage(pageMagazine: pages) {
                        let namePage = "\(i)"
                        ImageManager.saveImagePage(pages.image, nameImage:namePage, nameDirectory: "\(namePortada)")
                    }
                }
                
                self.alertExitoSavePortada()
            }else {
                //print("NO SE GUARDO LA PORTADA")
            }
        }else {
            let alert = SCLAlertView()
            alert.showSuccess("", subTitle: "La revista ya esta en la sección de favoritos", closeButtonTitle: "Aceptar", duration: 0, colorStyle: UInt(COLOR_ICONOS), colorTextButton: UInt(COLOR_BLANCO))
        }
    }
    
    //MARK: Alerts
    func alertExitoSavePortada(){
        let alert = SCLAlertView()
        alert.showSuccess("Se agrego a favoritos", subTitle: "Para ver la revista dirijase a favoritos", closeButtonTitle: "Aceptar", duration: 0, colorStyle: UInt(COLOR_ICONOS), colorTextButton: UInt(COLOR_BLANCO))
    }
    
    func alertNoGuardarMagazine(){
        let alert = SCLAlertView()
        alert.showCloseButton = false
        alert.addButton("Aceptar", action: {
            //self.saveInformationEstudio()
        })
        
        alert.showInfo("No se puede agregar a favoritos", subTitle: "Solo se permite un máximo de 5 revistas", closeButtonTitle: "Cancelar", duration: 0, colorStyle: UInt(COLOR_ICONOS), colorTextButton: UInt(COLOR_BLANCO))
    }
    
    func alertSaveMagazine(){
        let nameRevista = arrayPortadasTattoo[indexPortada].nombre
        
        let alert = SCLAlertView()
        alert.showCloseButton = false
        alert.addButton("Aceptar", action: {
            self.saveInformationEstudio()
        })
        alert.addButton("Cancelar", action: {
            
        })
        
        alert.showInfo("Agregar a favoritos?", subTitle: "Desea agregar a favoritos la revista: \(nameRevista)", closeButtonTitle: "", duration: 0, colorStyle: UInt(COLOR_ICONOS), colorTextButton: UInt(COLOR_BLANCO))
    }
    
    func alertError() {
        let alert = SCLAlertView()
        alert.showError("Error", subTitle: "No se puede guardar en favoritos", closeButtonTitle: "Aceptar", duration: 0, colorStyle: UInt(COLOR_ROJO), colorTextButton: UInt(COLOR_BLANCO))
    }
}
