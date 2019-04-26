//
//  SongCollectionViewControllerCellCollectionViewCell.swift
//  Songhound
//
//  Created by Divine Dube on 2019/04/25.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class SongCollectionViewControllerCell: UICollectionViewCell {
    @IBOutlet weak var songAlbumCover: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var tintView: UIView!
    
    var song: SongModel? {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI() {
        if let song = song {
            songAlbumCover.dowloadFromServer(link: song.artworkURL)
            songLabel.text = song.name
        } else {
            songAlbumCover?.image = nil
            songLabel.text = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 5, height: 5)
        
        self.clipsToBounds = false
    }
}
