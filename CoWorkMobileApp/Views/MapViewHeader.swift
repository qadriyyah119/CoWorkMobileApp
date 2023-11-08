//
//  HeaderView.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/15/22.
//

import UIKit
import Cartography
import MapKit

class MapViewHeader: UIView {
    static let identifier = String(describing: MapViewHeader.self)
    
    private lazy var minHeight: CGFloat = { 44 + safeAreaInsets.top }()
    private let maxHeight: CGFloat = 600
    private var heightConstraint = NSLayoutConstraint()
    
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
    
//    func updateHeader(newY: CGFloat, oldY: CGFloat) {
//        let scrollDiff = newY - oldY
//
//        if scrollDiff > 0 { // Scrolling down
//            animate(to: minHeight) // Collapse the header
//        } else if scrollDiff < 0 { // Scrolling up
//            animate(to: maxHeight) // Expand the header
//        }
//    }
    
    func updateHeader(yOffset: CGFloat) {
        let shouldCollapse = yOffset > 0
        let shouldExpand = yOffset < 0

        if shouldCollapse {
            animate(to: minHeight) // Collapse the header
        } else if shouldExpand {
            animate(to: maxHeight) // Expand the header
        }
    }


    
//    func updateHeader(newY: CGFloat, oldY: CGFloat) -> CGFloat {
//        let scrollDiff = newY - oldY
//
//        let isScrollingUp = scrollDiff > 0
//        let isInContent = newY > 0
//        let hasRoomToCollapse = currentOffset > minHeight
//        let shouldCollapse = isScrollingUp && isInContent && hasRoomToCollapse
//
//        let isMovingDown = scrollDiff < 0
//        let isBeyondContent = newY < 0
//        let hasRoomToExpand = currentOffset < maxHeight
//        let shouldExpand = isMovingDown && isBeyondContent && hasRoomToExpand
//
//        if shouldCollapse || shouldExpand {
//            currentOffset -= scrollDiff
//            return newY - scrollDiff
//        }
//
//        return newY
//    }

    private func animate(to value: CGFloat) {
        let newHeight = max(min(value, maxHeight), minHeight)
        UIView.animate(withDuration: 0.2) {
            self.heightConstraint.constant = newHeight
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        
        
    }
    
}
