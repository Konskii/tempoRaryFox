//
//  UITextField+separatorLineExtension.swift
//  Fox19
//
//  Created by Артём Скрипкин on 23.04.2021.
//

import UIKit

extension UITextField {
    convenience init(separatorImage: UIImage? = nil) {
        self.init()
        textColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        backgroundColor = .white
        let separator = UIImageView(image: separatorImage ?? UIImage(named: "ProfileSeparator"))
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: bottomAnchor, constant: 10),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
