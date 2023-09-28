//
//  MapView.swift
//  CoWorkMobileApp
//

import UIKit
import Cartography
import MapKit
import CoreLocation
import Combine

protocol MapViewDelegate: AnyObject {
    func mapView(_ view: MapView, userDidUpdateLocation location: CLLocation, query: String)
}

class MapView: UIView {
    
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
        map.showsCompass = true
        map.showsBuildings = true
        map.showsUserLocation = true
        map.mapType = .standard
        return map
    }()
    
    weak var delegate: MapViewDelegate?
    weak var datasource: (any WorkspaceDataSource)?
    let viewModel: MapViewModel
    private var workspaceAnnotations: [MapAnnotation] = []
    var selectedWorkspace: Workspace? = nil
    lazy var geocoder = CLGeocoder()
    private var cancellables: Set<AnyCancellable> = []
    var currentLocation: CLLocation? {
        didSet {
            viewModel.currentLocation = currentLocation
        }
    }
    var searchQuery: String = "" {
        didSet {
            viewModel.searchQuery = searchQuery
        }
    }
    
    var isAuthorized: Bool {
        return self.locationManager.authorizationStatus == .authorizedWhenInUse || self.locationManager.authorizationStatus == .authorizedAlways
    }
    
    init() {
        self.viewModel = MapViewModel(searchQuery: self.searchQuery)
        super.init(frame: .zero)
        
        self.setupView()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        startLocationService()
        locationManager.requestWhenInUseAuthorization()
        loadAnnotations()
        
        viewModel.$workspaces.sink { [weak self] workspaces in
            self?.loadAnnotations(for: workspaces)
        }.store(in: &cancellables)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.allowsBackgroundLocationUpdates = true
//        startLocationService()
//        locationManager.requestWhenInUseAuthorization()
//        loadAnnotations()
//
//        viewModel.$workspaces.sink { [weak self] workspaces in
//            self?.loadAnnotations(for: workspaces)
//        }.store(in: &cancellables)
//    }
    
    
    private func setupView() {
        mapView.delegate = self
        mapView.register(WorkplaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        self.addSubview(mapView)
        
        constrain(mapView) { mapView in
            mapView.edges == mapView.superview!.edges
        }
    
    }
    
    private func startLocationService() {
        let authStatus = locationManager.authorizationStatus

        if authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse {
            activateLocationServices()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func activateLocationServices() {
        locationManager.requestLocation()
    }
    
    private func printCurrentLocation(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let placemark = placemarks?.first else { return }
            if let city = placemark.locality,
               let state = placemark.administrativeArea {
                let currentLocationString = "\(city), \(state)"
                self?.currentLocationString = currentLocationString
            }
        }
    }
    
    private func loadAnnotations(for workspaces: [Workspace] = []) {
        let annotations = workspaces.compactMap { MapAnnotation(name: $0.name, location: $0.coordinate, rating: $0.rating ?? 0.0)
        }
        mapView.addAnnotations(annotations)
    }
    
}

extension MapView: CLLocationManagerDelegate {


    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authStatus = manager.authorizationStatus

        switch authStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            activateLocationServices()
        case .notDetermined , .denied , .restricted:
            break
        default:
            break
        }

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let currentLocation = locations.first else { return }
        printCurrentLocation(location: currentLocation)
        
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locationValue.latitude) \(locationValue.longitude)")

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locationValue, span: span)
        mapView.setRegion(region, animated: true)
        
        convertCurrentLocationToString(from: currentLocation) { city, zip, error in
            if let zip = zip {
                self.searchQuery = zip
                self.viewModel.getWorkspaces(forLocation: currentLocation, locationQuery: self.searchQuery) {
                    if !self.viewModel.workspaces.isEmpty {
                        self.delegate?.mapView(self, userDidUpdateLocation: currentLocation, query: self.searchQuery)
                    }
                }
            }
        }
    }
    
    func convertCurrentLocationToString(from location: CLLocation, completion: @escaping (_ city: String?, _ zip: String?, _ error: Error?) -> ()) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.postalCode,
                       error)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }

}

extension MapView: MKMapViewDelegate {
    
// Methods to use later:
/*
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
*/
    
}


