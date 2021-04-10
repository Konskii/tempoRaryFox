//
//  MyClubsViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 17.02.2021.
//

import UIKit

protocol MyClubsProtocol: class {
    func reload()
}

class MyClubsViewController: UIViewController {
    
    //MARK: - Inits
    convenience init(userId: Int) {
        self.init()
        self.userId = userId
        getClubs()
    }
    
    //MARK: - Variables
    weak var delegate: MyClubsProtocol?
    
    private var userId: Int?
    
    private var clubs: [Club] = [] {
        willSet(new) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if new.count == 0 {
                    self.editButton.backgroundColor = .darkGray
                    self.editButton.isEnabled = false
                    self.tableView.isEditing = false
                } else {
                    self.editButton.backgroundColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1)
                    self.editButton.isEnabled = true
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private var messageToShow = "Проверяем ваши клубы..."
    
    private let networkManager = TestUserNetwrokManager()
    
    //MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .white
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
    
    private lazy var addButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("+", for: .normal)
        view.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        view.tintColor = .white
        view.backgroundColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1).cgColor
        view.addTarget(self, action: #selector(add), for: .touchUpInside)
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
    
    //MARK: - UserInteraction Methods
    @objc private func add() {
        guard let userId = userId else { return }
        let vc = ClubsListViewController(userId: userId, userClubs: clubs)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func edit() {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }
    
    @objc private func hide() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.reload()
        }
    }
    
    //MARK: - Methods
    private func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(editButton)
        view.addSubview(dismissButton)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            tableView.widthAnchor.constraint(equalToConstant: view.frame.width / 1.2),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 48),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            addButton.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20),
            
            editButton.bottomAnchor.constraint(equalTo: addButton.bottomAnchor),
            editButton.heightAnchor.constraint(equalTo: addButton.heightAnchor),
            editButton.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -15),
        
            dismissButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 25),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }
    
    private func getClubs() {
        guard let userId = userId else {
            showAlert(title: "Возникла ошибка!", message: "userId error")
            return
        }
        networkManager.getMemberedClubs(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success( let likedClubs):
                var tempClubs: [Club] = []
                likedClubs.results.forEach({
                    tempClubs.append($0.club)
                })
                self.clubs = tempClubs
            case .failure(let error):
                self.showAlert(title: "Возникла ошибка", message: "\(error)")
            }
        }
    }
    
    //need API
    private func deleteClub(at index: IndexPath) {

    }
    
    //MARK: - Life Cycle
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getClubs()
    }
}

//MARK: - UITableViewDataSource
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
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        if clubs.isEmpty {
            cell.textLabel?.text = messageToShow
        } else {
            cell.textLabel?.text = clubs[indexPath.row].name
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MyClubsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        deleteClub(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - ClubsListProtocol
extension MyClubsViewController: ClubsListProtocol {
    func reload() {
        getClubs()
    }
}
