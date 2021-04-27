//
//  HeaderForDerailView.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 18.01.2021.
//

import UIKit

class HeaderForDerailView: UIView {
    private let separatorColor = UIColor(red: 225/255, green: 236/255, blue: 249/255, alpha: 1)
    private let gameTitleLabel = UILabel(text: "Название игры",
                                    font: UIFont(name: "Inter-Regular", size: 23),
                                    textColor: .black)
    
    private let coachView = CoachView()
    private let mainTextLabel = UILabel(text: "Привет! В воскресенье хотелось бы найти компанию для быстрой игры в Московском городском клубе. Встреча в 15:00 около входа",
                                        font: UIFont(name: "Inter-Regular", size: 13),
                                        textColor: .black)
    private let separator = UIView()
    private let locationPointer = UIImageView(image: UIImage(named: "locationPointer"))
    private let locationLabel = UILabel(text: "НАЗВАНИЕ ГОЛЬФ-КЛУБА",
                                        font: UIFont(name: "Inter-Regular", size: 13),
                                        textColor: .black)
    
    private let datePointer = UIImageView(image: UIImage(named: "datePointer"))
    private let dateLabel = UILabel(text: "Data",
                                        font: UIFont(name: "Inter-Regular", size: 13),
                                        textColor: .black)
    private let separatorMiddle = UIView()
   
    
    private let conditionTitleLabel = UILabel(text: "Условия участия:",
                                        font: UIFont(name: "Inter-Regular", size: 13),
                                        textColor: UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1))
    private let consitionLabel = UILabel(text: "Гандикап не выше 15",
                                        font: UIFont(name: "Inter-Medium", size: 15),
                                        textColor: .black)
    
    private let separatorBottom = UIView()
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        
        addSubview(gameTitleLabel)
        gameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            gameTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
        ])
        
        addSubview(coachView)
        coachView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coachView.heightAnchor.constraint(equalToConstant: 80),
            coachView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coachView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coachView.topAnchor.constraint(equalTo: gameTitleLabel.bottomAnchor, constant: 20),
        ])
        
        addSubview(mainTextLabel)
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTextLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            mainTextLabel.topAnchor.constraint(equalTo: coachView.bottomAnchor, constant: 10),
            mainTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            
        ])

        separator.backgroundColor = separatorColor
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -16),
            separator.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 10),
        ])

        locationPointer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(locationPointer)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(locationLabel)

        NSLayoutConstraint.activate([
            locationPointer.widthAnchor.constraint(equalToConstant: 29),
            locationPointer.heightAnchor.constraint(equalToConstant: 29),
            locationPointer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            locationPointer.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 7),

            locationLabel.leadingAnchor.constraint(equalTo: locationPointer.trailingAnchor, constant: 4),
            locationLabel.centerYAnchor.constraint(equalTo: locationPointer.centerYAnchor),
        ])

        datePointer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(datePointer)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            datePointer.widthAnchor.constraint(equalToConstant: 29),
            datePointer.heightAnchor.constraint(equalToConstant: 29),
            datePointer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            datePointer.topAnchor.constraint(equalTo: locationPointer.bottomAnchor, constant: 16),

            dateLabel.leadingAnchor.constraint(equalTo: datePointer.trailingAnchor, constant: 4),
            dateLabel.centerYAnchor.constraint(equalTo: datePointer.centerYAnchor),
        ])
        
        separatorMiddle.backgroundColor = separatorColor
        addSubview(separatorMiddle)
        separatorMiddle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorMiddle.heightAnchor.constraint(equalToConstant: 1),
            separatorMiddle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorMiddle.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -16),
            separatorMiddle.topAnchor.constraint(equalTo: datePointer.bottomAnchor, constant: 10),
        ])

        conditionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(conditionTitleLabel)
        consitionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(consitionLabel)
        NSLayoutConstraint.activate([
            conditionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            conditionTitleLabel.topAnchor.constraint(equalTo: separatorMiddle.bottomAnchor, constant: 12),

            consitionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            consitionLabel.topAnchor.constraint(equalTo: conditionTitleLabel.bottomAnchor, constant: 5),
        ])
        
        separatorBottom.backgroundColor = separatorColor
        addSubview(separatorBottom)
        separatorBottom.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorBottom.heightAnchor.constraint(equalToConstant: 1),
            separatorBottom.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorBottom.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -16),
            separatorBottom.topAnchor.constraint(equalTo: consitionLabel.bottomAnchor, constant: 10),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeaderWithData(mainImage: UIImage?, game: GamesModel.Game, creatorAvatar: UIImage?) {
        gameTitleLabel.text = game.title
        coachView.setupViewWithData(creatorImage: creatorAvatar, creatoreName: game.user?.name)
        locationLabel.text = "\(game.club?.title?.uppercased() ?? "") (15 км)"
        dateLabel.text = "\(game.date ?? ""), \(game.time ?? "")"
    }
    
    func getViewHeight(controllerWidth width: CGFloat) -> CGFloat {
     
        
        let titleTextLabelHeight = DynamicalLabelSize.height(text: gameTitleLabel.text,
                                                            font: gameTitleLabel.font,
                                                            width: width - 32)
        
        let mainTextLabelHeight = DynamicalLabelSize.height(text: mainTextLabel.text,
                                                            font: mainTextLabel.font,
                                                            width: width - 32)
        
        let conditionTitleLabelHeight = DynamicalLabelSize.height(text: conditionTitleLabel.text,
                                                            font: conditionTitleLabel.font,
                                                            width: width - 32)
        let consitionLabelHeight = DynamicalLabelSize.height(text: consitionLabel.text,
                                                            font: consitionLabel.font,
                                                            width: width - 32)

        let height = titleTextLabelHeight + 12 + 80 + 20 + mainTextLabelHeight + 10 + 20 + 29 + 16 + 29 + 16 + 11 + conditionTitleLabelHeight + 21 + consitionLabelHeight + 11
 
        return height
    }
}
