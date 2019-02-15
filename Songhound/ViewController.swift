//
//  ViewController.swift
//  Songhound
//
//  Created by Divine Dube on 2019/02/15.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

import UIKit
import GoogleMaps
class ViewController: UIViewController {
    
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        print("assigning the self to the delegate")
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func reverseGeocoderCoordinates(_ coordinates: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        
        
        //the closure is a callback because this does niot exec in the main thread
        geocoder.reverseGeocodeCoordinate(coordinates) {response, error in
            // powerful stuff yoh
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            let fullAddress = lines.joined(separator: "\n")
            print("the full address is \(fullAddress)")
        }
    }

}

//
// EXTENTIONS
//

// READ:  make sure the is conforms to the CLLocationManagerDelegate
 extension ViewController : CLLocationManagerDelegate {
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
        
        reverseGeocoderCoordinates(location.coordinate)
        // use GMSGeocoder to get the address of the user yeah?
        locationManager.stopUpdatingLocation()
    }
}


