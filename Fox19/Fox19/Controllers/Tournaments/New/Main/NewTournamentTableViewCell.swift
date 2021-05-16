//
//  NewTournamentTableViewCell.swift
//  Fox19
//
//  Created by Артём Скрипкин on 14.05.2021.
//

import UIKit

class NewTournamentTableViewCell: UITableViewCell {
    
    static let reusedId = "NewTournamentTableViewCell"
    
    private lazy var tournamentNameLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 15)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.32
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tournamentPlaceLabel: UILabel = {
        let view = UILabel()
        view.text = "В разработке"
        view.textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        view.font = UIFont(name: "Inter-Medium", size: 13)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.27
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tournamentDate: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        view.font = UIFont(name: "Inter-Medium", size: 13)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.27
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chevron: UIImageView = {
        let view = UIImageView(image: UIImage(named: "chevron_right"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupConstraints() {
        contentView.addSubview(tournamentNameLabel)
        contentView.addSubview(tournamentPlaceLabel)
        contentView.addSubview(tournamentDate)
        contentView.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            tournamentNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            tournamentNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tournamentNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            tournamentPlaceLabel.topAnchor.constraint(equalTo: tournamentNameLabel.bottomAnchor, constant: 8),
            tournamentPlaceLabel.leadingAnchor.constraint(equalTo: tournamentNameLabel.leadingAnchor),
            tournamentPlaceLabel.trailingAnchor.constraint(equalTo: tournamentNameLabel.trailingAnchor),
            
            tournamentDate.topAnchor.constraint(equalTo: tournamentPlaceLabel.bottomAnchor, constant: 8),
            tournamentDate.leadingAnchor.constraint(equalTo: tournamentNameLabel.leadingAnchor),
            tournamentDate.trailingAnchor.constraint(equalTo: tournamentNameLabel.trailingAnchor),
            
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: tournamentNameLabel.trailingAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 24),
            chevron.heightAnchor.constraint(equalTo: chevron.widthAnchor)
        ])
    }
    
    public func setup(tournament: FillableTournamentModel) {
        tournamentNameLabel.text = tournament.name
        tournamentDate.text = tournament.date
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
