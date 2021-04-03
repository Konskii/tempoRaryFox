//
//  TopView.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 22.10.2020.
//

import UIKit
import Cosmos

class TopView: UIView {

    private let orangeColor = UIColor(red: 242/255, green: 122/255, blue: 42/255, alpha: 1)
    
    private let locationPointer = UIImageView()
    private let locationLabel = UILabel()
    private let titleLabel = UILabel()
    private let starsratingView = CosmosView()
    private let reviewsLabel = UILabel()
    private let reviewButton = UIButton(type: .system)
    private let separator = UIView()
    private let descriptionLabel = UILabel()
    private let separatorBottom = UIView()
    private let photoPageLabel = UILabel()
    
    private var reviews: [Review] = []
    
    var didTapMakeReviewButton: (() -> Void)?
    var didTapShowReviews: (([Review]) -> Void)?
    
    var imageViews = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        locationPointer.image = UIImage(named: "ColorPointer")
        locationPointer.clipsToBounds = true

        locationLabel.text = "Нет данных"
        locationLabel.textColor = UIColor(red: 45/255, green: 63/255, blue: 102/255, alpha: 1)
        locationLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        
        titleLabel.textColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
        titleLabel.font = UIFont(name: "Merriweather", size: 27)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.sizeToFit()
        
        starsratingView.settings.emptyImage = UIImage(named: "emptyStar")
        starsratingView.settings.filledImage = UIImage(named: "filledStar")
        starsratingView.settings.starSize = 17
        starsratingView.settings.fillMode = .precise
        starsratingView.settings.updateOnTouch = false
        starsratingView.rating = 0
        
        reviewsLabel.text = "0 отзывов"
        reviewsLabel.textColor = UIColor(red: 190/255, green: 194/255, blue: 206/255, alpha: 1)
        reviewsLabel.font = UIFont(name: "Avenir-Medium", size: 13)
        reviewsLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showReviews))
        reviewsLabel.addGestureRecognizer(gesture)
        
        reviewButton.setTitle("Оставить отзыв", for: .normal)
        reviewButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
        reviewButton.setTitleColor(UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1), for: .normal)
        reviewButton.addTarget(self, action: #selector(leaveReview), for: .touchUpInside)
      
        
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
        addSubview(starsratingView)
        addSubview(reviewsLabel)
        addSubview(reviewButton)
        addSubview(separator)
        addSubview(descriptionLabel)
        addSubview(separatorBottom)
        addSubview(photoPageLabel)
        
        locationPointer.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        starsratingView.translatesAutoresizingMaskIntoConstraints = false
        reviewsLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewButton.translatesAutoresizingMaskIntoConstraints = false
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
            
            starsratingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            starsratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            reviewsLabel.centerYAnchor.constraint(equalTo: starsratingView.centerYAnchor),
            reviewsLabel.leadingAnchor.constraint(equalTo: starsratingView.trailingAnchor, constant: 15),
            reviewButton.centerYAnchor.constraint(equalTo: starsratingView.centerYAnchor),
            reviewButton.leadingAnchor.constraint(equalTo: reviewsLabel.trailingAnchor, constant: 15),
            
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
    
    //MARK: - SetupTopView with Data
    func setupTopView(controllerWidth width: CGFloat, club: Club) -> CGFloat {
        
        if let account = UserDefaults.standard.string(forKey: "number") {
            ClubsNetworkManager.shared.getClubReviews(for: account, clubId: club.id ?? 0) { (result) in
                switch result {
                case .success(let reviews):
                    DispatchQueue.main.async {
                        if let reviewsCount = reviews.results?.count, let result = reviews.results {
                            self.reviewsLabel.text = "\(reviewsCount) отзыв(ов)"
                            self.reviews = result
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        starsratingView.rating = Double(club.rate ?? 0)
        locationLabel.text = club.city?.name
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
    
    func updateReviews(with review: Review, and club: Club) {
        reviews.append(review)
        reviewsLabel.text = "\(reviews.count) отзыв(ов)"
        starsratingView.rating = Double(club.rate ?? 0)
    }
    
    @objc private func leaveReview() {
        didTapMakeReviewButton?()
    }
    
    @objc private func showReviews() {
        didTapShowReviews?(reviews)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
