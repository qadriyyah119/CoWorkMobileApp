//
//  WorkspaceListFilterContentView.swift
//  CoWorkMobileApp
//

import UIKit
import Cartography

class WorkspaceListFilterContentView: UIView, UIContentView {
    
    private lazy var filterTitleHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            createFilterView()
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    
    private func createFilterView() -> UILabel {
        
        let filterTitles = ["Sort", "Open Now", "Cafe", "Office Space"]
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        for filter in filterTitles {
            constrain(titleLabel) { titleLabel in
                titleLabel.centerX == titleLabel.superview!.centerX
                titleLabel.centerY == titleLabel.superview!.centerY
            }
            
            titleLabel.text = filter
        }

        return titleLabel
    }
    
    private var currentConfiguration: WorkspaceListFilterContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            return currentConfiguration
        } set {
            guard let newConfiguration = newValue as? WorkspaceListFilterContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
    
    private func apply(configuration: WorkspaceListFilterContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        self.currentConfiguration = configuration
    }
    
    init(configuration: WorkspaceListFilterContentConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(filterTitleHorizontalStackView)
        
        constrain(filterTitleHorizontalStackView) { filterTitleHorizontalStackView in
            filterTitleHorizontalStackView.top == filterTitleHorizontalStackView.superview!.top
            filterTitleHorizontalStackView.leading == filterTitleHorizontalStackView.superview!.leading + 4
            filterTitleHorizontalStackView.trailing == filterTitleHorizontalStackView.superview!.trailing - 4
            filterTitleHorizontalStackView.bottom == filterTitleHorizontalStackView.superview!.bottom - 4
        }
    }
    
}

