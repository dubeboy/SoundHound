//
//  ArtistTableViewCell.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/19.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    @IBOutlet weak var lblArtistName: UILabel!
    
    @IBOutlet weak var lblEmoji: UILabel!
    @IBOutlet weak var lblNumHits: UILabel!
    @IBOutlet weak var imgArtist: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        lblEmoji.text = "🔥"
        makeUIImageViewCircle(imageView: imgArtist, imgSize: 40)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
