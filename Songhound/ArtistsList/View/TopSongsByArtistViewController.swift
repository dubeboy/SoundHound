//
//  TopSongsByArtistViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/18.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit

class TopSongsByArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var artistsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var artists: [Artist] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.artistsTableView.delegate = self
        self.artistsTableView.dataSource = self
        self.searchBar.delegate = self

        // Do any additional setup after loading the view.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.artistsTableView.dequeueReusableCell(withIdentifier: "artistTableViewCell", for: indexPath) as! ArtistTableViewCell

        cell.lblArtistName.text = artists[indexPath.row].name
        //cell.lblNumHits.text = "\(artists[indexPath.row].numHits) hot songs"
        //  let str = artists[indexPath.row].isHot ? "🔥" :  "";
        //  cell.lblEmoji.text = str

//        cell.imgArtist. = // set the artist image 

        return cell
    }

    @IBAction func onBackButtonClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked bro")
        performSegue(withIdentifier: "viewSongsOfArtist", sender: self)
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

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // bad code!!!
        if !searchText.isEmpty {
            artists = artists.filter { (artist: Artist) -> Bool in
                return artist.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        } else {
            // populateArtists()
        }

        artistsTableView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        //populateArtists()
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
