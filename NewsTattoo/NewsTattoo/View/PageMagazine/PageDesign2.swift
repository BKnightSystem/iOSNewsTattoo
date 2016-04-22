//
//  PageDesign2.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz on 01/04/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

/*
****************
********       *
*      *       *
*  img *==Text=*
*      *       *
********       *
*======Text====*
*              *
*              *
*              *
*              *
****************
*/
import UIKit

class PageDesign2: UIView {

    //Visual Elements
    var txTop:UITextView!
    var txDown:UITextView!
    var imgTattoo:UIImageView!
    
    func createPage(width:CGFloat, height:CGFloat, index: Int) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, width, height))
        view.backgroundColor = UIColor(netHex: COLOR_BACKGROUND_PAGE)
        
        //Dimensions of elements
        let widthImg:CGFloat = (view.bounds.size.width / 6) * 2
        let heightImg:CGFloat = (view.bounds.size.height / 2)
        
        let posX:CGFloat = 10
        let posY:CGFloat = 20
        
        imgTattoo = UIImageView(frame: CGRectMake(posX, posY, view.bounds.size.width - widthImg, heightImg))
        imgTattoo.borderRadius(12)
        
        txTop = UITextView(frame: CGRectMake(imgTattoo.bounds.size.width + 15, posY, widthImg, heightImg))
        txTop.editable = false
        txTop.backgroundColor = UIColor(netHex: COLOR_BACKGROUND_PAGE)
        txTop.backgroundColor = UIColor(netHex: COLOR_BACKGROUND_PAGE)
        txTop.textColor = UIColor(netHex: COLOR_TITLE_PAGE)
        txTop.font = FONT_TEXT_2
        
        txDown = UITextView(frame: CGRectMake(posX, heightImg + 10, view.bounds.size.width, view.bounds.size.height - heightImg))
        txDown.editable = false
        txDown.backgroundColor = UIColor(netHex:COLOR_BACKGROUND_PAGE)
        
        txTop.text = "Autor: \(arrayDetailPages[index].nombreTatuador)"
        imgTattoo.image = arrayDetailPages[index].image //UIImage(named: "backTattoo")
        txDown.text = arrayDetailPages[index].descripcion
        
        view.addSubview(txTop)
        view.addSubview(imgTattoo)
        view.addSubview(txDown)
        
        return view
    }

}
