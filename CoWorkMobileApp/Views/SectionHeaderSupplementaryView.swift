//
//  SectionHeaderSupplementaryView.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/15/22.
//

import UIKit
import Cartography

class SectionHeaderSupplementaryView: UICollectionReusableView {
    static let identifier = String(describing: SectionHeaderSupplementaryView.self)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: ThemeFonts.bodyFontMedium, size: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubview(titleLabel)
        
        constrain(titleLabel) {titleLabel in
            titleLabel.leading == titleLabel.superview!.leading + 16
            titleLabel.trailing == titleLabel.superview!.trailing - 16
            titleLabel.bottom == titleLabel.superview!.bottom
        }
    }
    
    func updateLabel(withText text: String) {
        self.titleLabel.text = text
    }
    
}
