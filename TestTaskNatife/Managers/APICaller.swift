//
//  APICaller.swift
//  TestTaskNatife
//
//  Created by Ilya Tovstokory on 05.09.2023.
//

import Foundation

struct Constants {
    static let postsFeedURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json"
    static let postIdURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getPostsFeed(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: Constants.postsFeedURL) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            do {
                let results = try decoder.decode(PostsFeed.self, from: data)
                completion(.success(results.posts))
                print(results)
            } catch {
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func getPostById(with id: Int, completion: @escaping (Result<PostById, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.postIdURL)\(id).json") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            do {
                let results = try decoder.decode(PostDetails.self, from: data)
                completion(.success(results.post))
                print(results)
            } catch {
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
