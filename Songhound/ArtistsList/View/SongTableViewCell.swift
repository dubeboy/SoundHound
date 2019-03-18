//
//  SongTableViewCell.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/18.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblAlbumName: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var imgAlbumCover: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func set(forSong song: SongModel) {
        self.selectionStyle = .none
        self.lblArtistName.text = song.artistName
        self.lblSongName.text = song.name
        self.lblGenre.text = song.genre
        self.lblAlbumName.text = song.albumName
        self.imgAlbumCover.dowloadFromServer(link: song.artworkURL)
    }
}
