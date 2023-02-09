//
//  WorkspaceDetailContentViewViewModel.swift
//  CoWorkMobileApp
//

import UIKit
import RealmSwift

class WorkspaceDetailContentViewViewModel {
    
    var workspace: Workspace? {
        didSet {
            if let workspace = workspace {
                nameText = workspace.name
                
                if let workspaceDistance = workspace.distance {
                    let distance = Measurement(value: workspaceDistance, unit: UnitLength.meters)
                    let miles = distance.converted(to: .miles)
                    let milesValue = round(miles.value * 10) / 10
                    distanceText = "\(milesValue) mi"
                }
                
                ratingText = "\(workspace.rating ?? 0.0)"
                reviewCountText = "(\(workspace.reviewCount ?? 0))"
                for hours in workspace.hours {
                    isOpenNow = hours.isOpenNow
                }
                addressText = workspace.displayAddress.joined(separator: ", ")
                phoneText = workspace.displayPhone
            }
        }
    }
    
    var nameText: String?
    var distanceText: String?
    var ratingText: String?
    var reviewCountText: String?
    var isOpenNow: Bool = false
    var addressText: String?
    var phoneText: String?
    
    func fill(withWorkspaceId id: String, completion: (() -> Void)? ) {
        let realm = try? Realm()
        self.workspace = realm?.object(ofType: Workspace.self, forPrimaryKey: id)
        completion?()
    }
}
