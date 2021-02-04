//
//  DetailTableViewCell.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 29.11.2020.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    static let cellID = "DetailTableViewCell"
    
    private let playerImageView = UIImageView()
    private let playerGandicak = UILabel()
    private let playerName = UILabel()
    private let sendButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(sendButton)
        addSubview(playerImageView)
        addSubview(playerGandicak)
        addSubview(playerName)
       // addSubview(sendButton)
        
        playerImageView.image =  UIImage(named: "ImageForTest")
        playerImageView.clipsToBounds = true
        playerImageView.layer.cornerRadius = 20
        playerImageView.layer.opacity = 0.5
        playerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        playerGandicak.text = "7"
        playerGandicak.font = UIFont(name: "Avenir-Light", size: 14)
        playerGandicak.translatesAutoresizingMaskIntoConstraints = false
        
        playerName.text = "My Name is!"
        playerName.font = UIFont(name: "Avenir-Light", size: 15)
        playerName.textColor = UIColor(red: 45/255, green: 63/255, blue: 102/255, alpha: 1)
        playerName.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "blueMessageIcon")?.withRenderingMode(.alwaysOriginal)
        sendButton.setImage(image, for: .normal)
        sendButton.addTarget(self, action: #selector(buttonTaped(button:)), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerImageView.heightAnchor.constraint(equalToConstant: 41),
            playerImageView.widthAnchor.constraint(equalToConstant: 41),
            playerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            playerImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            playerGandicak.centerXAnchor.constraint(equalTo: playerImageView.centerXAnchor),
            playerGandicak.centerYAnchor.constraint(equalTo: playerImageView.centerYAnchor),
            
            playerName.centerYAnchor.constraint(equalTo: centerYAnchor),
            playerName.leadingAnchor.constraint(equalTo: playerImageView.trailingAnchor, constant: 17),
            
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
        ])
    }
    
    @objc func buttonTaped(button: UIButton) {
        print("Button Tap")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSetup(userID: Int) {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        
        UserNetworkManager.shared.getUser(id: userID, token: token) { (result) in
            switch result {
            case .success(let member):
                DispatchQueue.main.async {
                    self.playerName.text = member.name
                    guard let handicap = member.handicap else { return }
                    self.playerGandicak.text = String(handicap)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
