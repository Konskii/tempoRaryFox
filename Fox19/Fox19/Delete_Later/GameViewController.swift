////
////  PlayersViewController.swift
////  Fox19
////
////  Created by Калинин Артем Валериевич on 13.10.2020.
////
//
//import UIKit
//
//
//class GamesViewController: UIViewController, UIPopoverPresentationControllerDelegate {
//
//    private let titleColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
//    private var tableView = UITableView()
//    private var newGameButton = UIButton(type: .system)
//
//    var games: GameModel?
//    var countOfMembers = 0
//
//    //MARK: - Life Cycle
//    override func viewWillAppear(_ animated: Bool) {
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setBackBarButton()
//        gettingGames()
//        setBarItems()
//        setTableView()
//        setupTitleSettings()
//    }
//
//    //MARK: - Methods
//    private func gettingGames() {
//        GamesNetworkManager.shared.getGames { [weak self] (result) in
//            guard let self = self else {return}
//            switch result {
//            case .success(let arrayFromNetwork):
//                DispatchQueue.main.async {
//                    self.games = arrayFromNetwork
//                    self.tableView.reloadData()
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//    private func setBackBarButton() {
//        let image = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal)
//        self.navigationController?.navigationBar.backIndicatorImage = image
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//    }
//
//    //Устанавливаем настройки тайтла
//    private func setupTitleSettings() {
//        let attributesGray: [NSAttributedString.Key: Any] = [
//            .foregroundColor: titleColor,
//            .font: UIFont(name: "avenir", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
//        ]
//        navigationController?.navigationBar.barTintColor = .white
//        navigationController?.navigationBar.titleTextAttributes = attributesGray
//    }
//
//    //Устанавливаем Коллекция
//    private func setTableView() {
//        navigationItem.title = "ИГРЫ"
//        self.tableView = UITableView(frame: view.bounds, style: .plain)
//     //   tableView.register(GamesTableViewCell.self, forCellReuseIdentifier: GamesTableViewCell.identifire)
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.backgroundColor = .white
//        tableView.separatorStyle = .none
//        tableView.separatorColor = .white
//        view.addSubview(tableView)
//    }
//
//    private func setupHeaderOn(header: UIView) {
//        newGameButton.setTitle("Создать игру", for: .normal)
//        newGameButton.setTitleColor(UIColor(red: 0.278, green: 0.427, blue: 0.741, alpha: 1), for: .normal)
//        newGameButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
//        newGameButton.backgroundColor = .white
//        newGameButton.layer.cornerRadius = 8
//        newGameButton.layer.borderWidth = 2
//        newGameButton.layer.borderColor = UIColor(red: 0.278, green: 0.427, blue: 0.741, alpha: 1).cgColor
//        newGameButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
//        newGameButton.translatesAutoresizingMaskIntoConstraints = false
//
//        header.insertSubview(newGameButton, at: 0)
//
//        let constraints = [
//            newGameButton.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 17),
//            newGameButton.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -17),
//            newGameButton.centerYAnchor.constraint(equalTo: header.centerYAnchor , constant: 0),
//            newGameButton.centerXAnchor.constraint(equalTo: header.centerXAnchor , constant: 0),
//
//        ]
//
//        NSLayoutConstraint.activate(constraints)
//    }
//
//    @objc func buttonAction(_ sender:UIButton!) {
//        print("Создать игру")
//        let vc = GameCreateViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    //MARK: - Устанавливаем Вью Игрока
//
//    //Устанавливаем Коллекция
//    func setBarItems() {
//        //Левая кнопка
//        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "SearchNav"), style: .done, target: self, action: #selector(showSearching))
//        searchButton.tintColor = #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1)
//        self.navigationItem.leftItemsSupplementBackButton = true
//        self.navigationItem.leftBarButtonItem = searchButton
//        //Правая кнопка
//        let filtersButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filters"), style: .plain, target: self, action: #selector(showFilter))
//        filtersButton.tintColor = #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1)
//        self.navigationItem.rightBarButtonItem = filtersButton
//    }
//
//    //MARK: - Search
//    @objc func showSearching() {
//        print("Нажали на Поиск")
//    }
//
//    //MARK: - Filters
//    @objc func showFilter() {
//        print("Нажали на Фильтры")
//    }
//}
//
////MARK: - Extension
//extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        guard let game = games?.results else { return 0 }
////        return game.count
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: GamesTableViewCell.identifire, for: indexPath) as? GamesTableViewCell else {return UITableViewCell()}
//     //   guard let game = games?.results[indexPath.row] else {return UITableViewCell()}
////        cell.backgroundColor = .white
////        cell.selectionStyle = .none
////        cell.setupImage(with: game.club.id ?? 0)
////        cell.setup(game: game)
////        cell.setupPlayers(gameID: game.id ?? 0)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 281
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView()
//        header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 75)
//        header.backgroundColor = .white
//        setupHeaderOn(header: header)
//        return header
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 75
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let vc = DetailView()
//      //  vc.game = self.games?.results[indexPath.row]
//        DispatchQueue.main.async {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//
//    }
//}
