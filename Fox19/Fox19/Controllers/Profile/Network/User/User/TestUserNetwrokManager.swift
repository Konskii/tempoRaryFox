//
//  TestUserNetwrokManager.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 08.02.2021.
//
import UIKit

class TestUserNetwrokManager: UniversalNetwokManager {
    func getCurrentUser(completion: @escaping (Result<GetUserResponse, Error>) -> Void) {
        guard let url = getUrl(forPath: UserPaths.user) else { return }
        let request = getRequest(url: url, method: .GET)
        dataTask(request: request, completion: completion)
    }
    
    func getUser(id: Int, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = getUrl(forPath: UserPaths.user + "/\(id)") else { return }
        let request = getRequest(url: url, method: .GET)
        dataTask(request: request, completion: completion)
    }
    
    func downloadImage(pathToImage path: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = getUrl(forPath: path) else { return }
        downloadImage(url: url, completion: completion)
    }
    
    func updateUserAvatar(id: Int, avatar: UIImage, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = getUrl(forPath: UserPaths.user + "/\(id)") else { return }
        guard let compressedImage = avatar.compressTo(10) else { return }
        guard let compressedImageString = compressedImage.jpegData(compressionQuality: 1)?
                .base64EncodedString() else { return }
        let model = UserAvatarPutModel(avatar:
                                        AvatarModel(base64: compressedImageString,
                                                    filename: "avatar\(id)"))
        guard let body = try? JSONEncoder().encode(model) else { return }
        let request = getRequest(url: url, method: .PUT, body: body)
        dataTask(request: request, completion: completion)
    }
    
    func updateUser(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        guard let id = user.id else { return }
        guard let url = getUrl(forPath: UserPaths.user + "/\(id)") else { return }
        guard let body = try? JSONEncoder().encode(user) else { return }
        let request = getRequest(url: url, method: .PUT, body: body)
        dataTask(request: request, completion: completion)
    }

    func getMemberedClubs(userId: Int, completion: @escaping (Result<MemberedClubsModel, Error>) -> Void) {
        guard let url = getUrl(forPath: UserPaths.user + "/\(userId)" + UserPaths.memberedClubs, include: "club") else { return }
        let request = getRequest(url: url, method: .GET)
        dataTask(request: request, completion: completion)
    }
    
    func leaveClub(memberId: Int, completion: @escaping (Result<MemberedClubsModel, Error>) -> Void) {
        guard let url = getUrl(forPath: UserPaths.memberedClubsApi + "\(memberId)") else { return }
        let request = getRequest(url: url, method: .DELETE)
        dataTask(request: request, completion: completion)
    }
    
    func joinClub(userId: Int, clubId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = getUrl(forPath: UserPaths.user + "/\(userId)" + UserPaths.memberedClubs) else { return }
        guard let body = try? JSONEncoder().encode(JoinClubModel(club: clubId)) else { return }
        let request = getRequest(url: url, method: .POST, body: body)
        dataTask(request: request, completion: completion)
    }
}
