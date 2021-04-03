////
////  SmsVareficationViewController.swift
////  Fox19
////
////  Created by Mykhailo Romanovskyi on 02.11.2020.
////
//
//import UIKit
//
//class SmsVareficationViewController: UIViewController {
//
//    private let topLabel = UILabel()
//    private let middleLabel = UILabel()
//    private let bottomLabel = UILabel()
//    private let otpTextField1 = UITextField()
//    private let otpTextField2 = UITextField()
//    private let otpTextField3 = UITextField()
//    private let otpTextField4 = UITextField()
//    private let otpStackView = UIStackView()
//
//    private var data: AuthenticationModel!
//    private var backgroundImageView: UIImageView!
//    private var timer = Timer()
//    private var seconds = 59
//
//    private var firstNum = ""
//    private var secondNum = ""
//    private var thirdNum = ""
//    private var forthNum = ""
//
//    func setupData(data: AuthenticationModel) {
//        self.data = data
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupElements()
//        switchKeyBoard()
//        setNeedsStatusBarAppearanceUpdate()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        runTimer()
//        setNeedsStatusBarAppearanceUpdate()
//    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        backgroundImageView.frame = view.bounds
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        .lightContent
//    }
//
//    private func setupElements() {
//        backgroundImageView = UIImageView(image: UIImage(named: "LoginWithPhoneNumber"))
//        backgroundImageView.contentMode = .scaleToFill
//        view.insertSubview(backgroundImageView, at: 0)
//        setupTopLabel()
//        setOtpStack()
//        setPhoneNumber()
//        setBottomLabel()
//        handleTapToHideKeyboard()
//    }
//
//    private func setupTopLabel() {
//        topLabel.text = "Введите код подтверждения"
//        topLabel.textColor = .white
//        topLabel.font = UIFont(name: "Avenir-Book", size: 17)
//        topLabel.textAlignment = .center
//        topLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(topLabel)
//        NSLayoutConstraint.activate([
//            topLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
//            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//    }
//
//    private func setOtpStack() {
//        //TODO: Проверить заполняются ли автоматически все поля
//        otpTextField1.textContentType = .oneTimeCode
//        let otpTextFields = [otpTextField1,otpTextField2,otpTextField3,otpTextField4]
//        otpTextFields.forEach {
//            $0.backgroundColor = .white
//            $0.textAlignment = .center
//            $0.textColor = .black
//            $0.layer.cornerRadius = 10
//            $0.delegate = self
//            $0.keyboardType = .numberPad
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            otpStackView.addArrangedSubview($0)
//
//            let constraints = [
//                $0.heightAnchor.constraint(equalToConstant: 56),
//                $0.widthAnchor.constraint(equalToConstant: 44)
//            ]
//            NSLayoutConstraint.activate(constraints)
//        }
//
//        otpStackView.axis = .horizontal
//        otpStackView.alignment = .fill
//        otpStackView.distribution = .fill
//        otpStackView.spacing = 16
//        otpStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(otpStackView)
//
//        NSLayoutConstraint.activate([
//            otpStackView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 35),
//            otpStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//    }
//
//    private func setPhoneNumber() {
//        middleLabel.text = "Код выслан на \(data.phone)"
//        middleLabel.textColor = .white
//        middleLabel.font = UIFont(name: "SFProText-Regular", size: 16)
//        middleLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(middleLabel)
//
//        NSLayoutConstraint.activate([
//            middleLabel.topAnchor.constraint(equalTo: otpStackView.bottomAnchor, constant: 15),
//            middleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//    }
//
//    //Label Новый полученный код
//    private func setBottomLabel() {
//        bottomLabel.text = "Новый код можно получить \n через 00:\(seconds)"
//        bottomLabel.numberOfLines = 2
//        bottomLabel.textAlignment = .center
//        bottomLabel.textColor = .white
//        bottomLabel.font = UIFont(name: "SFProText-Regular", size: 16)
//        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(bottomLabel)
//
//        NSLayoutConstraint.activate([
//            bottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            bottomLabel.topAnchor.constraint(equalTo: middleLabel.bottomAnchor, constant: 19)
//        ])
//    }
//
//    //Устанавливаем таймер
//    private func runTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
//    }
//
//    @objc func updateTimer() {
//        seconds -= 1
//        bottomLabel.text = "Новый код можно получить \n через 00:\(seconds)"
//        if seconds < 10 {
//            bottomLabel.text = "Новый код можно получить \n через 00:0\(seconds)"
//        }
//        if seconds < 1 {
//            timer.invalidate()
//
//            //TODO: - Использовать функцию с предыдущего экрана (где вводим номер телефона) для получения нового ID
//
//        }
//    }
//
//    //Устанавливаем поднимание и опускание кейборда
//    private func switchKeyBoard() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height / 1.5
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
//
//
//    //Добавляет GestureRecognizer для нажатия на экран
//    private func handleTapToHideKeyboard() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
//        view.addGestureRecognizer(tap)
//    }
//
//    //Скрывает клавиатуру по тапу
//    @objc private func hideKeyboard(_ sender: AnyObject) {
//        view.endEditing(true)
//    }
//}
//
//extension SmsVareficationViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
//
//        if (range.length == 0){
//            if textField == otpTextField1 {
//                firstNum = string
//                otpTextField2.becomeFirstResponder()
//            }
//            if textField == otpTextField2 {
//                secondNum = string
//                otpTextField3.becomeFirstResponder()
//            }
//            if textField == otpTextField3 {
//                thirdNum = string
//                otpTextField4.becomeFirstResponder()
//            }
//            if textField == otpTextField4 {
//                forthNum = string
//                otpTextField4.resignFirstResponder()
//
//                let embedSmsCode = "\(firstNum)\(secondNum)\(thirdNum)\(forthNum)"
//                NetworkManager.shared.sendSmsCode(with: data, smscode: embedSmsCode) { (result) in
//                    switch result {
//                    case .success(let user):
//                        DispatchQueue.main.async {
//                      //      AppDelegate.shared.rootViewController.showMainTabBarScreen()
//                            let vc = WelkomeViewController()
//                            vc.setupData(data: user.user.id)
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//            textField.text? = string
//            return false
//        }else if (range.length == 1) {
//            if textField == otpTextField4 {
//                otpTextField3.becomeFirstResponder()
//            }
//            if textField == otpTextField3 {
//                otpTextField2.becomeFirstResponder()
//            }
//            if textField == otpTextField2 {
//                otpTextField1.becomeFirstResponder()
//            }
//            if textField == otpTextField1 {
//                otpTextField1.resignFirstResponder()
//            }
//            textField.text? = ""
//            return false
//        }
//        return true
//    }
//}

//
//  SmsVareficationViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 02.11.2020.
//

import UIKit

class SmsVareficationViewController: UIViewController {
    
    private let topLabel = UILabel()
    private let middleLabel = UILabel()
    private let bottomLabel = UILabel()
    
    private lazy var codeTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.textAlignment = .center
        view.textColor = .black
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "backgroundBlue")?.cgColor
        view.textContentType = .oneTimeCode
        view.keyboardType = .numberPad
        view.delegate = self
        return view
    }()
    
    private var data: AuthenticationModel!
    private var backgroundImageView: UIImageView!
    private var timer = Timer()
    private var seconds = 90
    
    func setupData(data: AuthenticationModel) {
        self.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        switchKeyBoard()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        runTimer()
        setNeedsStatusBarAppearanceUpdate()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
    }
    
    private func setupElements() {
        backgroundImageView = UIImageView(image: UIImage(named: "LoginWithPhoneNumber"))
        backgroundImageView.contentMode = .scaleToFill
        view.insertSubview(backgroundImageView, at: 0)
        setupTopLabel()
        setCodeTextField()
        setPhoneNumber()
        setBottomLabel()
        handleTapToHideKeyboard()
    }
    
    private func setupTopLabel() {
        topLabel.text = "Введите код подтверждения"
        topLabel.textColor = .white
        topLabel.font = UIFont(name: "Avenir-Book", size: 17)
        topLabel.textAlignment = .center
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topLabel)
        NSLayoutConstraint.activate([
            topLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setPhoneNumber() {
        middleLabel.text = "Код выслан на \(data.phone)"
        middleLabel.textColor = .white
        middleLabel.font = UIFont(name: "SFProText-Regular", size: 16)
        middleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(middleLabel)
        NSLayoutConstraint.activate([
            middleLabel.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 15),
            middleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setCodeTextField() {
        view.addSubview(codeTextField)
        NSLayoutConstraint.activate([
            codeTextField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 17),
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeTextField.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor),
            codeTextField.trailingAnchor.constraint(equalTo: topLabel.trailingAnchor),
            codeTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    //Label Новый полученный код
    private func setBottomLabel() {
        bottomLabel.text = "Новый код можно получить \n через 00:\(seconds)"
        bottomLabel.numberOfLines = 2
        bottomLabel.textAlignment = .center
        bottomLabel.textColor = .white
        bottomLabel.font = UIFont(name: "SFProText-Regular", size: 16)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getNewCode)))
        
        view.addSubview(bottomLabel)
        
        NSLayoutConstraint.activate([
            bottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomLabel.topAnchor.constraint(equalTo: middleLabel.bottomAnchor, constant: 19)
        ])
    }
    
    //Устанавливаем таймер
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        bottomLabel.text = "Новый код можно получить \n через 00:\(seconds)"
        if seconds < 10 {
            bottomLabel.text = "Новый код можно получить \n через 00:0\(seconds)"
        }
        if seconds < 1 {
            timer.invalidate()
            bottomLabel.isUserInteractionEnabled = true
            bottomLabel.text = "Получить новый код"
            
        }
    }
    
    @objc private func getNewCode() {
        middleLabel.text = "Подождите..."
        codeTextField.text = ""
        NetworkManager.shared.getCodeForVarification(witn: data.phone) {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.seconds = 10
                self.runTimer()
                self.data = data
            case .failure(let error):
                self.middleLabel.text = "Произошла ошибка"
                self.showAlert(title: "Возникла ошибка", message: "\(error)")
            }
        }
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Скрывает клавиатуру по тапу
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

extension SmsVareficationViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let code = textField.text, code.count == 4 {
            hideKeyboard()
            NetworkManager.shared.sendSmsCode(with: data, smscode: code) {[weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        let vc = WelkomeViewController()
                        vc.setupData(data: user.user.id)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    self.showAlert(title: "Возникла ошибка", message: "\(error)")
                    textField.text = ""
                }
            }
        }
    }
}
