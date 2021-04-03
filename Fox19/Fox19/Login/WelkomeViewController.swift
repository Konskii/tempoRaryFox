//
//  TestWelcome.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 10.11.2020.
//
import UIKit
class WelkomeViewController: UIViewController  {
    
    private var topBackgroundView: UIImageView!
    private var bottomBackgtoundView: UIImageView!
    private var logoImageview: UIImageView!
    
    private var welkomeLable: UILabel!
    private var nameLabel: UILabel!
    
    private var textField: UITextField!
    private var lineView: UIView!
    
    private var nextButton: UIButton!
    
    private var arrowImageView: UIImageView!
    
    private var data: Int!
    
    func setupData(data: Int) {
        self.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllElements()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupAllElements() {
        topBackgroundView = UIImageView()
        topBackgroundView.image = UIImage(named: "Rectangle")
        topBackgroundView.clipsToBounds = true
        topBackgroundView.layer.cornerRadius = 18
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBackgtoundView = UIImageView()
        bottomBackgtoundView.image = UIImage(named: "Kentucky")
        bottomBackgtoundView.clipsToBounds = true
        bottomBackgtoundView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageview = UIImageView()
        logoImageview.image = UIImage(named: "LoginLogo")
        logoImageview.contentMode = .scaleAspectFill
        logoImageview.clipsToBounds = true
        logoImageview.translatesAutoresizingMaskIntoConstraints = false
        
        welkomeLable = UILabel()
        welkomeLable.adjustsFontForContentSizeCategory = true
        welkomeLable.text = "Добро\nпожаловать\nв мир гольфа"
        welkomeLable.textColor = .white
        welkomeLable.font = UIFont(name: "Merriweather-Regular", size: 35)
        welkomeLable.numberOfLines = 3
        welkomeLable.lineBreakMode = .byWordWrapping
        welkomeLable.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel = UILabel()
        nameLabel.text = "Отображаемое имя"
        nameLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        nameLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField = UITextField()
        textField.keyboardType = .default
        textField.inputAccessoryView = createToolBar()
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.font = UIFont(name: "Avenir-Medium", size: 17)
        textField.textAlignment = .left
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        lineView = UIView()
        lineView.backgroundColor = .white
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton = UIButton(type: .system)
        let attributesForTitle: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 1, green: 0.537, blue: 0, alpha: 1),
            .font: UIFont(name: "Avenir-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        let attrTitle = NSAttributedString(string: "Далее", attributes: attributesForTitle)
        nextButton.setAttributedTitle(attrTitle, for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "arrow")
        arrowImageView.contentMode = .scaleAspectFill
        arrowImageView.clipsToBounds = true
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(bottomBackgtoundView)
        view.addSubview(topBackgroundView)
        view.addSubview(logoImageview)
        view.addSubview(nameLabel)
        
        view.addSubview(welkomeLable)
        view.addSubview(textField)
        view.addSubview(lineView)
        
        view.addSubview(nextButton)
        view.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            bottomBackgtoundView.heightAnchor.constraint(equalToConstant: 100),
            bottomBackgtoundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBackgtoundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBackgtoundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundView.bottomAnchor.constraint(equalTo: bottomBackgtoundView.topAnchor, constant: 10),
            topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            
            logoImageview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 41),
            logoImageview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 41),
            logoImageview.heightAnchor.constraint(equalToConstant: 85),
            logoImageview.widthAnchor.constraint(equalToConstant: 55),
            
            welkomeLable.topAnchor.constraint(equalTo: logoImageview.bottomAnchor, constant: 87),
            welkomeLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 29),
            
            nameLabel.topAnchor.constraint(equalTo: welkomeLable.bottomAnchor, constant: 44),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            textField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -145),
            
            lineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 3),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -69),
            
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 162),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -135),
            
            arrowImageView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: nextButton.trailingAnchor, constant: 23)
            
        ])
    }
    
    private func createToolBar() ->UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(hideKeyboard))
        toolbar.setItems([doneButton], animated: true)
        return toolbar
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func buttonPressed() {
        if textField.text != "", let name = textField.text {
            guard let number = UserDefaults.standard.string(forKey: "number") else { return }
            guard let token = Keychainmanager.shared.getToken(account: number) else { return }
            
            NetworkManager.shared.putUser(id: data,
                                          name: name,
                                          token: token) { (result) in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        AppDelegate.shared.rootViewController.showMainTabBarScreen()
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            print("Empty")
        }
    }
}

extension WelkomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Тут возможно добавить действия на нажатие кнопки return. Или удалить.
        true
    }
    
}
