//
//  MapViewHeader.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 1/9/24.
//

import UIKit
import Cartography
import MapKit

class MapViewHeader: UIView {
    
    enum ViewState {
        case collapsed
        case expanded
    }
    
    
    static let identifier = String(describing: MapViewHeader.self)
    
    private lazy var minHeight: CGFloat = { 44 }()
    private let maxHeight: CGFloat = 600
    private var heightConstraint = NSLayoutConstraint()
    private var viewState: ViewState = .expanded
    
    private lazy var card: UIView = {
        let card = UIView()
        card.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        card.layer.cornerRadius = 20
        card.layer.masksToBounds = true
        return card
    }()
    
    var mapView: MKMapView = {
        let map = MKMapView()
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.showsCompass = true
        map.showsBuildings = true
        map.showsUserLocation = true
        map.mapType = .standard
        return map
    }()
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .quaternaryLabel
        return separator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .black
        heightConstraint =  self.heightAnchor.constraint(equalToConstant: 600)
        
        NSLayoutConstraint.activate([
          heightConstraint
        ])
        
        [card, separator].forEach {self.addSubview($0)}
        [mapView].forEach {self.card.addSubview($0)}

        constrain(card, separator, mapView) {card, separator, mapView in
            card.top == card.superview!.top
            card.leading == card.superview!.leading
            card.trailing == card.superview!.trailing
            card.bottom == card.superview!.bottom
            mapView.edges == card.edges
            separator.height == 1
            separator.leading == separator.superview!.leading
            separator.trailing == separator.superview!.trailing
            separator.bottom == separator.superview!.bottom
            
        }
    }
    
}

// MARK: - Animation

extension MapViewHeader {
    
    private var currentOffset: CGFloat {
        get { heightConstraint.constant }
        set { animate(to: newValue) }
    }
    
    func updateHeader(newY: CGFloat, oldY: CGFloat) {
        let scrollDiff = newY - oldY

        let isScrollingDown = scrollDiff > 0 && newY > 0 // User is scrolling down past the first item.
        let isScrollingUp = scrollDiff < 0 && newY < 0 // User is pulling down at the top.
        
        var newHeight = currentOffset
        
        if isScrollingDown {
            // User is scrolling down - Collapse
            newHeight = max(minHeight, currentOffset - abs(scrollDiff))
        } else if isScrollingUp {
            // User is pulling up - Expand
            newHeight = min(maxHeight, currentOffset + abs(scrollDiff))
        }
        
        // If the new height is different than the current height, update it.
        if newHeight != currentOffset {
            animate(to: newHeight)
        }
    }

    
    private func animate(to value: CGFloat) {
        guard self.superview != nil else { return }

        DispatchQueue.main.async {
            let newHeight = max(min(value, self.maxHeight), self.minHeight)
            self.heightConstraint.constant = newHeight
            UIView.animate(withDuration: 0.1) {
                self.superview?.layoutIfNeeded()
                self.layoutIfNeeded()
            }
        }
    }

}
