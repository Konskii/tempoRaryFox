////
////  Header_test.swift
////  Fox19
////
////  Created by Калинин Артем Валериевич on 28.11.2020.
////
//
//import Foundation
//import UIKit
//
//class Header {
//    
//    var clubPhoto = UIImageView()
//    var descriptionText = UILabel()
//    
//    private var orangePointer = UIImageView()
//    private var locationLabel = UILabel()
//    private var firstSeparator = UIView()
//    private var orangeFlag = UIImageView()
//    private var countOfHole = UILabel()
//    private var orangeResrve = UIImageView()
//    private var reserveLabel = UILabel()
//    private var rublLabel = UILabel()
//    private var gamePrice = UILabel()
//    private var orangePerson = UIImageView()
//    private var secondSeporator = UIView()
//    private var organaizerLabel = UILabel()
//    private var membersLable = UILabel()
//    
//    var game: Game?
//    var clubs: ClubsModel?
//    
//    init(game: Game?, clubs: ClubsModel?) {
//        self.game = game
//        self.clubs = clubs
//    }
//    
//    func setupFirst(header: UIView) {
//        
//        guard let game = game else {return}
//        
//        let number = LocalDataProvider.number
//        ClubsNetworkManager.shared.getAllClubs(for: number) { (result) in
//            switch result {
//            case .success(let clubs):
//                DispatchQueue.main.async {
//                    self.clubs = clubs
//                    for club in clubs.results where club.id == game.club.id {
//                        self.locationLabel.text = club.title
//                        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
//                        ClubsNetworkManager.shared.getImageForClubCover(for: account, clubId: club.id ?? 0) { (result) in
//                            switch result {
//                            case .success(let data):
//                                let url = data.results?.first?.image
//                                ClubsNetworkManager.shared.downloadImageForCover(from: url ?? "", account: account) { (result) in
//                                    switch result {
//                                    case .success(let data):
//                                        DispatchQueue.main.async {
//                                            self.clubPhoto.image = UIImage(data: data)
//                                        }
//                                    case .failure(let error):
//                                        print(error.localizedDescription)
//                                    }
//                                }
//                            case .failure(let error):
//                                print(error.localizedDescription)
//                            }
//                        }
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//        
//        if clubPhoto.image == nil {
//            clubPhoto.backgroundColor = .darkGray
//        }
//        clubPhoto.layer.cornerRadius = 6
//        clubPhoto.contentMode = .scaleToFill
//        clubPhoto.clipsToBounds = true
//        clubPhoto.translatesAutoresizingMaskIntoConstraints = false
//        
//        orangePointer.image = UIImage(named: "orangePointer")
//        orangePointer.contentMode = .scaleToFill
//        orangePointer.clipsToBounds = true
//        orangePointer.translatesAutoresizingMaskIntoConstraints = false
//        
//        locationLabel.textColor = UIColor(red: 0.178, green: 0.247, blue: 0.4, alpha: 1)
//        locationLabel.font = UIFont(name: "Avenir-Medium", size: 12)
//        locationLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        firstSeparator.backgroundColor = UIColor(red: 0.918, green: 0.925, blue: 0.937, alpha: 1)
//        firstSeparator.translatesAutoresizingMaskIntoConstraints = false
//        
//        orangeFlag.image = UIImage(named: "orangeFlag")
//        orangeFlag.contentMode = .scaleToFill
//        orangeFlag.clipsToBounds = true
//        orangeFlag.translatesAutoresizingMaskIntoConstraints = false
//        
//        countOfHole.text = String("\(game.holes ?? 0) лунок")
//        countOfHole.textColor = UIColor(red: 0.178, green: 0.247, blue: 0.4, alpha: 1)
//        countOfHole.font = UIFont(name: "Avenir-Book", size: 13)
//        countOfHole.translatesAutoresizingMaskIntoConstraints = false
//        
//        orangeResrve.image = UIImage(named: "orangeReserve")
//        orangeResrve.contentMode = .scaleToFill
//        orangeResrve.clipsToBounds = true
//        orangeResrve.translatesAutoresizingMaskIntoConstraints = false
//        
//        if game.reserved == true {
//            reserveLabel.text = "Забронировано"
//        } else {
//            reserveLabel.text = "Свободно"
//        }
//        reserveLabel.textColor = UIColor(red: 0.178, green: 0.247, blue: 0.4, alpha: 1)
//        reserveLabel.font = UIFont(name: "Avenir-Book", size: 13)
//        reserveLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        rublLabel.text = "₽"
//        rublLabel.textColor = UIColor(red: 1, green: 0.537, blue: 0, alpha: 1)
//        rublLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        gamePrice.text = "\(game.guestPrice ?? 0)/\(game.gamersCount ?? 0)"
//        gamePrice.textColor = UIColor(red: 0.178, green: 0.247, blue: 0.4, alpha: 1)
//        gamePrice.font = UIFont(name: "Avenir-Book", size: 13)
//        gamePrice.translatesAutoresizingMaskIntoConstraints = false
//        
//        orangePerson.image = UIImage(named: "orangePerson")
//        orangePerson.contentMode = .scaleToFill
//        orangePerson.clipsToBounds = true
//        orangePerson.translatesAutoresizingMaskIntoConstraints = false
//        
//        secondSeporator.backgroundColor = UIColor(red: 0.918, green: 0.925, blue: 0.937, alpha: 1)
//        secondSeporator.translatesAutoresizingMaskIntoConstraints = false
//        
//        descriptionText.text = String(game.description ?? "")
//        descriptionText.numberOfLines = 6
//        descriptionText.contentMode = .scaleAspectFill
//        descriptionText.lineBreakMode = .byTruncatingTail
//        descriptionText.textColor = UIColor(red: 0.314, green: 0.333, blue: 0.361, alpha: 1)
//        descriptionText.font = UIFont(name: "Avenir-Book", size: 17)
//        
//        descriptionText.translatesAutoresizingMaskIntoConstraints = false
//        
//        membersLable.text = "Организатор"
//        membersLable.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        membersLable.font = UIFont(name: "Avenir-Medium", size: 15)
//        membersLable.translatesAutoresizingMaskIntoConstraints = false
//        
//        header.addSubview(clubPhoto)
//        header.addSubview(orangePointer)
//        header.addSubview(locationLabel)
//        header.addSubview(firstSeparator)
//        header.addSubview(countOfHole)
//        header.addSubview(orangeResrve)
//        header.addSubview(orangeFlag)
//        header.addSubview(reserveLabel)
//        header.addSubview(rublLabel)
//        header.addSubview(gamePrice)
//        header.addSubview(orangePerson)
//        header.addSubview(secondSeporator)
//        header.addSubview(descriptionText)
//        header.addSubview(membersLable)
//        
//        let constraints = [
//            clubPhoto.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor, constant: 19),
//            clubPhoto.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 17),
//            clubPhoto.trailingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.trailingAnchor, constant: -15),
//            clubPhoto.heightAnchor.constraint(equalToConstant: 200),
//            
//            orangePointer.topAnchor.constraint(equalTo: clubPhoto.safeAreaLayoutGuide.bottomAnchor, constant: 20),
//            orangePointer.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 17),
//            orangePointer.heightAnchor.constraint(equalToConstant: 17),
//            orangePointer.widthAnchor.constraint(equalToConstant: 12),
//            
//            locationLabel.topAnchor.constraint(equalTo: clubPhoto.safeAreaLayoutGuide.bottomAnchor, constant: 20),
//            locationLabel.leadingAnchor.constraint(equalTo: orangePointer.safeAreaLayoutGuide.trailingAnchor, constant: 7),
//            
//            firstSeparator.topAnchor.constraint(equalTo: orangePointer.bottomAnchor, constant: 10),
//            firstSeparator.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 0),
//            firstSeparator.trailingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.trailingAnchor, constant: 0),
//            firstSeparator.heightAnchor.constraint(equalToConstant: 1),
//            
//            orangeFlag.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 15),
//            orangeFlag.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            orangeFlag.heightAnchor.constraint(equalToConstant: 17),
//            orangeFlag.widthAnchor.constraint(equalToConstant: 12),
//            
//            countOfHole.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 15),
//            countOfHole.leadingAnchor.constraint(equalTo: orangeFlag.safeAreaLayoutGuide.trailingAnchor, constant: 11),
//            
//            orangeResrve.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 15),
//            orangeResrve.leadingAnchor.constraint(equalTo: countOfHole.safeAreaLayoutGuide.trailingAnchor, constant: 50),
//            
//            reserveLabel.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 15),
//            reserveLabel.leadingAnchor.constraint(equalTo: orangeResrve.safeAreaLayoutGuide.trailingAnchor, constant: 7),
//            
//            orangePerson.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 15),
//            orangePerson.trailingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            
//            gamePrice.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 15),
//            gamePrice.trailingAnchor.constraint(equalTo: orangePerson.safeAreaLayoutGuide.leadingAnchor, constant: -2),
//            
//            rublLabel.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 15),
//            rublLabel.trailingAnchor.constraint(equalTo: gamePrice.safeAreaLayoutGuide.leadingAnchor, constant: -3),
//            
//            secondSeporator.topAnchor.constraint(equalTo: orangeFlag.bottomAnchor, constant: 15),
//            secondSeporator.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 0),
//            secondSeporator.trailingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.trailingAnchor, constant: 0),
//            secondSeporator.heightAnchor.constraint(equalToConstant: 1),
//            
//            descriptionText.topAnchor.constraint(equalTo: secondSeporator.bottomAnchor, constant: 10),
//            descriptionText.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 17),
//            descriptionText.trailingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.trailingAnchor, constant: -17),
//            
//            membersLable.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            membersLable.bottomAnchor.constraint(equalTo: header.safeAreaLayoutGuide.bottomAnchor, constant: 0)
//        ]
//        NSLayoutConstraint.activate(constraints)
//    }
//    
//    ///функция для динамичексого изменения высоты хэдера
//    func setupDescription(controllerWidth width: CGFloat, game: Game) -> CGFloat {
//        
//        descriptionText.text = game.description
//        let widthWithInset = width - 40
//        let descriptionLable = DynamicalLabelSize.height(text: descriptionText.text,
//                                                         font: descriptionText.font,
//                                                         width: widthWithInset)
//        let height = descriptionLable + 370
//        
//        return height
//    }
//    
//}
//
//
//
