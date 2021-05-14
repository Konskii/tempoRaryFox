//
//  StartViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 27.10.2020.
//

import UIKit
import LocalAuthentication

class StartViewController: UIViewController {
    
    private lazy var backroundImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "LoginSmallBackground"))
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var smallGradientImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "LoginBackgroundGradient"))
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "LoginLogo"))
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var signUpButton: UIButton = {
        let view = UIButton(type: .system)
        let attributesForTitle: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 22/255, green: 31/255, blue: 51/255, alpha: 1),
            .font: UIFont(name: "Avenir", size: 12) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        let attrTitle = NSAttributedString(string: "SIGN UP", attributes: attributesForTitle)
        
        view.setAttributedTitle(attrTitle, for: .normal)
        view.setBackgroundImage(UIImage(named: "LoginSignUpButtonGradient"), for: .normal)
        view.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logInButton: UIButton = {
        let view = UIButton(type: .system)
        let attributesForTitle: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
            .font: UIFont(name: "Avenir", size: 12) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        let attrTitle = NSAttributedString(string: "LOG IN", attributes: attributesForTitle)
        
        view.setAttributedTitle(attrTitle, for: .normal)
        view.setBackgroundImage(UIImage(named: "LoginLogInButtonGradient"), for: .normal)
        view.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupConstraints()
        goToMainTabBarDirectly()
      //  authenticateUser()
    }
    
    private func setupConstraints() {
        view.addSubview(backroundImageView)
        view.addSubview(smallGradientImageView)
        view.addSubview(logoImageView)
        
        view.addSubview(signUpButton)
        view.addSubview(logInButton)
        
        let constraints = [
            backroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -276),
            backroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            smallGradientImageView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -337),
            smallGradientImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            smallGradientImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            smallGradientImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            smallGradientImageView.heightAnchor.constraint(equalToConstant: 337),
            
            logoImageView.topAnchor.constraint(equalTo: smallGradientImageView.topAnchor, constant: 41.95),
            logoImageView.bottomAnchor.constraint(equalTo: smallGradientImageView.bottomAnchor, constant: -210.04),
            logoImageView.widthAnchor.constraint(equalToConstant: 54.16),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: smallGradientImageView.bottomAnchor, constant: -126.14),
            signUpButton.leadingAnchor.constraint(equalTo: smallGradientImageView.leadingAnchor, constant: 33),
            signUpButton.trailingAnchor.constraint(equalTo: smallGradientImageView.trailingAnchor, constant: -33),
            signUpButton.heightAnchor.constraint(equalToConstant: 52.99),
            
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 15.46),
            logInButton.leadingAnchor.constraint(equalTo: smallGradientImageView.leadingAnchor, constant: 33),
            logInButton.trailingAnchor.constraint(equalTo: smallGradientImageView.trailingAnchor, constant: -33),
            logInButton.bottomAnchor.constraint(equalTo: smallGradientImageView.bottomAnchor, constant: -57.69)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func signUpTapped() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func logInTapped() {
//        let vc = LoginViewController()
//        navigationController?.pushViewController(vc, animated: true)
        authenticateUser()
    }
}

// MARK: User authenticate
extension StartViewController {
    private func authenticateUser() {
        if #available(iOS 8.0, *, *) {
            let authenticationContext = LAContext()
            setupAuthenticationContext(context: authenticationContext)
            
            let reason = "Fast and safe authentication in your app"
            var authError: NSError?
            
            if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [unowned self] success, evaluateError in
                    if success {
                        
                        guard let number = UserDefaults.standard.string(forKey: "number"),
                              let token = Keychainmanager.shared.getToken(account: number)  else {
                            DispatchQueue.main.async {
                                
                                    alertMessage(title: "Error", message: "Please login or signUP") 
                                
                            }
                            return
                        }
                            DispatchQueue.main.async {
                                AppDelegate.shared.rootViewController.showMainTabBarScreen()
                            }
                        
                    } else {
                        // Пользователь не прошел аутентификацию
                        DispatchQueue.main.async {
                            let vc = LoginViewController()
                            navigationController?.pushViewController(vc, animated: true)
                        }
                      
                        if let error = evaluateError {
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                // Не удалось выполнить проверку на использование биометрических данных или пароля для аутентификации
                if let error = authError {
                    print(error.localizedDescription)
                }
            }
        } else {
            // Более рання версия iOS macOS
        }
    }
    
    private  func setupAuthenticationContext(context: LAContext) {
        context.localizedReason = "Use for fast and safe authentication in your app"
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Enter password"
        
        context.touchIDAuthenticationAllowableReuseDuration = 600
    }
    
    private func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            
            let vc = SignUpViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func goToMainTabBarDirectly() {
        guard let number = UserDefaults.standard.string(forKey: "number"),
              let _ = Keychainmanager.shared.getToken(account: number) else { return }
        AppDelegate.shared.rootViewController.showMainTabBarScreen()
    }
}
