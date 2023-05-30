//
//  LocationHelper.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 11/29/22.
//

import UIKit
import Combine
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    static let shared = LocationHelper()
    
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    var deniedAccessPublisher = PassthroughSubject<Void, Never>() //used to notify the app in the event the user removes location access from settings
    
    private(set) var userLocation: CLLocation?
    
    private lazy var locationManager: CLLocationManager = {
      let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()

    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startLocationServices() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            // send denied access publisher
            print("denied access")
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()

        default:
            // send denied access publisher
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        
        coordinatesPublisher.send(location.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        coordinatesPublisher.send(completion: .failure(error))
    }
    
}

    
