//
//  WelkomeViewController.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 27.10.2020.
//

import UIKit
import EZYGradientView

class WelkomeViewControllerOld: UIViewController {
    
    private var backGroundView = UIImageView()
    private var imageView = UIImageView()
    private var nextLable = UILabel()
    private var logoView = UIImageView()
    private var welkomeLable = UILabel()
    private var nameLable = UILabel()
    private var textField = UITextField()
    private var dashView = UIView()
    private var arrowView = UIImageView()
    
    var userNameForSave = ""
    var userEmail = ""
    
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchKeyBoard()
        textField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround()
        setImageview()
        setButton()
        setNameLable()
        setLogoView()
        setTextField()
        setDashView()
        setArrowView()
        setWelkomeLable()
        setupConstraints()
        handleTapToHideKeyboard()
    }
    
    
    //MARK: - Methods
    
    
    //Конпка далее
    private func setButton() {
        nextLable.text = "Далее"
        nextLable.textColor = UIColor(red: 1, green: 0.537, blue: 0, alpha: 1)
        nextLable.font = UIFont(name: "Avenir-Medium", size: 17)
        nextLable.translatesAutoresizingMaskIntoConstraints = false
        
        let gester = UITapGestureRecognizer(target: self, action: #selector(setNextView))
        nextLable.addGestureRecognizer(gester)
        nextLable.isUserInteractionEnabled = true
    }
    @objc func setNextView() {

        switch nameLable.text {
        case "Отображаемое имя":
            textField.text = userNameForSave
            textField.text = ""
            nameLable.text = "E-mail"
        case "E-mail":
            textField.text = userEmail
            textField.text = ""
            nextLable.text = "Готово"
        default:
            break
        }
        
        if nextLable.text == "Готово" {
            //TODO: - Переход на необходимый экран
            print("Переход")
        }
    }
    
    
    private func setBackGround() {
        backGroundView = UIImageView()
        backGroundView.image = UIImage(named: "Rectangle")
        backGroundView.frame.size = view.bounds.size
        backGroundView.layer.cornerRadius = 50
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //LogoView
    private func setLogoView() {
        logoView = UIImageView()
        logoView.image = UIImage(named: "LoginLogo")
        logoView.contentMode = .scaleAspectFill
        logoView.clipsToBounds = true
        logoView.translatesAutoresizingMaskIntoConstraints = false
        backGroundView.addSubview(logoView)

    }
    
    //BackgroundImage
    private func setImageview() {
        imageView = UIImageView()
        imageView.image = UIImage(named: "Kentucky")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    //Лейбл Welkome
    private func setWelkomeLable() {
        welkomeLable = UILabel()
        welkomeLable.adjustsFontForContentSizeCategory = true
        welkomeLable.text = "Добро\nпожаловать\nв мир гольфа"
        welkomeLable.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        welkomeLable.font = UIFont(name: "Merriweather-light", size: 35) //-Light
        welkomeLable.font = .systemFont(ofSize: 35)
        welkomeLable.numberOfLines = 3
        welkomeLable.lineBreakMode = .byWordWrapping
        welkomeLable.translatesAutoresizingMaskIntoConstraints = false
        backGroundView.addSubview(welkomeLable)
    }
    
    //Лейбл Отображаемое имя
    private func setNameLable() {
        nameLable.text = "Отображаемое имя"
        nameLable.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        nameLable.font = UIFont(name: "Avenir-Medium", size: 12)
        nameLable.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //Окно ввода
    private func setTextField() {
        textField.backgroundColor = .clear
        textField.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        textField.font = UIFont(name: "Avenir-Medium", size: 17)
        textField.textAlignment = .left
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //Линия
    private func setDashView() {
        dashView.backgroundColor = .white
        dashView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //Arrow
    private func setArrowView() {
        arrowView = UIImageView()
        arrowView.image = UIImage(named: "arrow")
        arrowView.contentMode = .scaleAspectFill
        arrowView.clipsToBounds = true
        arrowView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //Устанавливаем поднимание и опускание кейборда
    private func switchKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 1.5
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    //Добавляет GestureRecognizer для нажатия на экран
    private func handleTapToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tap)
    }
    
    //Скрывает клавиатуру по тапу
    @objc private func hideKeyboard(_ sender: AnyObject) {
      view.endEditing(true)
    }
    
    //MARK: - Constraints
    private func setupConstraints() {
        
        view.addSubview(imageView)
        view.insertSubview(nextLable, at: 1)
        imageView.addSubview(backGroundView)
        backGroundView.addSubview(logoView)
        backGroundView.addSubview(welkomeLable)
        backGroundView.addSubview(nameLable)
        backGroundView.addSubview(textField)
        backGroundView.addSubview(dashView)
        backGroundView.addSubview(arrowView)
        
        let constraints = [
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            nextLable.bottomAnchor.constraint(equalTo: backGroundView.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            nextLable.leftAnchor.constraint(equalTo: backGroundView.safeAreaLayoutGuide.leftAnchor, constant: 162),
            
            backGroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backGroundView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            backGroundView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            backGroundView.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: 10),
            
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 41),
            logoView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 41),
            logoView.heightAnchor.constraint(equalToConstant: 85.01),
            logoView.widthAnchor.constraint(equalToConstant: 54.16),
            
            welkomeLable.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 86.99),
            welkomeLable.leftAnchor.constraint(equalTo: backGroundView.leftAnchor, constant: 30),
            
            nameLable.topAnchor.constraint(equalTo: welkomeLable.bottomAnchor, constant: 44),
            nameLable.leftAnchor.constraint(equalTo: backGroundView.leftAnchor, constant: 30),
            
            textField.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 8),
            textField.leftAnchor.constraint(equalTo: backGroundView.leftAnchor, constant: 30),
            
            dashView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 3),
            dashView.leftAnchor.constraint(equalTo: backGroundView.leftAnchor, constant: 30),
            dashView.heightAnchor.constraint(equalToConstant: 1),
            dashView.widthAnchor.constraint(equalToConstant: 315),
            
            arrowView.leftAnchor.constraint(equalTo: nextLable.rightAnchor, constant: 23),
            arrowView.bottomAnchor.constraint(equalTo: backGroundView.safeAreaLayoutGuide.bottomAnchor, constant: -35)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}


extension WelkomeViewControllerOld: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
