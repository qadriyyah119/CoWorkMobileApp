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
    
    
//    func updateHeader(newY: CGFloat, oldY: CGFloat) -> CGFloat {
//        let scrollDiff = newY - oldY
//
//        let isScrollingDown = scrollDiff < 0
//        let isScrollingUp = scrollDiff > 0
//        let isInContent = newY > 0
//        let isBeyondContent = newY < 0
//        let hasRoomToCollapse = currentOffset > minHeight
//        let hasRoomToExpand = currentOffset < maxHeight
//
//        // Collapse when scrolling down and there's room to collapse
//        let shouldCollapse = isScrollingUp && isInContent && hasRoomToCollapse
//        // Expand when scrolling up and there's room to expand
//        let shouldExpand = isScrollingDown && isBeyondContent && hasRoomToExpand
//
//        if shouldCollapse {
//            currentOffset = minHeight
//        } else if shouldExpand {
//            currentOffset = maxHeight
//        }
//
//        // It is not clear why you would return newY - scrollDiff.
//        // This is not typically necessary unless you are trying to account for a correction.
//        // Usually, the newY passed in is simply the new oldY for the next call.
//        return newY
//    }
    
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
        let newHeight = max(min(value, maxHeight), minHeight)
        UIView.animate(withDuration: 0.3) {
            self.heightConstraint.constant = newHeight
            self.layoutIfNeeded()
        }
    }

}
