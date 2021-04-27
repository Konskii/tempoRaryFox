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
    private let club = "club"
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
    
    func getClub(for account: String, clubId: Int, completion: @escaping (Result<Club, Error>) -> Void) {
        
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        headerForJosn["Authorization"] = "Bearer \(token)"
                guard let request = generateRequest(for: "club/" + "\(clubId)",
                                                    method: httpMethod.GET.rawValue,
                                                    header: headerForJosn,
                                                    body: nil) else { return }
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let club = try JSONDecoder().decode(Club.self, from: data)
                    completion(.success(club))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getAllClubs(for account: String, completion: @escaping (Result<ClubsModel, Error>) -> Void) {
        
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        print(token)
        headerForJosn["Authorization"] = "Bearer \(token)"
        //        guard let request = generateRequest(for: "club?include=city",
        //                                            method: httpMethod.GET.rawValue,
        //                                            header: headerForJosn,
        //                                            body: nil) else { return }
        
        guard let request = generateRequestWithInclude(for: "http://213.159.209.245/api/club?include=city",
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
        let urlString = "http://213.159.209.245/api/club/\(id)/review?include=user"
        guard let request = generateRequestWithInclude(for: urlString,
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
    
    func postReview(for account: String, clubId id: Int, review: PostReview, completion: @escaping (Result<Review, Error>) -> Void) {
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        headerForJosn["Authorization"] = "Bearer \(token)"
        let body = try? JSONEncoder().encode(review)
        
        guard let request = generateRequest(for: club + "/\(id)" + self.review,
                                            method: httpMethod.POST.rawValue,
                                            header: headerForJosn,
                                            body: body) else { return }
        session.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let review = try JSONDecoder().decode(Review.self, from: data)
                    completion(.success(review))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getLikedClubs(for account: String, completion: @escaping (Result<LikedClubsModel, Error>) -> Void) {
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        headerForJosn["Authorization"] = "Bearer \(token)"
        guard let request = generateRequestWithInclude(for: "http://213.159.209.245/api/clublike?include=club",
                                                       method: httpMethod.GET.rawValue,
                                                       header: headerForJosn,
                                                       body: nil) else { return }
        session.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let likedClubs = try JSONDecoder().decode(LikedClubsModel.self, from: data)
                    completion(.success(likedClubs))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func deleteClubLike(for account: String, likeId: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        headerForJosn["Authorization"] = "Bearer \(token)"
        guard let request = generateRequestWithInclude(for: "http://213.159.209.245/api/clublike/\(likeId)",
                                                       method: httpMethod.DELETE.rawValue,
                                                       header: headerForJosn,
                                                       body: nil) else { return }
        
        session.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse {
                completion(.success(response.statusCode))
            }
        }.resume()
    }
    
    func addLikeToClub(for account: String, clubId: Int, userId:Int,completion: @escaping (Result<CreateClubLikeModel, Error>) -> Void) {
        
        struct Body:Codable {
            var users: [UId]
            struct UId: Codable {
                var id: Int
            }
        }
        let body = Body(users: [Body.UId(id:userId )])
        let bodyData = try? JSONEncoder().encode(body)
        
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
        headerForJosn["Authorization"] = "Bearer \(token)"
        guard let request = generateRequestWithInclude(for: "http://213.159.209.245/api/club/\(clubId)/clublike",
                                                       method: httpMethod.POST.rawValue,
                                                       header: headerForJosn,
                                                       body: bodyData) else { return }
        
        session.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let likedClubs = try JSONDecoder().decode(CreateClubLikeModel.self, from: data)
                    completion(.success(likedClubs))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
//    func getClubReviews(for account: String, clubId: Int, completion: @escaping (Result<[Reviews], Error>) -> Void) {
//        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
//        headerForJosn["Authorization"] = "Bearer \(token)"
//        guard let request = generateRequestWithInclude(for: "http://213.159.209.245/api/club/\(clubId)/review",
//                                                       method: httpMethod.GET.rawValue,
//                                                       header: headerForJosn,
//                                                       body: nil) else { return }
//        session.dataTask(with: request) { (data, _, error) in
//            if let error = error {
//                completion(.failure(error))
//            }
//            if let data = data {
//                do {
//                    let result =  try JSONDecoder().decode(ReviewsModel.self, from: data)
//
//                } catch let error {
//                    print(error.localizedDescription)
//                }
//            }
//        }.resume()
//
//    }
    
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
