//
//  SearchContentConfiguration.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/11/22.
//

import UIKit

public struct SearchContentConfiguration: UIContentConfiguration {
    var workspaceId: String?
    
    public func makeContentView() -> UIView & UIContentView {
        return SearchContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> SearchContentConfiguration {
        return self
    }

}

extension SearchContentConfiguration: Equatable {
    public static func ==(lhs: SearchContentConfiguration, rhs: SearchContentConfiguration) -> Bool {
        return lhs.workspaceId == rhs.workspaceId
    }
}

