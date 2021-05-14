//
//  MyGamesViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 22.11.2020.
//
import UIKit
class MyGamesViewController: UIViewController {
    
    //MARK: - Variables
    ///Массив с играми пользователя
    private var games: [Game] = []
    
    ///Id текущего пользователя
    private var currentId: Int?
    
    //MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    //MARK: - Methods
    private func configureNavigationBar() {
        let view = UILabel()
        view.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "МОИ ИГРЫ"
        navigationItem.titleView = view
        
        navigationItem.setRightBarButton(.init(title: "Изменить", style: .done, target: self, action: #selector(editPressed)), animated: true)
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "backButton"), style: .done, target: self, action: #selector(backButtonPressed)), animated: true)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "orange")
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "orange")
    }
    
    ///Метод получает игры пользователя(в которых он организатор)
    private func getUserGames(completion: @escaping () -> Void) {
        guard let currentId = currentId else { errorAlertMessage(message: "Ошибка id пользователя/n\(String(describing: self.currentId))"); return }
        GamesNetworkManager.shared.getGames() { (result) in
            switch result {
            case .failure(let error):
                self.errorAlertMessage(message: "\(error)")
            case .success(let games):
                var userGames: [Game] = []
//                for game in games.results {
//                    guard let id = game.user.id else {  self.errorAlertMessage(message: "Ошибка id игры \(String(describing: game.id))"); return }
//                    if id == currentId { userGames.append(game) }
//                }
                self.games = userGames
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }
    
    ///Показывает алерт с ошибкой
    ///Метод асинхронный.
    private func errorAlertMessage(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Возникла ошибка", message: "Код ошибки: \(message)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    ///Показывает алерт об успехе
    ///Метод асинхронный.
    private func successAlertMessage(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Успешно", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - User Interaction Methods
    @objc private func backButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func editPressed() {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem?.title = "Изменить"
        } else {
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem?.title = "Готово"
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserGames() { }
    }
    
    //MARK: - Inits
    
    convenience init(userId currentId: Int) {
        self.init()
        overrideUserInterfaceStyle = .light
        self.currentId = currentId
        getUserGames() { }
    }
}

//MARK: - UITableViewDataSource
extension MyGamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if games.isEmpty { return 0 }
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if games.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "EmptyCell")
            cell.textLabel?.text = "У вас нет игр"
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "GamesCell")
            cell.textLabel?.text = games[indexPath.row].title
            cell.detailTextLabel?.text = games[indexPath.row].description
            return cell
        }
    }
}

//MARK: - UITableViewDelegate
extension MyGamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let gameMembersCount = games[indexPath.row].gamersCount else { errorAlertMessage(message: "gameMembersCount"); return }
        guard let gameId = games[indexPath.row].id else { errorAlertMessage(message: "gameId"); return }
        let vc = EditGameViewController(gameId: gameId, gameMembersCount: gameMembersCount, game: games[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard !games.isEmpty else { return }
            guard let account = UserDefaults.standard.string(forKey: "number") else { errorAlertMessage(message: "account error"); return }
            guard let token = Keychainmanager.shared.getToken(account: account) else { errorAlertMessage(message: "token error"); return }
            guard let gameId = games[indexPath.row].id else { errorAlertMessage(message: "gameId"); return }
            
            MyGamesNetworkManager.shared.deleteGame(gameId: gameId, token: token) { (result) in
                switch result {
                case .failure(let error):
                    self.errorAlertMessage(message: "\(error)")
                case .success(let game):
                    self.successAlertMessage(message: "Игра \(game.title ?? "") успешно удалена!")
                    self.getUserGames() {
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }
                }
            }
        }
    }
}
