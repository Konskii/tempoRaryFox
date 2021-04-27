//
//  OnePlayerTableViewCell.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 18.10.2020.
//

import UIKit
import EZYGradientView

class OnePlayerTableViewCell: UITableViewCell {
    
    static let tableIdentifire = "OnePlayerViewController"
    
    private let view = UIView()
    private var descriptionLable = UILabel()
    private var statusLable = UILabel()
    
    func setupUser(with lable: String, description: String) {
        //Вью
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        //Описание игрока
        descriptionLable.text = description
        descriptionLable.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        descriptionLable.font = UIFont(name: "OpenSans-Regular", size: 12)
        descriptionLable.font = .systemFont(ofSize: 12.0, weight: .regular)
        descriptionLable.textAlignment = .center
        descriptionLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLable)
        
        //Статус / обо мне / клубы (Лейбыл)
        statusLable.text = lable
        statusLable.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4032266695)
        statusLable.font = UIFont(name: "Avenir-Medium", size: 12)
        statusLable.font = .systemFont(ofSize: 12.0, weight: .light)
        statusLable.textAlignment = .center
        statusLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLable)
        
        let constraints = [
            //Констрейнты Вью
            view.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
            view.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 0),
            view.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            //Констрейнты Лейблов
            statusLable.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 10.0),
            statusLable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            
            //Констрейнты Описания
            descriptionLable.topAnchor.constraint(equalTo: statusLable.bottomAnchor, constant: 4.0),
            descriptionLable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
