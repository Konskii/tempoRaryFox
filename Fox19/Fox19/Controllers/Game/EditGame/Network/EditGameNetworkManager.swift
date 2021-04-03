//
//  EditGameNetworkManager.swift
//  Fox19
//
//  Created by Артём Скрипкин on 26.11.2020.
//

import Foundation
class EditGameNetworkManager {
    
    private let mainHostPath = "http://213.159.209.245"
    private let hostPath = "http://213.159.209.245/api"
    private let game = "/game"
    private let gamemember = "/gamemember"
    private var headerForJson = ["Content-Type":"application/json"]
    private let defaultHeaders: [String: String] = [
        "accept": "application/json"
    ]
    
    private let user = "/user"
    
    private enum httpMethod: String {
        case POST
        case GET
        case PUT
        case DELETE
    }
    
    private enum Errors: Error {
        case body
        case gameId
        case response
        case request
        case data
        case parse
        case result
        case gettingUser
        case json
        case statusCode(Int)
    }
    
    static var shared = EditGameNetworkManager()
    private init() {}
    
    public func updateGame(token: String, game: EditGameUpdateModel, gameId: Int, completion: @escaping (Result<UpdatedGameModel, Error>) -> Void ) {
        guard var request = createPutGameRequest(id: gameId) else { return }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        var body = "date=\(game.date)"
        body.append("&time=\(game.time)")
        body.append("&club=\(game.club)")
        body.append("&description=\(game.description)")
        body.append("&holes=\(game.holes)")
        body.append("&memberPrice=\(game.memberPrice)")
        body.append("&guestPrice=\(game.guestPrice)")
        body.append("&gamersCount=\(game.gamersCount)")
        request.httpBody = body.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
              //  print(response)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard response.statusCode == 200 else { completion(.failure(Errors.statusCode(response.statusCode))); print(response); return }
                guard let data = data else { completion(.failure(Errors.data)); return }
                print(try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])
                guard let parsedGame = try? JSONDecoder().decode(UpdatedGameModel.self, from: data) else { completion(.failure(Errors.parse)); return }
                completion(.success(parsedGame))
            } else {
                completion(.failure(Errors.response))
            }
        }.resume()
    }
    
    private func createPutGameRequest(id: Int) -> URLRequest? {
        guard var baseURL = URL(string: hostPath) else { return nil }
        baseURL.appendPathComponent("/game")
        baseURL.appendPathComponent("/\(id)")
        var request = URLRequest(url: baseURL)
        var head = defaultHeaders
        head["Content-Type"] = "application/x-www-form-urlencoded"
        request.allHTTPHeaderFields = head
        request.httpMethod = httpMethod.PUT.rawValue
        return request
    }
    
    public func declineMember(token: String, gameId: Int, memberId: Int, completion: @escaping (Result<GameMember, Error>) -> Void) {
        guard var request = createPutAcceptDeclineMemberRequest(gameId: gameId, memberId: memberId) else { return }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body = "id=\(memberId)&status=Declined"
        request.httpBody = body.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard response.statusCode == 200 else { completion(.failure(Errors.statusCode(response.statusCode))); print(response); return }
                guard let data = data else { completion(.failure(Errors.data)); return }
                
                guard let parsedMember = try? JSONDecoder().decode(GameMember.self, from: data) else { completion(.failure(Errors.parse)); return }
                completion(.success(parsedMember))
            } else {
                completion(.failure(Errors.response))
            }
        }.resume()
    }
    
    public func acceptMember(token: String, gameId: Int, memberId: Int, completion: @escaping (Result<UpdatedGameModel, Error>) -> Void) {
        guard var request = createPutAcceptDeclineMemberRequest(gameId: gameId, memberId: memberId) else { return }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body = "id=\(memberId)&status=Accepted"
        request.httpBody = body.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard response.statusCode == 200 else { completion(.failure(Errors.statusCode(response.statusCode))); print(response); return }
                guard let data = data else { completion(.failure(Errors.data)); return }
                guard let parsedMember = try? JSONDecoder().decode(UpdatedGameModel.self, from: data) else { completion(.failure(Errors.parse)); return }
                completion(.success(parsedMember))
            } else {
                completion(.failure(Errors.response))
            }
        }.resume()
    }
    
    private func createPutAcceptDeclineMemberRequest(gameId: Int, memberId: Int) -> URLRequest? {
        guard var baseURL = URL(string: hostPath) else { return nil }
        baseURL.appendPathComponent("/game")
        baseURL.appendPathComponent("/\(gameId)")
        baseURL.appendPathComponent("/gamemember")
        baseURL.appendPathComponent("/\(memberId)")
        var request = URLRequest(url: baseURL)
        var head = defaultHeaders
        head["Content-Type"] = "application/x-www-form-urlencoded"
        request.allHTTPHeaderFields = head
        request.httpMethod = httpMethod.PUT.rawValue
        return request
    }
}
