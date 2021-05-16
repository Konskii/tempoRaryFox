//
//  NewDetailTournamentHeader.swift
//  Fox19
//
//  Created by Артём Скрипкин on 16.05.2021.
//

import UIKit

class NewDetailTournamentHeader: UITableViewHeaderFooterView {
    private lazy var tournamentName: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 23)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tournamentClub: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tournamentDate: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tournamentDescription: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
