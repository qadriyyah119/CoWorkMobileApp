//
//  SearchViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/10/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            ThemeColors.grayColor?.cgColor ?? UIColor.darkGray.cgColor,
            UIColor.lightGray.cgColor,
            UIColor.white.cgColor
        ]
        gradient.locations = [0, 0.25, 1]
        return gradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
//        view.backgroundColor = ThemeColors.grayColor
        self.title = "Search"
    }
}
