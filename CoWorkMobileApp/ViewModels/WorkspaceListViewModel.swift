//
//  WorkspaceListViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/11/22.
//

import UIKit
import RealmSwift
import CoreLocation

class WorkspaceListViewModel: ObservableObject {
    
    @Published var workspaces: [Workspace] = []
    var workspaceNotificationToken: NotificationToken?
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
    
    let searchTabTitle: String = "Search"
    let searchTabIcon = UIImage(systemName: "location.magnifyingglass")
    
    init(searchQuery: String) {
        self.searchQuery = searchQuery
        self.realmQuery()
    }
    
    func realmQuery() {
        
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
