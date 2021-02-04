//
//  SmsCodeViewController.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 26.10.2020.
//

import UIKit
import EZYGradientView

class SmsCodeViewController: UIViewController, UITextFieldDelegate {
    
    private var backGroundView = EZYGradientView()
    private var clearView = UIView()
    private var mapImageView = UIImageView()
    private var enterLable = UILabel()
    private var phoneNumberLable = UILabel()
    private var newCodeLable = UILabel()
    private var otpTextField1 = UITextField()
    private var otpTextField2 = UITextField()
    private var otpTextField3 = UITextField()
    private var otpTextField4 = UITextField()
    private var otpStackView = UIStackView()
    private var stackView = UIStackView()
    
    private var timer = Timer()
    private var seconds = 10
   // private var timerLable = UILabel()
    
    var firstNum = ""
    var secondNum = ""
    var thirdNum = ""
    var forthNum = ""
    
    //MARK: - Получаемые элементы с предыдущего экрана
    private var phoneNumber: String = "+8618501659040"
    private var codeID = "71" // <------ Сюда приходит id
    
    func setPhone(number: String) {
        phoneNumber = number
        
    }
    func setID(code: String){
        codeID = code
    }
    
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    //    otpTextField1.becomeFirstResponder()
        switchKeyBoard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runTimer()
        setBackGround()
        setMapImage()
        setConstraint()
        setClearView()
        setLablesForStack()
        setOtpStack()
        setPhoneNumber()
        setNewCodeLable()
    }
    
    //MARK: - URLRequest
    //Функция запроса от сервера по смс
    func getCode(withSms: String) {
        let Url = String(format: "http://213.159.209.245/api/sms/\(codeID)")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["code" : "\(withSms)"]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "PUT"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                //Проверка статус кода
                guard 200 ..< 300 ~= httpResponse.statusCode else {
                    print("Status code was \(httpResponse.statusCode), but expected 2xx")
                    DispatchQueue.main.async {
                        self.alertMessage()
                        self.seconds = 59
                        self.runTimer()
                    }
                    return
                }
                print("Все гуд!")
                DispatchQueue.main.async {
                    let vc = WelkomeViewController()
                    vc.modalTransitionStyle   = .coverVertical
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    //AlertMessage
    func alertMessage() {
        let alertController = UIAlertController(title: "Неверный код!", message: "Мы отправим вам новый смс код для подтверждения", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Methods
    
    //Gradient BackCround
    func setBackGround() {
        backGroundView = EZYGradientView()
        backGroundView.frame.size = view.bounds.size
        backGroundView.firstColor = UIColor(named: "gradientFromWhite")!
        backGroundView.secondColor =  UIColor(named: "gradientToWhite")!
        backGroundView.backgroundColor = UIColor(named: "backgroundBlue")
        backGroundView.angleº = 30.0
        backGroundView.colorRatio = 0.35
        backGroundView.fadeIntensity = 1
        backGroundView.isBlur = false
        view.addSubview(backGroundView)
    }
    
    //Clear View
    func setClearView() {
        clearView.backgroundColor = .clear
        clearView.frame.size = view.bounds.size
        mapImageView.addSubview(clearView)
    }
    
    //Картинка Карта
    func setMapImage() {
        mapImageView = UIImageView()
        mapImageView.image = UIImage(named: "map")
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //Код подтверждения
    func setLablesForStack() {
        enterLable.text = "Введите код подтверждения"
        enterLable.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        enterLable.font = UIFont(name: "Avenir-Book", size: 17)
        enterLable.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //Стек OTP TextFields
    func setOtpStack() {
        //TODO: Проверить заполняются ли автоматически все поля
        otpTextField1.textContentType = .oneTimeCode
        let otpTextFields = [otpTextField1,otpTextField2,otpTextField3,otpTextField4]
        otpTextFields.forEach {
            $0.backgroundColor = .white
            $0.textAlignment = .center
            $0.textColor = .black
            $0.layer.cornerRadius = 10
            $0.delegate = self
            $0.keyboardType = .numberPad
            $0.addTarget(self, action: #selector(textFiewldDidChange(textField:)), for: .editingChanged)
            $0.translatesAutoresizingMaskIntoConstraints = false
            otpStackView.addArrangedSubview($0)
            
            let constraints = [
                $0.heightAnchor.constraint(equalToConstant: 56),
                $0.widthAnchor.constraint(equalToConstant: 44)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        
        otpStackView.axis = .horizontal
        otpStackView.alignment = .fill
        otpStackView.distribution = .fill
        otpStackView.spacing = 16
        otpStackView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @objc func textFiewldDidChange(textField: UITextField) {
        
        let text = textField.text
        
        if text?.count == 1 { 
            switch textField {
            case otpTextField1:
                firstNum = text ?? ""
                otpTextField2.becomeFirstResponder()
            case otpTextField2:
                secondNum = text ?? ""
                otpTextField3.becomeFirstResponder()
            case otpTextField3:
                thirdNum = text ?? ""
                otpTextField4.becomeFirstResponder()
            case otpTextField4:
                forthNum = text ?? ""
    //            let embedSmsCode = "\(firstNum)\(secondNum)\(thirdNum)\(forthNum)"
                print("hi")
//                NetworkManager.shared.sendSmsCode(with: codeID, smscode: embedSmsCode) { (_) in
//                    print("Ready")
//                }
                //Проверка смс
             //   getCode(withSms: embedSmsCode)
            default:
                break
            }
        }
        
        if text?.count == 0 {
            switch textField{
            case otpTextField1:
                otpTextField1.becomeFirstResponder()
            case otpTextField2:
                otpTextField1.becomeFirstResponder()
            case otpTextField3:
                otpTextField2.becomeFirstResponder()
            case otpTextField4:
                otpTextField3.becomeFirstResponder()
            default:
                break
            }
            print("Delete")
        }
    }
    
    //Label Код выслан
    func setPhoneNumber() {
        phoneNumberLable.text = "Код выслан на \(phoneNumber)"
        phoneNumberLable.frame = CGRect(x: 0, y: 0, width: 265, height: 19)
        phoneNumberLable.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        phoneNumberLable.font = UIFont(name: "SFProText-Regular", size: 16)
        phoneNumberLable.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //Label Новый полученный код
    func setNewCodeLable() {
        newCodeLable.text = "Новый код можно получить \n через 00:\(seconds)"
        newCodeLable.numberOfLines = 2
        newCodeLable.textAlignment = .center
        newCodeLable.frame = CGRect(x: 0, y: 0, width: 265, height: 19)
        newCodeLable.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        newCodeLable.font = UIFont(name: "SFProText-Regular", size: 16)
        newCodeLable.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //Устанавливаем таймер
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        newCodeLable.text = "Новый код можно получить \n через 00:\(seconds)"
        if seconds < 10 {
            newCodeLable.text = "Новый код можно получить \n через 00:0\(seconds)"
        }
        if seconds < 1 {
            timer.invalidate()
            
            //TODO: - Использовать функцию с предыдущего экрана (где вводим номер телефона) для получения нового ID
            
            seconds = 59
            runTimer()
        }
    }
    
    //Поднимаем опускаем клавиатуру
    func switchKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: - Work with TextField
    //Констрейнты
    func setConstraint() {
        backGroundView.addSubview(mapImageView)
        mapImageView.addSubview(clearView)
        clearView.addSubview(enterLable)
        clearView.addSubview(otpStackView)
        clearView.addSubview(phoneNumberLable)
        clearView.addSubview(newCodeLable)
        
        let constraints = [
            mapImageView.topAnchor.constraint(equalTo: backGroundView.topAnchor, constant: 0),
            mapImageView.leftAnchor.constraint(equalTo: backGroundView.safeAreaLayoutGuide.leftAnchor, constant: 0),
            mapImageView.rightAnchor.constraint(equalTo: backGroundView.safeAreaLayoutGuide.rightAnchor, constant: 0),
            mapImageView.heightAnchor.constraint(equalToConstant: 505),
            
            enterLable.centerYAnchor.constraint(equalTo: clearView.centerYAnchor, constant: 0),
            enterLable.centerXAnchor.constraint(equalTo: clearView.centerXAnchor, constant: 0),
            
            otpStackView.topAnchor.constraint(equalTo: enterLable.bottomAnchor, constant: 35),
            otpStackView.centerXAnchor.constraint(equalTo: clearView.centerXAnchor, constant: 0),
            
            phoneNumberLable.topAnchor.constraint(equalTo: otpStackView.bottomAnchor, constant: 15),
            phoneNumberLable.centerXAnchor.constraint(equalTo: clearView.centerXAnchor, constant: 0),
            
            newCodeLable.topAnchor.constraint(equalTo: phoneNumberLable.bottomAnchor, constant: 15),
            newCodeLable.centerXAnchor.constraint(equalTo: clearView.centerXAnchor, constant: 0),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
