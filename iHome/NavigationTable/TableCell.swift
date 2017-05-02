//
//  TableCellTableViewCell.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-01.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell{

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
