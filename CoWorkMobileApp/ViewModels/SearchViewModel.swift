//
//  SearchViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/11/22.
//

import UIKit
import RealmSwift

class SearchViewModel {
    enum SearchStrings {
        static let titleText = "Explore"
    }
    
    enum Section: Int, CaseIterable, CustomStringConvertible {
//        case featured
        case allResults
        
        var description: String {
            switch self {
//            case .featured: return "Featured"
            case .allResults: return "All Results"
            }
        }
    }
    
    var workspaces: [Workspace] = []
    
    let titleText: String = SearchStrings.titleText
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = SearchStrings.titleText
        label.textAlignment = .left
        label.font = UIFont(name: ThemeFonts.headerFont, size: 37)
        return label
    }()
    
    func getWorkspaceList() {
        WorkspaceManager.shared.getWorkspaces { result in
            switch result {
            case .success(let workspaces):
                print("Success!")
                self.workspaces = Array(workspaces)
//                let realm = try? Realm()
//                try? realm?.write({
//                    realm?.add(workspaces, update: .modified)
//                })
            case .failure(let error):
                print(error)
            }
        }
    }
}
