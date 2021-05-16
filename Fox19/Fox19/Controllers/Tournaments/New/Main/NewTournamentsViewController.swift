//
//  NewTournamentsViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 14.05.2021.
//

import UIKit

class NewTournamentsViewController: UIViewController {
    
    private var tournaments: [Tournament] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
                print("""
                    updated
                    \(self.tournaments)
                    """
                    )
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame, style: .grouped)
        view.separatorStyle = .none
        view.register(NewTournamentTableViewCell.self, forCellReuseIdentifier: NewTournamentTableViewCell.reusedId)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        return view
    }()
    
    private func getAllTournaments() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        TournamentsNetworkManager.shared.getAllChampionships(for: number) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let tournaments = response.results else { return }
                self.tournaments = tournaments
            case .failure(let error):
                self.showAlert(title: "\(error)")
            }
        }
    }
    
    private func settingUpNavigationBar() {
        navigationItem.title = "Турниры"
        navigationController?.navigationBar.prefersLargeTitles = true
        let largeTitleAppearance = UINavigationBarAppearance()
        
        largeTitleAppearance.configureWithOpaqueBackground()
        largeTitleAppearance.backgroundImage = UIImage(named: "Rectangle")
        largeTitleAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        largeTitleAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Inter-Regular", size: 33) ?? UIFont.systemFont(ofSize: 30, weight: .light)
        ]
        navigationController?.navigationBar.standardAppearance = largeTitleAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = largeTitleAppearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllTournaments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        settingUpNavigationBar()
    }
}

//MARK: UITableViewDataSource
extension NewTournamentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tournaments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTournamentTableViewCell.reusedId) as? NewTournamentTableViewCell else { fatalError() }
        guard let tournament = tournaments.getElement(index: indexPath.row), let name = tournament.name, let isoDate = tournament.date?.value else {
            print("another error")
            return cell }
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ssZ"
        print(formatter.date(from: isoDate))
        cell.setup(tournament: .init(name: name, date: isoDate))
        return cell
    }
}

//MARK: UITableViewDelegate
extension NewTournamentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
}
