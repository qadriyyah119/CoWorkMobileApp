//
//  WorkplaceAnnotationView.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 12/14/22.
//

import UIKit
import MapKit

class WorkplaceAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            if let workplaceAnnotation = newValue as? MapAnnotation {
                if let rating = workplaceAnnotation.rating {
                    if rating >= 4.0 {
                        glyphText = "⭐️"
                        markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
                    }
                }
                canShowCallout = true
                calloutOffset = CGPoint(x: -5, y: 5)
                rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        }
    }

}
