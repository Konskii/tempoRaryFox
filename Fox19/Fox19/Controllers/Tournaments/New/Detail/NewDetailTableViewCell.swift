//
//  NewDetailTableViewCell.swift
//  Fox19
//
//  Created by Артём Скрипкин on 16.05.2021.
//

import UIKit

enum TournamentDetailCellTypes: CaseIterable {
    case format, startTime, startFormat, termsOfParticipation, participationCost, programm
}

class NewDetailTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let reusedId = "NewDetailTableViewCell"
    
    private lazy var mainLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 13)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var secondaryLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        view.font = UIFont(name: "Inter-Medium", size: 13)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setup(tournament: Tournament, type: TournamentDetailCellTypes) {
        switch type {
        case .format:
            mainLabel.text = "Формат"
            secondaryLabel.text = "need api"
        case .startTime:
            mainLabel.text = "Время начала"
            secondaryLabel.text = tournament.date?.value ?? ""
        case .startFormat:
            mainLabel.text = "Формат старта"
            secondaryLabel.text = "need api"
        case .termsOfParticipation:
            mainLabel.text = "Условия участия"
            secondaryLabel.text = "need api"
        case .participationCost:
            mainLabel.text = "Стоимость участия"
            secondaryLabel.text = "\(tournament.guestPrice ?? 00)"
        case .programm:
            mainLabel.text = "Программа"
            secondaryLabel.text = "need api"
        }
    }
    
    private func setupConstraints() {
        addSubview(mainLabel)
        addSubview(secondaryLabel)
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            secondaryLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8),
            secondaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
}
