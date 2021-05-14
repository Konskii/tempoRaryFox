//
//  DetailGameViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 18.01.2021.
//

import UIKit

class DetailGameViewController: UIViewController {
    
    private var topImageView = UIImageView()
    
    private let header = HeaderForDerailView()
    private var tableView: UITableView!
    
    private var game: GamesModel.Game? = nil
    private var gameMembers: GameMembers? = nil
    private var currentUser: User
    private let joinButton = UIButton(type: .system)
    
    init(user: User) {
        currentUser = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTopImage()
        setupTableView()
        
      //  setupNavigationBar()
        
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        guard let gameID = game?.id else { return }
        GamesNetworkManager.shared.getMembersTest(gameID: gameID, token: token) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.gameMembers = data
                   let isHave = data.results?.contains(where: { (member) -> Bool in
                    member.user?.id == self.currentUser.id
                    })

                    if self.gameMembers?.results?.count == self.game?.gamersCount {
                        self.joinButton.setTitle("Все месте заняты", for: .normal)
                        self.joinButton.isEnabled = false
                    }
                    
                    if isHave ?? false {
                        self.joinButton.setTitle("Вы в игре", for: .normal)
                        self.joinButton.isEnabled = false
                    }
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    func setupData(image: UIImage?, game:GamesModel.Game, avatarImage: UIImage?) {
        topImageView.image = image
        header.setupHeaderWithData(mainImage: image, game: game, creatorAvatar: avatarImage)
        self.game = game
    }
    
}

//MARK: - TableViewDelegate and TableViewDataSource
extension DetailGameViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
         let title = UILabel(frame: CGRect(x: 16, y: 0, width: 100, height: 30))
        
        title.font = UIFont(name: "Inter-Medium", size: 15)
        title.textColor = .black
        header.addSubview(title)
        if section == 2  {
            title.text = "Организатор"
        } else {
            title.text = "Учатсники"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 2:
            return 1
        case 0:
           // gameMembers?.results?.count ?? 0
            return game?.gamersCount ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard  let cell = tableView.dequeueReusableCell(withIdentifier: DitailGameTableViewCell.identifire, for: indexPath) as?
            DitailGameTableViewCell else { return UITableViewCell() }
        if indexPath.section == 2 {
            cell.setupCell(user: game?.user)
        } else if indexPath.row < gameMembers?.results?.count ?? 0 {
            cell.setupCell(user: gameMembers?.results?[indexPath.row].user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard gameMembers?.results?.count != 0 else { return }
        guard indexPath.row < gameMembers?.results?.count ?? 0 else { return }
        guard let friendUser = gameMembers?.results?[indexPath.row].user else { return }
        guard currentUser.id != friendUser.id else { return }
        let chatVC = ChatViewController(currentUser: currentUser, friendUser: friendUser)
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
}

//MARK: - Setup elements
extension DetailGameViewController {
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(DitailGameTableViewCell.self, forCellReuseIdentifier: DitailGameTableViewCell.identifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 10
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
         //   tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: -20),
           // tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
         //   tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
         //   tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let headerHeight = header.getViewHeight(controllerWidth: view.frame.width - 20)
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight)
        tableView.tableHeaderView = header
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 48))
        
        
        //let joinButton = UIButton(title: "Присоедениться к игре", textColor: #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1), buttonImageColor: #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1))
        joinButton.backgroundColor = UIColor(red: 242/255, green: 122/255, blue: 42/255, alpha: 1)
        joinButton.layer.cornerRadius = 14
        joinButton.setTitle("Участвовать", for: .normal)
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        footerView.addSubview(joinButton)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            joinButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            joinButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            joinButton.heightAnchor.constraint(equalToConstant: 48),
            joinButton.widthAnchor.constraint(equalToConstant: 278),
        ])
      
        tableView.tableFooterView = footerView
    }
    
    @objc private func joinButtonTapped() {
        GamesNetworkManager.shared.addToGame(gameID: game?.id ?? 0, userID: currentUser.id ?? 0) { (result) in
            switch result {
            case .success(let gameMemeber):
                DispatchQueue.main.async {
                    var member = gameMemeber
                    member.user = self.currentUser
                    self.gameMembers?.results?.append(member)
                    self.joinButton.setTitle("Вы в игре", for: .normal)
                    self.joinButton.isEnabled = false
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Setup Navigation Bar

extension DetailGameViewController {
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let imageBackBarButtonItem = UIImage(named: "BackArrow")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imageBackBarButtonItem, style: .plain, target: self, action: #selector(back))

        navigationItem.title = "ИГРА"
        
        let attributesForTitle: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Avenir", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundImage = UIImage()
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.titleTextAttributes = attributesForTitle
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK:- Setup Top Image View
extension DetailGameViewController {
    private func setupTopImage() {
        topImageView.backgroundColor = .lightGray
        view.addSubview(topImageView)
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.topAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.heightAnchor.constraint(equalToConstant: CGFloat(243))
        ])
    }
    
}
