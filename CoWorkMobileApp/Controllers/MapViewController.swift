//
//  MapViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 9/21/22.
//

import UIKit
import Cartography
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    private lazy var currentLocationString: String = "Current Location"
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.mapType = .standard
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCurrentLocation()
    }
    
    private func setupView() {
        mapView.delegate = self
        
        self.view.addSubview(mapView)
        
        constrain(mapView) { mapView in
            mapView.edges == mapView.superview!.edges
        }
        
    }
    
    func getCurrentLocation() {
        DispatchQueue.global(qos: .userInitiated).async {
            if CLLocationManager.locationServicesEnabled() {
                let authStatus: CLAuthorizationStatus
                
                authStatus = self.locationManager.authorizationStatus
                switch authStatus {
                case .authorizedAlways, .authorizedWhenInUse:
                    DispatchQueue.main.async {
                        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        self.locationManager.startUpdatingLocation()
                    }
                default:
                    break
                    
                }
            }
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locationValue.latitude) \(locationValue.longitude)")

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locationValue, span: span)
        mapView.setRegion(region, animated: true)
        
        guard let location: CLLocation = manager.location else { return }
        
        getCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            let currentLocationString = "\(city), \(country)"
            self.currentLocationString = currentLocationString
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationValue
            annotation.title = self.currentLocationString
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func getCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ()) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
}
