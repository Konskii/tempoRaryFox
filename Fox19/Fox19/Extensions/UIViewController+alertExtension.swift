//
//  UIViewController+alertExtension.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 08.02.2021.
//

import UIKit

extension UIViewController {
    ///Async method to show basic alert with title, message and "OK" button
    func showAlert(title: String = "Возникла ошибка", message: String = "", firstButtonText: String = "Ok", handler: @escaping (UIAlertAction) -> Void = {_ in}, additionalActions: [UIAlertAction] = []) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: firstButtonText, style: .default, handler: handler)
            alertController.addAction(action)
            for action in additionalActions {
                alertController.addAction(action)
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
