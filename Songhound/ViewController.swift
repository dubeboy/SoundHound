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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var imgProfilePictue: UIImageView!
    @IBOutlet weak var imgArtist3: UIImageView!
    @IBOutlet weak var imgArtist2: UIImageView!
    @IBOutlet weak var imgArtist1: UIImageView!
    @IBOutlet weak var lblArtistName3: UILabel!
    @IBOutlet weak var lblArtistName2: UILabel!
    @IBOutlet weak var lblArtistName1: UILabel!
    @IBOutlet weak var tableViewSongs: UITableView!
    @IBOutlet weak var lblPlaying: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    
    //CELL
  
    
    private let locationManager = CLLocationManager()
    private var data: [Song] = []
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
         self.tableViewSongs.delegate = self

        print("assigning the self to the delegate")
        locationManager.requestWhenInUseAuthorization()
        //Todo comment this out for now
        getTracDetails(songName: "love", artistName : "") { response in
            
            
            
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
                    
                    
                    self.data.append(Song(name: trackName ?? "oops", artistName: artistName ?? "oops" , genre: genre ?? "oops" ,popularity: popularity ?? 0 ,albumName: albumName ?? "oops" ))
                    
                    print("trackName: \(String(describing: trackName))")
                }
                
                print("the data is \(self.data)")
           
                 self.tableViewSongs.dataSource = self
                
                
            case .failure(let error):
                print(error)
            }
        }
        makeUIImageViewCircle(imageView: imgProfilePictue, imgSize: 50)
        makeUIImageViewCircle(imageView: imgArtist1, imgSize: 100)
        makeUIImageViewCircle(imageView: imgArtist2, imgSize: 100)
        makeUIImageViewCircle(imageView: imgArtist3, imgSize: 100)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("data \(data.count)")
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewSongs.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        
        let artistName: String = data[indexPath.row].artistName
        let songName: String = data[indexPath.row].name
        let popularity: Int = data[indexPath.row].popularity
        let genre: String = data[indexPath.row].genre
        let albumName: String = data[indexPath.row].albumName
        
//        cell.lblArtistName.text = "\(songName ) - \(artistName ) - \(genre )"
        
////        cell.artistName.text = "\("Hello")"
//
     //   cell.lblPopularity.text = String(popularity)
        
        cell.lblArtistName.text = artistName
        cell.lblSongName.text = songName
        cell.lblGenre.text = genre
        cell.lblAlbumName.text = albumName
        
        return cell
        
    }
    
    
    private func reverseGeocoderCoordinates(_ coordinates: CLLocationCoordinate2D,_ didRespond: @escaping (_ response : String) -> Void) {
        
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
    private func getTracDetails(songName : String, artistName : String, responseCallback:  @escaping (_ response: (DataResponse<Any>) ) -> Void) {
        // this is requesting for a particular artist but it should search for a particualer song
        // validate() ??
        // should be able to also search by artist name
        let apiKey = "566c477a33b65757c982ebd5782c3377"
        let req = "http://api.musixmatch.com/ws/1.1/track.search?q_track=" +
            (songName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) +
            "&q_artist=" + (artistName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) +
            "&page_size=10&page=1&s_track_rating=desc&apikey=" + (apiKey)
        Alamofire.request(req).responseJSON { (response) in
           responseCallback(response)
        }
    }
    
    private func makeUIImageViewCircle(imageView: UIImageView, imgSize: Int) {
        imageView.layer.cornerRadius = CGFloat(imgSize / 2)
        imageView.layer.masksToBounds = true;
    }
    
    private func showCurrentPlayingSong() {
        
    }
}





//
// EXTENSIONS
//

// READ:  make sure the is conforms to the CLLocationManagerDelegate
 extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations : [CLLocation]) {
        guard let location = locations.first else {
            // could not get the current location
            print("sorry man could not get the current location")
            return
        }
        print("we know the current location yoh \(location)")
        // MY OWN CLOSURE
        reverseGeocoderCoordinates(location.coordinate) { fullAddressresponse in
            // do something with the response
            self.currentLocation.text = "In \(fullAddressresponse)"
            
        }
        // use GMSGeocoder to get the address of the user yeah?
        locationManager.stopUpdatingLocation()
    }
}


