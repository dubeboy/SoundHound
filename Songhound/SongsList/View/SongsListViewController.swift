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
import CoreLocation
import GoogleMaps
import FirebaseDatabase


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
    static let TAG = "SongsListViewController"
    let pref =  UserDefaults.standard

    var placeNameString: String = "" {
        didSet {
            presenter?.retrieveSongsList(for: placeNameString)
            getCurrentPlayingSong()
            // save the location the current location on every value change it makes sense yoh
            pref.set(placeNameString, forKey: "location")
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
        let currentPlayingSong = ["title": "Drive", "albumTitle": "Single", "artist": "Black Coffee"]
      //  let currentPlayingSong = ["title": "Blank Space", "albumTitle": "Single", "artist": "Taylor Swift"]

        presenter?.updateCurrentPlayingSong(songName: currentPlayingSong["title"]!, artistsName: currentPlayingSong["artist"]!)

    }

    func showError(errorMessage: String ) {
        HUD.flash(.label(errorMessage), delay: 2.0)
    }
}

// END OF CLASS //

//
// SONGSLIST VIEW PROTOCOL
//

extension SongsListViewController: SongsListViewProtocol {
    
    func onTopThreeArtistClicked() {
    }
    
    func showSongsList(songs: [SongModel]) {
        songList = songs
        tableViewSongs.reloadData()
        
        for (i , song ) in songList.enumerated() {
            // gangstar stuff here bro
            switch i {
            case 0:
                imgArtist1.dowloadFromServer(link: songList.first?.artworkURL ?? "")
                lblArtistName1.text = song.artistName
            case 1:
                imgArtist2.dowloadFromServer(link: song.artworkURL)
                lblArtistName2.text = song.artistName
            case 2:
                imgArtist3.dowloadFromServer(link: song.artworkURL)
                lblArtistName3.text = song.artistName
            case 3:
                break
            default:
                break
            }
        }
    }
    
    func showError() {
        HUD.flash(.label("Oops an error occurred!"), delay: 2.0)
    }
    
    func showLoading() {
        HUD.show(.progress)
    }
    
    func hideLoading() {
        HUD.hide()
    }
    
    // TODO this is very ambigious this will take the location and song ID
    func onSongIDReceived(song: SongModel) {
        let ref = Database.database().reference()
        print("SLVP: the placename  is;\(placeNameString)")
        ref.child(placeNameString).child("\(song.id)").setValue(["songID": song.id, "name": song.name])
    }
    
}


//
// UI TABLE VIEW DELEGATE
//

extension SongsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewSongs.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        if let cell = cell as? SongTableViewCell {
            let song = songList[indexPath.row]
            cell.set(forSong: song)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showSongDetail(forSong: songList[indexPath.row])
    }
}

//
//Google Sign in delegate
//

extension SongsListViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser?, withError error: Error!) {
        print("oopps user signed out yoh")
        
        guard let user = user, let authentication = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("user not signed in there was an error bro \(error)")
                return
            }
            print("Yey user signed in bro")
            self.saveGoogleUserInfo(user: user)
            print("the user is \(String(describing: user.userID))")
            if let user = getSignedInUser() {
                self.lblUserName.text = user.fullName
                if let profileUrl = user.profileURL {
                    self.imgProfilePicture.dowloadFromServer(link: profileUrl)
                } else {
                    // TODO: I want to set a default image
                    // leave it as is the defualt image will be set  ie wont change
                }
            } else {
                print("failed to load user man")
                self.lblUserName.text = ""
            }
        }
    }
    
    private func saveGoogleUserInfo(user: GIDGoogleUser) {
        let userId = user.userID
        let idToken = user.authentication.idToken
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        print("this user has profile picture \(user.profile.hasImage)")
        let profileURL = user.profile.imageURL(withDimension: 0).absoluteString
        let preferences = UserDefaults.standard
        
        preferences.set(userId, forKey: USER_ID)
        preferences.set(idToken, forKey: ID_TOKEN)
        preferences.set(fullName, forKey: FULL_NAME)
        preferences.set(givenName, forKey: GIVEN_NAME)
        preferences.set(familyName, forKey: FAMILY_NAME)
        preferences.set(email, forKey: EMAIL)
        preferences.set(profileURL, forKey: PROFILE_URL)
        
        let sync = preferences.synchronize()
        print("it sycned \(sync)")
    }
}

//
// LocationManagerProtocol
//

extension SongsListViewController: LocationManagerProtocol {
    func reverseGeocoderCoordinates(_ coordinates: UnsafeMutablePointer<CLLocationCoordinate2D>) {
        let geocoder = GMSGeocoder()
        //the closure is a callback because this does niot exec in the main thread
        geocoder.reverseGeocodeCoordinate(coordinates.pointee) { response, _ in
            // powerful stuff yoh
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            let fullAddress = lines.joined(separator: "\n")
            self.onReverseCoordinatesReceived(fullAddress)
            print("the full address is \(fullAddress)")
        }
    }
    
    func onReverseCoordinatesReceived(_ fullAddress: String) {
        let fullAddressFirstComponent = fullAddress.components(separatedBy: ",")[0]
        let fullAddressSecondComponent = fullAddress.components(separatedBy: ",")[1]
        self.currentLocation.text = "\(fullAddressFirstComponent), \(fullAddressSecondComponent) "
        placeNameString = fullAddressSecondComponent.trimmingCharacters(in: .whitespaces)
        // music stuff get song after setting up location
        // getCurrentPlayingSong()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            hideLoading()
            showError(errorMessage: "Please enable location to fully benefit from this app.")
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            // could not get the current location
            //  print("sorry man could not get the current location\(i)")
            return
        }
        print("we know the current location yoh \(location)")
        var coor = location.coordinate
        reverseGeocoderCoordinates(&coor)
        // use GMSGeocoder to get the address of the user yeah?
        locationManager.stopUpdatingLocation()
    }
}
