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
    
    var indexEstudio = 0
    var idMagazine = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createNavigationBar()
        self.configuration()
        self.initCarousel()
        
        SwiftSpinner.show("Descargando información")
        self.wsGetPages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCarousel(){
        carouselPages.tag = 1
        carouselPages.bounces = false
        carouselPages.pagingEnabled = true
        carouselPages.delegate = self
        carouselPages.dataSource = self
        carouselPages.type = .Linear
    }
    
    func createPagesMagazine(){
        arrayPagesMagazine.removeAll()
        if arrayDetailPages.count > 0 {
            for var i = 0 ; i < arrayDetailPages.count ; i++ {
                let pageView  = PageDesign()
                let pageView2 = PageDesign2()
                let pageView3 = PageDesign3()
                
                //Dinamic page
                let stylepage = i % 3
                var viewMa = UIView()
                
                switch stylepage {
                case 0://Page 1
                    viewMa = pageView.createPage(self.carouselPages.bounds.size.width, height: self.carouselPages.bounds.size.height, index: i)
                    break
                case 1://Page 2
                    viewMa = pageView2.createPage(self.carouselPages.bounds.size.width, height: self.carouselPages.bounds.size.height, index: i)
                    break
                default://Page3
                    viewMa = pageView3.createPage(self.carouselPages.bounds.size.width, height: self.carouselPages.bounds.size.height, index: i)
                    break
                }
                
                arrayPagesMagazine.append(viewMa)
            }
        }
    }
    
    //MARK: WS
    func wsGetPages(){
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
        viewTop.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
        viewDown.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
    }

    //MARK: NavigationBar
    func createNavigationBar(){
        self.title = arrayEstudiosTattoo[indexEstudio].nombreEstudio
        
        //self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        
        //Icono Izquierdo
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.setImage(IMAGE_ICON_BACK, forState: UIControlState.Normal)
        button.addTarget(self, action:"back", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame=CGRectMake(0, 0, 40, 40)
        let barButton = UIBarButtonItem(customView: button)
        //let login = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "login2")
        self.navigationItem.leftBarButtonItem = barButton
        
        //Icono Derecho
        let buttonDer = UIButton(type: UIButtonType.Custom) as UIButton
        buttonDer.setImage(IMAGE_ICON_FAVORITO, forState: UIControlState.Normal)
        buttonDer.addTarget(self, action:"addFavorite", forControlEvents: UIControlEvents.TouchUpInside)
        buttonDer.frame=CGRectMake(0, 0, 40, 40)
        let barButtonDer = UIBarButtonItem(customView: buttonDer)
        //let login = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "login2")
        self.navigationItem.rightBarButtonItem = barButtonDer
    }
    
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addFavorite() {
        print("Agregar como favoritos")
        let alert = SCLAlertView()
        alert.showCloseButton = false
        alert.addButton("Aceptar", action: {
            self.saveInformationEstudio()
        })
        
        alert.showInfo("Agregar a favoritos?", subTitle: "Desea agregar a favoritos la siguiente revista", closeButtonTitle: "Cancelar", duration: 0, colorStyle: UInt(COLOR_NEGRO), colorTextButton: UInt(COLOR_BLANCO))
    }
    
    //MARK: Save information for Estudio
    func saveInformationEstudio(){
        print("Hola mundo")
    }

}
