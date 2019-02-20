//
//  MyCollectioTableCellCollectionViewCell.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/20.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class MyCollectioTableCellCollectionViewCell: UICollectionViewCell {
    weak var lblSong : UILabel!
    weak var lblArtistName : UILabel!
    weak var lblGenre : UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        let lblSong = UILabel(frame: .zero)
        lblSong.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(lblSong)
        
        NSLayoutConstraint.activate([
            lblSong.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            lblSong.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            lblSong.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            lblSong.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        
    }
    
    
}
