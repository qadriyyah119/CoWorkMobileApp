//
//  MapViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 9/21/22.
//

import UIKit
import RealmSwift
import CoreLocation

class MapViewModel: ObservableObject {
    
    @Published var workspaces: [Workspace] = []
    
    let searchTabTitle: String = "Search"
    let searchTabIcon = UIImage(systemName: "location.magnifyingglass")
    
    private var workspaceNotificationToken: NotificationToken?
    private var workspaceResults: Results<Workspace>?
    
    var currentLocation: CLLocation? {
        didSet {
            realmQuery()
        }
    }
    
    var searchQuery: String {
        didSet {
            realmQuery()
        }
    }
    
    init(searchQuery: String) {
        self.searchQuery = searchQuery
        self.realmQuery()
    }
    
    func getWorkspaces(forLocation location: CLLocation, locationQuery: String, completion: @escaping () -> Void) {
        WorkspaceManager.shared.getWorkspaces(location: locationQuery) { result in
            switch result {
            case .success(let workspaces):
                self.workspaces = Array(workspaces)
            case .failure(let error):
                print(error)
            }
            completion()
        }
    }
    
    private func realmQuery() {
        
        let realm = try? Realm()
        if let currentLocation = currentLocation {
            self.workspaceResults = realm?.objects(Workspace.self)
            self.workspaceNotificationToken = self.workspaceResults?.observe { [weak self] changes in
                switch changes {
                case .initial(let workspaces):
                    self?.workspaces = Array(workspaces)
                        .filter{ $0.coordinate.distance(from: currentLocation) <= 1609 * 5 }
                case .update(let workspaces, _, _, _):
                    self?.workspaces = Array(workspaces)
                        .filter{ $0.coordinate.distance(from: currentLocation) <= 1609 * 5 }
                case .error(let error):
                    print(error)
                }
            }
        } else {
            self.workspaceResults = realm?.objects(Workspace.self)
                .where{ $0.zipCode == searchQuery }
            self.workspaceNotificationToken = self.workspaceResults?.observe { [weak self] changes in
                switch changes {
                case .initial(let workspaces):
                    self?.workspaces = Array(workspaces)
                case .update(let workspaces, _, _, _):
                    self?.workspaces = Array(workspaces)
                case .error(let error):
                    print(error)
                }
            }
        }
    }
}
