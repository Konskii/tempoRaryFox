//
//  RulesViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 13.10.2020.
//

import UIKit

class RulesViewController: UIViewController {
    
    private let titleColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
    private let arrayOfJudge = setJudges()
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarItems()
        setTableView()
        setupTitleSettings()
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
        navigationItem.title = "СУДЬИ"
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(RulesTableViewCell.self, forCellReuseIdentifier: RulesTableViewCell.tableCellID)
        
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    //Устанавливаем Коллекция
    func setBarItems() {
        
        //Левая кнопка
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "SearchNav"), style: .done, target: self, action: #selector(showSearching))
        searchButton.tintColor = #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1)
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = searchButton
        
        //Правая кнопка
        let rulesButton = UIBarButtonItem(image: #imageLiteral(resourceName: "BookmarkNav"), style: .plain, target: self, action: #selector(showRules))
        rulesButton.tintColor = #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1)
        self.navigationItem.rightBarButtonItem = rulesButton
    }
    
    //Функция по тапу на правую кнопку
    @objc func showSearching() {
        print("Нажали на Поиск")
    }
    
    //Функция по тапу на левую кнопку
    @objc func showRules() {
        print("Нажали на Правила")
    }
}

extension RulesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfJudge.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RulesTableViewCell.tableCellID, for: indexPath) as? RulesTableViewCell else {return UITableViewCell()}
        let judge = arrayOfJudge[indexPath.row]
        cell.separatorInset = .init(top: 1, left: 80, bottom: 1, right: 0)
        cell.layoutMargins = .zero
        cell.backgroundColor = .white
        cell.setup(judge: judge)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RulesViewController: CellDelegate {
    
    func didTapOnQuestion(cell: UITableViewCell, judge: JudgeForExample) {
        //По нажатию на лэйбл "Спросить"
    }
}

