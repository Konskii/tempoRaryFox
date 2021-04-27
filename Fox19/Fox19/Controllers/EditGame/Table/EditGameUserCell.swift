//
//  EditGameUserCell.swift
//  Fox19
//
//  Created by Артём Скрипкин on 12.12.2020.
//

import UIKit

protocol editGameCellServiceProtocol: class  {
    func needToShowErrorAlert(message: String)
    func accept(memberId: Int)
    func decline(memberId: Int)
}

class EditGameUserCell: UITableViewCell {
    
    static let reusedId = "EditGameUserCell"
    
    weak var delegate: editGameCellServiceProtocol?
    
    private var memberId: Int?
    
    private var storedGameUser: (User, Int, String)?
    
    //MARK: - UI Elements
    private lazy var userAvatar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "user")
        view.layer.cornerRadius = 41 / 2
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 0.5)
        return view
    }()
    
    private lazy var handicapView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 41 / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userHandicapLabel: UILabel = {
        let view = UILabel()
        view.text = "0.0"
        view.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.font = UIFont(name: "Avenir-Medium", size: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userNameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Avenir-Medium", size: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var confirmationIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "confirmation")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var declinedIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "declined")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var acceptButtonImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "acceptImage")
        view.isHidden = true
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(acceptPressed))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var declineButtonImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "declineImage")
        view.isHidden = true
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(declinePressed))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.tintColor = UIColor(named: "orange")
        view.startAnimating()
        view.hidesWhenStopped = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - UserIneraction Methods
    
    @objc func acceptPressed() {
        guard let memberId = memberId else { return }
        delegate?.accept(memberId: memberId)
    }
    
    @objc func declinePressed() {
        guard let memberId = memberId else { return }
        delegate?.decline(memberId: memberId)
    }
    
    //MARK: - Methods
    public func configureCell(gameUser: (User, Int, String)) {
        setupUser(user: gameUser.0)
        memberId = gameUser.1
        storedGameUser = gameUser
        switch gameUser.2 {
        case "New":
            confirmationIcon.isHidden = true
            declinedIcon.isHidden = true
            acceptButtonImage.isHidden = false
            declineButtonImage.isHidden = false
        case "Accepted":
            acceptButtonImage.isHidden = true
            declineButtonImage.isHidden = true
            declinedIcon.isHidden = true
            confirmationIcon.isHidden = false
        case "Declined":
            acceptButtonImage.isHidden = true
            declineButtonImage.isHidden = true
            confirmationIcon.isHidden = true
            declinedIcon.isHidden = false
        default:
            return
        }
    }
    
    private func setupUser(user: User) {
        //TODO handicap, error alerts
        guard let name = user.name else {
            self.delegate?.needToShowErrorAlert(message: "userName")
            return
        }
        guard let id = user.id else {
            self.delegate?.needToShowErrorAlert(message: "userId")
            return
        }
        userNameLabel.text = name
        if let handicap = user.handicap {
            userHandicapLabel.text = "\(handicap)"
        }
        guard let account = UserDefaults.standard.string(forKey: "number") else {
            self.delegate?.needToShowErrorAlert(message: "account")
            return
        }
        guard let token = Keychainmanager.shared.getToken(account: account) else {
            self.delegate?.needToShowErrorAlert(message: "tokenError")
            return
        }
        
        UserNetworkManager.shared.downloadUserAvatar(token: token, id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(_):
                //TODO
                //handle errors while not showning error when user doen't have image
                return
            case .success(let image):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.userAvatar.image = image
                }
            }
        }
    }
    
    private func setupConstraints() {
        contentView.addSubview(userAvatar)
        userAvatar.addSubview(handicapView)
        handicapView.addSubview(userHandicapLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(confirmationIcon)
        contentView.addSubview(declinedIcon)
        contentView.addSubview(acceptButtonImage)
        contentView.addSubview(declineButtonImage)
        contentView.addSubview(activityIndicator)
        
        let constraints = [
            userAvatar.heightAnchor.constraint(equalToConstant: 41),
            userAvatar.widthAnchor.constraint(equalTo: userAvatar.heightAnchor),
            userAvatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            
            handicapView.topAnchor.constraint(equalTo: userAvatar.topAnchor),
            handicapView.leadingAnchor.constraint(equalTo: userAvatar.leadingAnchor),
            handicapView.bottomAnchor.constraint(equalTo: userAvatar.bottomAnchor),
            handicapView.trailingAnchor.constraint(equalTo: userAvatar.trailingAnchor),
            
            userHandicapLabel.centerYAnchor.constraint(equalTo: handicapView.centerYAnchor),
            userHandicapLabel.centerXAnchor.constraint(equalTo: handicapView.centerXAnchor),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 20),
            userNameLabel.centerYAnchor.constraint(equalTo: userAvatar.centerYAnchor),
            
            confirmationIcon.heightAnchor.constraint(equalToConstant: 8),
            confirmationIcon.widthAnchor.constraint(equalToConstant: 12),
            confirmationIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            confirmationIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -37),
            
            declinedIcon.heightAnchor.constraint(equalToConstant: 12),
            declinedIcon.widthAnchor.constraint(equalTo: declinedIcon.heightAnchor),
            declinedIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            declinedIcon.trailingAnchor.constraint(equalTo: confirmationIcon.trailingAnchor),
            
            acceptButtonImage.heightAnchor.constraint(equalToConstant: 41),
            acceptButtonImage.widthAnchor.constraint(equalTo: acceptButtonImage.widthAnchor),
            acceptButtonImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            acceptButtonImage.centerYAnchor.constraint(equalTo: userAvatar.centerYAnchor),
            
            declineButtonImage.heightAnchor.constraint(equalToConstant: 41),
            declineButtonImage.widthAnchor.constraint(equalTo: declineButtonImage.widthAnchor),
            declineButtonImage.trailingAnchor.constraint(equalTo: acceptButtonImage.leadingAnchor, constant: -10),
            declineButtonImage.centerYAnchor.constraint(equalTo: userAvatar.centerYAnchor),
            
            activityIndicator.heightAnchor.constraint(equalToConstant: 15),
            activityIndicator.widthAnchor.constraint(equalToConstant: 15),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -37)
        ]
        
        NSLayoutConstraint.activate(constraints)
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
