//
//  GameCreateView.swift
//  Fox19
//
//  Created by Артём Скрипкин on 17.11.2020.
//

import UIKit
///fileprivate тк этот класс используется и в дргом экране и сделано это чтобы сделать эти классы более автономными
fileprivate class HolesSegmentControll: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 35
        layer.masksToBounds = true
    }
}

protocol GetDataFromGameCreateViewProtocol: class {
    func dataFilled(data: GameCreateModel?)
    func needToShowErrorAlert(message: String)
    func needToShowSelectClubVC()
}

class GameCreateView: UIView {
    
    //MARK: - Delegates
    weak var delegate: GetDataFromGameCreateViewProtocol?
    
    //MARK: - Variables
    private var date = ""
    
    private var time = ""
    
    private var selectedClubId = 1
    
    private var userID: Int?
    
    //MARK: - UI Elements
    private lazy var gameNameLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.745, green: 0.761, blue: 0.808, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "Название игры"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var gameNameField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.textColor = UIColor(red: 0.119, green: 0.143, blue: 0.194, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIImageView(image: UIImage(named: "ProfileSeparator"))
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        separator.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 4).isActive = true
        separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        return view
    }()
    
    private lazy var gameDescriptionLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.745, green: 0.761, blue: 0.808, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "Описание игры"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var gameDescriptionField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.textColor = UIColor(red: 0.119, green: 0.143, blue: 0.194, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIImageView(image: UIImage(named: "ProfileSeparator"))
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        separator.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 4).isActive = true
        separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        return view
    }()
    
    private lazy var clubsLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.745, green: 0.761, blue: 0.808, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "Клуб"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var selectedClubLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.119, green: 0.143, blue: 0.194, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Московский Городской Гольф Клуб"
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedClubPressed)))
        
        let separator = UIImageView(image: UIImage(named: "ProfileSeparator"))
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        separator.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 4).isActive = true
        separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        return view
    }()
    
    private lazy var gameDetailLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "Детали игры"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var holesSegmentControll: HolesSegmentControll = {
        let view = HolesSegmentControll()
        view.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1)], for: .normal)
        if let orangeColor = UIColor(named: "orange") {
            view.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : orangeColor], for: .selected)
        }
        view.selectedSegmentTintColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1)
        view.insertSegment(withTitle: "18", at: 0, animated: true)
        view.setImage(UIImage(named: "18lunok"), forSegmentAt: 0)
        view.insertSegment(withTitle: "9", at: 1, animated: true)
        view.setImage(UIImage(named: "9lunok"), forSegmentAt: 1)
        view.selectedSegmentIndex = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var playersCountLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.745, green: 0.761, blue: 0.808, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "Количество игроков"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var playersCountField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.keyboardType = .numberPad
        view.textColor = UIColor(red: 0.119, green: 0.143, blue: 0.194, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIImageView(image: UIImage(named: "ProfileSeparator"))
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        separator.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 4).isActive = true
        separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        return view
    }()
    
    private lazy var dateAndTimeLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.745, green: 0.761, blue: 0.808, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "Дата и время"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.minimumDate =  .init(timeIntervalSinceNow: 0)
        view.addTarget(self, action: #selector(setDate), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var pricesLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.745, green: 0.761, blue: 0.808, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "Стоимость участия"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var guestPriceLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.119, green: 0.143, blue: 0.194, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 17)
        view.text = "Гость"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var guestPriceField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.keyboardType = .numberPad
        view.textColor = UIColor(red: 0.119, green: 0.143, blue: 0.194, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 17)
        view.placeholder = "Стоимость"
        view.textAlignment = .right
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIImageView(image: UIImage(named: "ProfileSeparator"))
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        separator.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 4).isActive = true
        separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        return view
    }()
    
    private lazy var memberPriceLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.119, green: 0.143, blue: 0.194, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 17)
        view.text = "Член клуба"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var memberPriceField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.keyboardType = .numberPad
        view.textColor = UIColor(red: 0.119, green: 0.143, blue: 0.194, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 17)
        view.placeholder = "Стоимость"
        view.textAlignment = .right
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIImageView(image: UIImage(named: "ProfileSeparator"))
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        separator.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 4).isActive = true
        separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        return view
    }()
    
    private lazy var fieldStatusLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.745, green: 0.761, blue: 0.808, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "Статус поля"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var shieldImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "security")
        view.tintColor = UIColor(red: 0.178, green: 0.247, blue: 0.4, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reservationLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.178, green: 0.247, blue: 0.4, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 13)
        view.text = "Забронировать"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reservationSwitch: UISwitch = {
        let view = UISwitch()
        view.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        view.onTintColor = UIColor(named: "orange")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Setting up constraints
    
    private func setupConstraints() {
        addSubview(gameNameLabel)
        addSubview(gameNameField)
        addSubview(gameDetailLabel)
        addSubview(gameDescriptionLabel)
        addSubview(gameDescriptionField)
        addSubview(clubsLabel)
        addSubview(selectedClubLabel)
        addSubview(holesSegmentControll)
        addSubview(playersCountLabel)
        addSubview(playersCountField)
        addSubview(dateAndTimeLabel)
        addSubview(datePicker)
        addSubview(pricesLabel)
        addSubview(guestPriceLabel)
        addSubview(guestPriceField)
        addSubview(memberPriceLabel)
        addSubview(memberPriceField)
        addSubview(fieldStatusLabel)
        addSubview(shieldImageView)
        addSubview(reservationLabel)
        addSubview(reservationSwitch)
        
        let constraints = [
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            heightAnchor.constraint(equalToConstant: 920),
            
            gameNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 38),
            gameNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            
            gameNameField.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 10),
            gameNameField.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            gameNameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            gameDescriptionLabel.topAnchor.constraint(equalTo: gameNameField.bottomAnchor, constant: 15),
            gameDescriptionLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            
            gameDescriptionField.topAnchor.constraint(equalTo: gameDescriptionLabel.bottomAnchor, constant: 10),
            gameDescriptionField.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            gameDescriptionField.trailingAnchor.constraint(equalTo: gameNameField.trailingAnchor),
            
            clubsLabel.topAnchor.constraint(equalTo: gameDescriptionField.bottomAnchor, constant: 15),
            clubsLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            
            selectedClubLabel.topAnchor.constraint(equalTo: clubsLabel.bottomAnchor, constant: 10),
            selectedClubLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            selectedClubLabel.trailingAnchor.constraint(equalTo: gameNameField.trailingAnchor),
            
            gameDetailLabel.topAnchor.constraint(equalTo: selectedClubLabel.bottomAnchor, constant: 40),
            gameDetailLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            
            holesSegmentControll.heightAnchor.constraint(equalToConstant: 65),
            holesSegmentControll.topAnchor.constraint(equalTo: gameDetailLabel.bottomAnchor, constant: 45),
            holesSegmentControll.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor, constant: 2),
            holesSegmentControll.trailingAnchor.constraint(equalTo: gameNameField.trailingAnchor),
            
            playersCountLabel.topAnchor.constraint(equalTo: holesSegmentControll.bottomAnchor, constant: 40),
            playersCountLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            
            playersCountField.topAnchor.constraint(equalTo: playersCountLabel.bottomAnchor, constant: 10),
            playersCountField.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            playersCountField.trailingAnchor.constraint(equalTo: gameNameField.trailingAnchor),
            
            dateAndTimeLabel.topAnchor.constraint(equalTo: playersCountField.bottomAnchor, constant: 30),
            dateAndTimeLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            
            datePicker.topAnchor.constraint(equalTo: dateAndTimeLabel.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            
            pricesLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 40),
            pricesLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            
            guestPriceLabel.topAnchor.constraint(equalTo: pricesLabel.bottomAnchor, constant: 10),
            guestPriceLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            
            guestPriceField.topAnchor.constraint(equalTo: pricesLabel.bottomAnchor, constant: 10),
            guestPriceField.leadingAnchor.constraint(equalTo: guestPriceLabel.trailingAnchor, constant: 5),
            guestPriceField.trailingAnchor.constraint(equalTo: gameNameField.trailingAnchor),
            
            memberPriceLabel.topAnchor.constraint(equalTo: guestPriceLabel.bottomAnchor, constant: 23),
            memberPriceLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            
            memberPriceField.topAnchor.constraint(equalTo: guestPriceField.bottomAnchor, constant: 20),
            memberPriceField.leadingAnchor.constraint(equalTo: memberPriceLabel.trailingAnchor, constant: 5),
            memberPriceField.trailingAnchor.constraint(equalTo: gameNameField.trailingAnchor),
            
            fieldStatusLabel.topAnchor.constraint(equalTo: memberPriceField.bottomAnchor, constant: 70),
            fieldStatusLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            
            reservationSwitch.topAnchor.constraint(equalTo: fieldStatusLabel.bottomAnchor, constant: 35),
            reservationSwitch.trailingAnchor.constraint(equalTo: gameNameField.trailingAnchor),
            
            shieldImageView.centerYAnchor.constraint(equalTo: reservationSwitch.centerYAnchor),
            shieldImageView.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            
            reservationLabel.leadingAnchor.constraint(equalTo: shieldImageView.trailingAnchor, constant: 7),
            reservationLabel.centerYAnchor.constraint(equalTo: shieldImageView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - UserIneraction Methods
    @objc private func selectedClubPressed() {
        delegate?.needToShowSelectClubVC()
    }
    
    @objc func switchValueDidChange(sender:UISwitch!) {
        if sender.isOn {
            shieldImageView.image = UIImage(named: "reservationOn")
            reservationLabel.text = "Забронированно"
        } else {
            shieldImageView.image = UIImage(named: "reservationOff")
            reservationLabel.text = "Забронировать"
        }
    }
    
    //MARK: - Methods
    private func checkIsFilled() {
        guard let gameName = gameNameField.text, gameNameField.text != "" else { delegate?.dataFilled(data: nil); return }
        guard let gameDescription = gameDescriptionField.text, gameDescriptionField.text != "" else { delegate?.dataFilled(data: nil); return }
        guard let gamePlayersCount = playersCountField.text, playersCountField.text != "" else { delegate?.dataFilled(data: nil); return }
        guard let gameGuestPrice = guestPriceField.text, guestPriceField.text != "" else { delegate?.dataFilled(data: nil); return }
        guard let gameMemberPrice = memberPriceField.text, memberPriceField.text != "" else { delegate?.dataFilled(data: nil); return }
        guard let id = userID else { delegate?.dataFilled(data: nil); return }
        guard let intGuestPrice = Int(gameGuestPrice) else { delegate?.dataFilled(data: nil); return }
        guard let intMemberPrice = Int(gameMemberPrice) else { delegate?.dataFilled(data: nil); return }
        guard let intGamersCount = Int(gamePlayersCount) else { delegate?.dataFilled(data: nil); return }
        var holes = 9
        if holesSegmentControll.selectedSegmentIndex == 0 {
            holes = 18
        }
        
        delegate?.dataFilled(data: .init(date: date, description: gameDescription, time: time, name: gameName, guestPrice: intGuestPrice, memberPrice: intMemberPrice, userId: id, clubId: selectedClubId, holes: holes, gamersCount: intGamersCount, reserved: reservationSwitch.isOn))
    }
    
    private func setCurrentUserId() {
        guard let account = UserDefaults.standard.string(forKey: "number") else { delegate?.needToShowErrorAlert(message: "account error"); return }
        guard let token = Keychainmanager.shared.getToken(account: account) else { delegate?.needToShowErrorAlert(message: "token error"); return }
        UserNetworkManager.shared.getUser(id: nil, token: token) { (result) in
            switch result {
            case .failure(let error):
                self.delegate?.needToShowErrorAlert(message: "\(error)")
            case .success(let user):
                guard let id = user.id else { self.delegate?.needToShowErrorAlert(message: "gameName"); return }
                self.userID = id
            }
        }
    }

    @objc private func setDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        date = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "HH:mm:ssZ"
        date += "T"
        date += dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "HH:mm:ss"
        time = dateFormatter.string(from: datePicker.date)
    }

    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setCurrentUserId()
        setDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UITextFieldDelegate
extension GameCreateView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkIsFilled()
    }
}

//MARK: - GetDataFromSelectClubProtocol
extension GameCreateView: GetDataFromSelectClubProtocol {
    func clubSelected(clubId: Int, clubName: String) {
        selectedClubLabel.text = clubName
        selectedClubId = clubId
    }
}
