//
//  DynamicalLabelSize.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 19.11.2020.
//
import UIKit

class DynamicalLabelSize {
    
    static func height(text: String?, font: UIFont, width: CGFloat) -> CGFloat {
        var currentHeight: CGFloat!
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.text = text
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        
        currentHeight = label.frame.height
        label.removeFromSuperview()
    
        return currentHeight
    }
}
