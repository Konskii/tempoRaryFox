//
//  ClubsListViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 08.04.2021.
//

import UIKit

protocol ClubsListProtocol: class {
    func reload()
}

class ClubsListViewController: UIViewController {
    
    convenience init(userId: Int) {
        self.init()
        self.userId = userId
    }
    
    private var userId: Int?
    
    weak var delegate: ClubsListProtocol?
    
    private var clubs: [Club] = [] {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    private let networkManager = TestUserNetwrokManager()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private func getAllClubs() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        ClubsNetworkManager.shared.getAllClubs(for: number) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let clubsResponse):
                self.clubs = clubsResponse.results
            case .failure(let error):
                self.showAlert(title: "Возникла ошибка", message: "\(error)")
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        getAllClubs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
}

extension ClubsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clubs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let name = clubs[indexPath.row].name {
            cell.textLabel?.text = "\(name)"
        }
        return cell
    }
    
    
}

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
                self.showAlert(title: "Dозникла ошибка", message: "\(error)")
            }
        }
    }
}
