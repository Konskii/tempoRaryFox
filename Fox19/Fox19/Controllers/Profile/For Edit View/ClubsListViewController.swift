//
//  ClubsListViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 24.04.2021.
//

import UIKit

protocol ClubsListProtocol: class {
    func reload()
}

class ClubsListViewController: UIViewController {
    //MARK: - Inits
    convenience init(userId: Int, userClubs: [Club]) {
        self.init()
        self.userId = userId
        self.userClubs = userClubs
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        getAllClubs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Variabl;es
    private var userId: Int?
    
    weak var delegate: ClubsListProtocol?
    
    private var messageToShow = "Загружаем список клубов..." {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    private var userClubs: [Club] = []
    
    private var clubs: [Club] = [] {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    private let networkManager = TestUserNetwrokManager()
    
    //MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .singleLine
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    //MARK: - Methods
    private func getAllClubs() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        messageToShow = "Загружаем список клубов..."
        ClubsNetworkManager.shared.getAllClubs(for: number) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let clubsResponse):
                var tempClubs: [Club] = []
                clubsResponse.results.forEach({ clubInResponse in
                    guard !self.userClubs.contains(clubInResponse) else { return }
                    tempClubs.append(clubInResponse)
                })
                self.clubs = tempClubs
                if tempClubs.isEmpty {
                    self.messageToShow = "Невозможно добавить новые клубы"
                }
            case .failure(let error):
                self.showAlert(title: "Возникла ошибка", message: "\(error)")
                self.messageToShow = "Возникла ошибка"
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
}

//MARK: - UITableViewDataSource
extension ClubsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clubs.isEmpty {
            return 1
        } else {
            return clubs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if clubs.isEmpty {
            cell.textLabel?.text = messageToShow
            cell.textLabel?.adjustsFontSizeToFitWidth = true
        } else {
            guard let name = clubs[indexPath.row].name else { return cell }
            cell.textLabel?.text = "\(name)"
        }
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension ClubsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let clubId = clubs.getElement(index: indexPath.row)?.id else { return }
        guard let userId = userId else { return }
        print("ok")
        networkManager.joinClub(userId: userId, clubId: clubId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                print("ok2")
                DispatchQueue.main.async { self.dismiss(animated: true) {
                    self.delegate?.reload()
                } }
            case .failure(let error):
                print("bad \(error)")
                self.showAlert(title: "Возникла ошибка", message: "\(error)")
            }
        }
    }
}

