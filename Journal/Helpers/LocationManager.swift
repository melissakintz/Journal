//
//  LocationHandler.swift
//  Journal
//
//  Created by Mélissa Kintz on 13/07/2023.
//

import Foundation
import CoreLocation

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var placemark : CLPlacemark?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            
            if let location = locationManager.location {
                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("*** Error in \(#function): \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    self.placemark = placemark
                } else {
                    print("*** Error in \(#function): placemark is nil")
                }
            }
            }
            
            break
            
        case .restricted:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .restricted
            break
            
        case .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .denied
            break
            
        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    
}
