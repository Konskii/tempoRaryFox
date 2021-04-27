//
//  EditGameHeader.swift
//  Fox19
//
//  Created by Артём Скрипкин on 12.12.2020.
//

import UIKit
fileprivate class HolesSegmentControll: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 35
        layer.masksToBounds = true
    }
}

protocol EditGameHeaderServiceProtocol: class {
    func needToShowAlert(message: String)
    func needToShowSelectClubVC()
}

protocol GetEditedGameProtocol: class {
    func getEditedGame() -> EditGameUpdateModel?
}

class EditGameHeader: UITableViewHeaderFooterView {
    
    static let reusedId = "EditGameHeader"
    
    weak var delegate: EditGameHeaderServiceProtocol?
    
    private var selectedClubId = 1
    
    private var date = ""
    
    private var time = ""
    
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
    
    private lazy var applicationsForParticipation: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.745, green: 0.761, blue: 0.808, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "Заявки на участие"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - UserInteraction Methods
    @objc private func selectedClubPressed() {
        delegate?.needToShowSelectClubVC()
    }
    
    //MARK: - Methods
    public func configureHeader(game: Game) {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-ddHH:mm:ss"
        guard let count = game.gamersCount else { delegate?.needToShowAlert(message: "gamersCountError"); return }
        guard let gameDate = game.date else { delegate?.needToShowAlert(message: "gameDateError"); return }
        guard let gameTime = game.time else { delegate?.needToShowAlert(message: "gameTimeError"); return }
        guard let dateToFill = df.date(from: "\(gameDate)\(gameTime)") else { delegate?.needToShowAlert(message: "gameDateTimeError"); return }
        guard let memberPrice = game.memberPrice else { delegate?.needToShowAlert(message: "memberPriceError"); return }
        guard let guestPrice = game.guestPrice else { delegate?.needToShowAlert(message: "guestPriceError"); return }
        guard let holes = game.holes else { delegate?.needToShowAlert(message: "gameHolesError"); return }
        guard let clubId = game.club.id else { delegate?.needToShowAlert(message: "gameClubIdError"); return }
        gameNameField.text = game.title ?? ""
        gameDescriptionField.text = game.description ?? ""
        playersCountField.text = "\(count)"
        datePicker.setDate(dateToFill, animated: true)
        datePicker.minimumDate = dateToFill
        setDate()
        memberPriceField.text = "\(memberPrice)"
        guestPriceField.text = "\(guestPrice)"
        if holes == 9 {
            holesSegmentControll.selectedSegmentIndex = 1
        }
        if clubId == 2 {
            selectedClubLabel.text = "Сколково"
        }
    }
    
    @objc private func setDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        date = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "HH:mm:ss"
        time = dateFormatter.string(from: datePicker.date)
    }
    
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
        addSubview(applicationsForParticipation)
        
        let constraints = [
            
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
            
            applicationsForParticipation.topAnchor.constraint(equalTo: memberPriceField.bottomAnchor, constant: 40),
            applicationsForParticipation.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    //MARK: - Inits
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - fetchDataFromSelectClub
extension EditGameHeader: GetDataFromSelectClubProtocol {
    func clubSelected(clubId: Int, clubName: String) {
        selectedClubId = clubId
        selectedClubLabel.text = clubName
    }
}

extension EditGameHeader: GetEditedGameProtocol {
    func getEditedGame() -> EditGameUpdateModel? {
        guard let gameDescription = gameDescriptionField.text, gameDescriptionField.text != "" else { return  nil }
        guard let gamePlayersCount = playersCountField.text, playersCountField.text != "" else { return nil }
        guard let gameGuestPrice = guestPriceField.text, guestPriceField.text != "" else { return nil }
        guard let gameMemberPrice = memberPriceField.text, memberPriceField.text != "" else { return nil }
        guard let intGuestPrice = Int(gameGuestPrice) else { return nil }
        guard let intMemberPrice = Int(gameMemberPrice) else { return nil}
        guard let intGamersCount = Int(gamePlayersCount) else { return nil }
        var holes = 9
        if holesSegmentControll.selectedSegmentIndex == 0 {
            holes = 18
        }
        return EditGameUpdateModel(date: date, description: gameDescription, time: time, guestPrice: intGuestPrice, memberPrice: intMemberPrice, club: selectedClubId, holes: holes, gamersCount: intGamersCount)
    }
}
