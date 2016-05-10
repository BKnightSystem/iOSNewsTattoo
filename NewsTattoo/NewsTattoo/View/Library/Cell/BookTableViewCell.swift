//
//  BookTableViewCell.swift
//  NewsTattoo
//
//  Created by Jonathan Cruz Orozco on 31/03/16.
//  Copyright © 2016 DAMSIBit. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var imgMagazine:UIImageView!
    @IBOutlet weak var lbNameMagazine:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configuration()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Configuration
    func configuration(){
        self.imgMagazine.borderRadius(12)
        self.lbNameMagazine.textColor = UIColor(netHex: COLOR_NEGRO)
        self.lbNameMagazine.font = FONT_TEXT_2
    }
    
}
