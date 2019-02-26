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


    @IBAction func onSeeMoreClick(_ sender: UIButton) {

    }



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
      
        getTracDetails(songName: "love", artistName: "") { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("here is the json: ")
                print(json)
                //get the first track
                //bad was should use the provided way
                for i in 0..<10 {
                    let track = json["message"]["body"]["track_list"][i]["track"]
                    //TODO retrieve the value that I want to actually post to firebase
                    //push the whole track object but should also collect the current seek time
                    // should also save the track ID fro easy search
                    let trackName = track["track_name"].stringValue
                    let albumName = track["album_name"].stringValue
                    let artistName = track["artist_name"].stringValue
                    let genre = track["primary_genres"]["music_genre_list"][0]["music_genre"]["music_genre_name"].stringValue
                    let popularity = track["num_favourite"].intValue
                    let albumId = track["album_id"].int64Value
                    print("the album id is \(albumId)")

                    // pick the first 3 artists
                    if i < 3 {
                        let artist = self.createArtist(artist: track)
                        self.topThreeArtists.append(artist)
                    }

                    self.data.append(Song(name: trackName, artistName: artistName, genre: genre, popularity: popularity, albumName: albumName, albumId: albumId))

                    print("trackName: \(String(describing: trackName))")
                }

                print("the data is \(self.data)")

                // setup up the top 3 people
                self.setupTopThreeArtists()
                self.tableViewSongs.reloadData()


            case .failure(let error):
                print(error)
            }
        }
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
    }

    private func setupTopThreeArtists() {
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
        let albumId: Int64 = data[indexPath.row].albumId
//        I will implement something like this in the future but for now what we have is cool so I will cmt it out
//        let popularity: Int = data[indexPath.row].popularity
        let genre: String = data[indexPath.row].genre
        let albumName: String = data[indexPath.row].albumName
        cell.lblArtistName.text = artistName
        cell.lblSongName.text = songName
        cell.lblGenre.text = genre
        cell.lblAlbumName.text = albumName
        //ASK: I dont get why this whould be forced to unwrapped
              //  let cellImageView = cell.imgAlbumCover!
                // will download image later
               // downloadImage(uiImageView: cellImageView, albumId: albumId)


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

    // TODO: should be an extension function
    private func downloadImage(uiImageView: UIImageView, albumId: Int64) {
        // capture the imageview bro
        print("downloadImage: the album id: \(albumId)")
        Alamofire.request("http://api.musixmatch.com/ws/1.1/album.get?album_id=\(albumId)&apikey=\(self.apiKey)")
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let v):
                        // populate this to artist model TODO
                        let artistJSON = JSON(v)  // make json out of this response
                        print()
                        print("the artist JSON \(artistJSON)")
                        let albumData = artistJSON["message"]["body"]["album"]

                        let mbid = albumData["album_mbid"].stringValue // get the mbID so that we can get the album cover
                        print("the mbid \(mbid)")
                        // there are cases where the mbID is blank yoh
                        if !mbid.isEmpty {
                            Alamofire.request("http://coverartarchive.org/release/\(mbid)")
                                    .responseJSON(completionHandler: { response in
                                        switch response.result {
                                        case .success(let cj):
                                            let artistCoverArtJSON = JSON(cj)
                                            let imageStringUrl = artistCoverArtJSON["images"]["image"].stringValue
                                            print("the cover art String URL is \(imageStringUrl)")
                                            let url = URL(string: imageStringUrl)
                                            print("the cover art URL is \(String(describing: url))")
                                            if let url = url {
                                                let data = try? Data(contentsOf: url)
                                                if let data = data { // unwrap this data or our on the background thread yoh
                                                    // go to main thread bro
                                                    DispatchQueue.main.async {
                                                        // display the downloaded image
                                                        uiImageView.image = UIImage(data: data)
                                                    }
                                                }
                                            }
                                        case .failure:
                                            print("oops failure could not get the cover art bro")
                                                // still gonna throw proper errors rarely happens though
                                        }
                                    })
                        }
                        print("queue")
                    case .failure:
                        print("oops failure")
                            // still gonna throw proper errors rarely happens though
                    }
                })
    }
}

//
// EXTENSIONS
//
// READ:  make sure the is conforms to the CLLocationManagerDelegate

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


