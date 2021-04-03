//
//  ChatNetworkManager.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 28.01.2021.
//

import UIKit

class ChatNetworkManager {
    
//    private let mainHostPath = "http://213.159.209.245"
   private let hostPath = "http://213.159.209.245/api"
//    private let game = "/game?include=club,user"
//    private let gamemember = "/gamemember?include=user"
    
  //  http://213.159.209.245/api/chat/12/chatmessage
    private let chat = "http://213.159.209.245/api/chat/"
    private var headerForJson = ["Content-Type":"application/json"]
    private let chats = "http://213.159.209.245/api/chat?include=users"
    private let user = "/user"
    static var shared = ChatNetworkManager()
    private init() {}
    
    private enum httpMethod: String {
        case POST
        case GET
        case PUT
        case DELETE
    }
    
    func getAllMyChats(token: String, competiton: @escaping (Result<MyChats, Error>) -> Void) {
        headerForJson["Authorization"] = "Bearer \(token)"
        guard let request = generateRequest(for: chats,
                                            method: httpMethod.GET.rawValue,
                                            header: headerForJson,
                                            body: nil) else { return }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                competiton(.failure(error))
            }
          
            if let data = data {
                do {
                    let chats = try JSONDecoder().decode(MyChats.self, from: data)
                    competiton(.success(chats))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
        
    }
    
    func getChatWithFriend(token: String, friendId: Int, competiton: @escaping (Result<Int, Error>) -> Void) {
        headerForJson["Authorization"] = "Bearer \(token)"
        
        struct Body:Codable {
            var users: [UId]
            struct UId: Codable {
                var id: Int
            }
        }
        let body = Body(users: [Body.UId(id: friendId)])
        let bodyData = try? JSONEncoder().encode(body)
        guard let request = generateRequest(for: chat,
                                            method: httpMethod.POST.rawValue,
                                            header: headerForJson,
                                            body: bodyData) else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                competiton(.failure(error))
            }
            
            if let data = data {
                do {
                    let chat =  try JSONDecoder().decode(MChat.self, from: data)
                    competiton(.success(chat.id ?? 0))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getAllMessagesWithFriend(token: String, chatId: Int, competiton: @escaping (Result<ChatMessage, Error>) -> Void) {
        headerForJson["Authorization"] = "Bearer \(token)"
        guard let request = generateRequest(for: hostPath + "/chat/\(chatId)/chatmessage",
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
                    let chats =  try JSONDecoder().decode(ChatMessage.self, from: data)
                    competiton(.success(chats))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
        
    }
    
    func createNewMessage(token: String, chatId: Int, text: String, competiton: @escaping (Result<ChatMessage.Result, Error>) -> Void) {
        headerForJson["Authorization"] = "Bearer \(token)"
        struct TextMessage:Codable {
            let text: String
        }
        let body = TextMessage(text: text)
        let bodyData = try? JSONEncoder().encode(body)
        print(chatId)
        guard let request = generateRequest(for: hostPath + "/chat/\(chatId)/chatmessage",
                                            method: httpMethod.POST.rawValue,
                                            header: headerForJson,
                                            body: bodyData) else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                competiton(.failure(error))
            }
//
//            if let response = response as? HTTPURLResponse {
//                print(response.statusCode)
//            }
            
            if let data = data {
                do {
                    let message =  try JSONDecoder().decode(ChatMessage.Result.self, from: data)
                    print(message)
                    competiton(.success(message))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}


extension ChatNetworkManager {
    //MARK: - Generate Request
    private func generateRequest(for action: String, method: String, header: [String: String]?, body: Data?) -> URLRequest? {
        //        guard let baseUrl = URL(string: hostPath) else {
        //            print("It will never heppend")
        //            return nil }
        //        let url = baseUrl.appendingPathComponent(action) - данная запись не позволяет вставлять в строку вопросительный знак
        //        print(url)
        
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

//MARK: - WebSockets
