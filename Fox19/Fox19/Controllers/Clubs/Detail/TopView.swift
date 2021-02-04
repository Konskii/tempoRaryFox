//
//  TopView.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 22.10.2020.
//

import UIKit

class TopView: UIView {

    private let locationPointer = UIImageView()
    private let locationLabel = UILabel()
    private let titleLabel = UILabel()
    private let starsImageView = UIImageView()
    private let reviewsLabel = UILabel()
    private let separator = UIView()
    private let descriptionLabel = UILabel()
    private let separatorBottom = UIView()
    private let photoPageLabel = UILabel()
    
    var imageViews = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        locationPointer.image = UIImage(named: "ColorPointer")
        locationPointer.clipsToBounds = true

        locationLabel.text = "Нет данных в АПИ"
        locationLabel.textColor = UIColor(red: 45/255, green: 63/255, blue: 102/255, alpha: 1)
        locationLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        
        titleLabel.textColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
        titleLabel.font = UIFont(name: "Merriweather", size: 27)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.sizeToFit()
        
        starsImageView.image = UIImage(named: "Stars")
        
        reviewsLabel.text = "0 отзывов"
        reviewsLabel.textColor = UIColor(red: 190/255, green: 194/255, blue: 206/255, alpha: 1)
        reviewsLabel.font = UIFont(name: "Avenir-Medium", size: 13)
        
        separator.backgroundColor = UIColor(red: 240/255, green: 241/255, blue: 244/255, alpha: 1)
        
        descriptionLabel.font = UIFont(name: "Avenir-Light", size: 17)
        descriptionLabel.textColor = UIColor(red: 80/255, green: 85/255, blue: 92/255, alpha: 1)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        separatorBottom.backgroundColor = UIColor(red: 240/255, green: 241/255, blue: 244/255, alpha: 1)
        
        photoPageLabel.text = "ФОТОГРАФИИ"
        photoPageLabel.textColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
        photoPageLabel.font = UIFont(name: "Avenir-Medium", size: 15)
        
        addSubview(locationPointer)
        addSubview(locationLabel)
        addSubview(titleLabel)
        addSubview(starsImageView)
        addSubview(reviewsLabel)
        addSubview(separator)
        addSubview(descriptionLabel)
        addSubview(separatorBottom)
        addSubview(photoPageLabel)
        
        locationPointer.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        starsImageView.translatesAutoresizingMaskIntoConstraints = false
        reviewsLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorBottom.translatesAutoresizingMaskIntoConstraints = false
        photoPageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationPointer.widthAnchor.constraint(equalToConstant: 20),
            locationPointer.heightAnchor.constraint(equalToConstant: 20),
            locationPointer.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            locationPointer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            locationLabel.leadingAnchor.constraint(equalTo: locationPointer.trailingAnchor, constant: 7),
            
            titleLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            starsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            starsImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            reviewsLabel.centerYAnchor.constraint(equalTo: starsImageView.centerYAnchor),
            reviewsLabel.leadingAnchor.constraint(equalTo: starsImageView.trailingAnchor, constant: 18),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: reviewsLabel.bottomAnchor, constant: 20),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            descriptionLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 26),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            separatorBottom.heightAnchor.constraint(equalToConstant: 1),
            separatorBottom.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 19),
            separatorBottom.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            separatorBottom.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            photoPageLabel.topAnchor.constraint(equalTo: separatorBottom.bottomAnchor, constant: 21),
            photoPageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)

        ])
    }
    
    func setupTopView(controllerWidth width: CGFloat, club: Club) -> CGFloat {
        
        if let account = UserDefaults.standard.string(forKey: "number") {
            ClubsNetworkManager.shared.getClubReviews(for: account, clubId: club.id ?? 0) { (result) in
                switch result {
                case .success(let reviews):
                    DispatchQueue.main.async {
                        self.reviewsLabel.text = "\(reviews.results.count) отзыв(ов)"
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        
        descriptionLabel.text = club.description
        titleLabel.text = club.title
        
        let widthWithInset = width - 40
        
        let locationLabelHeight = DynamicalLabelSize.height(text: locationLabel.text,
                                          font: locationLabel.font,
                                          width: widthWithInset)
        
        let mainLableHeight = DynamicalLabelSize.height(text: titleLabel.text,
                                          font: titleLabel.font,
                                          width: widthWithInset)
        
        let reviewsLabelHeight = DynamicalLabelSize.height(text: reviewsLabel.text,
                                          font: reviewsLabel.font,
                                          width: widthWithInset)
        
        let mainTextLabelHeight = DynamicalLabelSize.height(text: descriptionLabel.text,
                                          font: descriptionLabel.font,
                                          width: widthWithInset)

        let photoPageLabelHeight = DynamicalLabelSize.height(text: photoPageLabel.text,
                                          font: photoPageLabel.font,
                                          width: widthWithInset)
        
        let height = locationLabelHeight + mainLableHeight + reviewsLabelHeight + mainTextLabelHeight + photoPageLabelHeight + 13 + 12 + 18 + 20 + 1 + 26 + 19 + 1 + 21
        
        return height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
