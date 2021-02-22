//
//  ProfileCell.swift
//  Fox19
//
//  Created by Артём Скрипкин on 22.02.2021.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    static let reusedId = "ProfileCell"
    
    //MARK: - Delegates
    weak var delegate: FillProfileCellProtocol?
    
    ///Показывает в каком контроллере используется ячейка
    private var isEditStyle: Bool = false
    
    ///В зависимости от расположения ячейки(и тип контроллера в котором она используется) выставляются ее данные
    private var indexPath: IndexPath?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    //MARK: - Configuring Cell
    func setData() {
        guard let int = indexPath?.row else { return }
        guard let data = delegate?.getDataForCell() else { return }
        if isEditStyle {
            switch int {
            case 0:
                label.text = "Имя"
                guard let name = data.name else { return }
                textField.textContentType = .givenName
                textField.placeholder = " Иван"
                textField.text = name
            case 1:
                label.text = "Идентификатор в реестре гольфистов"
                guard let golfId = data.golfRegistryIdRU else { return }
                textField.placeholder = " RUXXXXXX"
                textField.text = golfId
            case 2:
                label.text = "Обо мне"
                guard let aboutMe = data.about else { return }
                textField.text = aboutMe
            case 3:
                label.text = "Email"
                guard let email = data.email else { return }
                textField.textContentType = .emailAddress
                textField.keyboardType = .emailAddress
                textField.placeholder = " email@email.com"
                textField.clearsOnInsertion = true
                textField.autocapitalizationType = .none
                textField.text = email
            default:
                return
            }
        } else {
            isUserInteractionEnabled = false
            switch int {
            case 0:
                label.text = "Имя"
                guard let name = data.name else { return }
                textField.textContentType = .givenName
                textField.placeholder = "Иван"
                textField.text = name
            case 1:
                label.text = "Гандикап"
                guard let handicap = data.handicap else { return }
                textField.placeholder = " dd.d"
                textField.text = "\(handicap)"
            case 2:
                label.text = "Обо мне"
                guard let aboutMe = data.about else { return }
                textField.text = aboutMe
            case 3:
                label.text = "Мои клубы"
                textField.text = "Список клубов. Нажатие для подробностей"
            case 4:
                label.text = "Email"
                guard let email = data.email else { return }
                textField.text = email
                textField.autocorrectionType = .no
                textField.textContentType = .emailAddress
                textField.placeholder = " email@email.com"
            case 5:
                label.text = "Статус"
                var status = ""
                if let admin = data.isAdmin, let gamer = data.isGamer, let referee = data.isReferee, let trainer = data.isTrainer  {
                    if admin {
                        textField.text = "Админ"
                        break
                    }
                    var statusArray: [String] = []
                    if gamer { statusArray.append("Игрок") }
                    if trainer { statusArray.append("Тренер") }
                    if referee { statusArray.append("Судья") }
                    status = statusArray.joined(separator: ", ")
                }
                textField.text = status
            case 6:
                label.text = "Номер телефона"
                guard let phone = data.phone else { return }
                textField.textContentType = .telephoneNumber
                textField.text = phone
            case 7:
                label.text = "Идентификатор в реестре гольфистов"
                guard let golfId = data.golfRegistryIdRU else { return }
                textField.placeholder = " RUXXXXXX"
                textField.text = golfId
            default:
                return
            }
        }
    }
    
    public func setIndexPath(indexPath: IndexPath, isEditingVC: Bool) {
        self.indexPath = indexPath
        self.isEditStyle = isEditingVC
        setData()
        textField.borderStyle = .none
    }
}

extension ProfileCell: ManageUpdatedUserProtocol {
    func manageText() -> (String?, IndexPath?) {
        guard let indexPath = indexPath else { return (nil, nil) }
        guard let text = textField.text else { return (nil, nil) }
        return (text, indexPath)
    }
}
