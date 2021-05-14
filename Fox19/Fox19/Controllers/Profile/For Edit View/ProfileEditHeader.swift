//
//  ProfileEditHeader.swift
//  Fox19
//
//  Created by Артём Скрипкин on 23.04.2021.
//

import UIKit

protocol ProfileEditHeaderToControllerProtocol: class {
    func showImagePicker()
    func showAlertFromHeader(text: String)
}

protocol ProfileEditHeaderDataProtocol: class {
    func getData() -> User
}

class ProfileEditHeader: UITableViewHeaderFooterView {
    
    weak var delegate: ProfileEditHeaderToControllerProtocol?
    
    private let service = ProfileService()
    
    private var userAvatar: UIImage? {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.avatarImageView.image = newValue
            }
        }
    }
    
    private var storedHandicap: String = ""
    
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var changeAvatarButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Изменить", for: .normal)
        view.addTarget(self, action: #selector(change), for: .touchUpInside)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var name: UITextField = {
        let view = UITextField(separatorImage: nil)
        view.placeholder = "Имя"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lastName: UITextField = {
        let view = UITextField(separatorImage: nil)
        view.placeholder = "Фамилия"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var handicap: UITextField = {
        let view = UITextField(separatorImage: nil)
        view.delegate = self
        view.placeholder = "Гандикап"
        view.keyboardType = .numbersAndPunctuation
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

extension ProfileEditHeader {
    private func addSubviews() {
        addSubview(avatarImageView)
        addSubview(changeAvatarButton)
        addSubview(name)
        addSubview(lastName)
        addSubview(handicap)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 64),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            changeAvatarButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 4),
            changeAvatarButton.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            
            name.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            lastName.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20),
            lastName.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            lastName.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            handicap.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: 20),
            handicap.leadingAnchor.constraint(equalTo: lastName.leadingAnchor),
            handicap.trailingAnchor.constraint(equalTo: lastName.trailingAnchor)
        ])
    }
    
    @objc private func change() {
        delegate?.showImagePicker()
    }
}

// MARK: Init
extension ProfileEditHeader {
    convenience init(user: User, avatar: UIImage?) {
        self.init()
        let backView = UIView(frame: frame)
        backView.backgroundColor = .white
        backgroundView = backView
        addSubviews()
        setupConstraints()
        avatarImageView.image = avatar
        name.text = user.name ?? ""
        lastName.text = user.lastName ?? ""
        handicap.text = service.getHandicapToShow(handicapFromServer: user.handicap) ?? ""
        storedHandicap = service.getHandicapToShow(handicapFromServer: user.handicap) ?? ""
    }
}

extension ProfileEditHeader: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { fatalError() }
        if text.isEmpty {
            handicap.text = storedHandicap
            return true
        }
        if service.handicapsStringArray.contains(text) {
            return true
        } else {
            delegate?.showAlertFromHeader(text: "Введенное вами значение не входит в диапазон +10.0...0.0...54.0, при вводе используйте только дробные числа.")
            return false
        }
    }
}

extension ProfileEditHeader: ProfileEditHeaderDataProtocol {
    func getData() -> User {
        return User(id: nil, phone: nil, email: nil, golfRegistryIdRU: nil, about: nil, name: name.text, lastName: lastName.text, handicap: service.getHandicapForServer(handicapToShow: handicap.text ?? ""), isAdmin: nil, isReferee: nil, isGamer: nil, isTrainer: nil, avatar: nil)
    }
}
 
