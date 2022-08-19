//
//  SearchContentConfiguration.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/11/22.
//

import UIKit

struct SearchContentConfiguration: UIContentConfiguration, Hashable {
    var workspaceId: String?
    
    func makeContentView() -> UIView & UIContentView {
        return SearchContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> SearchContentConfiguration {
        return self
    }

}

extension SearchContentConfiguration: Equatable {
    public static func ==(lhs: SearchContentConfiguration, rhs: SearchContentConfiguration) -> Bool {
        return lhs.workspaceId == rhs.workspaceId
    }
}

