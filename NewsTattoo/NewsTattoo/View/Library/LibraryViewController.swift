//
//  LibraryViewController.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz Orozco on 31/03/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import UIKit
import CoreData

class LibraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, iCarouselDelegate, iCarouselDataSource {

    @IBOutlet weak var tbMagazines:UITableView!
    @IBOutlet weak var carouselHeader:iCarousel!
    @IBOutlet weak var viewLineTop:UIView!
    @IBOutlet weak var viewLineDown:UIView!
    @IBOutlet weak var btnShareFB:FBSDKShareButton!
    @IBOutlet weak var btnFavorito:UIButton!
    
    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configuration()
        
        self.tbMagazines.delegate = self
        self.tbMagazines.dataSource = self
        
        self.connectionInternet()
        
        ImageManager.createDirectoryImage()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.btnShareFBConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openWeb(){
        print("Show Web")
        let propaganda = PropagandaViewController(nibName: "PropagandaViewController", bundle: nil)
        self.navigationController?.pushViewController(propaganda, animated: true)
    }
    
    //MARK: Connection Internet
    func connectionInternet(){
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            //print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LibraryViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            //print("could not start reachability notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
//                print("Reachable via WiFi")
                self.wsGetPromociones()
                self.wsGetStudios()
            } else {
//                print("Reachable via Cellular")
                self.wsGetPromociones()
                self.wsGetStudios()
                
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                Utilidades.alertSinConexion()
                self.getEstudiosCD()
            }
        }
    }
    
    //MARK: Action Button
    @IBAction func btnFavorito(sender:UIButton) {
        let favoritos = FavoritosViewController(nibName: "FavoritosViewController", bundle: nil)
        self.navigationController?.pushViewController(favoritos, animated: true)
    }
    
    //MARK: Facebook Share
    
    func btnShareFBConfig() {
        btnShareFB.setTitle("", forState: .Normal)
        btnShareFB.backgroundColor = UIColor(netHex: COLOR_BACKGROUND_APP)
//        btnShareFB.setBackgroundImage(IMAGE_ICON_FB, forState: .Normal)
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "http://www.techotopia.com/index.php/Working_with_Directories_in_Swift_on_iOS_8")
        content.contentTitle = "News Tattoo"
        content.contentDescription = "Revista Digital para los amantes del tatuaje"
        content.imageURL = NSURL(string: "<INSERT STRING HERE>")
        
        btnShareFB.shareContent = content
    }
    
    //MARK: WS
    func wsGetStudios(){
        let parameters:[String:AnyObject] = ["":""]
        WebService.estudios(parameters, callback:{(isOK) -> Void in
            if isOK {
                dispatch_async(dispatch_get_main_queue(), {
                    //Delete All Estudio
                    CDEstudios.deleteAllEstudios()
                    //Guardar todos los estudios en la base de datos
                    self.saveEstudios()
                    self.tbMagazines.reloadData()
                })
                
                SwiftSpinner.hide()
            }
            else {
                SwiftSpinner.hide()
            }
        })
    }
    
    func wsGetPromociones(){
        dispatch_async(dispatch_get_main_queue()) {
            SwiftSpinner.show("Buscando promociones")
        }
        
        let parameters:[String:AnyObject] = ["":""]
        WebService.promociones(parameters, callback:{(isOK) -> Void in
            if isOK {
                dispatch_async(dispatch_get_main_queue(), {
                    self.initCarousel()
                })
                
                SwiftSpinner.hide()
            }
            else {
                SwiftSpinner.hide()
            }
        })
    }
    
    //MARK: Without Internet
    func showEstudiosWithoutInternet() {
        arrayEstudiosTattoo.removeAll()
        for i in 0 ..< estudios.count {
            let estudio = estudios[i]
            let dataEstudio = Estudios()
            
            dataEstudio.idEstudio = estudio.valueForKey("idEstudio") as! String
            dataEstudio.nombreEstudio = estudio.valueForKey("nombre") as! String
            dataEstudio.latitud = estudio.valueForKey("latitud") as! Double
            dataEstudio.longitud = estudio.valueForKey("longitud") as! Double
            dataEstudio.telefono = estudio.valueForKey("telefono") as! String
            dataEstudio.direccion = estudio.valueForKey("direccion") as! String
            
            let imageName = "\(i + 1)"
            let imgLogo = ImageManager.getLogoByID(imageName)
            if  imgLogo != nil {
               // print("SI EXISTE LA IMAGEN")
                dataEstudio.logo = imgLogo!
            }
            
            arrayEstudiosTattoo.append(dataEstudio)
        }
        
        self.tbMagazines.reloadData()
    }
    
    //MARK: Save data in coreData
    func saveEstudios(){
        for i in 0 ..< arrayEstudiosTattoo.count  {
            if CDEstudios.saveStudio(dataEstudio: arrayEstudiosTattoo[i]) {
                let image:UIImage = arrayEstudiosTattoo[i].logo
                let nameImage = arrayEstudiosTattoo[i].idEstudio
                ImageManager.saveImage(image, name: nameImage)
                //print("Se GUARDO EL ESTUDIO \(arrayEstudiosTattoo[i].nombreEstudio)")
            }else {
               // print("ERROR AL GUARDAR DATO")
            }
            
        }
    }
    
    func getEstudiosCD() {
        CDEstudios.fetchRequest()
       // print("CUANTOS ENCONTRO \(estudios.count)")
        self.showEstudiosWithoutInternet()
    }
    
    func deleteEstudios(){
        for i in 0  ..< estudios.count  {
            CDEstudios.deleteEstudio(i)
        }
    }
    
    //MARK: Carousel Delegate
    func initCarousel(){
        carouselHeader.bounces = false
        carouselHeader.pagingEnabled = true
        carouselHeader.delegate = self
        carouselHeader.dataSource = self
        carouselHeader.type = .Linear
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        var newView = view
        var imageView:UIImageView!
        
        if arrayPromociones.count > 0 {
            imageView = UIImageView(image: arrayPromociones[index].bannerViewPromocion)
        }else {
            imageView = UIImageView(image: IMG_DEFAULT_PROMO)
        }
        
        imageView.borderRadius(12)
        imageView.backgroundColor = UIColor(netHex: COLOR_NEGRO);
        imageView.frame = CGRect(x: 0, y: 0, width:carouselHeader.frame.width, height:carouselHeader.frame.height)
        imageView.contentMode = .ScaleAspectFit
        newView = imageView
        
        return newView
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        var elements = 0
        if arrayPromociones.count > 0 {
            elements = arrayPromociones.count
        }else {
            elements = 1
        }
        return elements
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel!) {
        //pageControl.currentPage = carousel.currentItemIndex
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
    
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        if arrayPromociones.count > 0 {
            let propaganda = PropagandaViewController(nibName:"PropagandaViewController", bundle: nil)
            propaganda.indexEstudio = index
            self.navigationController?.pushViewController(propaganda, animated: true)
        }
    }

    //MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayEstudiosTattoo.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = BookTableViewCell()
        
        tableView.registerNib(UINib(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: "bookCell")
        cell = tableView.dequeueReusableCellWithIdentifier("bookCell") as! BookTableViewCell
        cell.selectionStyle = .None
        cell.lbNameMagazine.text = arrayEstudiosTattoo[indexPath.row].nombreEstudio
        //if arrayEstudiosTattoo[indexPath.row].imgLogo != "" {
            cell.imgMagazine.image = arrayEstudiosTattoo[indexPath.row].logo
        //}
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let listMagazine = ListMagazinesViewController(nibName:"ListMagazinesViewController", bundle:nil)
        listMagazine.indexEstudio = indexPath.row
        self.navigationController?.pushViewController(listMagazine, animated: true)
    }
    
    //MARK: Configuration
    func configuration(){
        //self.imgHeader.borderRadius(12)
        self.viewLineTop.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
        self.viewLineDown.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
    }

}
