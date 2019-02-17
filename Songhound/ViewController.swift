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

class ViewController: UIViewController {
    
    @IBOutlet weak var imgProfilePictue: UIImageView!
    private let locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        print("assigning the self to the delegate")
        locationManager.requestWhenInUseAuthorization()
        //Todo comment this out for now
        //getTracDetails(songName: "zeze", artistName : "kodak Black")

        imgProfilePictue.layer.cornerRadius = 25
        imgProfilePictue.layer.masksToBounds = true;
        
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
    private func getTracDetails(songName : String, artistName : String) {
        // this is requesting for a particular artist but it should search for a particualer song
        // validate() ??
        // should be able to also search by artist name
        let apiKey = "566c477a33b65757c982ebd5782c3377"
        let req = "http://api.musixmatch.com/ws/1.1/track.search?q_track=" +
            (songName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) +
            "&q_artist=" + (artistName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) +
            "&page_size=3&page=1&s_track_rating=desc&apikey=" + (apiKey)
        Alamofire.request(req).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //TODO retrieve the value that I want to actually post to firebase
                    //push the whole track object but should also collect the current seek time
                    print(json)
                case .failure(let error):
                    print(error)
            }
        }
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
        reverseGeocoderCoordinates(location.coordinate) { fullAddressresponse in
            // do something with the response
            
        }
        // use GMSGeocoder to get the address of the user yeah?
        locationManager.stopUpdatingLocation()
    }
}


