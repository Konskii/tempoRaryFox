//
//  ProfileEditViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 08.11.2020.
//

import UIKit

class ProfileEditViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: - Variables
    ///Чтобы инсеты для скроллвью не увеличивались при каждом нажатии без скрытия клавиатуры
    private var didInset = false
    
    private var user: User?
    
    private let networkManager = TestUserNetwrokManager()
    
    //MARK: - Delegates
    private var delegates: [ManageUpdatedUserProtocol?] = []
    
    private weak var statusDelegate: ManageUpdatedUserStatusProtocol?
    
    //MARK: - UI elements
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame, style: .grouped)
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.backgroundColor = .white
        view.register(ProfileTableViewCell.self,
                      forCellReuseIdentifier: ProfileTableViewCell.reusedId)
        view.register(UserStatusTableViewCell.self,
                      forCellReuseIdentifier: UserStatusTableViewCell.reusedId)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let view = UIButton(type: .system)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 0.278, green: 0.427, blue: 0.741, alpha: 1).cgColor
        view.tintColor = UIColor(red: 0.278, green: 0.427, blue: 0.741, alpha: 1)
        view.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        view.setTitle("Сохранить", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let view = UIButton(type: .system)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 0.278, green: 0.427, blue: 0.741, alpha: 1).cgColor
        view.tintColor = UIColor(red: 0.278, green: 0.427, blue: 0.741, alpha: 1)
        view.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        view.setTitle("Отмена", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        return view
    }()
    
    //MARK: - UserIneraction Methods
    ///Тут обнолвение юзера и переход на экран профиля
    @objc private func saveButtonPressed() {
        updateUser()
    }
    
    @objc private func dismissButtonPressed() {
        DispatchQueue.main.async { self.navigationController?.popViewController(animated: true) }
    }
    
    @objc private func changeProfileTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func searchTapped() {
        
    }
    
    //MARK: - Methods
    private func setup() {
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        handleTapToHideKeyboard()
        configureNavigationBar()
        manageKeyboardObserver()
    }
    
    private func configureNavigationBar() {
        let view = UILabel()
        view.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.text = "РЕДАКТИРОВАНИЕ ПРОФИЛЯ"
        view.adjustsFontSizeToFitWidth = true
        view.font = UIFont.avenir(fontSize: 15)
        navigationItem.titleView = view
        
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "ChangeProfile"),
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(changeProfileTapped)),
                                         animated: true)
        
        ///Для работы свайпа назад
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        ///Для явного указания цвета статус бара(тк не используем darkMode)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor(named: "orange")
    }
    
    ///Обновление данных пользователя на новые
    private func updateUser() {
        guard let userId = user?.id else {
            showAlert(title: "Возникла ошибка", message: "id error"); return }
        
        var nameToUpdate: String?
        var aboutToUpdate: String?
        var emailToUpdate: String?
        var golfRegistryIdRUToUpdate: String?
        var lastNameToUpdate: String?
        
        for i in 0...5 - 1 {
            guard let updateData = delegates[i]?.manageText() else {
                showAlert(title: "Возникла ошибка", message: "delegate error"); return }
            
            switch updateData.1?.row {
            case 0:
                nameToUpdate = updateData.0
            case 1:
                lastNameToUpdate = updateData.0
            case 2:
                golfRegistryIdRUToUpdate = updateData.0
            case 3:
                aboutToUpdate = updateData.0
            case 4:
                emailToUpdate = updateData.0
            default:
                break
            }
        }
        
        guard let statusesData = statusDelegate?.getStatuses() else {
            showAlert(title: "Возникла ошибка", message: "status delegate error"); return }
        guard let newHandicap = statusDelegate?.getHandicap() else {
            showAlert(title: "Возникла ошибка", message: "status delegate(handicap) error"); return
        }
        
        let isGamer = statusesData[0]
        let isTrainer = statusesData[1]
        guard let isReferee = user?.isReferee else { return }
        let user = User(id: userId,
                        phone: self.user?.phone,
                        email: emailToUpdate,
                        golfRegistryIdRU: golfRegistryIdRUToUpdate,
                        about: aboutToUpdate,
                        name: nameToUpdate,
                        lastName: lastNameToUpdate,
                        handicap: newHandicap,
                        isAdmin: self.user?.isAdmin,
                        isReferee: isReferee,
                        isGamer: isGamer,
                        isTrainer: isTrainer,
                        avatar: self.user?.avatar)
        
        networkManager.updateUser(user: user) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async { self.navigationController?.popToRootViewController(animated: true) }
            case .failure(let error):
                self.showAlert(title: "Возникла ошибка", message: "\(error)")
                DispatchQueue.main.async { self.navigationController?.popToRootViewController(animated: true) }
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubview(dismissButton)
        view.addSubview(saveButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            dismissButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            dismissButton.heightAnchor.constraint(equalToConstant: 42),
            
            saveButton.leadingAnchor.constraint(equalTo: dismissButton.leadingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -8),
            saveButton.trailingAnchor.constraint(equalTo: dismissButton.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: dismissButton.heightAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setup()
    }
    
    //MARK: - Inits
    convenience init(user: User?) {
        self.init()
        self.user = user
    }
}

//MARK: - Table View Data Source
extension ProfileEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reusedId, for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        delegates.append(cell)
        guard user != nil else {
            showAlert(title: "Возникла ошибка", message: "Ошибка User"); return cell }
        cell.delegate = self
        cell.setIndexPath(indexPath: indexPath, isEditingVC: true)
        if indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: UserStatusTableViewCell.reusedId) as?
                    UserStatusTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            statusDelegate = cell
            cell.configureSelector()
            return cell
        }
        return cell
    }
}

//MARK: - Table View Delegate
extension ProfileEditViewController: UITableViewDelegate {
    ///Убираем хайлайт с ячеек
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
}

//MARK: - FillProfileCellProtocol
extension ProfileEditViewController: FillProfileCellProtocol {
    func getDataForCell() -> User? {
        return user
    }
    
    func showMyClubsViewController() {
        
    }
}

//MARK: - SetUserStatusesProtocol
extension ProfileEditViewController: SetUserStatusesProtocol {
    func giveData() -> User? {
        return user
    }
}

//MARK: - Manage keyboard and content move
extension ProfileEditViewController {
    ///Добавляет отступы при показе клавиатуры
    @objc private func keyboardWillShow(_ notification: Notification) {
        if !didInset {
            adjustInsetForKeyboardShow(true, notification: notification)
            didInset = true
        }
        tableView.showsVerticalScrollIndicator = false
    }
    
    ///Убирает отступы при показе клавиатуры
    @objc private func keyboardWillHide(_ notification: Notification) {
        if didInset {
            adjustInsetForKeyboardShow(false, notification: notification)
            didInset = false
        }
        tableView.showsVerticalScrollIndicator = true
    }
    
    ///Добавляет наблюдателя для показа/скрытия клавиатуры
    private func manageKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    ///Устанавливает отступы чтобы скролл вью сдвигалось не перекрывая контент при показе клавиатуры
    private func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue
        else {
            return
        }
        
        let adjustmentHeight = (keyboardFrame.cgRectValue.height + 20) * (show ? 1 : -1)
        tableView.contentInset.bottom += adjustmentHeight
        tableView.verticalScrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    ///Добавляет GestureRecognizer для нажатия на экран
    private func handleTapToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tap)
    }
    
    ///Скрывает клавиатуру по тапу
    @objc private func hideKeyboard(_ sender: AnyObject) {
        view.endEditing(true)
    }
}
