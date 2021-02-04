//
//  UILabel+extension.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 16.01.2021.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont?, textColor: UIColor) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
