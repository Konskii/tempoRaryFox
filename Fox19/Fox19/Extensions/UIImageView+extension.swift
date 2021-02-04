//
//  UIImageView+extension.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 19.01.2021.
//

import UIKit

extension UIImageView {
    convenience init(imageName:String?, playerGandicap:String?, image: UIImage? = nil, fogLayer: Bool = true) {
        self.init()
        if image != nil {
            self.image = image
        }
        if let name = imageName {
            self.image = UIImage(named: name)
        }
       
        self.contentMode = .scaleAspectFit
        self.layer.cornerRadius = 41/2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        
        if fogLayer {
            let viewForPlayer = UIView()
            addSubview(viewForPlayer)
            viewForPlayer.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1725490196, blue: 0.3058823529, alpha: 0.5)
            viewForPlayer.contentMode = .scaleAspectFit
            viewForPlayer.clipsToBounds = true
            viewForPlayer.layer.cornerRadius = 41 / 2
            viewForPlayer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                viewForPlayer.centerXAnchor.constraint(equalTo: centerXAnchor),
                viewForPlayer.centerYAnchor.constraint(equalTo: centerYAnchor),
                viewForPlayer.heightAnchor.constraint(equalToConstant: 41),
                viewForPlayer.widthAnchor.constraint(equalToConstant: 41),
            ])
            
        }
        
        if let playerGandicap = playerGandicap {
            let gandicap = UILabel(text: playerGandicap,
                                   font: .avenir(fontSize: 13),
                                   textColor: .white)
            addSubview(gandicap)
            gandicap.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                gandicap.centerXAnchor.constraint(equalTo: centerXAnchor),
                gandicap.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
            
    }
}


