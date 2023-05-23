//
//  WorkspaceReview.swift
//  CoWorkMobileApp
//

import UIKit
import RealmSwift

class WorkspaceReview: Object, Decodable {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var url: String?
    @Persisted var text: String?
    @Persisted var rating: Double?
    @Persisted var timeCreated: String?
    @Persisted var user: ReviewUser?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "url"
        case text = "text"
        case rating = "rating"
        case timeCreated = "time_created"
        case user = "user"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        timeCreated = try container.decodeIfPresent(String.self, forKey: .timeCreated)
        user = try container.decodeIfPresent(ReviewUser.self, forKey: .user)
    }
}

class ReviewUser: Object, Decodable {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var profileUrl: String?
    @Persisted var imageUrl: String?
    @Persisted var name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case profileUrl = "profile_url"
        case imageUrl = "image_url"
        case name = "name"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        profileUrl = try container.decodeIfPresent(String.self, forKey: .profileUrl)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        name = try container.decode(String.self, forKey: .name)
    }
}

class ReviewResults: Object, Decodable {
    @Persisted var reviews: List<WorkspaceReview>
    @Persisted var total: Int?
    
    enum CodingKeys: String, CodingKey {
        case reviews = "reviews"
        case total = "total"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        reviews = try container.decodeIfPresent(List<WorkspaceReview>.self, forKey: .reviews) ?? List<WorkspaceReview>()
        total = try container.decodeIfPresent(Int.self, forKey: .total)
    }
}
