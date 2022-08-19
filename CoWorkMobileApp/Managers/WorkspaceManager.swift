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
        case unknownError
    }
    
    let apiKey = "KZeMZbxJ_GU-GtyZ_AppdK82oo6k5K5hyTP5pEs4XYoP7YuZS_8N8XYlLLFq_KzXe-QYrCO9l-Fub3RkuOb0InM-Bm1259Wqc3BLpZfa5awdSFJ4Hfu0XnJd5wnXYnYx"
    
    let url = "https://api.yelp.com/v3"
    
    static let shared = WorkspaceManager()
    
    func getWorkspaces(completion: @escaping(Result<List<Workspace>, AuthError>) -> Void) {
        
        var urlComponents = URLComponents(string: "\(url)/businesses/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "term", value: "coffee+shop"),
            URLQueryItem(name: "location", value: "20774")
        ]
        
        guard let url = urlComponents?.url else {
            return completion(.failure(.invalidRequest))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        AF.request(request)
            .responseDecodable(of: WorkspaceListResults.self, decoder: JSONDecoder()) { response in
                switch response.result {
                case .success(let workspace):
                    let spaces = workspace.businesses
                    completion(.success(spaces))
                case .failure:
                    completion(.failure(.invalidData))
                }
            }
    }
}
