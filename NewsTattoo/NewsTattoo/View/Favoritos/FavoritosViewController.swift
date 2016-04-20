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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createNavigationBar()
        
        CDMagazine.fetchRequest()
        self.initData()
        
        tbFavoritos.delegate = self
        tbFavoritos.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData() {
        arrayFavoritos.removeAll()
        
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
                print("SI EXISTE LA IMAGEN")
                portada.imgPortada = imgLogo!
            }
            
            arrayFavoritos.append(portada)
        }
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
        let fecha = "\(arrayFavoritos[indexPath.row].mes) - \(arrayFavoritos[indexPath.row].anio)"
        cell.lbFechaRevista.text = fecha
        cell.imgPortada.image = arrayFavoritos[indexPath.row].imgPortada
        
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
