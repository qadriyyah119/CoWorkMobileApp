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


class WorkspaceListViewController: UIViewController, UICollectionViewDelegate {
    
    private enum Section: Int, CaseIterable, CustomStringConvertible {
        case allResults
        
        var description: String {
            switch self {
            case .allResults: return "All Results"
            }
        }
    }
    
    struct WorkspaceItem: Hashable {
        var workspaceId: String?
    }
    
    private(set) var collectionView: UICollectionView!
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, WorkspaceItem>!
    
    let viewModel: WorkspaceListViewModel
    weak var datasource: WorkspaceDataSource?
    
    init(viewModel: WorkspaceListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.applySnapshot()
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
            case .allResults:
                return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            }
        }
        
        diffableDataSource.supplementaryViewProvider = { [weak self] view, kind, indexPath in
            guard let strongSelf = self else { return UICollectionViewCell() }
            
            return strongSelf.collectionView.dequeueConfiguredReusableSupplementary(using: strongSelf.sectionHeaderRegistration, for: indexPath)
        }
    }
    
//    private func setupRealmDataSource() {
//        let userLocation: CLLocation = LocationHelper.currentLocation
//
//        let realm = try? Realm()
//        self.workspaceResults = realm?.objects(Workspace.self)
////            .sorted(by: { $0.coordinate.distance(from: userLocation) < $1.coordinate.distance(from: userLocation)})
//
//        self.workspaceNotificationToken = self.workspaceResults?.observe { [weak self] changes in
//            guard let strongSelf = self else { return }
//            switch changes {
//            case .initial(let workspaces):
//                let sortedItems = workspaces.sorted(by: { $0.coordinate.distance(from: userLocation) < $1.coordinate.distance(from: userLocation)})
//                let workspaceListItems = sortedItems.compactMap { WorkspaceItem(workspaceId: $0.id) }
////                let workspaceListItems = workspaces.compactMap { WorkspaceItem(workspaceId: $0.id) }
//                strongSelf.workspaceListItems = Array(workspaceListItems)
//                strongSelf.applySectionSnapshot(items: strongSelf.workspaceListItems, section: .allResults, animate: true)
//            case .update(let workspaces, _, _, _):
//                let sortedItems = workspaces.sorted(by: { $0.coordinate.distance(from: userLocation) < $1.coordinate.distance(from: userLocation)})
//                let workspaceListItems = sortedItems.compactMap { WorkspaceItem(workspaceId: $0.id) }
//                strongSelf.workspaceListItems = Array(workspaceListItems)
//                strongSelf.applySectionSnapshot(items: strongSelf.workspaceListItems, section: .allResults, animate: true)
////                let workspaceListItems = workspaces.compactMap { WorkspaceItem(workspaceId: $0.id) }
////                strongSelf.workspaceListItems = Array(workspaceListItems)
////                strongSelf.applySectionSnapshot(items: strongSelf.workspaceListItems, section: .allResults, animate: true)
//            case .error(let error):
//                print(error)
//            }
//        }
//    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, layoutEnv in
            
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            
            switch section {

            case .allResults:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupHeight = NSCollectionLayoutDimension.estimated(275)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let headerLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerLayoutSize, elementKind: SectionHeaderSupplementaryView.identifier, alignment: .topLeading)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [sectionHeader]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                
                return section
            }
        }, configuration: configuration)
        return layout
    }
    
//    private func applySectionSnapshot(items: [WorkspaceItem] = [], section: Section, animate: Bool = false) {
//        var snapshot = NSDiffableDataSourceSectionSnapshot<WorkspaceItem>()
//        snapshot.append(items)
//        diffableDataSource.apply(snapshot, to: section, animatingDifferences: animate)
//    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSectionSnapshot<WorkspaceItem>()
        let workspaceItems = viewModel.workspaces.compactMap{ WorkspaceItem(workspaceId: $0.id) }
        snapshot.append(workspaceItems)
        diffableDataSource.apply(snapshot, to: .allResults, animatingDifferences: true)

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

