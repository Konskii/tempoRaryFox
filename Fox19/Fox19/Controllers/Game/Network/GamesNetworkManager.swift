//
//  Network.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 31.10.2020.
//

import UIKit

class GamesNetworkManager {
    
    private let mainHostPath = "http://213.159.209.245"
    private let hostPath = "http://213.159.209.245/api"
    private let game = "/game?include=club,user"
    private let gamemember = "/gamemember?include=user"
    private var headerForJson = ["Content-Type":"application/json"]
    
    private let user = "/user"
    
    private enum httpMethod: String {
        case POST
        case GET
        case PUT
        case DELETE
    }
    
    private enum Errors: Error {
        case body
        case response
        case request
        case data
        case parse
        case result
        case gettingUser
        case json
        case statusCode(Int)
    }
    
    static var shared = GamesNetworkManager()
    private init() {}
    
    //MARK: - Get Games
    func getGamesTest(token: String, competiton: @escaping (Result<GamesModel, Error>) -> Void) {
        headerForJson["Authorization"] = "Bearer \(token)"
        guard let request = generateRequest(for: game,
                                            method: httpMethod.GET.rawValue,
                                            header: headerForJson,
                                            body: nil) else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                competiton(.failure(error))
            }
            if let data = data {
                do {
                    let games = try JSONDecoder().decode(GamesModel.self, from: data)
                    competiton( .success(games))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getMembersTest(gameID: Int, token: String, competiton: @escaping (Result<GameMembers, Error>) -> Void) {
        
        headerForJson["Authorization"] = "Bearer \(token)"
        guard let request = generateRequest(for: "/game" + "/\(gameID)" + gamemember,
                                            method: httpMethod.GET.rawValue,
                                            header: headerForJson,
                                            body: nil) else { return }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                competiton(.failure(error))
            }
            
//            if let response = response as? HTTPURLResponse {
//                print("GameMember Status")
//                print(response.statusCode)
//            }
            
            if let data = data {
                do {
                    let gameMember = try JSONDecoder().decode(GameMembers.self, from: data)
                    competiton( .success(gameMember))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    

    
    //MARK: - Get Games
    func getGames(competiton: @escaping (Result<GameModel, Error>) -> Void) {

      //  headerForJson["Authorization"] = "Bearer \(token)"
        
        guard let request = generateRequest(for: game,
                                            method: httpMethod.GET.rawValue,
                                            header: headerForJson,
                                            body: nil) else { return }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                competiton(.failure(error))
            }
            
//            if let response = response as? HTTPURLResponse {
//                print(response.statusCode)
//            }
            
            if let data = data {
                do {
                    let games = try JSONDecoder().decode(GameModel.self, from: data)
                    competiton( .success(games))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    //MARK: - Get Members
    func getMembers(gameID: Int, competiton: @escaping (Result<GameMembers, Error>) -> Void) {
        
        guard let request = generateRequest(for: game + "/\(gameID)" + gamemember,
                                            method: httpMethod.GET.rawValue,
                                            header: headerForJson,
                                            body: nil) else { return }
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                competiton(.failure(error))
            }
            
//            if let response = response as? HTTPURLResponse {
//                print(response.statusCode)
//            }
            
            if let data = data {
                do {
                    let gameMember = try JSONDecoder().decode(GameMembers.self, from: data)
                    competiton( .success(gameMember))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    //MARK: - Delete gameMember
    
    func deleteFromGame(gameID: Int, gameMemberID: Int, competiton: @escaping (Result<GameMembers, Error>) -> Void) {
        
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        
        guard let request = generateRequestWithTwoHeaders(for: game + "/\(gameID)" + gamemember + "/\(gameMemberID)",
                                      method: httpMethod.DELETE.rawValue,
                                      body: nil,
                                      token: token) else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                competiton(.failure(error))
            }
            
//            if let response = response as? HTTPURLResponse {
//                print(response.statusCode)
//            }
            
            if let data = data {
                do {
                    let gameMember = try JSONDecoder().decode(GameMembers.self, from: data)
                    competiton( .success(gameMember))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    //MARK: - Add Game
    
    func addToGame(gameID: Int, userID: Int, competiton: @escaping (Result<GameMember, Error>) -> Void) {
        
        struct PostGamemember: Codable {
            let user: Int
        }
        
        let body = PostGamemember(user: userID)
        let data = try? JSONEncoder().encode(body)
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        headerForJson["Authorization"] = "Bearer \(token)"
        guard let request = generateRequest(for: "/game" + "/\(gameID)/" + "gamemember",
                                            method: httpMethod.POST.rawValue,
                                            header: headerForJson,
                                            body: data) else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                competiton(.failure(error))
            }
//            
//            if let response = response as? HTTPURLResponse {
//                print(response.statusCode)
//            }
//                
            if let data = data {
                do {
                    let gameMember = try JSONDecoder().decode(GameMember.self, from: data)
                    competiton( .success(gameMember))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    //MARK: - Generate Request
    private func generateRequest(for action: String, method: String, header: [String: String]?, body: Data?) -> URLRequest? {
        guard let baseUrl = URL(string: hostPath) else {
            print("It will never heppend")
            return nil }
//        let url = baseUrl.appendingPathComponent(action) - данная запись не позволяет вставлять в строку вопросительный знак
//        print(url)

        guard let url = URL(string: baseUrl.absoluteString + action) else {
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
    
    private func generateRequestWithTwoHeaders(for action: String, method: String, body: Data?, token: String?) -> URLRequest? {
        guard let baseUrl = URL(string: hostPath) else {
            print("It will never heppend")
            return nil }
        let url = baseUrl.appendingPathComponent(action)
   
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("Application/json", forHTTPHeaderField: "Accept")
        }
        if let body = body {
            request.httpBody = body
        }
        return request
    }
}
