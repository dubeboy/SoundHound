//
//  SongTableViewCell.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/18.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    

    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblPopularity: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
