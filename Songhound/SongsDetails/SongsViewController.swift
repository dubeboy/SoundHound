//
//  SongsViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/21.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class SongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var songs: [Song] = []
    var artist: Artist? = nil

    @IBOutlet weak var arti: UILabel!
    @IBOutlet weak var songsTableView: UITableView!


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.songsTableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell

        let artistName: String = songs[indexPath.row].artistName
        let songName: String = songs[indexPath.row].name
        //        I will implement something like this in the future but for now what we have is cool so I will cmt it out
        //        let popularity: Int = data[indexPath.row].popularity
        let genre: String = songs[indexPath.row].genre
        let albumName: String = songs[indexPath.row].albumName
        cell.lblArtistName.text = artistName
        cell.lblSongName.text = songName
        cell.lblGenre.text = genre
        cell.lblAlbumName.text = albumName

        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.songsTableView.delegate = self
        self.songsTableView.dataSource = self
        // Do any additional setup after loading the view.

        guard artist != nil else {
            print("ooops could not populate the view properly bro")
            return
        }

        arti.text = artist?.name


    }

    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
