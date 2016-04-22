//
//  FavoritoTableViewCell.swift
//  NewsTattoo
//
//  Created by gigigo on 20/04/16.
//  Copyright © 2016 BKSystem. All rights reserved.
//

import UIKit

class FavoritoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPortada:UIImageView!
    @IBOutlet weak var lbNombreRevista:UILabel!
    @IBOutlet weak var lbNombreEstudio:UILabel!
    @IBOutlet weak var lbFechaRevista:UILabel!
    @IBOutlet weak var lineDown:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lineDown.backgroundColor = UIColor(netHex: COLOR_LINE_VIEW)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
