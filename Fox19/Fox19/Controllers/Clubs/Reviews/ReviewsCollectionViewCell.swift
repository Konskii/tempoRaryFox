//
//  ReviewsCollectionViewCell.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 15.03.2021.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {
    static let reusedID = "ReviewsCollectionViewCell"
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let bodyLabel = UILabel()
    private let separatorView = UIView()
    private var showsSeparator = true {
        didSet {
            updateSeparator()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with review: Review, showsSeparator: Bool) {
        titleLabel.text = review.user?.name
        dateLabel.text = review.dateOnly
        bodyLabel.text = review.description
        self.showsSeparator = showsSeparator
    }
    
}

extension ReviewsCollectionViewCell {
    private func configure() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.adjustsFontForContentSizeCategory = true
        dateLabel.adjustsFontForContentSizeCategory = true
        bodyLabel.adjustsFontForContentSizeCategory = true
        
        titleLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
        
        titleLabel.font = UIFont(name: "Avenir-Light", size: 17)
        dateLabel.font = UIFont(name: "Avenir-Light", size: 15)
        bodyLabel.font = UIFont(name: "Avenir-Light", size: 19)
        
        separatorView.backgroundColor = .placeholderText
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(separatorView)
        
        let views = ["title": titleLabel, "date": dateLabel, "body": bodyLabel, "separator": separatorView]
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[title]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[date]", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[body]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[separator]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[title]-[date]-[body]-20-[separator(==1)]|",
            options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(constraints)
    }
   private func updateSeparator() {
        separatorView.isHidden = !showsSeparator
    }
}
