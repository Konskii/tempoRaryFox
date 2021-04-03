//
//  ClubsCollectionViewCell.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 16.10.2020.
//

import UIKit
import Cosmos

protocol CelTapHandlerProtocol: class {
    func bookmarkButtonPressed(button: UIButton, club: Club, index:Int)
    func imageButtonTap(clubData: Club, coverImage: UIImage, itemIndex:Int)
}

class ClubsCollectionViewCell: UICollectionViewCell {
    
    static let reusedID = "ClubsCell"
    
    weak var delegate: CelTapHandlerProtocol?
    
    private let coverImageButton = UIButton()
    private var coverImage = UIImage()
    private let locationLabel = UILabel()
    private let clubNameLabel = UILabel()
    private let starsCosmosViewRating = CosmosView()
    private let bookMarkButton = UIButton()
    
    private let locationPointer = UIImageView(image: UIImage(named: "Pointer"))
    
    private var club: Club!
    private var itemIndex: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        coverImageButton.backgroundColor = .darkGray
        coverImageButton.layer.cornerRadius = 8
        coverImageButton.clipsToBounds = true
        coverImageButton.addTarget(self, action: #selector(imageButtonPresed), for: .touchUpInside)
        
        bookMarkButton.setImage(UIImage(named: "Bookmark"), for: .normal)
        bookMarkButton.addTarget(self, action: #selector(bookmarkPressed), for: .touchUpInside)
        
        locationPointer.clipsToBounds = true
        
        locationLabel.text = "Bermuda"
        locationLabel.textColor = .white
        locationLabel.font = UIFont(name: "Avenir-Medium", size: 15)
        
        clubNameLabel.textColor = .white
        clubNameLabel.font = UIFont(name: "Avenir Next Bold", size: 17)
        
        //starsImageView.image = UIImage(named: "Stars")
        starsCosmosViewRating.settings.emptyImage = UIImage(named: "emptyStar")
        starsCosmosViewRating.settings.filledImage = UIImage(named: "filledStar")
        starsCosmosViewRating.settings.starSize = 22
        starsCosmosViewRating.settings.fillMode = .precise
        starsCosmosViewRating.settings.updateOnTouch = false
        starsCosmosViewRating.rating = 0
        
        addSubview(coverImageButton)
        addSubview(bookMarkButton)
        addSubview(locationPointer)
        addSubview(locationLabel)
        addSubview(clubNameLabel)
        addSubview(starsCosmosViewRating)
        
        coverImageButton.translatesAutoresizingMaskIntoConstraints = false
        bookMarkButton.translatesAutoresizingMaskIntoConstraints = false
        locationPointer.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        clubNameLabel.translatesAutoresizingMaskIntoConstraints = false
        starsCosmosViewRating.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coverImageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bookMarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            bookMarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            locationPointer.widthAnchor.constraint(equalToConstant: 20),
            locationPointer.heightAnchor.constraint(equalToConstant: 20),
            locationPointer.topAnchor.constraint(equalTo: coverImageButton.topAnchor, constant: 11),
            locationPointer.leadingAnchor.constraint(equalTo: coverImageButton.leadingAnchor, constant: 13)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: coverImageButton.topAnchor, constant: 11),
            locationLabel.leadingAnchor.constraint(equalTo: locationPointer.trailingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            clubNameLabel.bottomAnchor.constraint(equalTo: coverImageButton.bottomAnchor, constant: -42),
            clubNameLabel.leadingAnchor.constraint(equalTo: coverImageButton.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            starsCosmosViewRating.bottomAnchor.constraint(equalTo: coverImageButton.bottomAnchor, constant: -12),
            starsCosmosViewRating.leadingAnchor.constraint(equalTo: coverImageButton.leadingAnchor, constant: 13)
        ])
    }
    
    func cellSetup(with result: Club, index: Int) {
        self.itemIndex = index
        club = result
        starsCosmosViewRating.rating = Double(result.rate ?? 0)
        clubNameLabel.text = result.title
        locationLabel.text = result.city?.name
        let image = result.like ?? false ? UIImage(named: "ColorBookmark") : UIImage(named: "Bookmark")
        bookMarkButton.setImage(image, for: .normal)
        
        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
        ClubsNetworkManager.shared.getImageForClubCover(for: account, clubId: result.id ?? 0) { (result) in
            switch result {
            case .success(let data):
                let url = data.results?.first?.image
                ClubsNetworkManager.shared.downloadImageForCover(from: url ?? "", account: account) { (result) in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self.coverImageButton.setImage(UIImage(data: data), for: .normal)
                            self.coverImage = UIImage(data: data) ?? UIImage()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    @objc func imageButtonPresed() {
        guard let club = club else { return }
        delegate?.imageButtonTap(clubData: club, coverImage: coverImage, itemIndex: itemIndex)
    }
    
    @objc func bookmarkPressed() {
        delegate?.bookmarkButtonPressed(button: bookMarkButton, club: club, index: itemIndex)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
