//
//  BaseNetwork.swift
//  BaseNetWork
//
//  Created by Nguyen Son on 27/2/25.
//

import Foundation
import Combine
import Network

enum NetworkError: Error {
    case noInternet
    case invalidURL
    case requestFailed
    case invalidResponse
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class BaseNetwork {
    static let shared = BaseNetwork()
    
    func request<T: Decodable>(endpoint: APIEndpoint,
                               headers: [String: String] = [:],
                               maxRetry: Int = 3) -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint.url) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        if endpoint.method != .get {
            request.httpBody = endpoint.body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .retry(maxRetry)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
