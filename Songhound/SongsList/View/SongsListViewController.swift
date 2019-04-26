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
    @IBOutlet weak var collectionView: UICollectionView!

    var presenter: SongListPresenterProtocol?
    var songList: [SongModel] = []
    private var selectedImage = -1  //-1 means no image was selected
    let locationManager = CLLocationManager()
    static let TAG = "SongsListViewController"
    let pref =  UserDefaults.standard
    // this will never be null because we instatiate this after songList has been initliased
    // before that we lock the screen to potrait orirntation
    let cellSpacing: CGFloat = 0.6
    private let reuseIdentifier = "songCollectionCell"
    
    
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
        setUpCollectionView(collectionView: collectionView)
//        collectionView.backgroundColor = .gray
        //store the view hieracy for this file
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
          print("BEGIN  viewWillTransition")
        coordinator.animate(alongsideTransition: { _ in
            // This is called during the animation
            print("in viewWillTransition: alongsideTransition")
        }, completion: { _ in
            print("in viewWillTransition: completion")
            // This is called after the rotation is finished. Equal to deprecated `didRotate`
            if UIApplication.shared.statusBarOrientation.isPortrait {
             
            } else {
                print("in viewWillTransition: landscape")
                self.collectionView.reloadData()
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
        }
        // mock song being listened to man
        let currentPlayingSong = ["title": "Drive", "albumTitle": "Single", "artist": "Black Coffee"]
      //  let currentPlayingSong = ["title": "Blank Space", "albumTitle": "Single", "artist": "Taylor Swift"]
        presenter?.updateCurrentPlayingSong(songName: currentPlayingSong["title"]!, artistsName: currentPlayingSong["artist"]!)
    }

    func showError(errorMessage: String ) {
        HUD.flash(.label(errorMessage), delay: 2.0)
    }

    
    private func setUpCollectionView(collectionView: UICollectionView) {
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellSpacing)
        let cellHeight = floor(screenSize.height * cellSpacing)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insertY = (view.bounds.height - cellHeight) / 2.0
        
       // let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        collectionView.contentInset = UIEdgeInsets(top: insertY, left: insetX, bottom: insertY, right: insetX)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// END OF CLASS //
// shoukld look for a better way to expresss the below concepts
//
// SONGSLIST VIEW PROTOCOL
//

extension SongsListViewController: SongsListViewProtocol {
    
    func onTopThreeArtistClicked() {
        // MARK: to be completed
    }
    
    func showSongsList(songs: [SongModel]) {
        songList = songs
        tableViewSongs.reloadData()
        collectionView.reloadData()

        
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
        //Mark: iniatlise the collection view
      // songsCollectionViewXib = loadViewFromXib(songs: songList)
    }
    
    func showError() {
        HUD.flash(.label("Oops an error occurred!"), delay: 2.0)
    }
    
    func showLoading() {
        HUD.show(.progress)
        
        //MARK: disable changing orientation
    }
    
    func hideLoading() {
        // MARK CHANGE ENABLE ORRIENTATION
        HUD.hide()
    }
    
    // TODO this is very ambigious this will take the location and song ID
    func onSongIDReceived(song: SongModel) {
        let ref = Database.database().reference()
        print("SLVP: the placename  is;\(placeNameString)")
        //save song to firebase
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

//
// collection view
//
extension SongsListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("colectiobV: numberOfSections")
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("colectiobV: cell init")

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SongCollectionViewControllerCell
        cell.song = songList[indexPath.item]
        

        return cell
    }
    
    
}

extension SongsListViewController : UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         presenter?.showSongDetail(forSong: songList[indexPath.row])
    }
}





