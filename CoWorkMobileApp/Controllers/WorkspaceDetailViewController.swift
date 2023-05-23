//
//  WorkspaceDetailViewController.swift
//  CoWorkMobileApp
//


import UIKit
import Cartography

class WorkspaceDetailViewController: UIViewController, UICollectionViewDelegate {
    
    private enum Section: Int, CaseIterable, CustomStringConvertible {
        case workspaceImages
        case details
        
        var description: String {
            switch self {
            case .workspaceImages: return ""
            case .details: return ""
            }
        }
    }
    
    struct WorkspaceDetailItem: Hashable {
        var workspaceId: String?
        var imageUrl: String?
    }
    
    private(set) var collectionView: UICollectionView!
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, WorkspaceDetailItem>!
    
    let viewModel: WorkspaceDetailViewModel
    var workspaceId: String
    
    init(workspaceId: String) {
        self.workspaceId = workspaceId
        self.viewModel = WorkspaceDetailViewModel(workspaceId: self.workspaceId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureDataSource()
        viewModel.getWorkspaceDetails(forId: self.workspaceId) {
            if let workspace = self.viewModel.workspace {
                self.applySnapshot(forWorkspace: workspace)
            }
        }
        let xButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = xButton
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
    }
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark.circle"), for: .normal)
        button.tintColor = UIColor.white
        button.sizeToFit()
        button.addTarget(self, action: #selector(saveToFavorites), for: .primaryActionTriggered)
        return button
    }()
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
    
    @objc func saveToFavorites() {
        print("Save")
    }
    
    private func setupView() {
        lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = ThemeColors.mainBackgroundColor
        collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        constrain(collectionView) { collectionView in
            collectionView.edges == collectionView.superview!.edges
        }
        
    }
    
    private let imageCellRegistration = UICollectionView.CellRegistration<WorkspaceDetailImageCell, WorkspaceDetailItem> { cell, indexPath, item in
        cell.workspaceId = item.workspaceId
    }
    
    private let detailCellRegistration = UICollectionView.CellRegistration<WorkspaceDetailCell, WorkspaceDetailItem> { cell, indexPath, item in
        cell.workspaceId = item.workspaceId
    }
    
    private func configureDataSource() {
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section, WorkspaceDetailItem>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .workspaceImages:
                return collectionView.dequeueConfiguredReusableCell(using: self.imageCellRegistration, for: indexPath, item: itemIdentifier)
            case .details: return collectionView.dequeueConfiguredReusableCell(using: self.detailCellRegistration, for: indexPath, item: itemIdentifier)
            }
        }
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 15.0

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, layoutEnv in

            guard let section = Section(rawValue: sectionIndex) else { return nil }

            switch section {
            case .workspaceImages:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupHeight = NSCollectionLayoutDimension.estimated(320)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

                let section = NSCollectionLayoutSection(group: group)

                return section

            case .details:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

                let groupHeight = NSCollectionLayoutDimension.estimated(100)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

                return section

            }
        }, configuration: configuration)
        return layout
    }
    
    
    private func applySnapshot(forWorkspace workspace: Workspace) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WorkspaceDetailItem>()
        snapshot.appendSections(Section.allCases)
        
        let imageItems = WorkspaceDetailItem(workspaceId: workspace.id, imageUrl: workspace.url)
        let detailItems = WorkspaceDetailItem(workspaceId: workspace.id)
        snapshot.appendItems([imageItems], toSection: .workspaceImages)
        snapshot.appendItems([detailItems], toSection: .details)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
