//
//  HeaderForDerailView.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 18.01.2021.
//

import UIKit

class HeaderForDerailView: UIView {
    
    private let imageView = UIImageView()
    private let locationPointer = UIImageView(image: UIImage(named: "orangePointer"))
    private let flagImageView = UIImageView(image: UIImage(named: "orangeFlag"))
   // private let reserveImageView = UIImageView(image: UIImage(named: "orangeReserve"))
    private let userImageView = UIImageView(image: UIImage(named: "orangePerson"))
    private let locationLabel = UILabel(text: "НАЗВАНИЕ ГОЛЬФ-КЛУБА",
                                        font: .avenir(fontSize: 12),
                                        textColor: .blueForHeaderLabels())
    private let numberOfLunokLabel = UILabel(text: "18 лунок",
                                             font: .avenir(fontSize: 13),
                                             textColor: .blueForHeaderLabels())
    
  //  private let reserveLabel = UILabel(text: "Забронированно",
//                                       font: .avenir(fontSize: 13),
//                                       textColor: .blueForHeaderLabels())
    
    private let priceLabel = UILabel(text:  "5000/4 р",
                                     font: .avenir(fontSize: 13),
                                     textColor: .blueForHeaderLabels())
    
    private let mainTextLabel = UILabel(text: "Описание какое то про этот турнир. Рассказать несколько слов для участников Описание какое то про этот турнир. Рассказать несколько слов для участников.",
                                        font: .avenir(fontSize: 17),
                                        textColor: .blueForHeaderLabels())
    
    private let separator = UIView()
    private let separatorBottom = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.backgroundColor = .lightGray
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        addSubview(locationPointer)
        addSubview(locationLabel)
        addSubview(separator)
        
        addSubview(flagImageView)
     //   addSubview(reserveImageView)
        addSubview(userImageView)
        
        addSubview(numberOfLunokLabel)
   //     addSubview(reserveLabel)
        addSubview(priceLabel)
        addSubview(separatorBottom)
        
        addSubview(mainTextLabel)
        
        separator.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separatorBottom.translatesAutoresizingMaskIntoConstraints = false
        separatorBottom.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 1)
        
        locationPointer.contentMode = .scaleAspectFit
        locationPointer.clipsToBounds = true
        locationPointer.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
     //   reserveImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        numberOfLunokLabel.translatesAutoresizingMaskIntoConstraints = false
   //     reserveLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mainTextLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            locationPointer.widthAnchor.constraint(equalToConstant: 20),
            locationPointer.heightAnchor.constraint(equalToConstant: 20),
            locationPointer.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 22),
            locationPointer.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            locationLabel.leadingAnchor.constraint(equalTo: locationPointer.trailingAnchor, constant: 7),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: locationPointer.bottomAnchor, constant: 11),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            numberOfLunokLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16),
            numberOfLunokLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            flagImageView.centerYAnchor.constraint(equalTo: numberOfLunokLabel.centerYAnchor),
            flagImageView.leadingAnchor.constraint(equalTo: numberOfLunokLabel.trailingAnchor, constant: 5),
            
        //    reserveImageView.centerYAnchor.constraint(equalTo: flagImageView.centerYAnchor),
          //  reserveImageView.leadingAnchor.constraint(equalTo: numberOfLunokLabel.trailingAnchor, constant: 30),
            
            //reserveLabel.leadingAnchor.constraint(equalTo: reserveImageView.trailingAnchor, constant: 11),
            //reserveLabel.centerYAnchor.constraint(equalTo: flagImageView.centerYAnchor),

            userImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13),
           userImageView.centerYAnchor.constraint(equalTo: flagImageView.centerYAnchor),

            priceLabel.trailingAnchor.constraint(equalTo: userImageView.leadingAnchor, constant: -5),
            priceLabel.centerYAnchor.constraint(equalTo: flagImageView.centerYAnchor),
            
            separatorBottom.heightAnchor.constraint(equalToConstant: 1),
            separatorBottom.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 15),
            separatorBottom.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorBottom.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            mainTextLabel.topAnchor.constraint(equalTo: separatorBottom.bottomAnchor, constant: 20),
            mainTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeaderWithData(mainImage: UIImage?, game: GamesModel.Game) {
        imageView.image = mainImage
        locationLabel.text = game.club?.title?.uppercased()
        numberOfLunokLabel.text = "\(game.holes ?? 0)"
       // reserveLabel.text = game.reserved ?? false ? "Забронированно" : "Не забронированно"
        priceLabel.text = "\(game.memberPrice ?? 0)/\(game.gamersCount ?? 0) рублей"
        mainTextLabel.text = game.description
    }
    
    func getViewHeight(controllerWidth width: CGFloat) -> CGFloat {
     
        let imageViewHeight = CGFloat(200)
        let locationPointerHeightWithPadding = locationPointer.frame.height + 22
        let separatorHeightWithPadding = separator.frame.height + 11
        let flagImageViewHeightWithPadding = flagImageView.frame.height + 16
        let separatorBootomHeightWithPadding = separatorBottom.frame.height + 15
        
        let mainTextLabelHeight = DynamicalLabelSize.height(text: mainTextLabel.text,
                                                            font: mainTextLabel.font,
                                                            width: width)

        let height = imageViewHeight + locationPointerHeightWithPadding + separatorHeightWithPadding + flagImageViewHeightWithPadding + separatorBootomHeightWithPadding + mainTextLabelHeight + 20 + 30
        
        return height
    }
}
