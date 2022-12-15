//
//  LocationHelper.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 11/29/22.
//

import UIKit
import CoreLocation

class LocationHelper: NSObject, ObservableObject {
    
    static let shared = LocationHelper()
    static var currentLocation = shared.locationManager.location
    var locationManager = CLLocationManager()
//    static let defaultLocation = CLLocation(latitude: 37.0902, longitude: 95.7129)
//    static var currentLocation: CLLocation {
//        guard let location = shared.locationManager.location else {
//           return defaultLocation
//        }
//        return location
//    }

    var hasPermission: Bool = false

    

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
    }
    
    func startLocationService() {
        let authStatus = locationManager.authorizationStatus
        
        if authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse {
            activateLocationServices()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func activateLocationServices() {
        locationManager.startUpdatingLocation()
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            activateLocationServices()
            self.hasPermission = true
        case .notDetermined, .denied, .restricted:
            self.hasPermission = false
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
