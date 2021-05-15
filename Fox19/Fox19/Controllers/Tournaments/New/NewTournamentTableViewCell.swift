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
        view.backgroundColor = .white
        view.textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 15)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.32
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tournamentPlaceLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        view.font = UIFont(name: "Inter-Medium", size: 13)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.27
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tournamentDate: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        view.font = UIFont(name: "Inter-Medium", size: 13)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.27
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupConstraints() {
        contentView.addSubview(tournamentNameLabel)
        contentView.addSubview(tournamentPlaceLabel)
        contentView.addSubview(tournamentDate)
        
        NSLayoutConstraint.activate([
            tournamentNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            tournamentNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            tournamentPlaceLabel.topAnchor.constraint(equalTo: tournamentNameLabel.bottomAnchor),
            tournamentPlaceLabel.leadingAnchor.constraint(equalTo: tournamentNameLabel.leadingAnchor),
            
            tournamentDate.topAnchor.constraint(equalTo: tournamentPlaceLabel.bottomAnchor),
            tournamentDate.leadingAnchor.constraint(equalTo: tournamentNameLabel.leadingAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
