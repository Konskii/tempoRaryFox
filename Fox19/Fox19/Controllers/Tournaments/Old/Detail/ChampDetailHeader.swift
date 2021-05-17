//
//  ChampDetailHeader.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 29.11.2020.
//

import UIKit

class ChampDetailHeader: UIView {
    
    private let locationPointer = UIImageView()
    private let locationLabel = UILabel()
    private let titleLabel = UILabel()
   // private let dateLabel = UILabel()
    private let dateLabel = UIDatePicker()
    private let separator = UIView()
    private let descriptionLabel = UILabel()
    
    private var champDate: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(locationPointer)
        addSubview(locationLabel)
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(separator)
        addSubview(descriptionLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationPointer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        locationPointer.image = UIImage(named: "ColorPointer")
        locationPointer.clipsToBounds = true
        
        locationLabel.text = "Нет данных в АПИ"
        locationLabel.textColor = UIColor(red: 45/255, green: 63/255, blue: 102/255, alpha: 1)
        locationLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        
        titleLabel.textColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
        titleLabel.font = UIFont(name: "Merriweather", size: 27)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.sizeToFit()
        
        dateLabel.datePickerMode = .date
        dateLabel.locale = .current
        dateLabel.addTarget(self, action: #selector(dateControl), for: .valueChanged)
//        dateLabel.textColor = UIColor(red: 45/255, green: 63/255, blue: 102/255, alpha: 1)
//        dateLabel.font = UIFont(name: "Avenir-Light", size: 13)
        
        separator.backgroundColor = UIColor(red: 240/255, green: 241/255, blue: 244/255, alpha: 1)
        
        descriptionLabel.font = UIFont(name: "Avenir-Light", size: 17)
        descriptionLabel.textColor = UIColor(red: 80/255, green: 85/255, blue: 92/255, alpha: 1)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
            locationPointer.widthAnchor.constraint(equalToConstant: 20),
            locationPointer.heightAnchor.constraint(equalToConstant: 20),
            locationPointer.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            locationPointer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 33),
            
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            locationLabel.leadingAnchor.constraint(equalTo: locationPointer.trailingAnchor, constant: 7),
        
            titleLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 29),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 26),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func dateControl() {
        guard let date = champDate else { return }
        dateLabel.date = date
    }
    
    func setupVeiwWithData(tournament data: Tournament) {
        locationLabel.text = data.club?.city?.name

        if let date = data.date?.value  {
            let dataFormater = DateFormatter()
            dataFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let dateObj = dataFormater.date(from: date) {
                dataFormater.dateFormat = "dd-MM-YYYY"
              //  dateLabel.text = dataFormater.string(from: dateObj)
                dateLabel.setDate(dateObj, animated: true)
                champDate = dateObj
            }
        }

        titleLabel.text = data.title
      descriptionLabel.text = data.description
    }
    
    func getViewHeight(controllerWidth width: CGFloat) -> CGFloat {
        
        let locationLabelHeight = DynamicalLabelSize.height(text: locationLabel.text,
                                                            font: locationLabel.font,
                                                            width: width)
        
        let titleLabelHeight = DynamicalLabelSize.height(text: titleLabel.text,
                                                            font: titleLabel.font,
                                                            width: width - 50)
        
//        let dateLabelHeight = DynamicalLabelSize.height(text: dateLabel.text,
//                                                            font: dateLabel.font,
//                                                            width: width)
        let dateLabelHeight: CGFloat = 30
        
        let descriptionLabelHeight = DynamicalLabelSize.height(text: descriptionLabel.text,
                                                            font: descriptionLabel.font,
                                                            width: width - 50)

        let totalInsets: CGFloat = 13 + 12 + 18 + 20 + 1 + 26
        let height = locationLabelHeight + titleLabelHeight + dateLabelHeight + descriptionLabelHeight + totalInsets
        
        return height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

