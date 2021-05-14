//
//  DitailGameTableViewCell.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 19.01.2021.
//

import UIKit

class DitailGameTableViewCell: UITableViewCell {
    
    static let identifire = "DitailGameTableViewCell"
    private var mainImageView = UIImageView(imageName: nil,
                                            playerGandicap: nil,
                                            image: UIImage(named: "user"),
                                            fogLayer: false)
    
    private let emptyImageView = UIImageView(image: UIImage(named: "acceptButton"))
    private let messageImage = UIImageView(image: UIImage(named: "blueMessageIcon"))
    private let myLabel = UILabel(text: "Можно присоединиться",
                                  font: UIFont(name: "Inter-Medium", size: 15),
                                  textColor: #colorLiteral(red: 0.8274509804, green: 0.831372549, blue: 0.9294117647, alpha: 1))
    private let gandicap = UILabel(text: "0.0",
                                   font: UIFont(name: "Inter-Medium", size: 13),
                                   textColor: #colorLiteral(red: 0.8274509804, green: 0.831372549, blue: 0.9294117647, alpha: 1))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        addSubview(emptyImageView)
        addSubview(mainImageView)
        addSubview(myLabel)
        addSubview(messageImage)
        addSubview(gandicap)
        
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImage.translatesAutoresizingMaskIntoConstraints = false
        gandicap.translatesAutoresizingMaskIntoConstraints = false
        
        emptyImageView.tintColor = #colorLiteral(red: 0.8274509804, green: 0.831372549, blue: 0.9294117647, alpha: 1)
        //emptyImageView
        mainImageView.layer.cornerRadius = 32
        mainImageView.isHidden = true
        messageImage.isHidden = true
     //   gandicap.isHidden = true
        
        NSLayoutConstraint.activate([
            emptyImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emptyImageView.widthAnchor.constraint(equalToConstant: 64),
            emptyImageView.heightAnchor.constraint(equalToConstant: 64),
            
            mainImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainImageView.widthAnchor.constraint(equalToConstant: 64),
            mainImageView.heightAnchor.constraint(equalToConstant: 64),
            
            myLabel.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor, constant: -10),
            myLabel.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 27),
            
            messageImage.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
            messageImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            gandicap.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor, constant: 10),
            gandicap.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 27),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        mainImageView.isHidden = true
        messageImage.isHidden = true
     //   gandicap.isHidden = true
        gandicap.text = "0.0"
        emptyImageView.isHidden = false
        myLabel.text = "Можно присоединиться"
        myLabel.textColor = #colorLiteral(red: 0.8274509804, green: 0.831372549, blue: 0.9294117647, alpha: 1)
    }
    
    func setupCell(user: User?) {
        if user?.avatar != nil {
            downloadImageForAvatar(user: user)
        } else {
            mainImageView.image = UIImage(named: "user")
        }
        mainImageView.isHidden = false
        messageImage.isHidden = false
        gandicap.isHidden = false
        emptyImageView.isHidden = true
       
        gandicap.text = "\(user?.handicap ?? 0)"
        gandicap.textColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)
        myLabel.text = user?.name
       // myLabel.font = .avenir(fontSize: 15)
        myLabel.textColor =  UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    }
    
    private func downloadImageForAvatar(user: User?) {
        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
        ClubsNetworkManager.shared.downloadImageForCover(from: user?.avatar?.url ?? "", account: account) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.mainImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
