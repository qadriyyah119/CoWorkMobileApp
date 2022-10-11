//
//  MapViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 9/21/22.
//

import UIKit
import Cartography
import MapKit

class MapViewController: UIViewController {
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.addSubview(mapView)
        
        constrain(mapView) { mapView in
            mapView.edges == mapView.superview!.edges
        }
        
//        mapView.delegate = self 
    }
    
    
}
