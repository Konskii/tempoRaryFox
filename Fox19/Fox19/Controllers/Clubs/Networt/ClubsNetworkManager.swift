//
//  ClubsNetworkManager.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 03.11.2020.
//
import Foundation

class ClubsNetworkManager {
    
    private let mainHostPath = "http://213.159.209.245"
    private let hostPath = "http://213.159.209.245/api"
    private let club = "/club"
    private let image = "/image"
    private let review = "/review"
    private var headerForJosn = ["Content-Type":"application/json"]
    
    private enum httpMethod: String {
        case POST
        case GET
        case PUT
        case DELETE
    }
    
    let session = URLSession.shared
    static var shared = ClubsNetworkManager()
    private init(){}
    
    func getAllClubs(for account: String, completion: @escaping (Result<ClubsModel, Error>) -> Void) {
        
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        headerForJosn["Authorization"] = "Bearer \(token)"
        guard let request = generateRequest(for: club,
                                            method: httpMethod.GET.rawValue,
                                            header: headerForJosn,
                                            body: nil) else { return }
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
//            if let response = response as? HTTPURLResponse {
//                print(response.statusCode)
//            }
            
            if let data = data {
                do {
                    let clubs = try JSONDecoder().decode(ClubsModel.self, from: data)
                    completion(.success(clubs))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getImageForClubCover(for account: String, clubId id: Int, completion: @escaping (Result<ClubImagesModel, Error>) -> Void) {
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        headerForJosn["Authorization"] = "Bearer \(token)"
        guard let request = generateRequest(for: club + "/\(id)" + image,
                                            method: httpMethod.GET.rawValue,
                                            header: headerForJosn,
                                            body: nil) else { return }
        
        session.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let club = try JSONDecoder().decode(ClubImagesModel.self, from: data)
                    completion(.success(club))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func downloadImageForCover(from url: String, account: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        headerForJosn["Authorization"] = "Bearer \(token)"
        
        guard let baseUrl = URL(string: mainHostPath) else {
            print("It will never heppend")
            return }
        let url = baseUrl.appendingPathComponent(url)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.GET.rawValue
        request.allHTTPHeaderFields = headerForJosn
        session.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
    func getClubReviews(for account: String, clubId id: Int, completion: @escaping (Result<ClubReviews, Error>) -> Void) {
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        headerForJosn["Authorization"] = "Bearer \(token)"
        
        guard let request = generateRequest(for: club + "/\(id)" + review,
                                            method: httpMethod.GET.rawValue,
                                            header: headerForJosn,
                                            body: nil) else { return }
        session.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let reviews = try JSONDecoder().decode(ClubReviews.self, from: data)
                    completion(.success(reviews))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    private func generateRequest(for action: String, method: String, header: [String: String]?, body: Data?) -> URLRequest? {
        guard let baseUrl = URL(string: hostPath) else {
            print("It will never heppend")
            return nil }
        let url = baseUrl.appendingPathComponent(action)
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let header = header {
            request.allHTTPHeaderFields = header
        }
        if let body = body {
            request.httpBody = body
        }
        return request
    }
}
