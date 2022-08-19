//
//  SearchViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/11/22.
//

import UIKit

class SearchViewModel {
    enum SearchStrings {
        static let titleText = "Explore"
        
    }
    
    let titleText: String = SearchStrings.titleText
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = SearchStrings.titleText
        label.textAlignment = .left
        label.font = UIFont(name: ThemeFonts.headerFont, size: 37)
        return label
    }()
}
