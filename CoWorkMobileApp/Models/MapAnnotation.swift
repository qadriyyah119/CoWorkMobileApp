//
//  MapAnnotation.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 11/18/22.
//

import MapKit

class MapAnnotation: NSObject {
    
    let name: String
    let location: CLLocation
    let rating: Double?
    let ratingDescription: String?
    
    init(name: String,
         location: CLLocation,
         rating: Double) {
        self.name = name
        self.location = location
        self.rating = rating
        self.ratingDescription = "\(rating) stars"
        
        super.init()
    }
    
}

extension MapAnnotation: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return ratingDescription
    }
}
