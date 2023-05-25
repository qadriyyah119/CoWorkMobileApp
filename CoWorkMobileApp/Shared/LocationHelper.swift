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

    private lazy var locationManager: CLLocationManager = {
      let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()

    private override init() {
        super.init()

    }
    
    func startLocationServices() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            // send denied access publisher
            print("denied access")
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()

        default:
            // send denied access publisher
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coordinatesPublisher.send(location.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        coordinatesPublisher.send(completion: .failure(error))
    }
    
}

    
