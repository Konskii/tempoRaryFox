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
    
    weak var delegate: testProtocol?
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.layer.cornerRadius = 25
        view.dataSource = self
        view.delegate = self
        view.contentInset.bottom = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        getClubs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(hide))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hide() {
        dismiss(animated: true)
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            tableView.widthAnchor.constraint(equalToConstant: view.frame.width / 1.2),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private var clubs: [Club] = []
    
    private func getClubs() {
        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
        ClubsNetworkManager.shared.getAllClubs(for: account) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.showAlert(title: "Возникла ошибка", message: "\(error)")
            case .success(let clubs):
                self.clubs = clubs.results
                DispatchQueue.main.async { self.tableView.reloadData() }
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
            cell.textLabel?.text = "Клубы загружаются.."
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
}
