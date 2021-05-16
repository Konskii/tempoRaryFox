//
//  NewDetailTableViewCell.swift
//  Fox19
//
//  Created by Артём Скрипкин on 16.05.2021.
//

import UIKit

enum TournamentDetailCellTypes: CaseIterable {
    case description, format, startTime, startFormat, termsOfParticipation, participationCost, programm
}

class NewDetailTableViewCell: UITableViewCell {
    
    private lazy var mainLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 13)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var secondaryLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        view.font = UIFont(name: "Inter-Medium", size: 13)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setup(tournament: Tournament, type: TournamentDetailCellTypes) {
        
    }
}
