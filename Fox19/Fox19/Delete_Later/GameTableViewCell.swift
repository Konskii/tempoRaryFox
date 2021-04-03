////
////  PlayersTableViewCell.swift
////  Fox19
////
////  Created by Калинин Артем Валериевич on 13.10.2020.
////
//
//import UIKit
//
////MARK: - Game VC
//class GamesTableViewCell: UITableViewCell {
//    
//    static let identifire = "GamesTableViewCell"
//    
//    private var clubImage = UIImageView()
//    private var locationLable = UILabel()
//    private var locationImage = UIImageView()
//    private var golfHoleLable = UILabel()
//    private var golfHoleImage = UIImageView()
//    private var reservImage = UIImageView()
//    private var reserveLable = UILabel()
//    private var priceImage = UIImageView()
//    private var priceLable = UILabel()
//    private var pricePersonImage = UIImageView()
//    private var imageUser1 = UIImageView()
//    private var imageUser2 = UIImageView()
//    private var handicapView = UIView()
//    private var handicap = UILabel()
//    private var addGameImage = UIImageView()
//    
//    let users = getUserInGame()
//    var usersFromApi = [User?]()
//    var gameID: Int?
//    var clubs: ClubsModel?
//    var organaizer: User?
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupClubImage()
//        setupConstraints()
//        setupLocationImage()
//        setupLocationLable()
//        setupGolfHoleImage()
//        setupGolfHoleLable()
//        setupReservImage()
//        setupReserveLable()
//        setupPriceLable()
//        setupPersoneImage()
//        setupHandicapView()
//        setupAddGame()
//        setupPlayersCount()
//        //            setupTapRecognizer()
//        setupImage(user: users)
//    }
//    
//    
//    //MARK: - Methods
//    
//    func setup(game: Game?) {
//        guard let gettingGame = game else {return}
//        gameID = gettingGame.id
//        clubImage.backgroundColor = .darkGray
//        golfHoleLable.text = String("\(gettingGame.holes ?? 0) лунок")
//        if gettingGame.reserved == true {
//            reserveLable.text = "Забронированно"
//        } else {
//            reserveLable.text = "Свободно"
//        }
//        priceLable.text = "₽\(gettingGame.guestPrice ?? 0)/\(gettingGame.gamersCount ?? 0)"
//        
//        /// - На время ремшил убрать интерактивность  "Присоединиться к игре"
//        
//        //        if usersFromApi.count >= gettingGame.gamersCount ?? 0 {
//        //            addGameImage.isHidden = true
//        //        }
//        
//        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
//        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
//        UserNetworkManager.shared.getUser(id: game?.user.id, token: token) { [weak self] (result) in
//            guard let self = self else {return}
//            switch result {
//            case .success(let organaizer):
//                DispatchQueue.main.async {
//                    self.organaizer = organaizer
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    func setupImage(with clubId: Int) {
//        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
//        ClubsNetworkManager.shared.getAllClubs(for: number) { [weak self] (result) in
//            guard let self = self else {return}
//            switch result {
//            case .success(let clubs):
//                DispatchQueue.main.async {
//                    self.clubs = clubs
//                    for club in clubs.results where club.id == clubId {
//                        self.locationLable.text = club.title
//                        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
//                        ClubsNetworkManager.shared.getImageForClubCover(for: account, clubId: club.id ?? 0) { (result) in
//                            switch result {
//                            case .success(let data):
//                                let url = data.results?.first?.image
//                                ClubsNetworkManager.shared.downloadImageForCover(from: url ?? "", account: account) { (result) in
//                                    switch result {
//                                    case .success(let data):
//                                        DispatchQueue.main.async {
//                                            self.clubImage.image = UIImage(data: data)
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
//    }
//    
//    
//    func setupPlayers(gameID: Int) {
//        if self.usersFromApi.isEmpty {
//            GamesNetworkManager.shared.getMembers(gameID: gameID) { [weak self] (result) in
//                guard let self = self else {return}
//                switch result {
//                case .success(let members):
//                    
//                    if members.results.count > 0 {
//                        for member in members.results {
//                            guard let playerID = member.user?.id else {return}
//                            guard let account = UserDefaults.standard.string(forKey: "number") else { return }
//                            guard let token = Keychainmanager.shared.getToken(account: account) else { return }
//                            UserNetworkManager.shared.getUser(id: playerID, token: token) { (result) in
//                                switch result {
//                                case .success(let user):
//                                    self.usersFromApi.append(user)
//                                    DispatchQueue.main.async {
//                                        if self.usersFromApi[0]?.handicap != nil {
//                                            self.handicap.text = "\(String(describing: self.usersFromApi[0]?.handicap ?? 0))"
//                                        } else {
//                                            self.handicap.text = "0.0"
//                                        }
//                                        self.checkCurrentUserInGame()
//                                    }
//                                case .failure(let error):
//                                    print(error.localizedDescription)
//                                }
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.handicap.text = "\(String(describing: self.organaizer?.handicap ?? 0.0))"
//                        }
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//    
//    /// Если текущий пользователь уже присоединился к игре, то кнопка "Присоединиться к игре" не будет доступна
//    func checkCurrentUserInGame() {
//        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
//        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
//        UserNetworkManager.shared.getUser(id: nil, token: token) { [weak self] (result) in
//            guard let self = self else {return}
//            switch result {
//            case .success(let currentUser):
//                DispatchQueue.main.async {
//                    
//                    //                    for user in self.usersFromApi where user?.id == currentUser.id {
//                    //                        self.addGameImage.isHidden = true
//                    //                    }
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    ///Устанавливаем Нажатие на "Присоединиться к игре"
//    //    private func setupTapRecognizer() {
//    //        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapToAddGame))
//    //        addGameImage.isUserInteractionEnabled = true
//    //        addGameImage.addGestureRecognizer(gesture)
//    //    }
//    //
//    //    @objc func didTapToAddGame() {
//    //        print("Tap on Add to Game")
//    //        guard let gameID = gameID else { return }
//    //        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
//    //        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
//    //
//    //        UserNetworkManager.shared.getUser(id: nil, token: token) { [weak self] (result) in
//    //            guard let self = self else {return}
//    //            switch result {
//    //            case .success(let currentUser):
//    //                DispatchQueue.main.async {
//    //                    self.addGameImage.isHidden = true
//    //                }
//    //
//    //                GamesNetworkManager.shared.addToGame(gameID: gameID, userID: currentUser.id ?? 0) { [weak self] (result) in
//    //                    guard let self = self else {return}
//    //                    switch result {
//    //                    case .success(_): break
//    //                    case .failure(let error):
//    //                        print(error.localizedDescription)
//    //                    }
//    //                }
//    //
//    //            case .failure(let error):
//    //                print(error.localizedDescription)
//    //            }
//    //        }
//    //    }
//    
//    //MARK: - Parametrs
//    private func setupClubImage() {
//        //Фото
//        clubImage.layer.cornerRadius = 6
//        clubImage.contentMode = .scaleToFill
//        clubImage.clipsToBounds = true
//        clubImage.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    //Картинка локации
//    private func setupLocationImage() {
//        locationImage.image = UIImage(named: "location")
//        locationImage.contentMode = .scaleAspectFit
//        locationImage.clipsToBounds = true
//        locationImage.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    //Название локации
//    private func setupLocationLable() {
//        locationLable.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        locationLable.font = UIFont(name: "Avenir-Medium", size: 12)
//        locationLable.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    //Картинка флажок
//    private func setupGolfHoleImage() {
//        golfHoleImage.image = UIImage(named: "flag")
//        golfHoleImage.contentMode = .scaleAspectFit
//        golfHoleImage.clipsToBounds = true
//        golfHoleImage.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    //Количество лунок
//    private func setupGolfHoleLable() {
//        golfHoleLable.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        golfHoleLable.font = UIFont(name: "Avenir-Book", size: 13)
//        golfHoleLable.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    //Картинка резерв
//    private func setupReservImage() {
//        reservImage.image = UIImage(named: "reserve")
//        reservImage.contentMode = .scaleAspectFit
//        reservImage.clipsToBounds = true
//        reservImage.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    //Бронь да/нет
//    private func setupReserveLable() {
//        reserveLable.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        reserveLable.font = UIFont(name: "Avenir-Book", size: 13)
//        reserveLable.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    //Цена
//    private func setupPriceLable() {
//        priceLable.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        priceLable.font = UIFont(name: "Avenir-Book", size: 13)
//        priceLable.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    //Картинка Персона
//    private func setupPersoneImage() {
//        pricePersonImage.image = UIImage(named: "person")
//        pricePersonImage.contentMode = .scaleAspectFit
//        pricePersonImage.clipsToBounds = true
//        pricePersonImage.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    //Добавить юзеров
//    private func setupImage(user: [UserInClubs]) {
//        
//        //TODO: - Варианты если игроков меньше двух
//        
//        guard !(users.isEmpty) else {return}
//        
//        imageUser1.image = user[0].image
//        imageUser1.layer.cornerRadius = 41 / 2
//        imageUser1.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
//        imageUser1.contentMode = .scaleAspectFit
//        imageUser1.clipsToBounds = true
//        imageUser1.translatesAutoresizingMaskIntoConstraints = false
//        
//        imageUser2.image = user[1].image
//        imageUser2.layer.cornerRadius = 41 / 2
//        imageUser2.layer.borderWidth = 2
//        imageUser2.contentMode = .scaleAspectFit
//        imageUser2.clipsToBounds = true
//        imageUser2.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
//        imageUser2.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//    }
//    
//    private func setupHandicapView() {
//        handicapView.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1725490196, blue: 0.3058823529, alpha: 0.5)
//        handicapView.contentMode = .scaleAspectFit
//        handicapView.clipsToBounds = true
//        handicapView.layer.cornerRadius = 41 / 2
//        handicapView.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    private func setupAddGame() {
//        addGameImage.image = UIImage(named: "addGame")
//        addGameImage.contentMode = .scaleAspectFit
//        addGameImage.clipsToBounds = true
//        addGameImage.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    private func setupPlayersCount() {
//        handicap.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        handicap.font = UIFont(name: "Avenir-Medium", size: 14)
//        handicap.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    //MARK: - Constraints
//    
//    func setupConstraints() {
//        contentView.addSubview(clubImage)
//        contentView.addSubview(imageUser1)
//        contentView.addSubview(imageUser2)
//        contentView.addSubview(addGameImage)
//        imageUser1.addSubview(handicapView)
//        handicapView.addSubview(handicap)
//        clubImage.addSubview(locationImage)
//        clubImage.addSubview(locationLable)
//        clubImage.addSubview(golfHoleImage)
//        clubImage.addSubview(golfHoleLable)
//        clubImage.addSubview(reservImage)
//        clubImage.addSubview(reserveLable)
//        clubImage.addSubview(priceLable)
//        clubImage.addSubview(pricePersonImage)
//        
//        let constraints = [
//            //Устанавливаем фото юзера
//            clubImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
//            clubImage.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 17),
//            clubImage.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -15),
//            clubImage.bottomAnchor.constraint(equalTo: imageUser1.safeAreaLayoutGuide.bottomAnchor, constant: -16),
//            
//            locationImage.topAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.topAnchor, constant: 24),
//            locationImage.leftAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.leftAnchor, constant: 14),
//            
//            locationImage.widthAnchor.constraint(equalToConstant: 12),
//            locationImage.heightAnchor.constraint(equalToConstant: 16),
//            
//            locationLable.topAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.topAnchor, constant: 24),
//            locationLable.leftAnchor.constraint(equalTo: locationImage.safeAreaLayoutGuide.rightAnchor, constant: 7),
//            
//            golfHoleImage.leftAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.leftAnchor, constant: 14),
//            golfHoleImage.bottomAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.bottomAnchor, constant: -11),
//            golfHoleImage.widthAnchor.constraint(equalToConstant: 12),
//            golfHoleImage.heightAnchor.constraint(equalToConstant: 16),
//            
//            golfHoleLable.leftAnchor.constraint(equalTo: golfHoleImage.safeAreaLayoutGuide.rightAnchor, constant: 14),
//            golfHoleLable.bottomAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.bottomAnchor, constant: -11),
//            
//            reservImage.leftAnchor.constraint(equalTo: golfHoleLable.safeAreaLayoutGuide.rightAnchor, constant: 25),
//            reservImage.bottomAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.bottomAnchor, constant: -11),
//            
//            reserveLable.leftAnchor.constraint(equalTo: reservImage.safeAreaLayoutGuide.rightAnchor, constant: 7),
//            reserveLable.bottomAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.bottomAnchor, constant: -11),
//            
//            pricePersonImage.rightAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.rightAnchor, constant: -20),
//            pricePersonImage.bottomAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.bottomAnchor, constant: -11),
//            
//            priceLable.rightAnchor.constraint(equalTo: pricePersonImage.safeAreaLayoutGuide.leftAnchor, constant: -3),
//            priceLable.bottomAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.bottomAnchor, constant: -11),
//            
//            imageUser1.topAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.bottomAnchor, constant: 15),
//            imageUser1.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 25),
//            imageUser1.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//            imageUser1.widthAnchor.constraint(equalToConstant: 41),
//            imageUser1.heightAnchor.constraint(equalToConstant: 41),
//            
//            imageUser2.topAnchor.constraint(equalTo: clubImage.safeAreaLayoutGuide.bottomAnchor, constant: 15),
//            imageUser2.leftAnchor.constraint(equalTo: imageUser1.safeAreaLayoutGuide.rightAnchor, constant: -3),
//            imageUser2.widthAnchor.constraint(equalToConstant: 41),
//            imageUser2.heightAnchor.constraint(equalToConstant: 41),
//            
//            handicapView.topAnchor.constraint(equalTo: imageUser1.topAnchor, constant: 0),
//            handicapView.leftAnchor.constraint(equalTo: imageUser1.leftAnchor, constant: 0),
//            handicapView.rightAnchor.constraint(equalTo: imageUser1.rightAnchor, constant: 0),
//            handicapView.bottomAnchor.constraint(equalTo: imageUser1.bottomAnchor, constant: 0),
//            handicapView.widthAnchor.constraint(equalToConstant: 41),
//            handicapView.heightAnchor.constraint(equalToConstant: 41),
//            
//            addGameImage.topAnchor.constraint(equalTo: clubImage.bottomAnchor, constant: 15),
//            addGameImage.leftAnchor.constraint(equalTo: imageUser2.rightAnchor, constant: 15),
//            addGameImage.widthAnchor.constraint(equalToConstant: 184),
//            addGameImage.heightAnchor.constraint(equalToConstant: 41),
//            
//            handicap.centerYAnchor.constraint(equalTo: handicapView.centerYAnchor, constant: 0),
//            handicap.centerXAnchor.constraint(equalTo: handicapView.centerXAnchor, constant: 0),
//        ]
//        
//        contentView.setNeedsLayout()
//        NSLayoutConstraint.activate(constraints)
//    }
//    
//    
//    //MARK: - VerticalConstraint
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
