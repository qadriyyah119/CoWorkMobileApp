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
    
    private lazy var minHeight: CGFloat = { 44 + 12 + 12 + safeAreaInsets.top }()
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
    
    private lazy var searchContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(white: 1.0, alpha: 0)
        return container
    }()
    
    private(set) lazy var searchBarButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .medium
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .secondarySystemBackground
        config.baseForegroundColor = UIColor.black
        config.title = "Search Workspaces"
        config.image = UIImage(systemName: "magnifyingglass")
        config.imagePlacement = .leading
        config.imagePadding = 15
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self,
//                         action: #selector(loginButtonSelected),
//                         for: .primaryActionTriggered)
        return button
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
//          self.heightAnchor.constraint(equalToConstant: 600)
          heightConstraint
        ])
        
        [card, separator].forEach {self.addSubview($0)}
        [mapView, searchContainer].forEach {self.card.addSubview($0)}
        self.searchContainer.addSubview(searchBarButton)

        constrain(card, separator, mapView, searchContainer, searchBarButton) {card, separator, mapView, searchContainer, searchBarButton in
            card.top == card.superview!.top
            card.leading == card.superview!.leading
            card.trailing == card.superview!.trailing
            card.bottom == card.superview!.bottom
            mapView.edges == card.edges
            searchContainer.top == card.top
            searchContainer.leading == card.leading
            searchContainer.trailing == card.trailing
            searchContainer.height == 150
            searchBarButton.top >= searchContainer.top + 24
            searchBarButton.top >= searchContainer.safeAreaLayoutGuide.top + 12
            searchBarButton.leading == searchContainer.leading + 24
            searchBarButton.trailing == searchContainer.trailing - 24
            searchBarButton.bottom == searchContainer.bottom - 12
            separator.height == 1
            separator.leading == separator.superview!.leading
            separator.trailing == separator.superview!.trailing
            separator.bottom == separator.superview!.bottom
            
        }
    }
    
    override func safeAreaInsetsDidChange() {
        maxTopSpace = 40 + safeAreaInsets.top
        topSpaceConstraint.constant = maxTopSpace
    }
    
}

// MARK: - Animation

extension MapViewHeader {
    
    private var currentOffset: CGFloat {
        get { heightConstraint.constant }
        set { animate(to: newValue) }
    }
    
    func updateHeader(newY: CGFloat, oldY: CGFloat) -> CGFloat {
        let delta = newY - oldY
        
        let isMovingUp = delta > 0
        let isInContent = newY > 0
        let hasRoomToCollapse = currentOffset > minHeight
        let shouldCollapse = isMovingUp && isInContent && hasRoomToCollapse
        
        let isMovingDown = delta < 0
        let isBeyondContent = newY < 0
        let hasRoomToExpand = currentOffset < maxHeight
        let shouldExpand = isMovingDown && isBeyondContent && hasRoomToExpand
        
        if shouldCollapse || shouldExpand {
            currentOffset -= delta
            return newY - delta
        }
        
        return newY
    }
    
    private func animate(to value: CGFloat) {
        let clamped = max(min(value, maxHeight), minHeight)
        heightConstraint.constant = clamped
        
        let normalized = (value - minHeight) / (maxHeight - minHeight)
        switch normalized {
        case ..<0.5:
            animateToFifty(normalized)
        default:
            animateToOneHundred(normalized)
        }
    }
    
    private func animateToFifty(_ normalized: CGFloat) {
        let newTop = normalized * 2 * maxTopSpace
        topSpaceConstraint.constant = newTop
        searchContainer.backgroundColor = UIColor(white: 1.0, alpha: 1 - normalized * 2)
    }
    
    private func animateToOneHundred(_ normalized: CGFloat) {
        topSpaceConstraint.constant = maxTopSpace
        searchContainer.backgroundColor = UIColor(white: 1.0, alpha: 0)
    }
    
}
