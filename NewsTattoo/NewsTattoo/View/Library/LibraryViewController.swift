//
//  LibraryViewController.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz Orozco on 31/03/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tbMagazines:UITableView!
    @IBOutlet weak var imgHeader:UIImageView!
    @IBOutlet weak var viewLineTop:UIView!
    @IBOutlet weak var viewLineDown:UIView!
    @IBOutlet weak var lbTop:UILabel!
    @IBOutlet weak var lbDown:UILabel!
    
    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configuration()
        
        self.tbMagazines.delegate = self
        self.tbMagazines.dataSource = self
        
        self.connectionInternet()
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        }
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
        //cell.lbTelefono.text = arrayEstudiosTattoo[indexPath.row].telefono
        if arrayEstudiosTattoo[indexPath.row].imgLogo != "" {
            cell.imgMagazine.image = arrayEstudiosTattoo[indexPath.row].logo//Utilidades.base64ToImage(arrayEstudiosTattoo[indexPath.row].imgLogo)
        }
        
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
