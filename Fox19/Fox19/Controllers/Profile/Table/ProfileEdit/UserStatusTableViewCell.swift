//
//  UserStatusTableViewCell.swift
//  Fox19
//
//  Created by Артём Скрипкин on 25.11.2020.
//

import UIKit

protocol ManageUpdatedUserStatusProtocol: class {
    /// - Returns: Массив булевых значений статуса типа [Игрок, Тренер, Судья]
    func getStatuses() -> [Bool]
}

protocol SetUserStatusesProtocol: class {
    /// - Returns: user'а, данные статуса которого нужно заполнить
    func giveData() -> User?
}

class UserStatusTableViewCell: UITableViewCell {
    
    static let reusedId = "UserStatusTableViewCell"
    
    weak var delegate: SetUserStatusesProtocol?
    
    //MARK: - UI Elements
    private lazy var gamerStatusSwitch: UISwitch = {
        let view = UISwitch()
        view.onTintColor = UIColor(named: "orange")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var gamerStatusLabel: UILabel = {
        let view = UILabel()
        view.text = "Игрок"
        view.font = UIFont(name: "Avenir-Black", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trainerStatusSwitch: UISwitch = {
        let view = UISwitch()
        view.onTintColor = UIColor(named: "orange")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trainerStatusLabel: UILabel = {
        let view = UILabel()
        view.text = "Тренер"
        view.font = UIFont(name: "Avenir-Black", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var refereeStatusSwitch: UISwitch = {
        let view = UISwitch()
        view.onTintColor = UIColor(named: "orange")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var refereeStatusLabel: UILabel = {
        let view = UILabel()
        view.text = "Судья"
        view.font = UIFont(name: "Avenir-Black", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK: - Methods
    private func setupConstraints() {
        contentView.addSubview(gamerStatusSwitch)
        contentView.addSubview(gamerStatusLabel)
        contentView.addSubview(trainerStatusSwitch)
        contentView.addSubview(trainerStatusLabel)
        contentView.addSubview(refereeStatusSwitch)
        contentView.addSubview(refereeStatusLabel)
        
        let constraints = [
            gamerStatusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            gamerStatusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            gamerStatusSwitch.centerYAnchor.constraint(equalTo: gamerStatusLabel.centerYAnchor),
            gamerStatusSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            trainerStatusLabel.topAnchor.constraint(equalTo: gamerStatusLabel.bottomAnchor, constant: 20),
            trainerStatusLabel.leadingAnchor.constraint(equalTo: gamerStatusLabel.leadingAnchor),
            
            trainerStatusSwitch.centerYAnchor.constraint(equalTo: trainerStatusLabel.centerYAnchor),
            trainerStatusSwitch.trailingAnchor.constraint(equalTo: gamerStatusSwitch.trailingAnchor),
            
            refereeStatusLabel.topAnchor.constraint(equalTo: trainerStatusLabel.bottomAnchor, constant: 20),
            refereeStatusLabel.leadingAnchor.constraint(equalTo: gamerStatusLabel.leadingAnchor),
            
            refereeStatusSwitch.centerYAnchor.constraint(equalTo: refereeStatusLabel.centerYAnchor),
            refereeStatusSwitch.trailingAnchor.constraint(equalTo: gamerStatusSwitch.trailingAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: 110)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    public func configureSelector() {
        guard let user = delegate?.giveData() else { return }
        guard let isGamer = user.isGamer, let isTrainer = user.isTrainer, let isReferee = user.isReferee else { return }
        gamerStatusSwitch.isOn = isGamer
        trainerStatusSwitch.isOn = isTrainer
        refereeStatusSwitch.isOn = isReferee
    }
    
    //MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - manageUpdatedUserStatusProtocol
extension UserStatusTableViewCell: ManageUpdatedUserStatusProtocol {
    func getStatuses() -> [Bool] {
        return [
            gamerStatusSwitch.isOn,
            trainerStatusSwitch.isOn,
            refereeStatusSwitch.isOn
        ]
    }
}
