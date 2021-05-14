//
//  OldUserNetworkManager.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 28.02.2021.
//

import UIKit
class OldUserNetworkManager {
    private let defaultHeaders: [String: String] = [
        "accept": "application/json"
    ]
    private let hostPath = "http://213.159.209.245/api"
    private let userPath = "/user"
    
    private enum httpMethod: String {
        case GET
        case PUT
    }
    
    private enum Errors: Error {
        case response
        case request
        case data
        case parse
        case result
        case gettingUser
        case json
        case statusCode(Int)
        case imageUrl
        case dataToImage
    }
    
    private let sharedSession = URLSession.shared
    
    static var shared = OldUserNetworkManager()
    
    private init() { }
    
    //MARK: - Get User
    private func createGetUserRequest(id: Int?) -> URLRequest? {
        guard var baseURL = URL(string: hostPath) else { return nil }
        baseURL.appendPathComponent(userPath)
        
        if let userId = id {
            baseURL.appendPathComponent("/\(userId)")
        }
        
        var request = URLRequest(url: baseURL)
        request.allHTTPHeaderFields = defaultHeaders
        
        return request
    }
    
    /// - Parameter id: id пользователя которого нужно получить. Если хотите получить текущего пользователя - передавайте nil
    /// - Parameter token: токен доступа из кейчейна
    /// - Parameter completion: замыкание, в которое передается запрошенный пользотваель в случае успеха и ошибка в случае неудачи
    public func getUser(id: Int?, token: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard var request = createGetUserRequest(id: id) else { completion(.failure(Errors.request)); return }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        sharedSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard response.statusCode == 200 else { completion(.failure(Errors.statusCode(response.statusCode))); return }
                guard let data = data else { completion(.failure(Errors.data)); return }
                if id != nil {
                    guard let parsed = try? JSONDecoder().decode(User.self, from: data) else { completion(.failure(Errors.parse)); return }
                    completion(.success(parsed))
                } else {
                    guard let parsed = try? JSONDecoder().decode(GetUserResponse.self, from: data) else { completion(.failure(Errors.parse)); return }
                    guard let results = parsed.results else { completion(.failure(Errors.result)); return }
                    guard let user = results.first else { completion(.failure(Errors.gettingUser)); return }
                    completion(.success(user))
                }
            } else {
                completion(.failure(Errors.response))
            }
        }.resume()
    }
    
    //MARK: - Download User Avatar
    /// - Parameter token: токен доступа из кейчейна
    /// - Parameter id: id пользователя аватарку которого вы хотите получить, если требуется получить аватарку текущего пользователя - передайте nil(но можно и  его id)
    /// - Parameter completion: замыкание, в которое передается аватар пользователя или ошибка в случае неудачи
    public func downloadUserAvatar(token: String, id: Int?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        getUser(id: id, token: token) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let user):
                guard let pathToImage = user.avatar?.url else { completion(.failure(Errors.imageUrl)); return }
                guard var url = URL(string: "http://213.159.209.245") else { completion(.failure(Errors.imageUrl)); return }
                url.appendPathComponent(pathToImage)
                self.sharedSession.dataTask(with: url) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    guard let data = data else {
                        completion(.failure(Errors.data))
                        return
                    }
                    guard let image = UIImage(data: data) else {
                        completion(.failure(Errors.dataToImage))
                        return
                    }
                    completion(.success(image))
                }.resume()
            }
        }
    }
    
    //MARK: - Put User
    private func createPutUserRequest(id: Int) -> URLRequest? {
        guard var baseURL = URL(string: hostPath) else { return nil }
        baseURL.appendPathComponent(userPath)
        baseURL.appendPathComponent("/\(id)")
        var request = URLRequest(url: baseURL)
        var head = defaultHeaders
        head["Content-Type"] = "application/x-www-form-urlencoded"
        request.allHTTPHeaderFields = head
        request.httpMethod = httpMethod.PUT.rawValue
        return request
    }
    
    /// - Parameter id: id пользователя которого нужно обновить.
    /// - Parameter token: токен доступа из кейчейна
    /// - Parameter completion: замыкание, в которое передается обнолвенный пользотваель в случае успеха и ошибка в случае неудачи
    /// - Parameter golfRegistryIdRU: id в реестре гольфистов формата RUXXXXXX (из примеров в админке)
    public func putUser(id: Int, name: String?, about: String?, email: String?, golfRegistryIdRU: String?, token: String, isGamer: Bool?, isTrainer: Bool?, isReferee: Bool?, completion: @escaping (Result<User, Error>) -> Void) {
        guard var request = createPutUserRequest(id: id) else { completion(.failure(Errors.request)); return }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        var body = ""
        if let name = name {
            body.append("name=\(name)")
        }
        if let about = about {
            body.append("&about=\(about)")
        }
        if let email = email {
            body.append("&email=\(email)")
        }
        if let golfRegistryIdRU = golfRegistryIdRU {
            body.append("&golfRegistryIdRU=\(golfRegistryIdRU)")
        }
        if let isGamer = isGamer {
            body.append("&isGamer=\(isGamer)")
        }
        if let isTrainer = isTrainer {
            body.append("&isTrainer=\(isTrainer)")
        }
        if let isReferee = isReferee {
            body.append("&isReferee=\(isReferee)")
        }
        
        request.httpBody = body.data(using: .utf8)
        
        sharedSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard response.statusCode == 200 else { completion(.failure(Errors.statusCode(response.statusCode))); return }
                guard let data = data else { completion(.failure(Errors.data)); return }
                guard let parsed = try? JSONDecoder().decode(User.self, from: data) else { completion(.failure(Errors.parse)); return }
                completion(.success(parsed))
            } else {
                completion(.failure(Errors.response))
            }
        }.resume()
    }
    
    //MARK: - Put User Avatar
    private func createPutUserAvatarRequest(id: Int) -> URLRequest? {
        guard var baseURL = URL(string: hostPath) else { return nil }
        baseURL.appendPathComponent(userPath)
        baseURL.appendPathComponent("/\(id)")
        var request = URLRequest(url: baseURL)
        var head = defaultHeaders
        head["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = head
        request.httpMethod = httpMethod.PUT.rawValue
        return request
    }
    
    /// - Parameter token: токен доступа из кейчейна
    /// - Parameter id: id пользователя аватар которого нужно обновить
    /// - Parameter completion: замыкание, в которое передается обнолвенный пользотваель в случае успеха и ошибка в случае неудачи
    public func putUserAvatar(token: String, image: UIImage, id: Int, completion: @escaping (Result<User, Error>) -> Void) {
        guard var request = createPutUserAvatarRequest(id: id) else { completion(.failure(Errors.request)); return }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        guard let image64 = image.jpegData(compressionQuality: 0.5)?.base64EncodedString() else { return }
        guard let data = try? JSONEncoder().encode(UserAvatarPutModel(avatar: .init(base64: image64, filename: "try.png"))) else { return }
        request.httpBody = data
        
        sharedSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard response.statusCode == 200 else { completion(.failure(Errors.statusCode(response.statusCode))); return }
                guard let data = data else { completion(.failure(Errors.data)); return }
                guard let parsed = try? JSONDecoder().decode(User.self, from: data) else { completion(.failure(Errors.parse)); return }
                completion(.success(parsed))
                
            } else {
                completion(.failure(Errors.response))
            }
        }.resume()
    }
}

