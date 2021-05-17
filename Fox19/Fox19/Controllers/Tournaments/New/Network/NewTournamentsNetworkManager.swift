//
//  NewTournamentsNetworkManager.swift
//  Fox19
//
//  Created by Артём Скрипкин on 14.05.2021.
//

import UIKit

class NewTournamentsNetworkManager: UniversalNetwokManager {
    func getAllTournaments(completion: @escaping (Result<TournamentsModel, Error>) -> Void) {
        guard let url = getUrl(forPath: TournamentsNetworkPaths.championship) else { return }
        let request = getRequest(url: url, method: .GET)
        dataTask(request: request, completion: completion)
    }
    
    func getTournament(tournamentId Id: Int, completion: @escaping (Result<Tournament, Error>) -> Void) {
        guard let url = getUrl(forPath: TournamentsNetworkPaths.championship + "/\(Id)") else { return }
        let request = getRequest(url: url, method: .GET)
        dataTask(request: request, completion: completion)
    }
    
    func getChampionshipMembers(tournamentId Id: Int, completion: @escaping (Result<ChampioshipmembersModel, Error>) -> Void) {
        guard let url = getUrl(forPath: TournamentsNetworkPaths.championship + "\(Id)" + "\(TournamentsNetworkPaths.championshipMember)") else { return }
        let request = getRequest(url: url, method: .GET)
        dataTask(request: request, completion: completion)
    }
    
    func joinTournament(tournamentId id: Int, userId: Int, completion: @escaping (Result<TournamentJoinModel, Error>) -> Void) {
        guard let body = try? JSONEncoder().encode(TournamentJoinModel(status: "New", user: UserID(id: userId), championship: UserID(id: id))) else { return }
        guard let url = getUrl(forPath: TournamentsNetworkPaths.championship + "/\(id)" + TournamentsNetworkPaths.championshipMember) else { return }
        let request = getRequest(url: url, method: .POST, body: body)
        dataTask(request: request, completion: completion)
    }
}
