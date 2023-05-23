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
        let weekDay: String = Calendar.current.weekdaySymbols[day]
        
        switch day {
        case 0:
            sundayText = weekDay
            sundayHours = time
        case 1:
            mondayText = weekDay
            mondayHours = time
        case 2:
            tuesdayText = weekDay
            tuesdayHours = time
        case 3:
            wednesdayText = weekDay
            wednesdayHours = time
        case 4:
            thursdayText = weekDay
            thursdayHours = time
        case 5:
            fridayText = weekDay
            fridayHours = time
        case 6:
            saturdayText = weekDay
            saturdayHours = time
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
