//
//  SelectClubViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 24.11.2020.
//

import UIKit

protocol GetDataFromSelectClubProtocol: class {
    func clubSelected(clubId: Int, clubName: String)
}

class SelectClubViewController: UIViewController {
    
    //MARK: - Delegates
    weak var delegate: GetDataFromSelectClubProtocol?
    
    //MARK: - Variables
    private var clubs: [Club] = []
    
    //MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame, style: .plain)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    //MARK: - UserIneraction Methods
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    private func configureNavigantionBar() {
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "backButton"), style: .done, target: self, action: #selector(backButtonPressed)), animated: true)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "orange")
        let view = UILabel()
        view.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "ВЫБЕРИТЕ КЛУБ"
        navigationItem.titleView = view
    }
    
    private func getClubs() {
        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
        ClubsNetworkManager.shared.getAllClubs(for: account) { (result) in
            switch result {
            case .failure(let error):
                self.errorAlertMessage(message: "\(error)")
            case .success(let clubs):
                self.clubs = clubs.results
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
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        getClubs()
        configureNavigantionBar()
        overrideUserInterfaceStyle = .light
    }
}

//MARK: - UITableViewDataSource
extension SelectClubViewController: UITableViewDataSource {
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

//MARK: - UITableViewDelegate
extension SelectClubViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !clubs.isEmpty else { return }
        guard let id = clubs[indexPath.row].id else {
            self.errorAlertMessage(message: "clubId")
            return
        }
        guard let name = clubs[indexPath.row].name else {
            self.errorAlertMessage(message: "clubName")
            return
        }
        delegate?.clubSelected(clubId: id, clubName: name)
        navigationController?.popViewController(animated: true)
    }
}
