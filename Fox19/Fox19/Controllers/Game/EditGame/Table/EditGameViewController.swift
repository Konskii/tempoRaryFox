//
//  EditGameViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 12.12.2020.
//

import UIKit

class EditGameViewController: UIViewController, UIGestureRecognizerDelegate {
    //MARK: - Variables
    private var gameId: Int?
    
    private var gameMembersCount = 0
    
    private var storedGame: Game?
    
    ///Чтобы инсеты для скроллвью не увеличивались при каждом нажатии без скрытия клавиатуры
    private var didInset = false
    
    private weak var delegate: GetEditedGameProtocol?
    
    ///Массив типа [(Пользователь, его id в игре как member'а,  статус)]
    private var gameUsers: [(User, Int, String)] = []
    
    //MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.register(EditGameUserCell.self, forCellReuseIdentifier: EditGameUserCell.reusedId)
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let view = UIButton(type: .system)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        view.setTitle("Сохранить", for: .normal)
        view.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        view.tintColor = UIColor(red: 0.278, green: 0.427, blue: 0.741, alpha: 1)
        view.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        view.layer.borderColor = UIColor(red: 0.278, green: 0.427, blue: 0.741, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let view = UIButton(type: .system)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        view.setTitle("Отмена", for: .normal)
        view.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        view.tintColor = UIColor(red: 0.278, green: 0.427, blue: 0.741, alpha: 1)
        view.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        view.layer.borderColor = UIColor(red: 0.278, green: 0.427, blue: 0.741, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerView: EditGameHeader = {
        let view = EditGameHeader(reuseIdentifier: EditGameHeader.reusedId)
        view.delegate = self
        self.delegate = view
        return view
    }()
    
    //MARK: - UserIneraction Methods
    @objc private func savePressed() {
        guard let game = delegate?.getEditedGame() else {
            errorAlertMessage(message: "UpdatedGame")
            return
        }
        guard let gameId = gameId else {
            errorAlertMessage(message: "gameId")
            return
        }
        guard let account = UserDefaults.standard.string(forKey: "number") else {
            self.errorAlertMessage(message: "account error")
            return
        }
        guard let token = Keychainmanager.shared.getToken(account: account) else {
            self.errorAlertMessage(message: "token error")
            return
        }
        EditGameNetworkManager.shared.updateGame(token: token, game: game, gameId: gameId) { result in
            switch result {
            case .failure(let error):
                self.errorAlertMessage(message: "\(error)")
            case .success(_):
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc private func cancelPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    private func setup() {
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        configureNavigationBar()
        setupConstraints()
        handleTapToHideKeyboard()
        manageKeyboardObserver()
    }
    
    private func configureNavigationBar() {
        let view = UILabel()
        view.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "РЕДАКТИРОВАНИЕ ИГРЫ"
        navigationItem.titleView = view
        
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "backButton"), style: .done, target: self, action: #selector(backButtonPressed)), animated: true)
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "orange")
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "orange")
        
        ///Для работы свайпа назад
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        ///Для явного указания цвета статус бара(тк не используем darkMode)
        navigationController?.navigationBar.barTintColor = .white
    }
    
    ///Показывает алерт с ошибкой
    ///Метод асинхронный.
    private func errorAlertMessage(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Возникла ошибка", message: "Код ошибки: \(message)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func setupConstraints() {
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        view.addSubview(tableView)
        
        let constraints = [
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            cancelButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            cancelButton.heightAnchor.constraint(equalToConstant: 42),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            saveButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -8),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            saveButton.heightAnchor.constraint(equalToConstant: 42),
            
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func getUsers() {
        guard let gameId = gameId else { errorAlertMessage(message: "gameId"); return }
        GamesNetworkManager.shared.getMembers(gameID: gameId) { result in
            switch result {
            case .failure(let error):
                self.errorAlertMessage(message: "\(error)")
            case .success(let members):
                let members = members.results
                var tempUsers: [(User, Int, String)] = []
                DispatchQueue.global().async {
                    let group = DispatchGroup()
//                    for member in  members {
//                        guard let account = UserDefaults.standard.string(forKey: "number") else {
//                            self.errorAlertMessage(message: "account error")
//                            return
//                        }
//                        guard let token = Keychainmanager.shared.getToken(account: account) else {
//                            self.errorAlertMessage(message: "token error")
//                            return
//                        }
//                        guard let userId = member.user?.id else { self.errorAlertMessage(message: "userId"); return }
//                        group.enter()
//                        UserNetworkManager.shared.getUser(id: userId, token: token) { result in
//                            switch result {
//                            case .failure(let error):
//                                self.errorAlertMessage(message: "\(error)")
//                                group.leave()
//                            case .success(let user):
//                                guard let status = member.status else { self.errorAlertMessage(message: "memberStatus"); return }
//                                tempUsers.append((user, member.id, status))
//                                group.leave()
//                            }
//                        }
//                    }
                    group.wait()
                    self.gameUsers = tempUsers
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Inits
    convenience init(gameId: Int, gameMembersCount: Int, game: Game) {
        self.init()
        self.gameId = gameId
        self.gameMembersCount = gameMembersCount
        self.storedGame = game
        getUsers()
    }
}

//MARK: - UITableViewDataSource
extension EditGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditGameUserCell.reusedId) as? EditGameUserCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configureCell(gameUser: gameUsers[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDelegate
extension EditGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let game = storedGame else {
            return nil
        }
        headerView.configureHeader(game: game)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        57
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        800
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
}

//MARK: - fetchDataFromGameCreateViewProtocol
extension EditGameViewController: EditGameHeaderServiceProtocol {
    func needToShowAlert(message: String) {
        errorAlertMessage(message: message)
    }
    
    func needToShowSelectClubVC() {
        let vc = SelectClubViewController()
        vc.delegate = headerView
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - acceptDeclineMemberInitiadetProtocol
extension EditGameViewController: editGameCellServiceProtocol {
    func accept(memberId: Int) {
        guard let gameId = gameId else {
            self.errorAlertMessage(message: "gamId")
            return
        }
        guard let account = UserDefaults.standard.string(forKey: "number") else {
            self.errorAlertMessage(message: "account error")
            return
        }
        guard let token = Keychainmanager.shared.getToken(account: account) else {
            self.errorAlertMessage(message: "token error")
            return
        }
        
        EditGameNetworkManager.shared.acceptMember(token: token, gameId: gameId, memberId: memberId) { result in
            switch result {
            case .failure(let error):
                self.errorAlertMessage(message: "\(error)")
            case .success(_):
                DispatchQueue.main.async {
                    self.getUsers()
                }
            }
        }
    }
    
    func decline(memberId: Int) {
        guard let gameId = gameId else {
            self.errorAlertMessage(message: "gameId")
            return
        }
        guard let account = UserDefaults.standard.string(forKey: "number") else {
            self.errorAlertMessage(message: "account error")
            return
        }
        guard let token = Keychainmanager.shared.getToken(account: account) else {
            self.errorAlertMessage(message: "token error")
            return
        }
        
        EditGameNetworkManager.shared.declineMember(token: token, gameId: gameId, memberId: memberId) { result in
            switch result {
            case .failure(let error):
                self.errorAlertMessage(message: "\(error)")
            case .success(_):
                DispatchQueue.main.async {
                    self.getUsers()
                }
            }
        }
    }
    
    func needToShowErrorAlert(message: String) {
        errorAlertMessage(message: message)
    }
}

//MARK: - Manage keyboard and content move
extension EditGameViewController {
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
