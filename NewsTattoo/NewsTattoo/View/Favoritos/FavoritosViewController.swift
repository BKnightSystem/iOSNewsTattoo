//
//  FavoritosViewController.swift
//  NewsTattoo
//
//  Created by gigigo on 20/04/16.
//  Copyright © 2016 BKSystem. All rights reserved.
//

import UIKit

class FavoritosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tbFavoritos:UITableView!
    var arrayNamesEstudio = [String]()
    var arrayTelephoneStudio = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createNavigationBar()
        
        self.loadInformation()
        
        tbFavoritos.delegate = self
        tbFavoritos.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadInformation(){
//        CDEstudios.fetchRequest()
        CDMagazine.fetchRequest()
        self.initData()
    }
    
    func initData() {
        arrayFavoritos.removeAll()
        arrayNamesEstudio.removeAll()
        
        if magazineCD.count > 0 {
            for i in 0 ..< magazineCD.count {
                let dataPortada = magazineCD[i]
                let portada = MagazinePortada()
                
                portada.idEstudio = dataPortada.valueForKey("idEstudio") as! String
                portada.idMagazine = dataPortada.valueForKey("idMagazine") as! String
                portada.nombre = dataPortada.valueForKey("nombre") as! String
                portada.mes = dataPortada.valueForKey("mes") as! String
                portada.anio = dataPortada.valueForKey("anio") as! String
                
                let imageName = "\(portada.idEstudio)\(portada.idMagazine)"
                let imgLogo = ImageManager.getPortadaByID(imageName)
                if  imgLogo != nil {
                    //print("SI EXISTE LA IMAGEN")
                    portada.imgPortada = imgLogo!
                }
                
                let nameEstudio = CDEstudios.getNamesEstudio(portada.idEstudio)
                let telephone = CDEstudios.getTelephoneEstudio(portada.idEstudio)
                arrayNamesEstudio.append(nameEstudio)
                
                arrayFavoritos.append(portada)
                arrayTelephoneStudio.append(telephone)
            }
        }else {
            self.alertSinFavoritos()
        }
    }

    //MARK: Alert
    func alertSinFavoritos() {
        let alert = SCLAlertView()
        alert.showCloseButton = false
        alert.addButton("Aceptar", action: {
            self.navigationController?.popViewControllerAnimated(true)
        })
        
        alert.showInfo("No hay revistas", subTitle: "No hay revistas marcadas como favoritos", closeButtonTitle: "Aceptar", duration: 0, colorStyle: UInt(COLOR_ICONOS), colorTextButton: UInt(COLOR_BLANCO))
    }
    
    //MARK: Table Delegate and Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFavoritos.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = FavoritoTableViewCell()
        
        tableView.registerNib(UINib(nibName: "FavoritoTableViewCell", bundle: nil), forCellReuseIdentifier: "favoritoCell")
        cell = tableView.dequeueReusableCellWithIdentifier("favoritoCell") as! FavoritoTableViewCell
        cell.selectionStyle = .None
        cell.lbNombreRevista.text = arrayFavoritos[indexPath.row].nombre
        let mes = ARRAY_MONTHS[Int(arrayFavoritos[indexPath.row].mes)! - 1]
        let fecha = "\(mes) - \(arrayFavoritos[indexPath.row].anio)"
        cell.lbFechaRevista.text = fecha
        cell.imgPortada.image = arrayFavoritos[indexPath.row].imgPortada
        cell.lbNombreEstudio.text = arrayNamesEstudio[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let nameDirectory = "\(arrayFavoritos[indexPath.row].idEstudio)\(arrayFavoritos[indexPath.row].idMagazine)"
        let numPages = ImageManager.listPagesMagazine(nameDirectory)
        print("NUM PAGES \(numPages)")
        let pages = PageMagazineViewController(nibName:"PageMagazineViewController", bundle: nil)
        pages.indexEstudio = indexPath.row//Int(arrayFavoritos[indexPath.row].idEstudio)!
        pages.idMagazine = Int(arrayFavoritos[indexPath.row].idMagazine)!
        pages.isFavorito = true
        self.navigationController?.pushViewController(pages, animated: true)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Eliminar", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.deleteDataInformation(indexPath.row)
        })
        deleteAction.backgroundColor = UIColor(netHex: COLOR_BACKGROUND_VIEW)
        
        let callAction = UITableViewRowAction(style: .Normal, title: "Llamar", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.callStudio(self.arrayTelephoneStudio[indexPath.row])
        })
        callAction.backgroundColor = UIColor(netHex: COLOR_ICONOS)
        
        return [deleteAction, callAction]
        
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    //MARK: UITableViewRowAction
    func deleteDataInformation(index:Int){
        // Delete information about this studio by index Core Data
        CDMagazine.deleteMagazinePortada(index)
        let idEst = arrayFavoritos[index].idEstudio as String
        let idMag = arrayFavoritos[index].idMagazine as String
        CDGaleria.initPageMagazine(idEst, idMagazine: Int(idMag)!)
        
        for i in 0 ..< galeriaCD.count {
            print("Borrando elemento num \(i)")
            CDGaleria.deleteMagazinePages()
        }
        
        let identify = "\(idEst)\(idMag)"
        let nameDirectory = "/PagesMagazine\(identify)"
        let namePortada = "PortadaMagazine/\(identify).png"
        //Delete image pages
        ImageManager.deleteDirectory(nameDirectory)
        ImageManager.deletePortada(namePortada)
        
        //let tmpCount = galeriaCD.count
        //print("CUANTOS ELEMENTOS QUEDARON \(tmpCount)")
        
        self.loadInformation()
        self.tbFavoritos.reloadData()
    }
    
    func callStudio(telephone:String){
        if telephone != "" {
            Utilidades.callPhone(telephone)
        }
    }
    
    //MARK: NavigationBar
    
    /**
     Configurate navigationBar
     */
    func createNavigationBar(){
        self.title = "Favoritos"
        
        //Icono Izquierdo
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.setImage(IMAGE_ICON_BACK, forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(ListMagazinesViewController.back), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame=CGRectMake(0, 0, 40, 40)
        let barButton = UIBarButtonItem(customView: button)
        //let login = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "login2")
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }

}
