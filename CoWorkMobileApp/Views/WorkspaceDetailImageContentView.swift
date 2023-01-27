//
//  WorkspaceDetailImageContentView.swift
//  CoWorkMobileApp
//


import UIKit
import Cartography

class WorkspaceDetailImageContentView: UIView, UIContentView {
    
    private var viewModel = WorkspaceDetailImageContentViewViewModel()
        
    private(set) lazy var detailImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(bookmarkButton)
        
        constrain(bookmarkButton) { bookmarkButton in
            bookmarkButton.trailing == bookmarkButton.superview!.trailing - 16
            bookmarkButton.top == bookmarkButton.superview!.top + 16
        }
        return imageView
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark.circle"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }()
    
    private var currentConfiguration: WorkspaceDetailImageContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            return currentConfiguration
        } set {
            guard let newConfiguration = newValue as? WorkspaceDetailImageContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: WorkspaceDetailImageContentConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(configuration: WorkspaceDetailImageContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        self.currentConfiguration = configuration
        
        guard let workspaceId = currentConfiguration.workspaceId else { return }
        viewModel.workspaceImageCompletion = { image in
            self.detailImageView.image = image
        }
        
        viewModel.fill(withWorkspaceId: workspaceId) {
            self.populateView()
        }
    }
    
    private func populateView() {
        detailImageView.image = viewModel.workspaceImage
    }
    
    private func setupView() {
        self.backgroundColor = .magenta
        self.addSubview(detailImageView)
        
        constrain(detailImageView) { detailImageView in
            detailImageView.edges == detailImageView.superview!.edges
        }
    }
    
}
