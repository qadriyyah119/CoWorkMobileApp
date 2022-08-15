//
//  Workspace.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/12/22.
//

import UIKit
import RealmSwift

class Workspace: Object, Decodable {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var name: String = ""
    @Persisted var alias: String?
    @Persisted var isClosed: Bool = false
    @Persisted var imageUrl: String?
    @Persisted var url: String?
    @Persisted var reviewCount: Int?
    @Persisted var categories: List<Category>
    @Persisted var rating: Double?
    @Persisted var coordinates: Coordinates
    @Persisted var transactions: List<String>
    @Persisted var location: Location
    @Persisted var phone: String?
    @Persisted var displayPhone: String?
    @Persisted var distance: Double?
    @Persisted var photos: List<String>
    @Persisted var price: String?
    @Persisted var hours: List<WorkspaceHours>
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case alias = "alias"
        case isClosed = "is_closed"
        case imageUrl = "image_url"
        case url = "url"
        case reviewCount = "review_count"
        case categories = "categories"
        case rating = "rating"
        case coordinates = "coordinates"
        case transactions = "transactions"
        case location = "location"
        case phone = "phone"
        case displayPhone = "display_phone"
        case distance = "distance"
        case photos = "photos"
        case price = "price"
        case hours = "hours"
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        alias = try container.decodeIfPresent(String.self, forKey: .alias)
        isClosed = try container.decode(Bool.self, forKey: .isClosed)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        reviewCount = try container.decodeIfPresent(Int.self, forKey: .reviewCount)
        categories = try container.decodeIfPresent(List<Category>.self, forKey: .categories) ?? List<Category>()
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        transactions = try container.decodeIfPresent(List<String>.self, forKey: .transactions) ?? List<String>()
        location = try container.decode(Location.self, forKey: .location)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        displayPhone = try container.decodeIfPresent(String.self, forKey: .displayPhone)
        distance = try container.decodeIfPresent(Double.self, forKey: .distance)
        photos = try container.decodeIfPresent(List<String>.self, forKey: .photos) ?? List<String>()
        price = try container.decodeIfPresent(String.self, forKey: .price)
        hours = try container.decodeIfPresent(List<WorkspaceHours>.self, forKey: .hours) ?? List<WorkspaceHours>()
    }
}

class Category: Object, Decodable {
    @Persisted var alias: String?
    @Persisted var title: String?
}

class Coordinates: Object, Decodable {
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
}

class Location: Object, Decodable {
    @Persisted var address: String?
    @Persisted var address2: String?
    @Persisted var address3: String?
    @Persisted var city: String?
    @Persisted var zipCode: String?
    @Persisted var country: String?
    @Persisted var state: String?
    @Persisted var displayAddress = List<String>()
    @Persisted var crossStreets: String?
}

class WorkspaceHours: Object, Decodable {
    @Persisted var hours = List<Open>()
    @Persisted var isOpenNow: Bool = false
}

class Open: Object, Decodable {
    @Persisted var isOvernight: Bool = false
    @Persisted var start: String?
    @Persisted var end: String?
    @Persisted var day: Int?
}
