//
//  GameCollectionCell.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 14.01.2021.
//

import UIKit

class GameCollectionCell: UICollectionViewCell {
    private let separatorColor = UIColor(red: 225/255, green: 236/255, blue: 249/255, alpha: 1)
    private let primeColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
    static let reuseid = "GameCollectionCell"
    private(set) var clubImageView = UIImageView()
    private let locationLabel = UILabel(text: "НАЗВАНИЕ ГОЛЬФ-КЛУБА",
                                        font: UIFont(name: "Inter-Medium", size: 19),
                                        textColor: .white)
    
    private let gameNameLabel = UILabel(text: "Название игры",
                                    font: UIFont(name: "Inter-Medium", size: 13),
                                    textColor: .white)
    
    private lazy var dateLabel = UILabel(text: "",
                                    font: UIFont(name: "Inter-Regular", size: 15),
                                    textColor: primeColor)
    
    private lazy var creatorNameLabel = UILabel(text: "Мэттью Макконахи",
                                    font: UIFont(name: "Inter-Regular", size: 15),
                                    textColor: primeColor)
    private let separatorView = UIView()
    private(set) var imageView = UIImageView()
    
    
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
        setupConstraints()
        layer.cornerRadius = 8
        backgroundColor = .white
        
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = .none
        //Подумать
        
    }
    
    func cellConfigurator(game: GamesModel.Game) {
        locationLabel.text = game.club?.title?.uppercased()
        creatorNameLabel.text = game.user?.name
        dateLabel.text = "Дата проведения: \(game.date ?? ""), \(game.time?.dropLast(3) ?? "")"
        guard let account = UserDefaults.standard.string(forKey: "number") else { return }

        ClubsNetworkManager.shared.downloadImageForCover(from: game.user?.avatar?.url ?? "", account: account) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
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
        
    }
    
    private func setupElements() {
        clubImageView.backgroundColor = .lightGray
        clubImageView.layer.cornerRadius = 8
        clubImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clubImageView.clipsToBounds = true
        clubImageView.translatesAutoresizingMaskIntoConstraints = false
        
        locationLabel.numberOfLines = 0
        
        separatorView.backgroundColor = separatorColor
        
        imageView.backgroundColor = .darkGray
        imageView.layer.cornerRadius = 14.5
        imageView.clipsToBounds = true
        
        creatorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        gameNameLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(clubImageView)
        addSubview(locationLabel)
        addSubview(gameNameLabel)
        addSubview(dateLabel)
        addSubview(separatorView)
        addSubview(imageView)
        addSubview(creatorNameLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            clubImageView.topAnchor.constraint(equalTo: topAnchor),
            clubImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            clubImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            clubImageView.heightAnchor.constraint(equalToConstant: 89),
            
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            gameNameLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            gameNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            dateLabel.topAnchor.constraint(equalTo: clubImageView.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -8),
            separatorView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            
            imageView.widthAnchor.constraint(equalToConstant: 29),
            imageView.heightAnchor.constraint(equalToConstant: 29),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8),
            
            creatorNameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            creatorNameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
        ])
    }
}
