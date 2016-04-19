//
//  PageDesign.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz on 01/04/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

/*
    ****************
    *        *******
    *        *     *
    * ==Text=* img *
    *        *     *
    *        *******
    *======Text====*
    *              *
    *              *
    *              *
    *              *
    ****************
*/
import UIKit

class PageDesign: UIView {

    //Visual Elements
    var txTop:UITextView!
    var txDown:UITextView!
    var imgTattoo:UIImageView!
    
    func createPage(width:CGFloat, height:CGFloat, index: Int) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, width, height))
        
        //Dimensions of elements
        let widthImg:CGFloat = (view.bounds.size.width / 6) * 3
        let heightImg:CGFloat = (view.bounds.size.height / 2)
        
        let posX:CGFloat = 10
        let posY:CGFloat = 20
        
        txTop = UITextView(frame: CGRectMake(posX, posY, view.bounds.size.width - widthImg, heightImg))
        txTop.editable = false
        
        imgTattoo = UIImageView(frame: CGRectMake(txTop.bounds.size.width + 5, posY, widthImg, heightImg))
        imgTattoo.borderRadius(12)
        
        txDown = UITextView(frame: CGRectMake(posX, heightImg + 10, view.bounds.size.width, view.bounds.size.height - heightImg))
        txDown.editable = false
        
        txTop.text = arrayDetailPages[index].nombreTatuador
        imgTattoo.image = arrayDetailPages[index].image //UIImage(named: "backTattoo")
        txDown.text = arrayDetailPages[index].descripcion
        
        view.addSubview(txTop)
        view.addSubview(imgTattoo)
        view.addSubview(txDown)
        
        return view
    }
}
