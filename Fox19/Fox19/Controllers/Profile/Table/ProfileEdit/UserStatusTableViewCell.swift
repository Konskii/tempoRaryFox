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
    
    private var handicapValues: [Double] = []
    
    private var currentHandicapNumber: Int = 0
    
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
    
    private lazy var stepper: UIStepper = {
        let view = UIStepper()
        view.maximumValue = 54.0
        view.minimumValue = +10.0
        view.stepValue = 0.1
        view.addTarget(self,
                       action: #selector(changeValue),
                       for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var handicapLabel: UILabel = {
        let view = UILabel()
        view.text = "Гандикап:"
        view.font = UIFont(name: "Avenir-Black", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var handicapValue: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Avenir-Book", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Methods
    private func setupConstraints() {
        contentView.addSubview(gamerStatusSwitch)
        contentView.addSubview(gamerStatusLabel)
        contentView.addSubview(trainerStatusSwitch)
        contentView.addSubview(trainerStatusLabel)
        contentView.addSubview(handicapLabel)
        contentView.addSubview(handicapValue)
        contentView.addSubview(stepper)
        
        NSLayoutConstraint.activate([
            gamerStatusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            gamerStatusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            
            gamerStatusSwitch.centerYAnchor.constraint(equalTo: gamerStatusLabel.centerYAnchor),
            gamerStatusSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -55),
            
            trainerStatusLabel.topAnchor.constraint(equalTo: gamerStatusLabel.bottomAnchor, constant: 20),
            trainerStatusLabel.leadingAnchor.constraint(equalTo: gamerStatusLabel.leadingAnchor),
            
            trainerStatusSwitch.centerYAnchor.constraint(equalTo: trainerStatusLabel.centerYAnchor),
            trainerStatusSwitch.trailingAnchor.constraint(equalTo: gamerStatusSwitch.trailingAnchor),
            
            handicapLabel.topAnchor.constraint(equalTo: trainerStatusLabel.bottomAnchor, constant: 30),
            handicapLabel.leadingAnchor.constraint(equalTo: gamerStatusLabel.leadingAnchor),
            
            handicapValue.leadingAnchor.constraint(equalTo: gamerStatusLabel.leadingAnchor),
            handicapValue.topAnchor.constraint(equalTo: handicapLabel.bottomAnchor, constant: 15),
            
            stepper.trailingAnchor.constraint(equalTo: gamerStatusSwitch.trailingAnchor),
            stepper.centerYAnchor.constraint(equalTo: handicapValue.centerYAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    public func configureSelector() {
        guard let user = delegate?.giveData() else { return }
        guard let isGamer = user.isGamer,
              let isTrainer = user.isTrainer else { return }
        gamerStatusSwitch.isOn = isGamer
        trainerStatusSwitch.isOn = isTrainer
        handicapValue.text = "\(user.handicap ?? 0.0)"
        handicapValues.forEach({ if let handic = user.handicap, handic == $0 { print($0)}})
    }
    
    @objc private func changeValue() {
        
        print(stepper.value)
    }
    
    //MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        var val: Double = 0.0
        var tenVal: Double = 10.1
        
        for _ in 0...100 {
            tenVal -= 0.1
            handicapValues += [Double("+" + tenVal.removeZerosFromEnd()) ?? 0]
        }
        for _ in 0...539 {
            val += 0.1
            handicapValues += [Double(val.removeZerosFromEnd()) ?? 0]
        }
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
        ]
    }
}
