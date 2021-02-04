//
//  ClubsCollectionViewCell.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 16.10.2020.
//

import UIKit
protocol CelTapHandlerProtocol: class {
    func bookmarkButtonPressed(button: UIButton)
    func imageButtonTap(clubData: Club, coverImage: UIImage)
}

class ClubsCollectionViewCell: UICollectionViewCell {
    
    static let reusedID = "ClubsCell"
    
    weak var delegate: CelTapHandlerProtocol?
    
    private let coverImageButton = UIButton()
    private var coverImage = UIImage()
    private let locationLabel = UILabel()
    private let clubNameLabel = UILabel()
    private let starsImageView = UIImageView()
    private let bookMarkButton = UIButton()
    
    private let locationPointer = UIImageView(image: UIImage(named: "Pointer"))
    
    private var club: Club!
    
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
        
        starsImageView.image = UIImage(named: "Stars")
        
        addSubview(coverImageButton)
        addSubview(bookMarkButton)
        addSubview(locationPointer)
        addSubview(locationLabel)
        addSubview(clubNameLabel)
        addSubview(starsImageView)
        
        coverImageButton.translatesAutoresizingMaskIntoConstraints = false
        bookMarkButton.translatesAutoresizingMaskIntoConstraints = false
        locationPointer.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        clubNameLabel.translatesAutoresizingMaskIntoConstraints = false
        starsImageView.translatesAutoresizingMaskIntoConstraints = false
        
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
            starsImageView.bottomAnchor.constraint(equalTo: coverImageButton.bottomAnchor, constant: -12),
            starsImageView.leadingAnchor.constraint(equalTo: coverImageButton.leadingAnchor, constant: 13)
        ])
    }
    
    func cellSetup(with result: Club) {
        club = result
        clubNameLabel.text = result.title
        
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
        delegate?.imageButtonTap(clubData: club, coverImage: coverImage)
    }
    
    @objc func bookmarkPressed() {
        delegate?.bookmarkButtonPressed(button: bookMarkButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
