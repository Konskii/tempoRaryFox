//
//  NewDetailTournamentsViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 16.05.2021.
//

import UIKit

class NewDetailTournamentsViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame, style: .plain)
        view.separatorStyle = .singleLine
        view.dataSource = self
        view.delegate = self
        return view
    }()
}

//MARK: UITableViewDataSource
extension NewDetailTournamentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

//MARK: UITableViewDelegate
extension NewDetailTournamentsViewController: UITableViewDelegate {
    
}
