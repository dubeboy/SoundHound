//
// Created by Divine Dube on 2019-04-12.
// Copyright (c) 2019 Divine Dube. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps


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
        placeNameString = fullAddressSecondComponent
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
