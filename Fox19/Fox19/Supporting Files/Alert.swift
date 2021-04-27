//
//  Alert.swift
//  Course2FinalTask
//
//  Created by Mykhailo Romanovskyi on 17.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    class func showAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Внимание", message: "Данная функция в разработке", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
