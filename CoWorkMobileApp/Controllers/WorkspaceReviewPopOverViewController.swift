//
//  WorkspaceReviewPopOverViewController.swift
//  CoWorkMobileApp
//

import UIKit
import Cartography

class WorkspaceReviewPopoverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .magenta
        view.layer.cornerRadius = 30
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 300),
            view.heightAnchor.constraint(equalToConstant: 300)
        ])
        
    }
}
