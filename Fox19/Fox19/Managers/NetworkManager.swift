//
//  NetworkManager.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 01.11.2020.
//

import Foundation

class NetworkManager {
    private let hostPath = "http://213.159.209.245/api"
    private let smsCode = "/sms"
    private let user = "/user"
    private var headerForJosn = ["Content-Type":"application/json"]
    
    
    let session = URLSession.shared
    private enum httpMethod: String {
        case POST
        case GET
        case PUT
    }
    
    private enum Errors: Error {
        case data
        case parse
    }
    
    static var shared = NetworkManager()
    private init() {}
    
    
    func getCodeForVarification(witn number: String, completion: @escaping (Result<AuthenticationModel, Error>) -> Void) {
        
        let data = ["phone": number]
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        guard let request = generateRequest(for: smsCode,
                                            method: httpMethod.POST.rawValue,
                                            header: headerForJosn,
                                            body: jsonData) else { return }
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 ,let data = data {
                do {
                    let dataSms =  try JSONDecoder().decode(AuthenticationModel.self, from: data)
                    print(dataSms)
                    completion(.success(dataSms))
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
        }.resume()
        
    }
    
    func sendSmsCode(with codeModel: AuthenticationModel, smscode: String, completion: @escaping (Result<SMSResponse, Error>) -> Void) {
        print(codeModel)
        let data = ["code": smscode]
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        guard let request = generateRequest(for: smsCode + "/\(codeModel.id)",
                                            method: httpMethod.PUT.rawValue,
                                            header: headerForJosn,
                                            body: jsonData) else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let token = response.allHeaderFields["X-Authenticate"] as? String {
                    _ = Keychainmanager.shared.saveToken(token: token, account: codeModel.phone)
                    if let data = data {
                        guard let userData = try? JSONDecoder().decode(SMSResponse.self, from: data) else { return }
                        completion(.success(userData))
                    }
                }
            } else {
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode) }
            }
            
            //            //CurrentUserId
            //            guard let data = data else { completion(.failure(Errors.data)); return }
            //            guard let parsed = try? JSONDecoder().decode(SMSResponse.self, from: data) else { completion(.failure(Errors.parse)); return }
            //            UserDefaults.standard.set(parsed.user.id, forKey: "currentUserId")
            
        }.resume()
    }
    
    public func putUser(id: Int, name: String, token: String, completion: @escaping (Result<Int, Error>) -> Void) {
        headerForJosn["Authorization"] = "Bearer \(token)"
        headerForJosn["Content-Type"] = "application/x-www-form-urlencoded"
        
        let body = "name=\(name)"
        guard let request = generateRequest(for: user + "/\(id)",
                                            method: httpMethod.PUT.rawValue,
                                            header: headerForJosn,
                                            body: body.data(using: .utf8)) else { return }
        
        session.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse {
                completion(.success(response.statusCode))
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
