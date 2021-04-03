//
//  TournamentsCollectionViewCell.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 16.10.2020.
//

import UIKit

class TournamentsCollectionViewCell: UICollectionViewCell {
    
    static let reusedID = "TournamentsCell"
    
    private let imageView = UIImageView()
    private let locationLabel = UILabel()
    private let tournamentLabel = UILabel()
    private let dateLable = UILabel()
    
    private let locationPointer = UIImageView(image: UIImage(named: "Pointer"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.backgroundColor = .darkGray
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "ImageForTest")
        
        locationPointer.clipsToBounds = true
        
        locationLabel.text = "Bermuda"
        locationLabel.textColor = .white
        locationLabel.font = UIFont(name: "Avenir-Medium", size: 15)
        
        tournamentLabel.text = "Bermuda Championship"
        tournamentLabel.textColor = .white
        tournamentLabel.font = UIFont(name: "Avenir Next Bold", size: 17)
        
        dateLable.text = "dd.MM.YYYY"
        dateLable.textColor = .white
        dateLable.font = UIFont(name: "Avenir Light", size: 15)
        
        addSubview(imageView)
        addSubview(locationPointer)
        addSubview(locationLabel)
        addSubview(tournamentLabel)
        addSubview(dateLable)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        locationPointer.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        tournamentLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            locationPointer.widthAnchor.constraint(equalToConstant: 20),
            locationPointer.heightAnchor.constraint(equalToConstant: 20),
            locationPointer.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 15),
            locationPointer.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 13)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 14),
            locationLabel.leadingAnchor.constraint(equalTo: locationPointer.trailingAnchor, constant: 5)
        ])
        
        NSLayoutConstraint.activate([
            tournamentLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -38),
            tournamentLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            dateLable.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -13),
            dateLable.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 18)
        ])
    }
    
    func cellSetup(with item: Tournament) {
        tournamentLabel.text = item.title
        
        locationLabel.text = item.club?.city?.name

        guard let date = item.date?.value  else { return }
        let dataFormater = DateFormatter()
        dataFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateObj = dataFormater.date(from: date)!
        dataFormater.dateFormat = "dd-MM-YYYY"
        dateLable.text = dataFormater.string(from: dateObj)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
