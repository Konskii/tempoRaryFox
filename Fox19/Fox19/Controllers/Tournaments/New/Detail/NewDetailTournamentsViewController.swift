//
//  NewDetailTournamentsViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 16.05.2021.
//

import UIKit

class NewDetailTournamentsViewController: UIViewController {
    
    private var tournament: Tournament?
    
    private let networkManager = NewTournamentsNetworkManager()
    
    private let userNetworkManager = TestUserNetwrokManager()
    
    private lazy var backImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ClubTest")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let view = UIButton(type: .system)
        view.tintColor = .white
        view.setImage(UIImage(named: "BackArrow"), for: .normal)
        view.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private var descriptionHeight: CGFloat = 14 {
        willSet {
            tableView.reloadData()
        }
    }
    
    convenience init(tournament: Tournament) {
        self.init()
        self.tournament = tournament
        descriptionHeight = DynamicalLabelSize.height(text: tournament.description, font: UIFont(name: "Inter-Regular", size: 13)!, width: view.frame.width)
        tableView.reloadData()
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.separatorStyle = .singleLine
        view.register(NewDetailTableViewCell.self, forCellReuseIdentifier: NewDetailTableViewCell.reusedId)
        view.register(NewDetailTournamentHeader.self, forHeaderFooterViewReuseIdentifier: NewDetailTournamentHeader.reusedId)
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 16
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backImage)
        view.addSubview(tableView)
        view.addSubview(backButton)
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            backImage.heightAnchor.constraint(equalToConstant: 249),
            backImage.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            tableView.topAnchor.constraint(equalTo: backImage.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func joinButtonTapped() {
        guard let id = tournament?.id else { return }
        userNetworkManager.getCurrentUser() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.networkManager.joinTournament(tournamentId: id, userId: response.results!.first!.id!) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let response):
                        self.showAlert(title: "Заявка создана.", message: "Текущий статус: \(response.status)")
                        return
                    case .failure(let error):
                        self.showAlert(title: "\(error)")
                    }
                }
            case .failure(let error):
                self.showAlert(title: "\(error)")
            }
        }
    }
}

//MARK: UITableViewDataSource
extension NewDetailTournamentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewDetailTableViewCell.reusedId, for: indexPath) as? NewDetailTableViewCell else { fatalError() }
        guard let tournament = tournament else { return cell }
        cell.setup(tournament: tournament, type: .allCases[indexPath.row])
        return cell
    }
}

//MARK: UITableViewDelegate
extension NewDetailTournamentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        58
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewDetailTournamentHeader.reusedId) as? NewDetailTournamentHeader else { return nil }
        header.configure(tournament: tournament!)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 242/255, green: 122/255, blue: 42/255, alpha: 1)
        button.layer.cornerRadius = 14
        button.setTitle("Участвовать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        footer.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 48),
            button.widthAnchor.constraint(equalToConstant: 278),
        ])
        button.translatesAutoresizingMaskIntoConstraints = false
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 154 + descriptionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        62
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
}
