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
    
    
}
