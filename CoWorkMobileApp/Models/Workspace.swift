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
    @Persisted var coordinates: Coordinates?
    @Persisted var transactions: List<String>
    @Persisted var address: String?
    @Persisted var address2: String?
    @Persisted var address3: String?
    @Persisted var city: String?
    @Persisted var zipCode: String?
    @Persisted var country: String?
    @Persisted var state: String?
    @Persisted var displayAddress = List<String>()
    @Persisted var crossStreets: String?
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
        case address = "address1"
        case address2 = "address2"
        case address3 = "address3"
        case city = "city"
        case zipCode = "zip_code"
        case country = "country"
        case state = "state"
        case displayAddress = "display_address"
        case crossStreets = "cross_streets"
        case phone = "phone"
        case displayPhone = "display_phone"
        case distance = "distance"
        case photos = "photos"
        case price = "price"
        case hours = "hours"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let locationContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        alias = try container.decodeIfPresent(String.self, forKey: .alias)
        isClosed = try container.decode(Bool.self, forKey: .isClosed)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        reviewCount = try container.decodeIfPresent(Int.self, forKey: .reviewCount)
        categories = try container.decodeIfPresent(List<Category>.self, forKey: .categories) ?? List<Category>()
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        coordinates = try container.decodeIfPresent(Coordinates.self, forKey: .coordinates)
        transactions = try container.decodeIfPresent(List<String>.self, forKey: .transactions) ?? List<String>()

        address = try locationContainer.decodeIfPresent(String.self, forKey: .address)
        address2 = try locationContainer.decodeIfPresent(String.self, forKey: .address2)
        address3 = try locationContainer.decodeIfPresent(String.self, forKey: .address3)
        city = try locationContainer.decodeIfPresent(String.self, forKey: .city)
        zipCode = try locationContainer.decodeIfPresent(String.self, forKey: .zipCode)
        country = try locationContainer.decodeIfPresent(String.self, forKey: .country)
        state = try locationContainer.decodeIfPresent(String.self, forKey: .state)
        displayAddress = try locationContainer.decodeIfPresent(List<String>.self, forKey: .displayAddress) ?? List<String>()
        crossStreets = try locationContainer.decodeIfPresent(String.self, forKey: .crossStreets)
        
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

class Region: Object, Decodable {
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case center = "center"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let centerContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .center)
        
        latitude = try centerContainer.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try centerContainer.decodeIfPresent(Double.self, forKey: .longitude)
    }
}

class WorkspaceListResults: Object, Decodable {
    @Persisted var total: Int?
    @Persisted var businesses: List<Workspace>
    @Persisted var region: Region?
    
    enum CodingKeys: String, CodingKey {
        case total = "total"
        case businesses = "businesses"
        case region = "region"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try container.decodeIfPresent(Int.self, forKey: .total)
        businesses = try container.decodeIfPresent(List<Workspace>.self, forKey: .businesses) ?? List<Workspace>()
        region = try container.decodeIfPresent(Region.self, forKey: .region)
    }
}
