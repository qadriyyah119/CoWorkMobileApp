//
//  WorkspaceListViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/10/22.
//

import UIKit
import Cartography
import RealmSwift
import CoreLocation
import Combine

protocol WorkspaceListViewControllerDelegate: AnyObject {
    func workspaceListViewController(controller: WorkspaceListViewController, didSelectWorkspaceWithId id: String)
}

class WorkspaceListViewController: UIViewController, UICollectionViewDelegate {
    
    private enum Section: Int, CaseIterable, CustomStringConvertible {
        case topRated
        case allResults
        
        var description: String {
            switch self {
            case .allResults: return "All Results"
            case .topRated: return "Top Rated"
            }
        }
    }
    
    struct WorkspaceItem: Hashable {
        var workspaceId: String?
    }
    
    struct TopRatedWorkspaceItem: Hashable {
        var workspaceId: String?
    }
    
    private(set) var collectionView: UICollectionView!
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, WorkspaceItem>!
    
    weak var delegate: WorkspaceListViewControllerDelegate?
    let viewModel: WorkspaceListViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    var currentLocation: CLLocation? {
        didSet {
            viewModel.currentLocation = currentLocation
        }
    }
    var searchQuery: String = ""{
        didSet {
            viewModel.searchQuery = searchQuery
        }
    }
    
    init() {
        self.viewModel = WorkspaceListViewModel(searchQuery: self.searchQuery)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureDataSource()
        viewModel.$workspaces.sink { [weak self] workspaces in
            self?.applySnapshot(with: workspaces)
        }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = ThemeColors.mainBackgroundColor
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        constrain(collectionView) { collectionView in
            collectionView.edges == collectionView.superview!.edges
        }
    
    }
    
    private let cellRegistration = UICollectionView.CellRegistration<WorkspaceListCell, WorkspaceItem> { cell, indexPath, item in
        cell.workspaceId = item.workspaceId
    }
    
    private let sectionHeaderRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderSupplementaryView>(elementKind: SectionHeaderSupplementaryView.identifier) { supplementaryView, elementKind, indexPath in
        let section = Section(rawValue: indexPath.section)
        supplementaryView.updateLabel(withText: section?.description ?? "")
    }
    
    private func configureDataSource() {
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section, WorkspaceItem>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .topRated:
                return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            case .allResults:
                return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            }
        }
        
        diffableDataSource.supplementaryViewProvider = { [weak self] view, kind, indexPath in
            guard let strongSelf = self else { return UICollectionViewCell() }
            
            return strongSelf.collectionView.dequeueConfiguredReusableSupplementary(using: strongSelf.sectionHeaderRegistration, for: indexPath)
        }
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 15.0
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, layoutEnv in
            
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .topRated:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupHeight = NSCollectionLayoutDimension.estimated(250)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: groupHeight)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let headerLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerLayoutSize,
                                                                                elementKind: SectionHeaderSupplementaryView.identifier,
                                                                                alignment: .topLeading)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [sectionHeader]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                
                return section

            case .allResults:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupHeight = NSCollectionLayoutDimension.estimated(275)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let headerLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerLayoutSize,
                                                                                elementKind: SectionHeaderSupplementaryView.identifier,
                                                                                alignment: .topLeading)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [sectionHeader]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                
                return section
            }
        }, configuration: configuration)
        return layout
    }
    
    private func applySnapshot(with workspaces: [Workspace] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WorkspaceItem>()
        snapshot.appendSections(Section.allCases)
        
        let topRated = workspaces
            .filter { $0.reviewCount ?? 0 >= 50 && $0.rating ?? 0.0 >= 4.5 }
            .prefix(5)
            .map { WorkspaceItem(workspaceId: $0.id) }
        
        let workspaceItems = workspaces.compactMap{ WorkspaceItem(workspaceId: $0.id) }
        snapshot.appendItems(workspaceItems, toSection: .allResults)
        snapshot.appendItems(topRated, toSection: .topRated)
        diffableDataSource.apply(snapshot, animatingDifferences: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let workspace = diffableDataSource.itemIdentifier(for: indexPath)?.workspaceId else { return }
        self.delegate?.workspaceListViewController(controller: self, didSelectWorkspaceWithId: workspace)
    }

}

extension WorkspaceListViewController {
    
    func setupGradient() {
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
        
        gradient.frame = view.bounds
        self.view.layer.addSublayer(gradient)
    }
}

