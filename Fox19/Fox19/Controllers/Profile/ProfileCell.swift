//
//  ProfileCell.swift
//  Fox19
//
//  Created by Артём Скрипкин on 23.04.2021.
//
import UIKit
enum ProfileCellType {
    case rightArrow
    case downArrow
}

enum ProfileCellStringDataTypes: CaseIterable, Equatable {
    case golfId, phone, email, about
}

protocol ProfileCellProtocol: class {
    func showMemberedClubs()
    func showStatuses()
}

protocol ProfileCellStringDataProtocol: class {
    func getData(type: ProfileCellStringDataTypes) -> String?
}

class ProfileCell: UITableViewCell {
    
    static let reusedId = "ProfileCell"
    
    private var user: User?
    
    private var indexPath: IndexPath?
    
    private var type: ProfileCellStringDataTypes?
    
    weak var delegate: ProfileCellProtocol?
    
    private lazy var textField: UITextField = {
        let view = UITextField(separatorImage: nil)
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(hideKeyboard))
        bar.setItems([done], animated: true)
        bar.sizeToFit()
        view.inputAccessoryView = bar
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    @objc private func hideKeyboard() {
        endEditing(true)
    }
    
    private func setupConstraints() {
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        backgroundColor = .white
    }
    
    func configureBase(user: User, indexPath: IndexPath, type: ProfileCellStringDataTypes) {
        self.user = user
        self.indexPath = indexPath
        self.type = type
        switch indexPath.row {
        case 2:
            textField.placeholder = "Номер в реестре гольфистов"
            guard let golfId = user.golfRegistryIdRU else { return }
            textField.text = golfId
        case 3:
            textField.placeholder = "Мобильный телефон"
            textField.keyboardType = .phonePad
            textField.textContentType = .telephoneNumber
            textField.autocorrectionType = .no
            guard let phone = user.phone else { return }
            textField.text = phone
        case 4:
            textField.placeholder = "Электронная почта"
            textField.keyboardType = .emailAddress
            textField.textContentType = .emailAddress
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            guard let email = user.email else { return }
            textField.text = email
        case 5:
            textField.placeholder = "О себе"
            guard let about = user.about else { return }
            textField.text = about
        case 6:
            textField.placeholder = "Дата рождения (дд.мм.гггг) *need api*"
            textField.isUserInteractionEnabled = false
        default:
            return
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch indexPath?.row {
        case 2:
            user?.golfRegistryIdRU = textField.text
        case 3:
            user?.phone = textField.text
        case 4:
            user?.email = textField.text
        case 5:
            user?.about = textField.text
        case 6:
            ///need api
            return
        default:
            return
        }
    }
}

extension ProfileCell: ProfileCellStringDataProtocol {
    func getData(type: ProfileCellStringDataTypes) -> String? {
        if self.type == type {
            return textField.text
        }
        return nil
    }
}

extension ProfileCell {
    func configureType(user: User, type: ProfileCellType) {
        self.user = user
        switch type {
        case .rightArrow:
            textField.placeholder = "Домашний клуб"
            textField.isUserInteractionEnabled = false
            
            let rightArrow = UIImageView(image: UIImage(named: "rightArrow"))
            rightArrow.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(showClubs))
            rightArrow.addGestureRecognizer(tap)
            rightArrow.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(rightArrow)
            NSLayoutConstraint.activate([
                rightArrow.heightAnchor.constraint(equalToConstant: 24),
                rightArrow.widthAnchor.constraint(equalTo: rightArrow.heightAnchor),
                rightArrow.centerYAnchor.constraint(equalTo: textField.centerYAnchor, constant: 5),
                rightArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
        case .downArrow:
            textField.placeholder = "Ваш статус"
            textField.isUserInteractionEnabled = false
            
            let rightArrow = UIImageView(image: UIImage(named: "rightArrow"))
            rightArrow.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(showStatuses))
            rightArrow.addGestureRecognizer(tap)
            rightArrow.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(rightArrow)
            NSLayoutConstraint.activate([
                rightArrow.heightAnchor.constraint(equalToConstant: 24),
                rightArrow.widthAnchor.constraint(equalTo: rightArrow.heightAnchor),
                rightArrow.centerYAnchor.constraint(equalTo: textField.centerYAnchor, constant: 5),
                rightArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
        }
    }
    
    @objc private func showClubs() {
        delegate?.showMemberedClubs()
    }
    
    @objc private func showStatuses() {
        delegate?.showStatuses()
    }
}
