//
//  CircularImageView.swift
//  CoWorkMobileApp
//

import UIKit

class CircularImageView: UIImageView {
    
    private let radius: CGFloat
    
    init(radius: CGFloat) {
      self.radius = radius
      super.init(frame: .zero)
      
      self.translatesAutoresizingMaskIntoConstraints = false
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = radius / 2
        self.clipsToBounds = true
    }
    
    func setupView() {
      NSLayoutConstraint.activate([
        self.heightAnchor.constraint(equalToConstant: radius),
        self.widthAnchor.constraint(equalToConstant: radius)
      ])
    }
    
}
