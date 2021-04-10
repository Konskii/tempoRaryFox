//
//  UniversalNetwokManager.swift
//  Fox19
//
//  Created by Артём Скрипкин on 06.02.2021.
//

import UIKit

extension String: Error { }

class UniversalNetwokManager {
    private let scheme = "http"
    private let host = "213.159.209.245"
    
    func getUrl(forPath path: String, include: String? = nil) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        if let include = include {
            urlComponents.queryItems = [
            URLQueryItem(name: "include", value: include)
            ]
        }
        return urlComponents.url
    }
    
    enum httpMethods: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    private func handleError(withHttpCode code: Int? = nil) -> String {
        guard let code = code else { return "Unknown error" }
        switch code {
        case 400: return "Bad request"
        case 401: return "Unauthorized"
        case 404: return "Not Found"
        case 406: return "Not acceptable"
        case 422: return "Unprocessable"
        case 500: return "Internal server error"
        default: return "Transfer error"
        }
    }
    
    func getRequest(url: URL, method: httpMethods, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "accept")
        if let account = UserDefaults.standard.string(forKey: "number"),
           let token = Keychainmanager.shared.getToken(account: account) {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body {
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.httpBody = body
        }
        return request
    }
    
    func dataTask<T: Codable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if error != nil { completion(.failure(handleError())) }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else {
                completion(.failure(handleError(withHttpCode: response.statusCode)))
                return
            }
            guard let data = data else { completion(.failure(handleError())); return }
            guard let parsedData = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(handleError()))
                return
            }
            completion(.success(parsedData))
        }.resume()
    }
    
    func downloadImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { [self] data, response, error in
            if error != nil { completion(.failure(handleError())) }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else {
                completion(.failure(handleError(withHttpCode: response.statusCode)))
                return
            }
            guard let data = data else { completion(.failure(handleError())); return }
            guard let parsedImage = UIImage(data: data) else {
                completion(.failure(handleError()))
                return
            }
            completion(.success(parsedImage))
        }.resume()
    }
}
