//
//  SongDetailViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/11.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class SongDetailViewController: UIViewController {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songGenre: UILabel!
    @IBOutlet weak var songAlbumName: UILabel!
    @IBOutlet weak var songNumPlayes: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var presenter: SongDetailPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    //    makeUIImageViewCircle(imageView: artistImageView, imgSize: 300)
        makeBGImageBlur(view: backgroundImage)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    private func makeBGImageBlur(view: UIImageView) {
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}

extension SongDetailViewController: SongDetailsViewProtocol {

    func showSongsDetail(forSong song: SongModel) {
        artistImageView.dowloadFromServer(link: song.artworkURL)
        backgroundImage.dowloadFromServer(link: song.artworkURL)
        songNameLabel.text = song.name
        songGenre.text = song.genre
        songNumPlayes.text = "100 Playes in Joburg"
        songAlbumName.text = song.albumName
    }

}
