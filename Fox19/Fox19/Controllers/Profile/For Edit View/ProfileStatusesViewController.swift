//
//  ProfileStatusesViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 24.04.2021.
//

import UIKit

struct ProfileStatusesDataStruct {
    let isGamer: Bool
    let isTrainer: Bool
}

protocol ProfileStatusesServiceProtocol: class {
    func reload()
    func getStatuses(statuses: ProfileStatusesDataStruct)
}

class ProfileStatusesViewController: UIViewController {
    
    private var networkManager = TestUserNetwrokManager()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: ProfileStatusesServiceProtocol?
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var user: User? {
        willSet {
            guard let user = newValue else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.configureSelector(user: user)
            }
        }
    }
    
    //MARK: - UI Elements
    private lazy var gamerStatusSwitch: UISwitch = {
        let view = UISwitch()
        view.onTintColor = UIColor(named: "orange")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Отмена", for: .normal)
        view.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        view.tintColor = .white
        view.backgroundColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1).cgColor
        view.addTarget(self, action: #selector(hide), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var updateButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Готово", for: .normal)
        view.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        view.tintColor = .white
        view.backgroundColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1).cgColor
        view.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var gamerStatusLabel: UILabel = {
        let view = UILabel()
        view.text = "Игрок"
        view.textColor = .black
        view.font = UIFont(name: "Avenir-Black", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trainerStatusSwitch: UISwitch = {
        let view = UISwitch()
        view.onTintColor = UIColor(named: "orange")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trainerStatusLabel: UILabel = {
        let view = UILabel()
        view.text = "Тренер"
        view.textColor = .black
        view.font = UIFont(name: "Avenir-Black", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            backgroundView.widthAnchor.constraint(equalToConstant: view.frame.width / 1.2),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            gamerStatusLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            gamerStatusLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 50),
            
            gamerStatusSwitch.centerYAnchor.constraint(equalTo: gamerStatusLabel.centerYAnchor),
            gamerStatusSwitch.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -55),
            
            trainerStatusLabel.topAnchor.constraint(equalTo: gamerStatusLabel.bottomAnchor, constant: 20),
            trainerStatusLabel.leadingAnchor.constraint(equalTo: gamerStatusLabel.leadingAnchor),
            
            trainerStatusSwitch.centerYAnchor.constraint(equalTo: trainerStatusLabel.centerYAnchor),
            trainerStatusSwitch.trailingAnchor.constraint(equalTo: gamerStatusSwitch.trailingAnchor),
            
            dismissButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 48),
            dismissButton.widthAnchor.constraint(equalToConstant: view.frame.width / 1.2 / 2 - 16),
            dismissButton.bottomAnchor.constraint(equalTo: backgroundView.topAnchor, constant: -20),
            
            updateButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            updateButton.heightAnchor.constraint(equalTo: dismissButton.heightAnchor),
            updateButton.bottomAnchor.constraint(equalTo: dismissButton.bottomAnchor),
            updateButton.leadingAnchor.constraint(equalTo: dismissButton.trailingAnchor, constant: 20)
        ])
    }
    
    @objc private func updateUser() {
        delegate?.getStatuses(statuses: .init(isGamer: gamerStatusSwitch.isOn, isTrainer: trainerStatusSwitch.isOn))
        dismiss(animated: true)
    }
    
    @objc private func hide() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.delegate?.reload()
            }
        }
    }
    
    public func configureSelector(user: User) {
        guard let isGamer = user.isGamer,
              let isTrainer = user.isTrainer else { return }
        gamerStatusSwitch.isOn = isGamer
        trainerStatusSwitch.isOn = isTrainer
    }
    
    convenience init(user: User) {
        self.init()
        self.user = user
        configureSelector(user: user)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        view.addSubview(updateButton)
        view.addSubview(dismissButton)
        backgroundView.addSubview(gamerStatusSwitch)
        backgroundView.addSubview(gamerStatusLabel)
        backgroundView.addSubview(trainerStatusSwitch)
        backgroundView.addSubview(trainerStatusLabel)
    }
}
