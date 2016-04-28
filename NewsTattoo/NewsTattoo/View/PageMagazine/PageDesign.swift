//
//  PageDesign.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz on 01/04/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

/*
    ****************
    *=====Text=====*
    *    *******   *
    *    * img *   *
    *    *     *   *
    *    *******   *
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
    var txTop:UILabel!
    var txDown:UITextView!
    var imgTattoo:UIImageView!
    var lineSeparator:UIView!
    
    func createPage(width:CGFloat, height:CGFloat, index: Int) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, width, height))
        view.backgroundColor = UIColor(netHex: COLOR_BACKGROUND_PAGE)
        
        //print("Width \(width) HEIGHT \(height)")
        
        //Dimensions of elements
        let widthImg:CGFloat = (view.bounds.size.width / 6) * 5.5
        let heightImg:CGFloat = (view.bounds.size.height / 6) * 5
        
        let heightLineSeparator:CGFloat = 2.0
        let heightTitle:CGFloat = 20.0
        
        let posX:CGFloat = 10
        let posY:CGFloat = 20
        
        let posXImg:CGFloat = (view.bounds.size.width / 2) - (widthImg / 2)
        let posYImg:CGFloat = posY + heightLineSeparator + heightTitle
        
        txTop = UILabel(frame: CGRectMake(posX, posY, view.bounds.size.width, heightTitle))
        txTop.textAlignment = .Center
        txTop.backgroundColor = UIColor(netHex: COLOR_BACKGROUND_PAGE)
        txTop.textColor = UIColor(netHex: COLOR_TITLE_PAGE)
        txTop.font = FONT_TEXT_2
        
        lineSeparator = UIView(frame: CGRectMake(0, posY + heightTitle + 2, view.bounds.size.width,heightLineSeparator))
        lineSeparator.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
        
        imgTattoo = UIImageView(frame: CGRectMake(posXImg, posYImg + 5, widthImg, heightImg))
        imgTattoo.borderRadius(12)
        imgTattoo.clipsToBounds = true
        imgTattoo.contentMode = .ScaleAspectFit
        
        txDown = UITextView(frame: CGRectMake(posX, posYImg + heightImg, view.bounds.size.width, view.bounds.size.height - (posYImg + heightImg + 5)))
        txDown.editable = false
        txDown.backgroundColor = UIColor(netHex: COLOR_BACKGROUND_PAGE)
        txDown.font = FONT_TEXT_4
        
        txTop.text = "Autor: \(arrayDetailPages[index].nombreTatuador)"
        imgTattoo.image = arrayDetailPages[index].image //UIImage(named: "backTattoo")
        txDown.text = arrayDetailPages[index].descripcion
        
        view.addSubview(txTop)
        view.addSubview(lineSeparator)
        view.addSubview(imgTattoo)
        //view.addSubview(txDown)
        
        return view
    }
}
