//
//  PropagandaViewController.swift
//  NewsTattoo
//
//  Created by gigigo on 25/04/16.
//  Copyright © 2016 BKSystem. All rights reserved.
//

import UIKit

class PropagandaViewController: UIViewController {

    @IBOutlet weak var imgPromocion:UIImageView!
    
    var indexEstudio = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createNavigationBar()
        self.initPropaganda()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    func initPropaganda(){
        imgPromocion.image = arrayPromociones[indexEstudio].imgViewPromocion
    }

    //MARK: NavigationBar
    
    /**
     Configurate navigationBar
     */
    func createNavigationBar(){
        self.title = "Oferta del mes"
        
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
