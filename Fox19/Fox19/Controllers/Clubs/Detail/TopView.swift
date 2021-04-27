//
//  TopView.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 22.10.2020.
//

import UIKit
import Cosmos
import ReadMoreTextView


class TopView: UIView {

    private let orangeColor = UIColor(red: 242/255, green: 122/255, blue: 42/255, alpha: 1)
    private let separatorColor = UIColor(red: 225/255, green: 236/255, blue: 249/255, alpha: 1)
    
    private let starsCosmosViewRating = CosmosView()
    private let holeImageView = UIImageView()
    private let holeLable = UILabel(text: "",
                                    font: UIFont(name: "Inter-Medium", size: 15),
                                    textColor: UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1))
    
    private let pointerImageView = UIImageView()
    private let pointerLable = UILabel(text: "500",
                                       font: UIFont(name: "Inter-Medium", size: 15),
                                       textColor: UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1))
    

    private let titleLabel = UILabel()
    private let separator = UIView()
 //   private let textView = ReadMoreTextView()
    private let textView = UILabel()
    //
    
    var didTapMakeReviewButton: (() -> Void)?
    var didTapShowReviews: (([Review]) -> Void)?
    
    var imageViews = [UIImageView]()
    //
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        starsCosmosViewRating.settings.emptyImage = UIImage(named: "emptyStar")
        starsCosmosViewRating.settings.filledImage = UIImage(named: "filledStar")
        starsCosmosViewRating.settings.starSize = 22
        starsCosmosViewRating.settings.fillMode = .precise
        starsCosmosViewRating.settings.updateOnTouch = false
        starsCosmosViewRating.rating = 0
        
        holeImageView.image = UIImage(named: "holeImage")
        holeImageView.clipsToBounds = true
        
        pointerImageView.image = UIImage(named: "locationPointer")
        pointerImageView.clipsToBounds = true

        titleLabel.textColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        titleLabel.font = UIFont(name: "Inter-Regular", size: 23)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.sizeToFit()
        
        textView.numberOfLines = 0
        textView.font = UIFont(name: "Inter-Regular", size: 13)
//        textView.shouldTrim = true
//        textView.maximumNumberOfLines = 3
        let text = "Первое в России Чемпионское 18-луночное гольф-поле (пар 72, 6464 метра), расположенное в настоящем лесу с озерами и певчими птицами."
//        let attributedString = NSMutableAttributedString(string: text)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 5
//        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
//
//        attributedString.addAttribute(.font, value:  UIFont(name: "Inter-Regular", size: 16) ??  UIFont.systemFont(ofSize: 16, weight: .medium), range: NSMakeRange(0, attributedString.length))
//        textView.attributedText = attributedString
        
        textView.text = text
//        let attributedStringReadMore = NSMutableAttributedString(string: "...ещё")
//        attributedStringReadMore.addAttributes([
//            .font : UIFont(name: "Inter-Regular", size: 16) ??  UIFont.systemFont(ofSize: 16, weight: .medium),
//            .foregroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
//        ], range:NSMakeRange(0, attributedStringReadMore.length))
//
//        textView.attributedReadMoreText = attributedStringReadMore
        
        separator.backgroundColor = UIColor(red: 240/255, green: 241/255, blue: 244/255, alpha: 1)
        
        addSubview(titleLabel)
        addSubview(holeImageView)
        addSubview(holeLable)
        addSubview(pointerImageView)
        addSubview(pointerLable)
        addSubview(starsCosmosViewRating)
        addSubview(textView)
        addSubview(separator)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        holeImageView.translatesAutoresizingMaskIntoConstraints = false
        holeLable.translatesAutoresizingMaskIntoConstraints = false
        pointerImageView.translatesAutoresizingMaskIntoConstraints = false
        pointerLable.translatesAutoresizingMaskIntoConstraints = false
        starsCosmosViewRating.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
      
            
            holeImageView.widthAnchor.constraint(equalToConstant: 29),
            holeImageView.heightAnchor.constraint(equalToConstant: 29),
            holeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            holeImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 11),
            
            holeLable.centerYAnchor.constraint(equalTo: holeImageView.centerYAnchor),
            holeLable.leadingAnchor.constraint(equalTo: holeImageView.trailingAnchor, constant: 5),

            pointerImageView.widthAnchor.constraint(equalToConstant: 29),
            pointerImageView.heightAnchor.constraint(equalToConstant: 29),
            pointerImageView.leadingAnchor.constraint(equalTo: holeImageView.trailingAnchor, constant: 90),
            pointerImageView.centerYAnchor.constraint(equalTo: holeImageView.centerYAnchor),
            pointerLable.leadingAnchor.constraint(equalTo: pointerImageView.trailingAnchor, constant: 4),
            pointerLable.centerYAnchor.constraint(equalTo: holeImageView.centerYAnchor),

            starsCosmosViewRating.centerYAnchor.constraint(equalTo: holeImageView.centerYAnchor),
            starsCosmosViewRating.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            textView.topAnchor.constraint(equalTo: holeImageView.bottomAnchor, constant: 24),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            
        ])
    }
    
    //MARK: - SetupTopView with Data
    func setupTopView(controllerWidth width: CGFloat, club: Club) -> CGFloat {
        
        starsCosmosViewRating.rating = Double(club.rate ?? 0)
        titleLabel.text = club.title
        holeLable.text = "\(club.holes ?? 0)"
        
        let widthWithInset = width - 40
        let pointerHeight = 29 + 11
        
        let totalInsets = 16 + 24
        let separatorInset = CGFloat(11)
        
        let mainLableHeight = DynamicalLabelSize.height(text: titleLabel.text,
                                          font: titleLabel.font,
                                          width: widthWithInset)
        let textViewHeigth = DynamicalLabelSize.height(text: textView.text,
                                                       font: textView.font,
                                          width: widthWithInset)
        
        print(textViewHeigth)
        let height = mainLableHeight + CGFloat(pointerHeight) + textViewHeigth + CGFloat(totalInsets) + separatorInset
        
        return height
    }
    
    //START DELETE
    func updateReviews(with review: Review, and club: Club) {
   
    }
    
    @objc private func leaveReview() {
        didTapMakeReviewButton?()
    }
    
    @objc private func showReviews() {
 
    }
    //END DELETE
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
