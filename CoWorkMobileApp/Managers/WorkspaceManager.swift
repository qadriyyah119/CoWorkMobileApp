//
//  WorkspaceManager.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/15/22.
//

import UIKit
import Alamofire
import RealmSwift

class WorkspaceManager {
    
    enum AuthError: Error {
        case invalidRequest
        case invalidData
        case networkError
        case invalidAPIKey
        case unknownError
    }
        
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    let url = "https://api.yelp.com/v3"
    
    static let shared = WorkspaceManager()
    
    func getWorkspaces(forCategories categories: String = "sharedofficespaces",
                       location: String = "",
                       radius: Int = 10000,
                       sortBy: String = "best_match",
                       completion: @escaping(Result<List<Workspace>, AuthError>) -> Void) {
        
        guard let key = apiKey, !key.isEmpty else {
            print("API key does not exist")
            completion(.failure(.invalidAPIKey))
            return
        }
        
        var urlComponents = URLComponents(string: "\(url)/businesses/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "categories", value: categories),
            URLQueryItem(name: "location", value: location),
            URLQueryItem(name: "radius", value: String(radius)),
            URLQueryItem(name: "sort_by", value: sortBy)
        ]
        
        guard let url = urlComponents?.url else {
            return completion(.failure(.invalidRequest))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        
        AF.request(request)
            .responseDecodable(of: WorkspaceListResults.self, decoder: JSONDecoder()) { response in
                switch response.result {
                case .success(let workspace):
                    let spaces = workspace.businesses
                    let realm = try? Realm()
                    try? realm?.write({
                        realm?.add(spaces, update: .modified)
                    })
                    completion(.success(spaces))
                case .failure:
                    completion(.failure(.invalidData))
                }
            }
    }
    
    func getWorkspaceDetails(withId id: String, completion: @escaping(Result<Workspace, AuthError>) -> Void) {
        
        guard let key = apiKey, !key.isEmpty else {
            print("API key does not exist")
            completion(.failure(.invalidAPIKey))
            return
        }
        
        guard let url = URL(string: "\(url)/businesses/\(id)") else {
            return completion(.failure(.invalidRequest))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        
        AF.request(request)
            .responseDecodable(of: Workspace.self, decoder: JSONDecoder()) { response in
                switch response.result {
                case .success(let workspace):
                    let realm = try? Realm()
                    try? realm?.write({
                        realm?.add(workspace, update: .modified)
                    })
                    completion(.success(workspace))
                case .failure:
                    completion(.failure(.invalidData))
                }
            }
    }
    
    func getWorkspaceReviews(withId id: String,
                             limit: Int = 20,
                             sortBy: String = "yelp_sort",
                             completion: @escaping(Result<List<WorkspaceReview>, AuthError>) -> Void) {
        
        guard let key = apiKey, !key.isEmpty else {
            print("API key does not exist")
            completion(.failure(.invalidAPIKey))
            return
        }
        
        var urlComponents = URLComponents(string: "\(url)/businesses/\(id)/reviews")
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "sort_by", value: sortBy)
        ]
        
        guard let url = urlComponents?.url else {
            return completion(.failure(.invalidRequest))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        
        AF.request(request)
            .responseDecodable(of: ReviewResults.self, decoder: JSONDecoder()) { response in
                switch response.result {
                case .success(let review):
                    let reviews = review.reviews
                    print(reviews[0])
                    let realm = try? Realm()
                    try? realm?.write({
                        realm?.add(reviews, update: .modified)
                    })
                    completion(.success(reviews))
                case .failure:
                    completion(.failure(.invalidData))
                }
            }
        
    }
    
    func fetchImage(from urlString: String, completion: @escaping(Result<UIImage?, AuthError>) -> Void) {
        let session = URLSession(configuration: .default)
        
        guard let imageUrl = URL(string: urlString) else {
            return completion(.failure(.invalidRequest))
        }
        
        let dataTask = session.dataTask(with: imageUrl) { data, response, error in
            guard error == nil else {
                print("Image Network Error!")
                return completion(.failure(.networkError))
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            completion(.success(UIImage(data: data)))
        }
        dataTask.resume()
    }
    
}
