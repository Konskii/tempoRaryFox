//
//  TournamentsNetworkManager.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 03.11.2020.
//
import Foundation

class TournamentsNetworkManager {
    
    private let hostPath = "http://213.159.209.245/api"
    private let championship = "/championship"
    private let members = "/championshipmember"
    private var headerForJosn = ["Content-Type":"application/json"]
    
    private enum httpMethod: String {
        case POST
        case GET
        case PUT
        case DELETE
    }
    
    let session = URLSession.shared
    static var shared = TournamentsNetworkManager()
    private init(){}
    
    func getAllChampionships(for account: String, completion: @escaping (Result<TournamentsModel, Error>) -> Void) {
        
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        headerForJosn["Authorization"] = "Bearer \(token)"
        //Old request without include
//        guard let request = generateRequest(for: championship,
//                                            method: httpMethod.GET.rawValue,
//                                            header: headerForJosn,
//                                            body: nil) else { return }
        let url = hostPath + championship + "?include=club,club.city"
        guard let request = generateRequestWithInclude(for: url,
                                                       method: httpMethod.GET.rawValue,
                                                       header: headerForJosn,
                                                       body: nil) else { return }
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let tournamernts = try JSONDecoder().decode(TournamentsModel.self, from: data)
                    completion(.success(tournamernts))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getChampionshipMembers(for account: String, champID: Int, completion: @escaping (Result<ChampioshipmembersModel, Error>) -> Void) {
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        headerForJosn["Authorization"] = "Bearer \(token)"
        
        guard let request = generateRequest(for: championship + "/\(champID)" + members,
                                            method: httpMethod.GET.rawValue,
                                            header: headerForJosn,
                                            body: nil) else { return }
        
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let members = try JSONDecoder().decode(ChampioshipmembersModel.self, from: data)
                    completion(.success(members))
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
    
    private func generateRequestWithInclude(for action: String, method: String, header: [String: String]?, body: Data?) -> URLRequest? {
        guard let url = URL(string: action) else {
            print("It will never heppend")
            return nil }
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
