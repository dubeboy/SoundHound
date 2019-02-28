//
//  ViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/15.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import MediaPlayer
import GoogleSignIn
import Firebase
import GoogleSignIn

class ViewController: UIViewController,
                                    UITableViewDataSource,
                                    UITableViewDelegate, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var imgArtist3: UIImageView!
    @IBOutlet weak var imgArtist2: UIImageView!
    @IBOutlet weak var imgArtist1: UIImageView!
    @IBOutlet weak var lblArtistName3: UILabel!
    @IBOutlet weak var lblArtistName2: UILabel!
    @IBOutlet weak var lblArtistName1: UILabel!
    @IBOutlet weak var tableViewSongs: UITableView!
    @IBOutlet weak var lblPlaying: UILabel!
    @IBOutlet weak var currentLocation: UILabel!


    private let dispatcher = DispatchQueue(label: "execution-queue", qos: .default, attributes: .concurrent)
    private let locationManager = CLLocationManager()
    private var data: [Song] = []
    //-1 means no image was selected
    private var selectedImage = -1
    // prefill it with defined artists
    // we will get them from the api once we have the good data!
    private var topThreeArtists: [Artist] = []

    private let apiKey = "566c477a33b65757c982ebd5782c3377"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        locationManager.delegate = self
        self.tableViewSongs.delegate = self
        self.tableViewSongs.dataSource = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
      

        print("assigning the self to the delegate")
        showCurrentPlayingSong()

        locationManager.requestWhenInUseAuthorization()
      
        makeUIImageViewCircle(imageView: imgProfilePicture, imgSize: 50)
        makeUIImageViewCircle(imageView: imgArtist1, imgSize: 100)
        makeUIImageViewCircle(imageView: imgArtist2, imgSize: 100)
        makeUIImageViewCircle(imageView: imgArtist3, imgSize: 100)

        addTapGestureToAnImageView(imageView: imgArtist3)
        addTapGestureToAnImageView(imageView: imgArtist1)
        addTapGestureToAnImageView(imageView: imgArtist2)

        addTapGestureToAnImageView(imageView: imgProfilePicture)
        
       let user = getSignedInUser()
        if let user = user {
            lblUserName.text = user.fullName
            print("user details \(user.fullName!)")
            let prof = user.profileURL ?? ""
            print("the profile is \(prof)")
            downloadImage(urlString: prof )
        }
        
        searchForSongByArtist(songName: "Swift", callback: {songs in
            self.data = songs
            self.setupTopThreeArtists(songs: songs)
            self.tableViewSongs.reloadData()
        })
    }
    
    
    private func setupTopThreeArtists(songs: [Song]) {
        topThreeArtists.append(Artist(name: songs[0].artistName, artistID: 000))
        topThreeArtists.append(Artist(name: songs[1].artistName, artistID: 000))
        topThreeArtists.append(Artist(name: songs[2].artistName, artistID: 000))
        
        let name = topThreeArtists[0].name
        let name1 = topThreeArtists[1].name
        let name2 = topThreeArtists[2].name

        lblArtistName1.text = name
        lblArtistName2.text = name1
        lblArtistName3.text = name2
    }

//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//        if let error = error {
//            return
//        }
//
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                accessToken: authentication.accessToken)
//        // ...
//    }
//
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//    }


    private func createArtist(artist: JSON) -> Artist {
        let artistName = artist["artist_name"].stringValue
        let artistId = artist["artist_id"].int64Value

        return Artist(name: artistName, artistID: artistId)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("data \(data.count)")
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewSongs.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        let artistName: String = data[indexPath.row].artistName
        let songName: String = data[indexPath.row].name

        let genre: String = data[indexPath.row].genre
        let albumName: String = data[indexPath.row].albumName
        cell.lblArtistName.text = artistName
        cell.lblSongName.text = songName
        cell.lblGenre.text = genre
        cell.lblAlbumName.text = albumName
        //ASK: I dont get why this whould be forced to unwrapped
        let cellImageView = cell.imgAlbumCover!
                // will download image later
        let albumCoverURL = data[indexPath.row].artworkURL
        cellImageView.dowloadFromServer(link: albumCoverURL)


        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // I dont know what to show
        //  performSegue(withIdentifier: "viewSongsOfArtist", sender: self)

    }


    private func reverseGeocoderCoordinates(_ coordinates: CLLocationCoordinate2D, _ didRespond: @escaping (_ response: String) -> Void) {

        let geocoder = GMSGeocoder()


        //the closure is a callback because this does niot exec in the main thread
        geocoder.reverseGeocodeCoordinate(coordinates) { response, error in
            // powerful stuff yoh
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            let fullAddress = lines.joined(separator: "\n")
            didRespond(fullAddress)
            print("the full address is \(fullAddress)")
        }
    }

    /*
      example request
     http://api.musixmatch.com/ws/1.1/track.search?q_artist=justin bieber&page_size=3&page=1&s_track_rating=desc
     */
    private func getTracDetails(songName: String, artistName: String, responseCallback: @escaping (_ response: (DataResponse<Any>)) -> Void) {
        // this is requesting for a particular artist but it should search for a particualer song
        // validate() ??
        // should be able to also search by artist name
        let req = "http://api.musixmatch.com/ws/1.1/track.search?q_track=" +
                (songName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) +
                "&q_artist=" + (artistName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) +
                "&page_size=10&page=1&s_track_rating=desc&apikey=" + (apiKey)
        Alamofire.request(req).responseJSON { (response) in
            responseCallback(response)
        }
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
                performSegue(withIdentifier: "viewSongsForArtist", sender: self)
            case 1:
                print("img one open")
                selectedImage = 1
                performSegue(withIdentifier: "viewSongsForArtist", sender: self)
            case 2:
                print("img one opennn")
                selectedImage = 2
                performSegue(withIdentifier: "viewSongsForArtist", sender: self)
            case 3:
                print("profile picture selected bro ")
                GIDSignIn.sharedInstance().signIn()
            default:
                print("ooops")
                
            }
        }
    }


    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            saveGoogleUserInfo(user: user)
        }
    }

    private func saveGoogleUserInfo(user: GIDGoogleUser) {
        let userId = user.userID
        let idToken = user.authentication.idToken
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        let profileURL = user.profile.imageURL(withDimension: 100).absoluteString
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

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("oopps user signed out yoh")
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("user not signed in there was an error bro \(error)")
                return
            }
            print("Yey user signed in bro")
            self.saveGoogleUserInfo(user: user)
            print("the user is \(String(describing: user?.userID))")
            if let user = getSignedInUser() {
                self.lblUserName.text = user.fullName
                if let profileUrl = user.profileURL {
                    self.downloadImage(urlString: profileUrl )
                } else {
                    // TODO: I want to set a default image
                }
            } else {
                print("failed to load user man")
                self.lblUserName.text = ""
            }
        }
    }
    
    private func downloadImage(urlString: String) {
        // assuming that its dowloading the image
        dispatcher.async {
            let url = URL(string: urlString)
            print("the image of the profile picture is: \(String(describing: url))")
            if let url = url {
                let data = try? Data(contentsOf: url)
                if let data = data { // unwrap this data or our on the background thread yoh
                    // go to main thread bro
                    DispatchQueue.main.async {
                        // display the downloaded image
                        self.imgProfilePicture.image = UIImage(data: data)
                    }
                }
            }
        }
    }

    func addTapGestureToAnImageView(imageView: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true

        //  imageTapped(gesture: tapGesture)
    }

    private func showCurrentPlayingSong() {

        print("show currently Playing song")

        let player = MPMusicPlayerController.systemMusicPlayer


        if let mediaItem = player.nowPlayingItem {
            let title: String = mediaItem.value(forKey: MPMediaItemPropertyTitle) as! String
            let albumTitle: String = mediaItem.value(forKey: MPMediaItemPropertyTitle) as! String
            let artist: String = mediaItem.value(forKey: MPMediaItemPropertyArtist) as! String

            print("the title \(title) and albt \(albumTitle) and artist \(artist)")
        }
    }


    // this prepare is for the 3 top artists

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("called bro")
        if segue.identifier == "viewSongsForArtist" {
            if selectedImage >= 0 {
                let controller = segue.destination as! SongsViewController
                controller.artist = topThreeArtists[selectedImage]
            } else {
                print("this image is bad selected image is still 0 ")
            }
        }
    }


}

//
// EXTENSIONS
//
// READ:  make sure the is conforms to the CLLocationManagerDelegate

extension UIImageView {
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
}

extension ViewController: CLLocationManagerDelegate {
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
        // MY OWN CLOSURE
        reverseGeocoderCoordinates(location.coordinate) { fullAddressresponse in
            // do something with the response
            // baddd
            self.currentLocation.text = "\(String(describing: fullAddressresponse.components(separatedBy: ",").first!)), \(fullAddressresponse.components(separatedBy: ",")[1]) "
        }
        // use GMSGeocoder to get the address of the user yeah?
        locationManager.stopUpdatingLocation()
    }
}


