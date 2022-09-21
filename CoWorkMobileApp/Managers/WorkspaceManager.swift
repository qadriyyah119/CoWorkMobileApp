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
    
    func getWorkspaces(forSearchTerm term: String = "coffee+shop",
                       location: String = "20774",
                       completion: @escaping(Result<List<Workspace>, AuthError>) -> Void) {
        
        guard let key = apiKey, !key.isEmpty else {
            print("API key does not exist")
            completion(.failure(.invalidAPIKey))
            return
        }
        
        var urlComponents = URLComponents(string: "\(url)/businesses/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "location", value: location)
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
                    print(spaces[0])
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
