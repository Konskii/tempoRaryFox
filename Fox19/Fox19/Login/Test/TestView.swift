//
//  TestView.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 10.11.2020.
//

import UIKit

class TestView: UIView {
    
    private var topBackgroundView: UIImageView!
    private var bottomBackgtoundView: UIImageView!
    private var logoImageview: UIImageView!
    
    private var welkomeLable: UILabel!
    private var nameLabel: UILabel!
    
    private var textField: UITextField!
    private var lineView: UIView!
    
    private var nextButton: UIButton!
    
    private var arrowImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        topBackgroundView = UIImageView()
        topBackgroundView.image = UIImage(named: "Rectangle")
        topBackgroundView.clipsToBounds = true
        topBackgroundView.layer.cornerRadius = 18
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBackgtoundView = UIImageView()
        bottomBackgtoundView.image = UIImage(named: "Kentucky")
        bottomBackgtoundView.clipsToBounds = true
        bottomBackgtoundView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageview = UIImageView()
        logoImageview.image = UIImage(named: "LoginLogo")
        logoImageview.contentMode = .scaleAspectFill
        logoImageview.clipsToBounds = true
        logoImageview.translatesAutoresizingMaskIntoConstraints = false
        
        welkomeLable = UILabel()
        welkomeLable.adjustsFontForContentSizeCategory = true
        welkomeLable.text = "Добро\nпожаловать\nв мир гольфа"
        welkomeLable.textColor = .white
        welkomeLable.font = UIFont(name: "Merriweather-Regular", size: 35)
        welkomeLable.numberOfLines = 3
        welkomeLable.lineBreakMode = .byWordWrapping
        welkomeLable.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel = UILabel()
        nameLabel.text = "Отображаемое имя"
        nameLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        nameLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField = UITextField()
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.font = UIFont(name: "Avenir-Medium", size: 17)
        textField.textAlignment = .left
     //   textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        lineView = UIView()
        lineView.backgroundColor = .white
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton = UIButton(type: .system)
        let attributesForTitle: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 1, green: 0.537, blue: 0, alpha: 1),
            .font: UIFont(name: "Avenir-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        let attrTitle = NSAttributedString(string: "Далее", attributes: attributesForTitle)
        nextButton.setAttributedTitle(attrTitle, for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "arrow")
        arrowImageView.contentMode = .scaleAspectFill
        arrowImageView.clipsToBounds = true
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(bottomBackgtoundView)
        self.addSubview(topBackgroundView)
        self.addSubview(logoImageview)
        self.addSubview(nameLabel)
        
        self.addSubview(welkomeLable)
        self.addSubview(textField)
        self.addSubview(lineView)
        
        self.addSubview(nextButton)
        self.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            bottomBackgtoundView.heightAnchor.constraint(equalToConstant: 100),
            bottomBackgtoundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBackgtoundView.trailingAnchor.constraint(equalTo:trailingAnchor),
            bottomBackgtoundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            topBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo:trailingAnchor),
            topBackgroundView.bottomAnchor.constraint(equalTo: bottomBackgtoundView.topAnchor, constant: 10),
            topBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            
            logoImageview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 41),
            logoImageview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 41),
            logoImageview.heightAnchor.constraint(equalToConstant: 85),
            logoImageview.widthAnchor.constraint(equalToConstant: 55),
            
            welkomeLable.topAnchor.constraint(equalTo: logoImageview.bottomAnchor, constant: 87),
            welkomeLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 29),
            
            nameLabel.topAnchor.constraint(equalTo: welkomeLable.bottomAnchor, constant: 44),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            
            textField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -145),
            
            lineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 3),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -69),
            
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 162),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -135),
            
            arrowImageView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: nextButton.trailingAnchor, constant: 23)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
