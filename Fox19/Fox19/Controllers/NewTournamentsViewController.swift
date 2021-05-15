//
//  NewTournamentsViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 14.05.2021.
//

import UIKit

class NewTournamentsViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func getAllTournaments() {
        
    }
}

//MARK: UITableViewDataSource
extension NewTournamentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

//MARK: UITableViewDelegate
extension NewTournamentsViewController: UITableViewDelegate {
    
}
