//
//  PlayersViewController.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 13.10.2020.
//

import UIKit
import EZYGradientView


class PlayersViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let arrayOfUsers = setUsers()
    
    private let titleColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
    private var tableView = UITableView()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarItems()
        setTableView()
        setupTitleSettings()
    }
    
    //TODO: - Сделать видимым tabbar
    override func viewWillAppear(_ animated: Bool) {
        print("Hello")
        //tabBarController?.tabBar.isHidden = false
    }
    
  
    
    //Устанавливаем настройки тайтла
    private func setupTitleSettings() {
        let attributesGray: [NSAttributedString.Key: Any] = [
            .foregroundColor: titleColor,
            .font: UIFont(name: "avenir", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = attributesGray
    }
    
    //Устанавливаем Коллекция
    func setTableView() {
        navigationItem.title = "ИГРОКИ"
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(PlayersTableViewCell.self, forCellReuseIdentifier: PlayersTableViewCell.identifire)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    
    //MARK: - Устанавливаем Вью Игрока
    func setDetailView() {
        let vc = OnePlayerViewController()
        let selectedRow = tableView.indexPathForSelectedRow!.row
        vc.player = arrayOfUsers[selectedRow]
        vc.modalTransitionStyle   = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.preferredContentSize = CGSize(width: 300, height: 300)
       // tabBarController?.tabBar.isHidden = true
        present(vc, animated: true, completion: nil)
    }
    
    //Устанавливаем Коллекция
    func setBarItems() {
        //Левая кнопка
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "SearchNav"), style: .done, target: self, action: #selector(showSearching))
        searchButton.tintColor = #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1)
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = searchButton
        
        //Правая кнопка
        let filtersButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filters"), style: .plain, target: self, action: #selector(showFilter))
        filtersButton.tintColor = #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1)
        self.navigationItem.rightBarButtonItem = filtersButton
    }
    
    //MARK: - Search
    @objc func showSearching() {
        print("Нажали на Поиск")
    }
    
    //MARK: - Filters
    @objc func showFilter() {
        print("Нажали на Фильтры")
    }
}

extension PlayersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayersTableViewCell.identifire, for: indexPath) as? PlayersTableViewCell else {return UITableViewCell()}
        let user = arrayOfUsers[indexPath.row]
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.backgroundColor = .white
        cell.setup(user: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setDetailView()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
