//
//  MyClubsViewController.swift
//  Fox19
//
//  Created by Евгений Скрипкин on 17.02.2021.
//

import UIKit

protocol testProtocol: class {
    func showDetailVC(club: Club)
}

class MyClubsViewController: UIViewController {
    
    convenience init(userId: Int) {
        self.init()
        self.userId = userId
        getClubs()
    }
    
    weak var delegate: testProtocol?
    
    private let networkManager = TestUserNetwrokManager()
    
    private var userId: Int?
    
    private var clubs: [Club] = [] {
        willSet(new) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if new.count == 0 {
                    print("zero    \(new)")
                    self.editButton.backgroundColor = .darkGray
                    self.editButton.isEnabled = false
                    self.tableView.isEditing = false
                } else {
                    print("not zero     \(new)")
                    self.editButton.backgroundColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1)
                    self.editButton.isEnabled = true
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private var likes: [LikedClubModel] = []
    
    private var messageToShow = "Проверяем ваши клубы..."
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.layer.cornerRadius = 25
        view.dataSource = self
        view.delegate = self
        view.contentInset.bottom = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Редактировать", for: .normal)
        view.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        view.tintColor = .white
        view.backgroundColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1).cgColor
        view.addTarget(self, action: #selector(edit), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Назад", for: .normal)
        view.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        view.tintColor = .white
        view.backgroundColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1).cgColor
        view.addTarget(self, action: #selector(hide), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    @objc private func edit() {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }
    
    @objc private func hide() {
        dismiss(animated: true)
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(editButton)
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            tableView.widthAnchor.constraint(equalToConstant: view.frame.width / 1.2),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            editButton.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            editButton.heightAnchor.constraint(equalToConstant: 48),
        
            dismissButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 25),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }
    
    private func getClubs(completion: @escaping () -> Void = {}) {
        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
        guard let userId = userId else { return }
        clubs = []
        networkManager.getLikedClubs(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let likes):
                guard !likes.results.isEmpty else {
                    self.messageToShow = "У вас нет клубов."
                    DispatchQueue.main.async { self.tableView.reloadData() }
                    return
                }
                var tempClubs: [Club] = []
                likes.results.forEach({
                    guard $0.user.id == userId else { return }
                    let clubId = $0.club.id
                    ClubsNetworkManager.shared.getAllClubs(for: account) { result in
                        switch result {
                        case .success(let allClubs):
                            allClubs.results.forEach({ (club) in
                                guard club.id == clubId else { return }
                                tempClubs.append(club)
                            })
                            self.clubs = tempClubs
                            completion()
                        case .failure(let error):
                            self.showAlert(title: "Возникла ошибка.", message: "\(error)")
                        }
                    }
                })
                self.likes = likes.results
            case .failure(let error):
                self.showAlert(title: "Возникла ошибка.", message: "\(error)")
            }
        }
    }
    
    private func deleteClub(at index: IndexPath) {
        let likeId = likes[index.row].id
        networkManager.unlikeClub(likeIdToUnlike: likeId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.getClubs()
            case .failure(let error):
                self.showAlert(title: "Возникла ошибка.", message: "\(error)")
            }
        }
    }
}

extension MyClubsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clubs.isEmpty {
            return 1
        } else {
            return clubs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SelectClubCell")
        if clubs.isEmpty {
            cell.textLabel?.text = messageToShow
        } else {
            cell.textLabel?.text = clubs[indexPath.row].name
        }
        return cell
    }
}

extension MyClubsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let club = clubs[indexPath.row]
        dismiss(animated: true) {
            self.delegate?.showDetailVC(club: club)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        deleteClub(at: indexPath)
    }
}
