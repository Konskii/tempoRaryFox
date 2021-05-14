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
    
    private let blueColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1)
    
    static let reusedID = "ClubsCell"
    
    weak var delegate: CelTapHandlerProtocol?
    
    private let coverImageButton = UIButton()
    private var coverImage = UIImage()
    private let clubNameLabel = UILabel()
    private let starsCosmosViewRating = CosmosView()
    private let bookMarkButton = UIButton()
    private let holeImageView = UIImageView()
    private let holeLable = UILabel(text: "",
                                    font: UIFont(name: "Inter-Medium", size: 15),
                                    textColor: UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1))
    
    private let pointerImageView = UIImageView()
    private let pointerLable = UILabel(text: "",
                                       font: UIFont(name: "Inter-Medium", size: 15),
                                       textColor: UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1))
    
    private var club: Club!
    private var itemIndex: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 8
        
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        
        
        coverImageButton.backgroundColor = .darkGray
        coverImageButton.layer.cornerRadius = 8
        coverImageButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        coverImageButton.clipsToBounds = true
        coverImageButton.addTarget(self, action: #selector(imageButtonPresed), for: .touchUpInside)
        
        bookMarkButton.setImage(UIImage(named: "heartButton"), for: .normal)
        bookMarkButton.addTarget(self, action: #selector(bookmarkPressed), for: .touchUpInside)
        
        clubNameLabel.textColor = .white
        clubNameLabel.font = UIFont(name: "Inter-Medium", size: 19)
        clubNameLabel.numberOfLines = 0
        
        
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
        
        addSubview(coverImageButton)
        addSubview(bookMarkButton)
        addSubview(clubNameLabel)
        addSubview(starsCosmosViewRating)
        addSubview(holeImageView)
        addSubview(holeLable)
        addSubview(pointerImageView)
        addSubview(pointerLable)
        
        coverImageButton.translatesAutoresizingMaskIntoConstraints = false
        bookMarkButton.translatesAutoresizingMaskIntoConstraints = false
        clubNameLabel.translatesAutoresizingMaskIntoConstraints = false
        starsCosmosViewRating.translatesAutoresizingMaskIntoConstraints = false
        holeImageView.translatesAutoresizingMaskIntoConstraints = false
        holeLable.translatesAutoresizingMaskIntoConstraints = false
        pointerImageView.translatesAutoresizingMaskIntoConstraints = false
        pointerLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coverImageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -44),
            coverImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bookMarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            bookMarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bookMarkButton.widthAnchor.constraint(equalToConstant: 29),
            bookMarkButton.heightAnchor.constraint(equalToConstant: 29),
            
        ])
        
        NSLayoutConstraint.activate([
            clubNameLabel.topAnchor.constraint(equalTo: coverImageButton.topAnchor, constant: 11),
            clubNameLabel.leadingAnchor.constraint(equalTo: coverImageButton.leadingAnchor, constant: 13),
            clubNameLabel.trailingAnchor.constraint(equalTo: bookMarkButton.leadingAnchor, constant: 0)
        ])
        
        
        NSLayoutConstraint.activate([
            starsCosmosViewRating.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            starsCosmosViewRating.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            holeImageView.widthAnchor.constraint(equalToConstant: 29),
            holeImageView.heightAnchor.constraint(equalToConstant: 29),
            holeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            holeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            
            holeLable.leadingAnchor.constraint(equalTo: holeImageView.trailingAnchor, constant: 4),
            holeLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            
            pointerImageView.widthAnchor.constraint(equalToConstant: 29),
            pointerImageView.heightAnchor.constraint(equalToConstant: 29),
            pointerImageView.leadingAnchor.constraint(equalTo: holeImageView.trailingAnchor, constant: 90),
            pointerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            pointerLable.leadingAnchor.constraint(equalTo: pointerImageView.trailingAnchor, constant: 4),
            pointerLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            
        ])
    }
    
    func cellSetup(with result: Club, index: Int) {
        self.itemIndex = index
        club = result
        starsCosmosViewRating.rating = Double(result.rate ?? 0)
        holeLable.text = "\(result.holes ?? 0)"
        pointerLable.text = "500"
        let attributedString = NSMutableAttributedString(string: result.title ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        clubNameLabel.attributedText = attributedString
        let image = result.like ?? false ? UIImage(named: "heartButtonFilled") : UIImage(named: "heartButton")
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
