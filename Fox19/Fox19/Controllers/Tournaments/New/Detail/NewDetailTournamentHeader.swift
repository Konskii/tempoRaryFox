//
//  NewDetailTournamentHeader.swift
//  Fox19
//
//  Created by Артём Скрипкин on 16.05.2021.
//

import UIKit

class NewDetailTournamentHeader: UITableViewHeaderFooterView {
    
    static let reusedId = "NewDetailTournamentHeader"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupConstraints()
        let backView = UIView(frame: frame)
        backView.backgroundColor = .white
        backgroundView = backView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tournamentName: UILabel = {
        let view = UILabel()
        view.adjustsFontSizeToFitWidth = true
        view.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 23)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tournamentClub: UILabel = {
        let view = UILabel()
        view.adjustsFontSizeToFitWidth = true
        view.textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tournamentDate: UILabel = {
        let view = UILabel()
        view.adjustsFontSizeToFitWidth = true
        view.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tournamentDescription: UILabel = {
        let view = UILabel()
        view.adjustsFontSizeToFitWidth = true
        view.textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 13)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public func configure(tournament: Tournament) {
        tournamentName.text = tournament.name ?? ""
        tournamentClub.text = tournament.club?.name
        tournamentDate.text = tournament.date?.value
        tournamentDescription.text = tournament.description
    }
    
    private func setupConstraints() {
        addSubview(tournamentName)
        addSubview(tournamentClub)
        addSubview(tournamentDate)
        addSubview(tournamentDescription)
        
        NSLayoutConstraint.activate([
            tournamentName.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            tournamentName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tournamentName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            tournamentClub.topAnchor.constraint(equalTo: tournamentName.bottomAnchor, constant: 8),
            tournamentClub.leadingAnchor.constraint(equalTo: tournamentName.leadingAnchor),
            tournamentClub.trailingAnchor.constraint(equalTo: tournamentName.trailingAnchor),
            
            tournamentDate.topAnchor.constraint(equalTo: tournamentClub.bottomAnchor, constant: 8),
            tournamentDate.leadingAnchor.constraint(equalTo: tournamentName.leadingAnchor),
            tournamentDate.trailingAnchor.constraint(equalTo: tournamentName.trailingAnchor),
            
            tournamentDescription.topAnchor.constraint(equalTo: tournamentDate.bottomAnchor, constant: 24),
            tournamentDescription.leadingAnchor.constraint(equalTo: tournamentName.leadingAnchor),
            tournamentDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
