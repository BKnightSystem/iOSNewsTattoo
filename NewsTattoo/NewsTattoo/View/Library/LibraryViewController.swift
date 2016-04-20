//
//  LibraryViewController.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz Orozco on 31/03/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import UIKit
import CoreData

class LibraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tbMagazines:UITableView!
    @IBOutlet weak var imgHeader:UIImageView!
    @IBOutlet weak var viewLineTop:UIView!
    @IBOutlet weak var viewLineDown:UIView!
    @IBOutlet weak var lbTop:UILabel!
    @IBOutlet weak var lbDown:UILabel!
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
    
    //MARK: Connection Internet
    func connectionInternet(){
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LibraryViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
//                print("Reachable via WiFi")
                self.wsGetStudios()
                
            } else {
//                print("Reachable via Cellular")
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
        content.contentURL = NSURL(string: "https://www.facebook.com/profile.php?id=100011727544659")
        content.contentTitle = "News Tattoo"
        content.contentDescription = "Revista para los amantes del tatuaje"
        content.imageURL = NSURL(string: "<INSERT STRING HERE>")
        
        btnShareFB.shareContent = content
    }
    
    //MARK: WS
    func wsGetStudios(){
        dispatch_async(dispatch_get_main_queue()) {
            SwiftSpinner.show("Obteniendo Estudios de tatuajes")
        }
        
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
                print("SI EXISTE LA IMAGEN")
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
                print("Se GUARDO EL ESTUDIO \(arrayEstudiosTattoo[i].nombreEstudio)")
            }else {
                print("ERROR AL GUARDAR DATO")
            }
            
        }
    }
    
    func getEstudiosCD() {
        CDEstudios.fetchRequest()
        print("CUANTOS ENCONTRO \(estudios.count)")
        self.showEstudiosWithoutInternet()
    }
    
    func deleteEstudios(){
        for i in 0  ..< estudios.count  {
            CDEstudios.deleteEstudio(i)
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
        self.imgHeader.borderRadius(12)
        self.viewLineTop.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
        self.viewLineDown.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
        
        self.lbTop.font = FONT_TEXT_3
        self.lbDown.font = FONT_TEXT_3
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
