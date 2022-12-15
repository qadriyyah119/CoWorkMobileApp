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

protocol MapViewControllerDelegate: AnyObject {
    func mapViewController(_ controller: MapViewController, userDidUpdateLocation location: CLLocation)
}

class MapViewController: UIViewController {
    
    private lazy var currentLocationString: String = "Current Location"
    
//    private lazy var locationManager: CLLocationManager = {
//        let locationManager = CLLocationManager()
//        locationManager.delegate = self
//        return locationManager
//    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.showsCompass = true
        map.showsBuildings = true
        map.showsUserLocation = true
        map.mapType = .standard
        return map
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for Workspaces"
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    weak var delegate: MapViewControllerDelegate?
    weak var datasource: WorkspaceDataSource?
    let viewModel: MapViewModel
    private var workspaceAnnotations: [MapAnnotation] = []
    var selectedWorkspace: Workspace? = nil
    lazy var geocoder = CLGeocoder()
    private var previousLocation: CLLocation?
    
//    var isAuthorized: Bool {
//        return self.locationManager.authorizationStatus == .authorizedWhenInUse || self.locationManager.authorizationStatus == .authorizedAlways
//    }
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setRegion()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.allowsBackgroundLocationUpdates = true
//        startLocationService()
//        locationManager.requestWhenInUseAuthorization()
        loadAnnotations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//         getLocation()
//        if CLLocationManager.locationServicesEnabled(), isAuthorized {
//            activateLocationServices()
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        mapView.delegate = self
        mapView.register(WorkplaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        self.view.addSubview(mapView)
        
        constrain(mapView) { mapView in
            mapView.edges == mapView.superview!.edges
        }
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        printCurrentLocation()
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        
    }
    
//    private func startLocationService() {
//        let authStatus = locationManager.authorizationStatus
//
//        if authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse {
//            activateLocationServices()
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.requestAlwaysAuthorization()
//        }
//    }
    
//    private func activateLocationServices() {
//        locationManager.requestLocation()
//        locationManager.startUpdatingLocation()
//    }
    
//    func getLocation() -> CLLocation {
//        return LocationHelper.currentLocation
//    }
    
//    func getCurrentLocation() {
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//    }

    private func setRegion() {
//        guard let location: CLLocation = locationManager.location else { return }
        guard let location: CLLocation = LocationHelper.currentLocation else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.40, longitudeDelta: 0.40)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func printCurrentLocation() {
//        guard let location: CLLocation = locationManager.location else { return }
        guard let location: CLLocation = LocationHelper.currentLocation else { return }
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let placemark = placemarks?.first else { return }
            if let street = placemark.thoroughfare,
               let city = placemark.locality,
               let state = placemark.administrativeArea {
                let currentLocationString = "\(street) \(city), \(state)"
                self?.currentLocationString = currentLocationString
                self?.navigationItem.title = currentLocationString
                
            }
        }
    }
    
    private func loadAnnotations() {
        let annotations = viewModel.workspaces.compactMap { MapAnnotation(name: $0.name, location: $0.coordinate, rating: $0.rating ?? 0.0)
        }
        
        mapView.addAnnotations(annotations)
//        for business in viewModel.workspaces {
//
//            let coordinate = CLLocationCoordinate2D(latitude: business.coordinate.coordinate.latitude, longitude: business.coordinate.coordinate.longitude)
//            let name = business.name
//            let rating = business.rating ?? 0.0
//
//            let annotation = MapAnnotation(name: name,
//                                           coordinate: coordinate,
//                                           rating: rating)
//
//            mapView.addAnnotation(annotation)
//        }
    }
    
}

//extension MapViewController: CLLocationManagerDelegate {
//
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        let authStatus = manager.authorizationStatus
//
//        switch authStatus {
//        case .authorizedAlways , .authorizedWhenInUse:
//            activateLocationServices()
////            getCurrentLocation()
//        case .notDetermined , .denied , .restricted:
//            break
//        default:
//            break
//        }
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        guard let currentLocation = locations.first else { return }
//
//        if previousLocation == nil {
//            previousLocation = locations.first
//        } else {
//            guard let latestLocation = locations.first else { return }
//            let distanceInMeters = previousLocation?.distance(from: latestLocation) ?? 0
//            print("distance in meters: \(distanceInMeters)")
//            previousLocation = latestLocation
//        }
        
        
//        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locationValue.latitude) \(locationValue.longitude)")
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: locationValue, span: span)
//        mapView.setRegion(region, animated: true)

//    }

//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error - locationManager: \(error.localizedDescription)")
//    }
//
//}

extension MapViewController: MKMapViewDelegate {
    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        centerMap(on: userLocation.coordinate)
//    }
//
//    func centerMap(on location: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 1000) {
//        let coordinateRegion = MKCoordinateRegion(center: location,
//                                                  latitudinalMeters: regionRadius,
//                                                  longitudinalMeters: regionRadius)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MapAnnotation") as? MKMarkerAnnotationView
//        if annotationView == nil {
//            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MapAnnotation")
//        } else {
//            annotationView?.annotation = annotation
//        }
//        annotationView?.canShowCallout = true
//        annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
//        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        return annotationView
//        guard let annotation = annotation as? MapAnnotation else { return nil }
        
//        let identifier = "workspace"
//        let annotationView: MKMarkerAnnotationView
        
//        if let existingView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
//            existingView.annotation = annotation
//            annotationView = existingView
//        } else {
//            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView.canShowCallout = true
//            annotationView.calloutOffset = CGPoint(x: -5, y: 5)
//            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        annotationView.canShowCallout = true
//        return annotationView
//    }
}

extension MapViewController: UISearchBarDelegate {
    
}
