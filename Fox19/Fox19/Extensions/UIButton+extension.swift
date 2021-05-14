//
//  UIButton+extension.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 15.01.2021.
//

import UIKit

extension UIButton {
    
    convenience init(title: String, textColor: UIColor, buttonImageColor: UIColor) {
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: "Avenir", size: 12)
        setTitleColor(textColor, for: .normal)
        titleEdgeInsets.left = 50
        
        let imageForButton = UIImageView(image: UIImage(named: "acceptButton"))
        imageForButton.tintColor = buttonImageColor
        imageForButton.translatesAutoresizingMaskIntoConstraints = false
        imageForButton.contentMode = .scaleAspectFit
        addSubview(imageForButton)
        
        imageForButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageForButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageForButton.widthAnchor.constraint(equalToConstant: 41).isActive = true
        imageForButton.heightAnchor.constraint(equalToConstant: 41).isActive = true
    }
    
    convenience init(title: String, textColor: UIColor, imageName: String, buttonImageColor: UIColor) {
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        titleLabel?.font =  UIFont(name: "Inter-Regular", size: 13)
      //  titleLabel?.textAlignment = .left
        setTitleColor(textColor, for: .normal)
        titleEdgeInsets.left = 50
        
        
        let imageForButton = UIImageView(image: UIImage(systemName: imageName))
        imageForButton.tintColor = buttonImageColor
        imageForButton.translatesAutoresizingMaskIntoConstraints = false
        imageForButton.contentMode = .scaleAspectFit
        addSubview(imageForButton)
        
        imageForButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageForButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageForButton.widthAnchor.constraint(equalToConstant: 29).isActive = true
        imageForButton.heightAnchor.constraint(equalToConstant: 29).isActive = true
    }
}
