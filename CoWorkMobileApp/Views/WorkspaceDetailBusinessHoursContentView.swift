//
//  WorkspaceDetailBusinessHoursContentView.swift
//  CoWorkMobileApp
//

import UIKit
import Cartography

class WorkspaceDetailBusinessHoursContentView: UIView, UIContentView {
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var hoursLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var hoursRowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            dayLabel,
            hoursLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private var currentConfiguration: WorkspaceDetailBusinessHoursContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            return currentConfiguration
        } set {
            guard let newConfiguration = newValue as? WorkspaceDetailBusinessHoursContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
    
    private func apply(configuration: WorkspaceDetailBusinessHoursContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        self.currentConfiguration = configuration
        
        guard let workspaceId = currentConfiguration.workspaceId else { return }

//        viewModel.fill(withWorkspaceId: workspaceId) {
//            self.populateView()
//        }
    }
    
    init(configuration: WorkspaceDetailBusinessHoursContentConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
//        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
