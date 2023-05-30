//
//  WorkspaceDetailContentViewViewModel.swift
//  CoWorkMobileApp
//

import UIKit
import RealmSwift
import Combine
import CoreLocation

class WorkspaceDetailContentViewViewModel {
    let locationHelper = LocationHelper.shared
    private var locationCancellables: Set<AnyCancellable> = []
    
    var workspace: Workspace? {
        didSet {
            if let workspace = workspace {
                nameText = workspace.name

                if let location = locationHelper.userLocation {
                    let distanceValue = workspace.coordinate.distance(from: location)
                    let distanceV = Measurement(value: distanceValue, unit: UnitLength.meters)
                    let miles = distanceV.converted(to: .miles)
                    let milesValue = round(miles.value * 10) / 10
                    distanceText = "\(milesValue) mi"
                }
                
                ratingText = "\(workspace.rating ?? 0.0)"
                reviewCountText = "(\(workspace.reviewCount ?? 0))"
                isOpenNow = (workspace.hours.first(where: { $0.isOpenNow}) != nil)
                
                for hours in workspace.hours {
                    var businessHours: String = ""
                    for openHours in hours.open {
                        if let day = openHours.day, let start = openHours.start, let end = openHours.end {
                            let isOvernight = openHours.isOvernight
                            let openHours = format(time: start)
                            let closeHours = format(time: end)
                            
                            if !isOvernight {
                                businessHours = "\(openHours)am - \(closeHours)pm"
                            } else {
                                businessHours = "Open 24 hours"
                            }
                            setHours(forDay: day, time: businessHours)
                        }
                    }
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
    var weekdayText: String?
    var weekdayStartHour: String?
    var weekdayEndHour: String?
    var mondayText: String?
    var mondayHours: String?
    var tuesdayText: String?
    var tuesdayHours: String?
    var wednesdayText: String?
    var wednesdayHours: String?
    var thursdayText: String?
    var thursdayHours: String?
    var fridayText: String?
    var fridayHours: String?
    var saturdayText: String?
    var saturdayHours: String?
    var sundayText: String?
    var sundayHours: String?
        
    private func setHours(forDay day: Int, time: String) {
        
        switch day {
        case 0:
            mondayText = "Monday"
            mondayHours = time
        case 1:
            tuesdayText = "Tuesday"
            tuesdayHours = time
        case 2:
            wednesdayText = "Wednesday"
            wednesdayHours = time
        case 3:
            thursdayText = "Thursday"
            thursdayHours = time
        case 4:
            fridayText = "Friday"
            fridayHours = time
        case 5:
            saturdayText = "Saturday"
            saturdayHours = time
        case 6:
            sundayText = "Sunday"
            sundayHours = time
        default:
            break
        }
    }
    
    private func format(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        let dateFromStr = dateFormatter.date(from: time)!

        dateFormatter.dateFormat = "h:mm"
        let timeFromDate = dateFormatter.string(from: dateFromStr)
        return timeFromDate
    }
    
    func fill(withWorkspaceId id: String, completion: (() -> Void)? ) {
        let realm = try? Realm()
        self.workspace = realm?.object(ofType: Workspace.self, forPrimaryKey: id)
        completion?()
    }
}
