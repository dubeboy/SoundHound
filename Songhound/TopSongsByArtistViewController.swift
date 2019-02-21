//
//  TopSongsByArtistViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/18.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class TopSongsByArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var artistsTableView: UITableView!
   
    var artists: [Artist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateArtists()
        self.artistsTableView.delegate = self
        self.artistsTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func populateArtists() {
        for index in (1...10) {
          let isItHot = index % 2 == 0 || index % 3 == 0
            artists.append(Artist(name: "John \(index)", numHits: index, isHot: isItHot ))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.artistsTableView.dequeueReusableCell(withIdentifier: "artistTableViewCell", for: indexPath) as! ArtistTableViewCell
        
        cell.lblArtistName.text = artists[indexPath.row].name
        cell.lblNumHits.text = "\(artists[indexPath.row].numHits) hot songs"
        let str = artists[indexPath.row].isHot ? "🔥" :  "";
        cell.lblEmoji.text = str
        
//        cell.imgArtist. = // set the artist image 
        
        return cell
    }

    @IBAction func onBackButtonClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked bro")
        performSegue(withIdentifier: "viewSongsOfArtist", sender: self )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("called bro")
        if segue.identifier == "viewSongsOfArtist" {
            if let indexPath = self.artistsTableView.indexPathForSelectedRow {
                let controller = segue.destination as! SongsViewController
                controller.artist = artists[indexPath.row]
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
