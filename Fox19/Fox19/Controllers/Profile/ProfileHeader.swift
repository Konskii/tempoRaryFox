//
//  ProfileHeader.swift
//  Fox19
//
//  Created by Артём Скрипкин on 23.04.2021.
//

import UIKit
// MARK: var, let
class ProfileHeader: UITableViewHeaderFooterView {
    
    static let reusedId = "ProfileHeader"
    
    private let service = ProfileService()
    
    private var user: User? {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.userNameLabel.text = "\(newValue?.name ?? "") \(newValue?.lastName ?? "")"
                self.userHandicap.text = "\(self.service.getHandicapToShow(handicapFromServer: newValue?.handicap) ?? "") handicap"
            }
        }
    }
    
    private var memberedClubs: [MemberedClubModel]? {
        willSet {
            guard let newValue = newValue else { return }
            var namesArray = [String]()
            newValue.forEach({
                guard let name = $0.club.name else { return }
                namesArray.append(name)
            })
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.clubNameLabel.text = namesArray.joined(separator: ", ")
            }
        }
    }
    
    private var userAvatar: UIImage? {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.avatarImageView.image = newValue
            }
        }
    }
    
    
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userNameLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        view.font = UIFont(name: "Inter-Medium", size: 13)
        view.adjustsFontSizeToFitWidth = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userHandicap: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 12)
        view.adjustsFontSizeToFitWidth = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var clubNameLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 15)
        view.adjustsFontSizeToFitWidth = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var clubLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 12)
        view.adjustsFontSizeToFitWidth = true
        view.text = "Домашний клуб"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separator: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ProfileSeparator"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

// MARK: UI
extension ProfileHeader {
    private func addSubviews() {
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        addSubview(userHandicap)
        addSubview(clubNameLabel)
        addSubview(clubLabel)
        addSubview(separator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 64),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            userHandicap.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            userHandicap.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userHandicap.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            
            clubNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            clubNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            clubNameLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            
            clubLabel.topAnchor.constraint(equalTo: clubNameLabel.bottomAnchor, constant: 4),
            clubLabel.leadingAnchor.constraint(equalTo: clubNameLabel.leadingAnchor),
            clubLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            
            separator.topAnchor.constraint(equalTo: clubLabel.bottomAnchor, constant: 11),
            separator.leadingAnchor.constraint(equalTo: clubLabel.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor)
        ])
    }
}

// MARK: Init
extension ProfileHeader {
    convenience init(user: User, avatar: UIImage?, memberedClubs: [MemberedClubModel]) {
        self.init()
        let backView = UIView(frame: frame)
        backView.backgroundColor = .white
        backgroundView = backView
        addSubviews()
        setupConstraints()
        
        avatarImageView.image = avatar
        
        userNameLabel.text = "\(user.name ?? "") \(user.lastName ?? "")"
        userHandicap.text = "\(self.service.getHandicapToShow(handicapFromServer: user.handicap) ?? "") handicap"
        
        var namesArray = [String]()
        memberedClubs.forEach({
            guard let name = $0.club.name else { return }
            namesArray.append(name)
        })
        self.clubNameLabel.text = namesArray.joined(separator: ", ")
    }
}
