//
//  DetailGameViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 18.01.2021.
//

import UIKit

class DetailGameViewController: UIViewController {
    
    private let header = HeaderForDerailView()
    private var tableView: UITableView!
    
    private var game: GamesModel.Game? = nil
    private var gameMembers: GameMembers? = nil
    private var currentUser: User
    
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
        setupTableView()
        setupNavigationBar()
        
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        guard let gameID = game?.id else { return }
        GamesNetworkManager.shared.getMembersTest(gameID: gameID, token: token) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.gameMembers = data
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupData(image: UIImage?, game:GamesModel.Game) {
        header.setupHeaderWithData(mainImage: image, game: game)
        self.game = game
    }
    
}

//MARK: - TableViewDelegate and TableViewDataSource
extension DetailGameViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
         let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        title.font = UIFont(name: "Avenir", size: 15)
        title.textColor = .black
        header.addSubview(title)
        if section == 0  {
            title.text = "Организатор"
        } else {
            title.text = "Учатсники"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
           // gameMembers?.results?.count ?? 0
            return game?.gamersCount ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard  let cell = tableView.dequeueReusableCell(withIdentifier: DitailGameTableViewCell.identifire, for: indexPath) as?
            DitailGameTableViewCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.setupCell(user: game?.user)
        } else if indexPath.row < gameMembers?.results?.count ?? 0 {
            cell.setupCell(user: gameMembers?.results?[indexPath.row].user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard gameMembers?.results?.count != 0 else { return }
        guard let friendUser = gameMembers?.results?[indexPath.row].user else { return }
        guard currentUser.id != friendUser.id else { return }
        let chatVC = ChatViewController(currentUser: currentUser, friendUser: friendUser)
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        71
    }
}

//MARK: - Setup elements
extension DetailGameViewController {
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(DitailGameTableViewCell.self, forCellReuseIdentifier: DitailGameTableViewCell.identifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        let headerHeight = header.getViewHeight(controllerWidth: view.frame.width - 20)
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight)
        tableView.tableHeaderView = header
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 41))
        
        
        let joinButton = UIButton(title: "Присоедениться к игре", textColor: #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1), buttonImageColor: #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1))
        footerView.addSubview(joinButton)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            joinButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            joinButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            joinButton.heightAnchor.constraint(equalToConstant: 41),
            joinButton.widthAnchor.constraint(equalToConstant: 185),
        ])
      
        tableView.tableFooterView = footerView
    }
}

//MARK: - Setup Navigation Bar

extension DetailGameViewController {
    
    private func setupNavigationBar() {
        
        let titleColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
        let imageBackBarButtonItem = UIImage(named: "BackArrow")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imageBackBarButtonItem, style: .plain, target: self, action: #selector(back))
        
        let attributesGray: [NSAttributedString.Key: Any] = [
            .foregroundColor: titleColor,
            .font: UIFont(name: "avenir", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        navigationItem.title = "ИГРА"
        navigationController?.navigationBar.titleTextAttributes = attributesGray
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}
