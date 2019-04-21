//
//  SongsListViewViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/03/01.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit
import PKHUD
import GoogleMaps
import MediaPlayer
import GoogleSignIn
import Firebase

// TODO Modify change Controller window background
class SongsListViewController: UIViewController {

    //top Items for the songs list view controller
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgArtist3: UIImageView!
    @IBOutlet weak var imgArtist2: UIImageView!
    @IBOutlet weak var imgArtist1: UIImageView!
    @IBOutlet weak var lblArtistName3: UILabel!
    @IBOutlet weak var lblArtistName2: UILabel!
    @IBOutlet weak var lblArtistName1: UILabel!
    @IBOutlet weak var lblPlaying: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var tableViewSongs: UITableView!
    @IBOutlet weak var imgProfilePicture: UIImageView!

    var presenter: SongListPresenterProtocol?
    var songList: [SongModel] = []
    private var selectedImage = -1  //-1 means no image was selected
    let locationManager = CLLocationManager()
    var viewFromNib: UIView!

    let TAG = "SongsListViewController"
 //   private let ref: DatabaseReference!

    // the above is being set in the location manager
    var placeNameString: String = "" {
        didSet {
            presenter?.retrieveSongsList(for: placeNameString)
            getCurrentPlayingSong()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        self.tableViewSongs.delegate = self
        self.tableViewSongs.dataSource = self
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()

        let user = getSignedInUser()
        if let user = user {
            lblUserName.text = user.fullName
            print("user details \(user.fullName!)")
            let prof = user.profileURL ?? ""
            print("the profile is \(prof)")
            imgProfilePicture.dowloadFromServer(link: prof)
        }
        setUpTopThreeImages()
        viewFromNib = view
    }

    private func setUpTopThreeImages() {
        makeUIImageViewCircle(imageView: imgProfilePicture, imgSize: 50)
        makeUIImageViewCircle(imageView: imgArtist1, imgSize: 100)
        makeUIImageViewCircle(imageView: imgArtist2, imgSize: 100)
        makeUIImageViewCircle(imageView: imgArtist3, imgSize: 100)

        addTapGestureToAnImageView(imageView: imgArtist3)
        addTapGestureToAnImageView(imageView: imgArtist1)
        addTapGestureToAnImageView(imageView: imgArtist2)
        addTapGestureToAnImageView(imageView: imgProfilePicture)
    }


    func addTapGestureToAnImageView(imageView: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self,
                action: #selector(SongsListViewController.imageTapped(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true

        imageTapped(gesture: tapGesture)
    }

    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if gesture.numberOfTouches > 0 {
            if let imageView = gesture.view as? UIImageView {
                print("Hello ")
                print(gesture.numberOfTouches)
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
                    selectedImage = 3
                    GIDSignIn.sharedInstance().delegate = self
                    GIDSignIn.sharedInstance().uiDelegate = self
                    GIDSignIn.sharedInstance().signIn()

                default:
                    print("ooops")

                }
            }

        }
    }

    @IBAction func onMoreArtistsClick(_ sender: Any) {
        presenter?.presentMoreArtists()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            // This is called during the animation
            print("Not Broken")
        }, completion: { _ in
            print("Broken")
            // This is called after the rotation is finished. Equal to deprecated `didRotate`
            if UIApplication.shared.statusBarOrientation.isPortrait {
                print("Screen rotated  UP")
                self.view = self.viewFromNib
            } else {
                print("Screen rotated  DOWN")
               self.view = UIView(frame: .zero)
            }
        })
    }
    
    func getCurrentPlayingSong() {
        print("####### calling the music player#####")
        let player = MPMusicPlayerController.systemMusicPlayer
        if let mediaItem = player.nowPlayingItem {
            let title: String = mediaItem.value(forProperty: MPMediaItemPropertyTitle) as! String
            let albumTitle: String = mediaItem.value(forProperty: MPMediaItemPropertyAlbumTitle) as! String
            let artist: String = mediaItem.value(forProperty: MPMediaItemPropertyArtist) as! String
            
            print("\(title) on \(albumTitle) by \(artist)")
            // get ID OF SONG ON ITUNES
            // check if the song exists on firebase then append the number of playes
            // if not
            // UPLOAD THE SONG ON FIREBASE
            //
        }
        // mock song being listened to man
//        let currentPlayingSong = ["title": "Spirit", "albumTitle": "Single", "artist": "Kwesta"]
        let currentPlayingSong = ["title": "Blank Space", "albumTitle": "Single", "artist": "Taylor Swift"]
      //  let currentPlayingSong = ["title": "Spirit", "albumTitle": "Single", "artist": "Kwesta"]

        presenter?.updateCurrentPlayingSong(songName: currentPlayingSong["title"]!, artistsName: currentPlayingSong["artist"]!)

    }

    func showError(errorMessage: String ) {
        HUD.flash(.label(errorMessage), delay: 2.0)
    }
}


