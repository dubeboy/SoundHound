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
        for i in 1...10 {
          let isItHot = i % 2 == 0 || i % 3 == 0
            artists.append(Artist(name: "John \(i)", numHits: i, isHot: isItHot ))
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
