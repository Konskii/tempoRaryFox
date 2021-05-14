//
//  SignUpViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 28.10.2020.
//

import UIKit
import PhoneNumberKit

class SignUpViewController: UIViewController {
    
    private let phoneKit = PhoneNumberKit()
    
    private lazy var textField: PhoneNumberTextField = {
        let view = PhoneNumberTextField(withPhoneNumberKit: self.phoneKit)
        view.withFlag = true
        view.withPrefix = true
        view.withExamplePlaceholder = true
        view.withDefaultPickerUI = true
        view.textColor = .white
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        view.attributedPlaceholder = NSAttributedString(string: "Enter your phone number", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)])
        let bar = UIToolbar()
        let send = UIBarButtonItem(title: "Получить код", style: .done, target: self, action: #selector(sendTapped))
        bar.setItems([send], animated: true)
        bar.sizeToFit()
        view.inputAccessoryView = bar
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var helloTextLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Avenir-Book", size: 17)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        view.textColor = .white
        view.text = "Добро пожаловать, введите номер\n телефона для входа"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "LoginWithPhoneNumber"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
     //   switchKeyBoard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    //MARK: - Methods
    
    private func setupConstraints() {
        view.addSubview(backgroundView)
        view.addSubview(textField)
        view.addSubview(helloTextLabel)
        
        let constraints = [
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            helloTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloTextLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
            
            textField.topAnchor.constraint(equalTo: helloTextLabel.bottomAnchor, constant: 43.69),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 46.37),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -46.37)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //Для запроса на сервер
    private func getFormattedNumber() -> String {
        guard let phone = textField.text else { return "" }
        guard let code = textField.phoneNumber?.countryCode else { return "" }
        
        let number = "+" + String(code) + PartialFormatter().nationalNumber(from: phone)
        
        return number
    }
    
    @objc private func sendTapped() {
        hideKeyboard()
        let phone = getFormattedNumber()
        UserDefaults.standard.setValue(phone, forKey: "number")
        LocalDataProvider.number = phone
                NetworkManager.shared.getCodeForVarification(witn: phone) { (result) in
                    switch result {
                    case .success(let data):
                            DispatchQueue.main.async {
                                let vc = SmsVareficationViewController()
                                vc.setupData(data: data)
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                    case .failure(let error):
                        print(error.localizedDescription)
                        print("Its erro")
                    }
                }
        //Здесь запрос + переход на VC с вводом кода
    }
}

//MARK: - Manage keyboard and content move

extension SignUpViewController {
    
    private func switchKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.textField.frame.origin.y == 0 && self.helloTextLabel.frame.origin.y == 0 {
                self.textField.frame.origin.y -= keyboardSize.height
                self.helloTextLabel.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.textField.frame.origin.y != 0 && self.helloTextLabel.frame.origin.y != 0 {
            self.textField.frame.origin.y = 0
            self.helloTextLabel.frame.origin.y = 0
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
        textField.attributedPlaceholder = NSAttributedString(string: "Enter your phone number", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)])
    }
}
