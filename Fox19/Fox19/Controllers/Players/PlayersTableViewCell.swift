//
//  PlayersTableViewCell.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 13.10.2020.
//

import UIKit

class PlayersTableViewCell: UITableViewCell {
    
    static let identifire = "PlayersTableViewCell"
    
    private var userPhoto = UIImageView()
    private var statusView = UIView()
    private var scoreView = UIView()
    private var quotes = UILabel()
    private var userName = UILabel()
    private var location = UILabel()
    private var scoreOfTeam = UILabel()
    private var statusOfTeam = UILabel()
    private var user: UserForExample?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupParametrs()
    }
    
    //Устанавливаем юзера на Вью
    func setup(user: UserForExample?) {
        guard let user = user else {return}
        userPhoto.image = user.userPhoto
        userName.text = user.userName
        location.text = user.location
        scoreOfTeam.text = user.score
        statusOfTeam.text = user.statusOfTeam
    }
    
    //Параметры
    func setupParametrs() {
        //Аватарка
        userPhoto.center = contentView.center
        userPhoto.layer.cornerRadius = 6
        userPhoto.contentMode = .scaleAspectFit
        userPhoto.clipsToBounds = true
        userPhoto.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(userPhoto)
        
        //Статус
        statusView.backgroundColor = #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1)
        statusView.layer.cornerRadius = 11 / 2
        statusView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusView)
        
        //Вью счета
        scoreView = UIView()
        scoreView.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1725490196, blue: 0.3058823529, alpha: 1)
        scoreView.layer.cornerRadius = 2
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scoreView)
        
        //Очки
        scoreOfTeam.center = scoreView.center
        scoreOfTeam.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        scoreOfTeam.font = .systemFont(ofSize: 10, weight: .regular)
        scoreOfTeam.textAlignment = .center
        scoreOfTeam.translatesAutoresizingMaskIntoConstraints = false
        scoreView.addSubview(scoreOfTeam)
        
        //Имя
        userName = UILabel()
        userName.textColor = #colorLiteral(red: 0.1098039216, green: 0.1725490196, blue: 0.3058823529, alpha: 1)
        userName.font = UIFont(name: "Avenir", size: 17.0)
        userName.font = .systemFont(ofSize: 17.0, weight: .semibold)
        userName.textAlignment = .center
        userName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(userName)
        
        //Локация
        location = UILabel()
        location.textColor = #colorLiteral(red: 0.1098039216, green: 0.1725490196, blue: 0.3058823529, alpha: 1)
        location.font = UIFont(name: "OpenSans-Regular", size: 12)
        location.font = .systemFont(ofSize: 12.0, weight: .light)
        location.textAlignment = .left
        location.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(location)
        
        //Кавычки
        quotes = UILabel()
        quotes.text = "″ "
        quotes.textColor = #colorLiteral(red: 0.1098039216, green: 0.1725490196, blue: 0.3058823529, alpha: 1)
        quotes.font = .systemFont(ofSize: 32.0, weight: .regular)
        quotes.textAlignment = .center
        quotes.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quotes)
        
        //Статус Команды
        statusOfTeam = UILabel()
        statusOfTeam.font = UIFont(name: "OpenSans-Regular", size: 12)
        statusOfTeam.textColor = #colorLiteral(red: 0.1098039216, green: 0.1725490196, blue: 0.3058823529, alpha: 1)
        statusOfTeam.font = .systemFont(ofSize: 12.0, weight: .regular)
        statusOfTeam.textAlignment = .left
        statusOfTeam.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusOfTeam)
        
        //Констрейнты
        let constraints = [
            //Устанавливаем фото юзера
            userPhoto.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            userPhoto.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 18),
            userPhoto.widthAnchor.constraint(equalToConstant: 77),
            userPhoto.heightAnchor.constraint(equalToConstant: 77),
            
            //Устанавливаем Вью Статуса
            statusView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            statusView.leftAnchor.constraint(equalTo: userPhoto.rightAnchor, constant: 21),
            statusView.widthAnchor.constraint(equalToConstant: 11),
            statusView.heightAnchor.constraint(equalToConstant: 11),
            
            //Устанавливаем имя
            userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userName.leftAnchor.constraint(equalTo: statusView.rightAnchor, constant: 6),
            
            //Устанавливаем Счет
            scoreView.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 15),
            scoreView.leftAnchor.constraint(equalTo: userPhoto.rightAnchor, constant: 23),
            scoreView.widthAnchor.constraint(equalToConstant: 18),
            scoreView.heightAnchor.constraint(equalToConstant: 16),
            
            //Устанавливаем Локацию
            location.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 9),
            location.leftAnchor.constraint(equalTo: scoreView.rightAnchor, constant: 14),
            
            //Устанавливаем Кавычки
            quotes.topAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: 4),
            quotes.leftAnchor.constraint(equalTo: userPhoto.rightAnchor, constant: 26),
            
            //Устанавливаем Статус(Собираем Команду)
            statusOfTeam.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 11),
            statusOfTeam.leftAnchor.constraint(equalTo: quotes.rightAnchor, constant: 17),
            
            //Устанавливаем Очки команды внутри вью
            scoreOfTeam.centerYAnchor.constraint(equalTo: self.scoreView.centerYAnchor),
            scoreOfTeam.centerXAnchor.constraint(equalTo: self.scoreView.centerXAnchor)
        ]
        
        contentView.setNeedsLayout()
        NSLayoutConstraint.activate(constraints)
        
    }
    
    //MARK: - VerticalConstraint
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
