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
import GoogleSignIn

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
    //-1 means no image was selected
    private var selectedImage = -1
    private let locationManager = CLLocationManager()
    private var viewFromNib: UIView!

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
        coordinator.animate(alongsideTransition: { context in
            // This is called during the animation
            print("Not Broken")
        }, completion: { context in
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
}

//Song list view protocol
extension SongsListViewController: SongsListViewProtocol {
    func onTopThreeArtistClicked() {
    }

    func showSongsList(songs: [SongModel]) {
        songList = songs
        tableViewSongs.reloadData()
        // we want to also load the top three images
        imgArtist1.dowloadFromServer(link: songList.first?.artworkURL ?? "")
        imgArtist2.dowloadFromServer(link: songList[1].artworkURL)
        imgArtist3.dowloadFromServer(link: songList[2].artworkURL)
        // we also want to set the names of the images here

        lblArtistName1.text = songList.first?.artistName
        lblArtistName2.text = songList[1].artistName
        lblArtistName3.text = songList[2].artistName
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
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            // could not get the current location
            print("sorry man could not get the current location")
            return
        }
        print("we know the current location yoh \(location)")
        var coor = location.coordinate
        reverseGeocoderCoordinates(&coor)
        // use GMSGeocoder to get the address of the user yeah?
        locationManager.stopUpdatingLocation()
    }
}

