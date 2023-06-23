//
//  Network.swift
//  CakeItApp
//
//  Created by Karekar, Mangesh on 23/06/2023.
//

import Foundation

public enum RequestError: Error {
    case decode
    case invalidURL
    case networkError
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "Session expired"
        case .networkError:
            return "Network error"
        }
    }
}
class Network {
    
    func performURLRequest<T: Decodable>(urlString : String,
                                         modelType: T.Type,
                                         completion: @escaping(Result<T, RequestError>) -> Void)   {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(modelType, from: data)
                completion(.success(decodedResponse))
            }
            catch {
                completion(.failure(.decode))
            }
        }.resume()
    }
}



