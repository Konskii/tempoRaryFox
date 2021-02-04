////
////  OneGameViewController.swift
////  Fox19
////
////  Created by Калинин Артем Валериевич on 31.10.2020.
////
//
//import UIKit
//
//class DetailView: UIViewController {
//    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        hidesBottomBarWhenPushed = true
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private var tableView = UITableView()
//    private var organaizerLabel = UILabel()
//    private var membersLable = UILabel()
//    private var footerView = UIView()
//    private var addButton = UIButton(type: .system)
//    private var deleteButton = UIButton(type: .system)
//    private var shareButton = UIButton(type: .system)
//    private var thirdSeparatop = UIView()
//    
//    var game: Game?
//    var clubs: ClubsModel?
//    var users = [User]()
//    var organaizer: User?
//    var currentUser: User?
//    var canAddCount = 0
//    
//    
//    //MARK: - Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = "ИГРА"
//        setupPlayers() //1
//        findCurrentUser()
//        setBarItems()
//        tableView = UITableView(frame: view.bounds, style: .grouped)
//        tableView.register(PlayersCell.self, forCellReuseIdentifier: PlayersCell.identifire)
//        tableView.register(CanAddCell.self, forCellReuseIdentifier: CanAddCell.identifire)//<---
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.backgroundColor = .white
//        tableView.separatorStyle = .none
//        view.addSubview(tableView)
//        setupFooter()
//    }
//    
//    private func findCurrentUser() {
//        
//        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
//        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
//        
//        UserNetworkManager.shared.getUser(id: nil, token: token) { (result) in
//            switch result {
//            case .success(let currentUser):
//                self.currentUser = currentUser
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        guard let game = game else {return}
//        
////        GamesNetworkManager.shared.getMembers(gameID: game.id ?? 0) { [weak self] (result) in
////            guard let self = self else {return}
////            switch result {
////            case .success(let members):
////                self.canAddCount = game.gamersCount! - members.results.count
////                for member in members.results {
////                    UserNetworkManager.shared.getUser(id: game.user.id, token: token) { [weak self] (result) in
////                        guard let self = self else {return}
////                        switch result {
////                        case .success(let organaizer):
////                            self.organaizer = organaizer
////                        case .failure(let error):
////                            print(error.localizedDescription)
////                        }
////                    }
////                }
////            case .failure(let error):
////                print(error.localizedDescription)
////            }
////        }
//    }
//    
//    ///Проверяем текущего пользователя
//    private func checkCurrentUserInGame() {
//        
//        guard self.canAddCount !=  0 else {
//            self.addButton.isHidden = true
//            self.tableView.reloadData()
//            return
//        }
//        
//        if currentUser?.id == game?.user.id {
//            self.addButton.isHidden = true
//            self.tableView.reloadData()
//        } else {
//            self.addButton.isHidden = false
//            self.tableView.reloadData()
//        }
//        
//        for user in self.users {
//            if user.id == currentUser?.id {
//                self.addButton.isHidden = true
//                self.deleteButton.isHidden = false
//                self.tableView.reloadData()
//            } else {
//                self.addButton.isHidden = false
//                self.deleteButton.isHidden = true
//                self.tableView.reloadData()
//            }
//        }
//    }
//    
//    //MARK: - Setup Footer
//    private func setupFooter() {
//        footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 190))
//        footerView.backgroundColor = .white
//        tableView.tableFooterView = footerView
//        
//        let shareImage = UIImage(named: "shareButton")?.withRenderingMode(.alwaysOriginal)
//        shareButton.setImage(shareImage, for: .normal)
//        shareButton.tintColor = .black
//        shareButton.translatesAutoresizingMaskIntoConstraints = false
//        shareButton.addTarget(self, action: #selector(pressShareButton(button:)), for: .touchUpInside)
//        
//        let image = UIImage(named: "addButtonInGameDetail")?.withRenderingMode(.alwaysOriginal)
//        addButton.setImage(image, for: .normal)
//        addButton.tintColor = .black
//        addButton.translatesAutoresizingMaskIntoConstraints = false
//        addButton.addTarget(self, action: #selector(pressAddGameButton(button:)), for: .touchUpInside)
//        
//        deleteButton.setImage(nil, for: .normal)
//        deleteButton.isHidden = true
//        deleteButton.setTitle("Покинуть игру", for: .normal)
//        deleteButton.tintColor = .red
//        deleteButton.addTarget(self, action: #selector(self.deleteUser(button:)), for: .touchUpInside)
//        deleteButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        footerView.addSubview(addButton)
//        footerView.addSubview(shareButton)
//        footerView.addSubview(deleteButton)
//        
//        let constraints = [
//            shareButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0),
//            shareButton.bottomAnchor.constraint(equalTo: footerView.centerYAnchor, constant: -15),
//            addButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0),
//            addButton.topAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 15),
//            deleteButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0),
//            deleteButton.topAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 15),
//        ]
//        NSLayoutConstraint.activate(constraints)
//    }
//    
//    @objc func pressShareButton(button: UIButton) {
//        print("Share")
//        shareFunction()
//    }
//    
//    @objc func pressAddGameButton(button: UIButton) {
//        guard let gameID = game?.id else { return }
//        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
//        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
//        
//        let group = DispatchGroup()
//        group.enter()
//        
//        UserNetworkManager.shared.getUser(id: nil, token: token) { [weak self] (result) in
//            guard let self = self else {return}
//            switch result {
//            case .success(let currentUser):
//                GamesNetworkManager.shared.addToGame(gameID: gameID, userID: currentUser.id ?? 0) { (result) in
//                    
//                    switch result {
//                    case .success(let user):
//                        print(user.results.count)
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//            group.leave()
//        }
//        
//        
//        group.wait()
//        
//        DispatchQueue.main.async {
//            self.alertMessage(title: "Вы присоединились к игре", message: "")
//            self.addButton.isHidden = true
//            ///Подумать над обновлением
////            self.users.removeAll()
////            self.setupPlayers()
//        }
//    }
//    
//    private func setupPlayers() {
//        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
//        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
//        
//        guard let game = game else {return}
//        GamesNetworkManager.shared.getMembers(gameID: game.id ?? 0) { [weak self] (result) in
//            guard let self = self else {return}
////            switch result {
////            case .success(let members):
////                //                if !(members.results?.isEmpty) {
//////                    for member in members.results {
//////                        guard let memberID = member.user?.id else {return}
//////                        UserNetworkManager.shared.getUser(id: memberID, token: token) { (result) in
//////                            switch result {
//////                            case .success(let user):
//////                                if user.id ?? 0 != game.user.id {
//////                                    self.users.append(user)
//////                                }
//////                                DispatchQueue.main.async {
//////                                    self.checkCurrentUserInGame()
//////                                    self.tableView.reloadData()
//////                                }
//////                            case .failure(let error):
//////                                print(error.localizedDescription)
//////                            }
//////                        }
//////                        self.getOrganaizer(game: game, token: token)
//////                    }
//////                } else {
////                    self.getOrganaizer(game: game, token: token)
////                }
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    ///Находим организатора игры
//    private func getOrganaizer(game: Game, token: String) {
//        UserNetworkManager.shared.getUser(id: game.user.id, token: token) { (result) in
//            switch result {
//            case .success(let organaizer):
//                self.organaizer = organaizer
//                DispatchQueue.main.async {
//                    self.checkCurrentUserInGame()
//                    self.tableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    
//    /// Удаляем игрока из игры
//    @objc func deleteUser(button: UIButton) {
//        
//        
//        guard let game = game else {return}
//        GamesNetworkManager.shared.getMembers(gameID: game.id ?? 0) { [weak self] (result) in
//            guard let self = self else {return}
//            switch result {
//            case .success(let members):
//                DispatchQueue.main.async {
//                    self.deleteFromeGameMessage()
//                    self.deleteButton.isHidden = true
//                    ///Подумать над обновлением
//                    //                    self.users.removeAll()
//                    //                    self.setupPlayers()
//                }
////                for member in members.results {
////                    if self.currentUser?.id == member.user?.id {
////                        GamesNetworkManager.shared.deleteFromGame(gameID: game.id ?? 0, gameMemberID: member.id) { (result) in}
////
////                    }
////                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    
//    func setBarItems() {
//        //Правая кнопка
//        let filtersButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filters"), style: .plain, target: self, action: #selector(showFilter))
//        filtersButton.tintColor = #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1)
//        self.navigationItem.rightBarButtonItem = filtersButton
//    }
//    
//    @objc func showFilter() {
//        print("Нажали на Фильтры")
//    }
//    
//    //MARK: - Second Header
//    private func setupSecont(header: UIView) {
//        organaizerLabel.text = "Участники"
//        organaizerLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        organaizerLabel.font = UIFont(name: "Avenir-Medium", size: 15)
//        organaizerLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        thirdSeparatop.backgroundColor = UIColor(red: 0.918, green: 0.925, blue: 0.937, alpha: 1)
//        thirdSeparatop.translatesAutoresizingMaskIntoConstraints = false
//        
//        header.addSubview(organaizerLabel)
//        header.addSubview(thirdSeparatop)
//        
//        let constraints = [
//            thirdSeparatop.topAnchor.constraint(equalTo: organaizerLabel.topAnchor, constant: -20),
//            thirdSeparatop.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 0),
//            thirdSeparatop.trailingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.trailingAnchor, constant: 0),
//            thirdSeparatop.heightAnchor.constraint(equalToConstant: 1),
//            
//            organaizerLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: 0),
//            organaizerLabel.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//        ]
//        
//        NSLayoutConstraint.activate(constraints)
//    }
//    
//    
//    
//    private func alertMessage(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
//    
//    private func deleteFromeGameMessage() {
//        let alert = UIAlertController(title: "Вы покинули игру", message: "", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
//    
//    //MARK: - Share
//    private func shareFunction() {
//        //        let image = photo
//        let text = "Какое-то описание. Возможно ссылка на сайт. Возможно ссылка на приложение в AppStore"
//        let ac:UIActivityViewController = UIActivityViewController(activityItems:  [text], applicationActivities: nil)
//        ac.excludedActivityTypes = [.print,
//                                    .postToWeibo,
//                                    .copyToPasteboard,
//                                    .addToReadingList,
//                                    .postToVimeo,
//                                    .postToFacebook]
//        self.present(ac, animated: true, completion: nil)
//    }
//}
//
////MARK: - Extension
//
//extension DetailView: UITableViewDelegate, UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        } else if section == 1 {
//            return users.count
//        } else {
//            return canAddCount - 1
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            let testHeader = Header(game: game, clubs: clubs)
//            let heigh = testHeader.setupDescription(controllerWidth: view.frame.width, game: game!)
//            let header = UIView()
//            header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: heigh)
//            header.backgroundColor = .white
//            
//            testHeader.setupFirst(header: header)
//            return header
//        } else if section == 1 {
//            let secondHeader = UIView()
//            secondHeader.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 15)
//            secondHeader.backgroundColor = .white
//            setupSecont(header: secondHeader)
//            return secondHeader
//        }
//        let label = UILabel()
//        label.text = ""
//        return label
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            let testHeader = Header(game: game, clubs: clubs)
//            let heigh = testHeader.setupDescription(controllerWidth: view.frame.width, game: game!)
//            return heigh
//        } else if section == 1 {
//            return 15
//        } else if section == 2 {
//            return 0
//        }
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if indexPath.section == 0 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayersCell.identifire) as? PlayersCell else { return UITableViewCell() }
//            cell.backgroundColor = .white
//            cell.selectionStyle = .none
//            cell.setupOrganizer(with: organaizer)
//            return cell
//        } else if indexPath.section == 1 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayersCell.identifire) as? PlayersCell else { return UITableViewCell() }
//            let player = users[indexPath.row]
//            cell.setupPlayer(with: player)
//            cell.selectionStyle = .none
//            cell.backgroundColor = .white
//            return cell
//        } else {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: CanAddCell.identifire, for: indexPath) as? CanAddCell else {return UITableViewCell()}
//            cell.canAdd()
//            cell.selectionStyle = .none
//            cell.backgroundColor = .white
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
//    
//}
