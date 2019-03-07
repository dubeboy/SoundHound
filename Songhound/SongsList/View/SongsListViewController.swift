//
//  SongsListViewViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit
import PKHUD

// TODO must be ablke to mod the navigation controller

// TODO GET APP back to the state that it was before VIPER

class SongsListViewController: UIViewController {
    
    //top Items for the songs list view controller
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var imgArtist3: UIImageView!
    @IBOutlet weak var imgArtist2: UIImageView!
    @IBOutlet weak var imgArtist1: UIImageView!
    @IBOutlet weak var lblArtistName3: UILabel!
    @IBOutlet weak var lblArtistName2: UILabel!
    @IBOutlet weak var lblArtistName1: UILabel!
    @IBOutlet weak var lblPlaying: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var tableViewSongs: UITableView!
    
    var presenter: SongListPresenterProtocol?
    var songList: [SongModel] = []
    //-1 means no image was selected
    private var selectedImage = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        // TODO: Investigate this please why does it not show list with out this
        // also why does it not show the cell separators
        self.tableViewSongs.delegate = self
        self.tableViewSongs.dataSource = self
       // tableViewSongs.tableFooterView = UIView()

        // Do any additional setup after loading the view.
        setUpTopThreeImages()
    }
    
    private func setUpTopThreeImages() {
        makeUIImageViewCircle(imageView: imgProfilePicture, imgSize: 50)
        makeUIImageViewCircle(imageView: imgArtist1, imgSize: 100)
        makeUIImageViewCircle(imageView: imgArtist2, imgSize: 100)
        makeUIImageViewCircle(imageView: imgArtist3, imgSize: 100)
        
        addTapGestureToAnImageView(imageView: imgArtist3)
        addTapGestureToAnImageView(imageView: imgArtist1)
        addTapGestureToAnImageView(imageView: imgArtist2)
    }
    
    
    func addTapGestureToAnImageView(imageView: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        imageTapped(gesture: tapGesture)
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if let imageView = gesture.view as? UIImageView {
            print("Hello ")
            // niot sure if this is a good idea on getting by tag
            let tag = imageView.tag
            print("the tag is \(tag)")
            
            switch tag {
            case 0:
                print("img one openi")
                selectedImage = 0
                presenter?.showSongs(forSelectedArtistId: selectedImage)
                    //  performSegue(withIdentifier: "viewSongsForArtist", sender: self)
                    // will perform segue on the presenter since its the only one which can do so
            case 1:
                print("img one open")
                selectedImage = 1
                presenter?.showSongs(forSelectedArtistId: selectedImage)
               // performSegue(withIdentifier: "viewSongsForArtist", sender: self)
            case 2:
                print("img one opennn")
                selectedImage = 2
                presenter?.showSongs(forSelectedArtistId: selectedImage)
              //  performSegue(withIdentifier: "viewSongsForArtist", sender: self)
            case 3:
                print("profile picture selected bro ")
            //    GIDSignIn.sharedInstance().signIn()
            default:
                print("ooops")
                
            }
        }
    }
    
    
}
//Song list view protocol
extension SongsListViewController: SongsListViewProtocol {
    func onTopThreeArtistClicked() {
        
    }
    
    func showSongsList(songs: [SongModel]) {
        songList = songs
        tableViewSongs.reloadData()
    }
    
    func showError() {
        HUD.flash(.label("Internet not connect"), delay: 2.0)
    }
    
    func showLoading() {
        HUD.show(.progress)
    }
    
    func hideLoading() {
        HUD.hide()
    }
}

extension SongsListViewController:  UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewSongs.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        let song = songList[indexPath.row]
        cell.set(forSong: song)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do stuff when a cell is selected
    }
}
