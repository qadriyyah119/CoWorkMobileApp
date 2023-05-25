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
import Combine

protocol MapViewControllerDelegate: AnyObject {
    func mapViewController(_ controller: MapViewController, userDidUpdateLocation location: CLLocation, query: String)
}

class MapViewController: UIViewController {
    
    private lazy var currentLocationString: String = "Current Location"
    
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
    let viewModel: MapViewModel
    private var workspaceAnnotations: [MapAnnotation] = []
    var selectedWorkspace: Workspace? = nil
    lazy var geocoder = CLGeocoder()
    private var cancellables: Set<AnyCancellable> = []
    
    let locationHelper = LocationHelper.shared
    private var locationCancellables: Set<AnyCancellable> = []
    private var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0) {
        didSet {
            didUpdateLocation(with: coordinates)
        }
    }
    
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
    
    init() {
        self.viewModel = MapViewModel(searchQuery: self.searchQuery)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeCoordinateUpdates()
        observeDeniedLocationAccess()
        locationHelper.startLocationServices()
        loadAnnotations()
        
        viewModel.$workspaces.sink { [weak self] workspaces in
            self?.loadAnnotations(for: workspaces)
        }.store(in: &cancellables)
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
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        
    }
    
    func observeCoordinateUpdates() {
        locationHelper.coordinatesPublisher
            .sink { completion in
                print("Handle \(completion) for error and finished subscription")
            } receiveValue: { [weak self] coordinates in
                self?.coordinates = coordinates
            }
            .store(in: &locationCancellables)

    }
    
    func observeDeniedLocationAccess() {
        locationHelper.deniedAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Handle access denied with alert")
            }
            .store(in: &locationCancellables)
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
                self?.navigationItem.title = currentLocationString

            }
        }
    }
    
    private func loadAnnotations(for workspaces: [Workspace] = []) {
        let annotations = workspaces.compactMap { MapAnnotation(name: $0.name, location: $0.coordinate, rating: $0.rating ?? 0.0)
        }
        mapView.addAnnotations(annotations)
    }
    
    func didUpdateLocation(with coordinates: CLLocationCoordinate2D) {
        
        let currentLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        printCurrentLocation(location: currentLocation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: true)
        
        convertCurrentLocationToString(from: currentLocation) { city, zip, error in
            if let zip = zip {
                self.searchQuery = zip
                self.viewModel.getWorkspaces(forLocation: currentLocation, locationQuery: self.searchQuery) {
                    if !self.viewModel.workspaces.isEmpty {
                        self.delegate?.mapViewController(self, userDidUpdateLocation: currentLocation, query: self.searchQuery)
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
    
}

extension MapViewController: MKMapViewDelegate {
    
}

extension MapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(searchText) { placemark, error in
            guard let location = placemark?.first?.location else { return }
            
            DispatchQueue.main.async {
                self.printCurrentLocation(location: location)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
            self.viewModel.getWorkspaces(forLocation: location, locationQuery: searchText) {
                if !self.viewModel.workspaces.isEmpty {
                    self.delegate?.mapViewController(self, userDidUpdateLocation: location, query: searchText)
                }
            }
        }
    }
}
