//
//  EventsCollectionViewCell.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 24.04.2021.
//

import UIKit

class EventsCollectionViewCell: UICollectionViewCell {
    
    static let reusedID = "EventsCollectionViewCell"
    
    private let primeColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
    private let separatorColor = UIColor(red: 225/255, green: 236/255, blue: 249/255, alpha: 1)
    private let textColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    private let textGreyColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)
    
    private lazy var titleLabel = UILabel(text: "Быстрый гольф",
                                     font: UIFont(name: "Inter-Regular", size: 15),
                                     textColor: textColor)
    private lazy var dateLabel = UILabel(text: "20 апреля 2021 в 10.00",
                                     font: UIFont(name: "Inter-Regular", size: 12),
                                     textColor: textGreyColor)
    
    private let leftImageView = UIImageView()
    private let rightImageView = UIImageView()
    private let separatorView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EventsCollectionViewCell {
    private func configure() {
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftImageView)
        leftImageView.image = UIImage(named: "Games")?.withTintColor(primeColor)
        leftImageView.tintColor = primeColor
        
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightImageView)
        rightImageView.image = UIImage(systemName: "chevron.right")
        rightImageView.tintColor = primeColor
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        separatorView.backgroundColor = separatorColor
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftImageView.widthAnchor.constraint(equalToConstant: 29),
            leftImageView.heightAnchor.constraint(equalToConstant: 29),
            leftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 21),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            dateLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 21),
            
            rightImageView.widthAnchor.constraint(equalToConstant: 24),
            rightImageView.heightAnchor.constraint(equalToConstant: 24),
            rightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
        ])
    }
}
