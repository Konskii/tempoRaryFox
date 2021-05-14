////
////  DetailCell.swift
////  Fox19
////
////  Created by Калинин Артем Валериевич on 31.10.2020.
////
//
//import UIKit
//
//class PlayersCell: UITableViewCell {
//    
//    static let identifire = "PlayersCell"
//    
//    private var playerPhoto = UIImageView()
//    private var playerName = UILabel()
//    private var blueMessageButton = UIButton(type: .system)
//    private var handicapView = UIView()
//    private var handicap = UILabel()
//    private var canAddImage = UIImageView()
//    private var canAddView = UIView()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupMessageButton()
//        setupConstraints()
//        setHandivapView()
//        setUsersPhoto()
//        setUserPhoto()
//        setHandicap()
//    }
//    
//    func setupPlayer(with player: User?) {
//        guard let player = player else {return}
//        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
//        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
//        
//        UserNetworkManager.shared.getUser(id: nil, token: token) { [weak self] (result) in
//            guard let self = self else {return}
//            switch result {
//            case .success(let currentUser):
//                if player.id == currentUser.id {
//                    DispatchQueue.main.async {
//                        self.blueMessageButton.isHidden = true
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.blueMessageButton.isHidden = false
//                    }
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        
//        playerPhoto.image = UIImage(named: "user")
//        playerName.text = player.name
//        if player.handicap == nil {
//            handicap.text = "0.0"
//        } else {
//            handicap.text = "\(player.handicap ?? 0.0)"
//        }
//    }
//    
//    func setupOrganizer(with user: User?) {
//        guard let user = user else {return}
//        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
//        guard let token = Keychainmanager.shared.getToken(account: account) else { return }
//        
//        playerPhoto.image = UIImage(named: "user")
//        playerName.text = user.name
//        handicap.text = "\(user.handicap ?? 0.0)"
//        
//        UserNetworkManager.shared.getUser(id: nil, token: token) { [weak self] (result) in
//            guard let self = self else {return}
//            switch result {
//            case .success(let currentUser):
//                if user.id == currentUser.id {
//                    DispatchQueue.main.async {
//                        self.blueMessageButton.isHidden = true
//                    }
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    private func setUserPhoto() {
//        playerName.textColor = UIColor(red: 0.178, green: 0.247, blue: 0.4, alpha: 1)
//        playerName.font = UIFont(name: "Avenir-Medium", size: 15)
//        playerName.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    private func setUsersPhoto() {
//        playerPhoto.layer.cornerRadius = 41 / 2
//        playerPhoto.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
//        playerPhoto.contentMode = .scaleAspectFit
//        playerPhoto.clipsToBounds = true
//        playerPhoto.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    private func setHandivapView() {
//        handicapView.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1725490196, blue: 0.3058823529, alpha: 0.5)
//        handicapView.contentMode = .scaleAspectFit
//        handicapView.clipsToBounds = true
//        handicapView.layer.cornerRadius = 41 / 2
//        handicapView.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    private func setHandicap() {
//        handicap.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        handicap.font = UIFont(name: "Avenir-Medium", size: 14)
//        handicap.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    private func setupMessageButton() {
//        let image = UIImage(named: "blueMessageIcon")?.withRenderingMode(.alwaysOriginal)
//        blueMessageButton.setImage(image, for: .normal)
//        blueMessageButton.tintColor = .black
//        blueMessageButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
//        blueMessageButton.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    @objc func pressButton(button: UIButton) {
//        print("Send")
//    }
//    
//    private func setupConstraints() {
//        contentView.addSubview(playerPhoto)
//        contentView.addSubview(playerName)
//        contentView.addSubview(blueMessageButton)
//        playerPhoto.addSubview(handicapView)
//        handicapView.addSubview(handicap)
//        
//        let constraints = [
//            playerPhoto.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
//            playerPhoto.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            playerPhoto.widthAnchor.constraint(equalToConstant: 41),
//            playerPhoto.heightAnchor.constraint(equalToConstant: 41),
//            
//            playerName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
//            playerName.leadingAnchor.constraint(equalTo: playerPhoto.safeAreaLayoutGuide.trailingAnchor, constant: 16),
//            
//            blueMessageButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -30),
//            blueMessageButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
//            
//            handicapView.topAnchor.constraint(equalTo: playerPhoto.topAnchor, constant: 0),
//            handicapView.leftAnchor.constraint(equalTo: playerPhoto.leftAnchor, constant: 0),
//            handicapView.rightAnchor.constraint(equalTo: playerPhoto.rightAnchor, constant: 0),
//            handicapView.bottomAnchor.constraint(equalTo: playerPhoto.bottomAnchor, constant: 0),
//            handicapView.widthAnchor.constraint(equalToConstant: 41),
//            handicapView.heightAnchor.constraint(equalToConstant: 41),
//            
//            handicap.centerYAnchor.constraint(equalTo: handicapView.centerYAnchor, constant: 0),
//            handicap.centerXAnchor.constraint(equalTo: handicapView.centerXAnchor, constant: 0),
//        ]
//        NSLayoutConstraint.activate(constraints)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
