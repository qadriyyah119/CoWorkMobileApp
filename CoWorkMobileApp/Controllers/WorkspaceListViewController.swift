//
//  WorkspaceListViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/10/22.
//

import UIKit
import Cartography
import RealmSwift
import MapKit
import CoreLocation
import Combine

protocol WorkspaceListViewControllerDelegate: AnyObject {
//    func listViewController(_ controller: ListViewController, userDidUpdateLocation location: CLLocation, query: String)
    func workspaceListViewController(controller: WorkspaceListViewController, didSelectWorkspaceWithId id: String)
}

class WorkspaceListViewController: UIViewController, UICollectionViewDelegate {
    
    private enum Section: Int, CaseIterable, CustomStringConvertible {
        case topRated
        case allResults
        
        var description: String {
            switch self {
            case .allResults: return "All Results"
            case .topRated: return "Top Rated"
            }
        }
    }
    
    struct WorkspaceItem: Identifiable, Hashable {
        var id = UUID()
        var workspaceId: String?
    }
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    private lazy var mapViewHeader: MapViewHeader = {
        let view = MapViewHeader()
        return view
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for Workspaces"
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.searchTextField.backgroundColor = .systemBackground
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    weak var delegate: WorkspaceListViewControllerDelegate?
    private(set) var collectionView: UICollectionView!
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, WorkspaceItem>!
    private var workspaceAnnotations: [MapAnnotation] = []
    lazy var geocoder = CLGeocoder()
    private var oldYOffset: CGFloat = 0
    
    let viewModel: WorkspaceListViewModel
    private var cancellables: Set<AnyCancellable> = []
    private lazy var currentLocationString: String = "Current Location"
    
    var currentLocation: CLLocation? {
        didSet {
            viewModel.currentLocation = currentLocation
        }
    }
    var searchQuery: String = ""{
        didSet {
            viewModel.searchQuery = searchQuery
        }
    }
    
    var topBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    init() {
        self.viewModel = WorkspaceListViewModel(searchQuery: self.searchQuery)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        startLocationService()
        locationManager.requestWhenInUseAuthorization()
        loadAnnotations()
        configureDataSource()
        
        viewModel.$workspaces.sink { [weak self] workspaces in
            self?.applySnapshot(with: workspaces)
            self?.loadAnnotations(for: workspaces)
        }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        mapViewHeader.mapView.register(WorkplaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = .systemBackground
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        self.view.addSubview(self.mapViewHeader)
        
        constrain(mapViewHeader, collectionView) { mapViewHeader, collectionView in
            mapViewHeader.top == mapViewHeader.superview!.top
            mapViewHeader.leading == mapViewHeader.superview!.leading
            mapViewHeader.trailing == mapViewHeader.superview!.trailing
            collectionView.top == mapViewHeader.bottom
            collectionView.leading == collectionView.superview!.leading
            collectionView.trailing == collectionView.superview!.trailing
            collectionView.bottom == collectionView.superview!.bottom
        }
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
    }
    
    private let cellRegistration = UICollectionView.CellRegistration<WorkspaceListCell, WorkspaceItem> { cell, indexPath, item in
        cell.workspaceId = item.workspaceId
    }
    
    private let sectionHeaderRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderSupplementaryView>(elementKind: SectionHeaderSupplementaryView.identifier) { supplementaryView, elementKind, indexPath in
        let section = Section(rawValue: indexPath.section)
        supplementaryView.updateLabel(withText: section?.description ?? "")
    }
    
    private func configureDataSource() {
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section, WorkspaceItem>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .topRated:
                return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            case .allResults:
                return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            }
        }
        
        diffableDataSource.supplementaryViewProvider = { [weak self] view, kind, indexPath in
            guard let strongSelf = self else { return UICollectionViewCell() }
            
            return strongSelf.collectionView.dequeueConfiguredReusableSupplementary(using: strongSelf.sectionHeaderRegistration, for: indexPath)
        }
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 15.0
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, layoutEnv in
            
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .topRated:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupHeight = NSCollectionLayoutDimension.estimated(250)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: groupHeight)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let headerLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerLayoutSize,
                                                                                elementKind: SectionHeaderSupplementaryView.identifier,
                                                                                alignment: .topLeading)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [sectionHeader]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                
                return section

            case .allResults:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupHeight = NSCollectionLayoutDimension.estimated(275)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let headerLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerLayoutSize,
                                                                                elementKind: SectionHeaderSupplementaryView.identifier,
                                                                                alignment: .topLeading)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [sectionHeader]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                
                return section
            }
        }, configuration: configuration)
        return layout
    }
    
    private func applySnapshot(with workspaces: [Workspace] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WorkspaceItem>()
        snapshot.appendSections(Section.allCases)
        
        let topRated = workspaces
            .filter { $0.reviewCount ?? 0 >= 50 && $0.rating ?? 0.0 >= 4.5 }
            .prefix(5)
            .map { WorkspaceItem(workspaceId: $0.id) }
        
        let workspaceItems = workspaces.compactMap{ WorkspaceItem(workspaceId: $0.id) }
        snapshot.appendItems(workspaceItems, toSection: .allResults)
        snapshot.appendItems(topRated, toSection: .topRated)
        diffableDataSource.apply(snapshot, animatingDifferences: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let workspace = diffableDataSource.itemIdentifier(for: indexPath)?.workspaceId else { return }
        self.delegate?.workspaceListViewController(controller: self, didSelectWorkspaceWithId: workspace)
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
    
    private func loadAnnotations(for workspaces: [Workspace] = []) {
        let annotations = workspaces.compactMap { MapAnnotation(name: $0.name, location: $0.coordinate, rating: $0.rating ?? 0.0)
        }
        mapViewHeader.mapView.addAnnotations(annotations)
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        mapViewHeader.updateHeader(newY: yOffset, oldY: oldYOffset)
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

}

extension WorkspaceListViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authStatus = manager.authorizationStatus

        switch authStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            print("Auth: AuthorizedWhenInUse")
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
        
        let locationValue: CLLocationCoordinate2D = currentLocation.coordinate
        print("locations = \(locationValue.latitude) \(locationValue.longitude)")

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locationValue, span: span)
        mapViewHeader.mapView.setRegion(region, animated: true)
        
        convertCurrentLocationToString(from: currentLocation) { city, zip, error in
            if let zip = zip {
                self.searchQuery = zip
                self.viewModel.getWorkspaces(forLocation: currentLocation, locationQuery: self.searchQuery) {
                    
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

extension WorkspaceListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(searchText) { placemark, error in
            guard let location = placemark?.first?.location else { return }
            
            DispatchQueue.main.async {
                self.printCurrentLocation(location: location)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                self.mapViewHeader.mapView.setRegion(region, animated: true)
            }
            self.viewModel.getWorkspaces(forLocation: location, locationQuery: searchText) {

            }
        }
    }
}
