//
//  UIViewController+alertExtension.swift
//  Fox19
//
//  Created by Артём Скрипкин on 04.02.2021.
//

import UIKit

extension UIViewController {
    ///Async method to show basic alert with title, message and "OK" button
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
