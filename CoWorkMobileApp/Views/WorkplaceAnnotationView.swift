//
//  WorkplaceAnnotationView.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 12/14/22.
//

import UIKit
import MapKit

class WorkplaceAnnotationView: MKMarkerAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    override var annotation: MKAnnotation? {
        willSet {
            configure(for: newValue)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset any properties that might have been added or modified
        self.glyphText = nil
        self.markerTintColor = .red // Or whatever your default color is
    }

    private func setupView() {
        // Set up initial view properties that don't depend on the annotation data
        canShowCallout = true
        calloutOffset = CGPoint(x: -5, y: 5)
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }

    private func configure(for newValue: MKAnnotation?) {
        if let workplaceAnnotation = newValue as? MapAnnotation {
            if let rating = workplaceAnnotation.rating, rating >= 4.0 {
                glyphText = "⭐️"
                markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
            } else {
                // Configure for non-high-rated annotations
                glyphText = nil // Or some default text
                markerTintColor = .red // Default color for other annotations
            }
        }
    }
}

