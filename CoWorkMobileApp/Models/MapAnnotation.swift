//
//  MapAnnotation.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 11/18/22.
//

import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    
    let name: String?
    let coordinate: CLLocationCoordinate2D
    let rating: Double?
    let ratingDescription: String?
    
    init(name: String,
         coordinate: CLLocationCoordinate2D,
         rating: Double) {
        self.name = name
        self.coordinate = coordinate
        self.rating = rating
        self.ratingDescription = "\(rating) stars"
        
        super.init()
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return ratingDescription
    }
}
