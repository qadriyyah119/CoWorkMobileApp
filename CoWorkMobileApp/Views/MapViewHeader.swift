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
    private var maxTopSpace: CGFloat = 40
    private var topSpaceConstraint = NSLayoutConstraint()
    
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
//        self.searchContainer.addSubview(searchBarButton)

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
    
//    override func safeAreaInsetsDidChange() {
//        maxTopSpace = 40 + safeAreaInsets.top
//        topSpaceConstraint.constant = maxTopSpace
//    }
    
}

// MARK: - Animation

extension MapViewHeader {
    
    private var currentOffset: CGFloat {
        get { heightConstraint.constant }
        set { animate(to: newValue) }
    }
    
    func updateHeader(newY: CGFloat, oldY: CGFloat) -> CGFloat {
        let scrollDiff = newY - oldY

        let isScrollingUp = scrollDiff > 0
        let isInContent = newY > 0
        let hasRoomToCollapse = currentOffset > minHeight
        let shouldCollapse = isScrollingUp && isInContent && hasRoomToCollapse

        let isMovingDown = scrollDiff < 0
        let isBeyondContent = newY < 0
        let hasRoomToExpand = currentOffset < maxHeight
        let shouldExpand = isMovingDown && isBeyondContent && hasRoomToExpand

        if shouldCollapse || shouldExpand {
            currentOffset -= scrollDiff
            return newY - scrollDiff
        }

        return newY
    }

    
//    func updateHeader(newY: CGFloat, oldY: CGFloat) -> CGFloat {
//        let scrollDiff = newY - oldY
//
//        if scrollDiff > 0 {
//            // Scrolling down
//            // Expand the header
//            animate(to: minHeight)
//        } else if scrollDiff < 0 {
//            // Scrolling up
//            // Collapse the header
//            animate(to: maxHeight)
//        }
//
//        return newY
//    }

    
    
    private func animate(to value: CGFloat) {
        let newHeight = max(min(value, maxHeight), minHeight)
        heightConstraint.constant = newHeight
        
//        let normalized = (value - minHeight) / (maxHeight - minHeight)
//        switch normalized {
//        case ..<0.5:
//            animateToFifty(normalized)
//        default:
//            animateToOneHundred(normalized)
//        }
    }
    
    private func animateToFifty(_ normalized: CGFloat) {
        let newTop = normalized * 2 * maxTopSpace
        topSpaceConstraint.constant = newTop
    }

    private func animateToOneHundred(_ normalized: CGFloat) {
        topSpaceConstraint.constant = maxTopSpace
    }
    
}
