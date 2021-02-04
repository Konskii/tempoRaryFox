//
//  GameCollectionCell.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 14.01.2021.
//

import UIKit

class GameCollectionCell: UICollectionViewCell {
    
    static let reuseid = "GameCollectionCell"
    private(set) var clubImageView = UIImageView()
    private let locationPointer = UIImageView(image: UIImage(named: "Pointer"))
    private let flagImageView = UIImageView(image: UIImage(named: "flag"))
    private let reserveImageView = UIImageView(image: UIImage(named: "reserve"))
    private let userImageView = UIImageView(image: UIImage(named: "person"))
    private let locationLabel = UILabel(text: "НАЗВАНИЕ ГОЛЬФ-КЛУБА",
                                        font: .avenir(fontSize: 12),
                                        textColor: .white)
    private let numberOfLunokLabel = UILabel(text: "18 лунок",
                                             font: .avenir(fontSize: 13),
                                             textColor: .white)
    
    private let reserveLabel = UILabel(text: "Забронированно",
                                       font: .avenir(fontSize: 13),
                                       textColor: .white)
    
     private let priceLabel = UILabel(text:  "5000/4 рублей",
                                     font: .avenir(fontSize: 13),
                                     textColor: .white)
    private let joinTheGameButton = UIButton(title: "Присоедениться к игре", textColor: #colorLiteral(red: 0.1764705882, green: 0.2470588235, blue: 0.4, alpha: 1), buttonImageColor: #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellConfigurator(game: GamesModel.Game) {
        locationLabel.text = game.club?.title?.uppercased()
        numberOfLunokLabel.text = "\(game.holes ?? 0) лунок"
        priceLabel.text = "\(game.memberPrice ?? 0)/\(game.gamersCount ?? 0) рублей"
        reserveLabel.text = game.reserved ?? false ? "Забронированно" : "Не забронированно"
        
        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: account) else { return }

        ClubsNetworkManager.shared.getImageForClubCover(for: account, clubId: game.club?.id ?? 0) { (result) in
            switch result {
            case .success(let data):
                let url = data.results?.first?.image
                ClubsNetworkManager.shared.downloadImageForCover(from: url ?? "", account: account) { (result) in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self.clubImageView.image = UIImage(data: data)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        GamesNetworkManager.shared.getMembersTest(gameID: game.id ?? 0, token: token) { (result) in
            switch result {
            case .success(let members):
                DispatchQueue.main.async { [self] in
                    guard let players = members.results?.count, players != 0 else { return }
                    var playersImage: [UIImageView] = []
                        for player in 1...players {
                            let xPosition = (player - 1) * 21
                            let image = UIImageView(imageName: "user", playerGandicap: "\(members.results?[player - 1].user?.handicap ?? 0)")
                            playersImage.append(image)
                            image.translatesAutoresizingMaskIntoConstraints = false
                            self.addSubview(image)
                            NSLayoutConstraint.activate([
                                image.heightAnchor.constraint(equalToConstant: 41),
                                image.widthAnchor.constraint(equalToConstant: 41),
                                image.centerYAnchor.constraint(equalTo: self.joinTheGameButton.centerYAnchor),
                                image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CGFloat(xPosition)),
                            ])
                        }
                    if game.gamersCount == players {
                        self.joinTheGameButton.isEnabled = false
                        self.joinTheGameButton.setTitle("Все места заняты", for: .normal)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupElements() {
        clubImageView.backgroundColor = .lightGray
        clubImageView.layer.cornerRadius = 8
        clubImageView.clipsToBounds = true
        clubImageView.translatesAutoresizingMaskIntoConstraints = false
        
        locationPointer.translatesAutoresizingMaskIntoConstraints = false
        locationPointer.clipsToBounds = true
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.clipsToBounds = true
        
        numberOfLunokLabel.translatesAutoresizingMaskIntoConstraints = false
        
        reserveImageView.translatesAutoresizingMaskIntoConstraints = false
        reserveImageView.clipsToBounds = true
        
        reserveLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.clipsToBounds = true
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        joinTheGameButton.translatesAutoresizingMaskIntoConstraints = false
        
        clubImageView.addSubview(locationPointer)
        clubImageView.addSubview(locationLabel)
        clubImageView.addSubview(flagImageView)
        clubImageView.addSubview(numberOfLunokLabel)
        clubImageView.addSubview(reserveImageView)
        clubImageView.addSubview(reserveLabel)
        clubImageView.addSubview(userImageView)
        clubImageView.addSubview(priceLabel)
        addSubview(clubImageView)
        addSubview(joinTheGameButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            clubImageView.topAnchor.constraint(equalTo: topAnchor),
            clubImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            clubImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            clubImageView.heightAnchor.constraint(equalToConstant: 185),
            
            locationPointer.widthAnchor.constraint(equalToConstant: 20),
            locationPointer.heightAnchor.constraint(equalToConstant: 20),
            locationPointer.topAnchor.constraint(equalTo: clubImageView.topAnchor, constant: 23),
            locationPointer.leadingAnchor.constraint(equalTo: clubImageView.leadingAnchor, constant: 14),
            
            locationLabel.topAnchor.constraint(equalTo: clubImageView.topAnchor, constant: 25),
            locationLabel.leadingAnchor.constraint(equalTo: locationPointer.trailingAnchor, constant: 7),
            
            flagImageView.bottomAnchor.constraint(equalTo: clubImageView.bottomAnchor, constant: -12),
            flagImageView.leadingAnchor.constraint(equalTo: clubImageView.leadingAnchor, constant: 14),
            
            numberOfLunokLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 11),
            numberOfLunokLabel.bottomAnchor.constraint(equalTo: clubImageView.bottomAnchor, constant: -10),
            
            reserveImageView.bottomAnchor.constraint(equalTo: clubImageView.bottomAnchor, constant: -12),
            reserveImageView.leadingAnchor.constraint(equalTo: numberOfLunokLabel.trailingAnchor, constant: 25),
            
            reserveLabel.leadingAnchor.constraint(equalTo: reserveImageView.trailingAnchor, constant: 11),
            reserveLabel.bottomAnchor.constraint(equalTo: clubImageView.bottomAnchor, constant: -10),
            
            userImageView.trailingAnchor.constraint(equalTo: clubImageView.trailingAnchor, constant: -13),
            userImageView.bottomAnchor.constraint(equalTo: clubImageView.bottomAnchor, constant: -13),
            
            priceLabel.trailingAnchor.constraint(equalTo: userImageView.leadingAnchor, constant: -5),
            priceLabel.bottomAnchor.constraint(equalTo: clubImageView.bottomAnchor, constant: -10),
            
            joinTheGameButton.topAnchor.constraint(equalTo: clubImageView.bottomAnchor, constant: 15),
            joinTheGameButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            joinTheGameButton.heightAnchor.constraint(equalToConstant: 41),
            joinTheGameButton.widthAnchor.constraint(equalToConstant: 185),
            
        ])
    }
}
