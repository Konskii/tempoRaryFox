//
//  ProfileAvatarHeader.swift
//  Fox19
//
//  Created by Артём Скрипкин on 04.12.2020.
//

import UIKit

protocol needToUpdateAvatarProtocol: class {
    func needToUpdate()
}

class ProfileAvatarHeader: UITableViewHeaderFooterView {
    
    static let reusedId = "ProfileAvatarHeader"
    
    weak var delegate: needToUpdateAvatarProtocol?
    
    //MARK: - UI Elements
    private lazy var outerView: UIView = {
        let outerView = UIView()
        outerView.layer.borderWidth = 3
        outerView.layer.cornerRadius = 71
        outerView.layer.shadowRadius = 10
        outerView.layer.shadowOpacity = 1
        outerView.backgroundColor = .white
        outerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.borderColor = UIColor.white.cgColor
        outerView.translatesAutoresizingMaskIntoConstraints = false
        return outerView
    }()
    
    private lazy var avatarView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "LoginLogo"))
        view.clipsToBounds = true
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 71
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var changeButton: UIImageView = {
        let view = UIImageView(image: UIImage(named: "changePhoto"))
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleToFill
        let tap = UITapGestureRecognizer(target: self, action: #selector(changePressed))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - UserInteraction Methods
    @objc private func changePressed() {
        delegate?.needToUpdate()
    }
    
    //MARK: - Methods
    private func setupConstraints() {
        contentView.addSubview(outerView)
        outerView.addSubview(avatarView)
        contentView.addSubview(changeButton)
        
        NSLayoutConstraint.activate([
            outerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            outerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            outerView.heightAnchor.constraint(equalToConstant: 142),
            outerView.widthAnchor.constraint(equalToConstant: 142),
            
            avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 142),
            avatarView.widthAnchor.constraint(equalToConstant: 142),
            
            changeButton.heightAnchor.constraint(equalToConstant: 40),
            changeButton.widthAnchor.constraint(equalToConstant: 40),
            changeButton.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor),
            changeButton.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor)
        ])
    }
    
    public func setImage(image: UIImage?) {
        guard let newImage = image else { return }
        avatarView.image = newImage
    }
    
    //MARK: - Inits
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
