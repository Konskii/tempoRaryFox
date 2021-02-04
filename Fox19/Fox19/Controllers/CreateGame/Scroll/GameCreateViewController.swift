//
//  GameCreateViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 17.11.2020.
//

import UIKit

class GameCreateViewController: UIViewController {
    
    //MARK: - Variables
    private var didInset = false
    
    private var gameData: GameCreateModel?
    
    //MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var creatingView: GameCreateView = {
        let view = GameCreateView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var createGameButton: UIButton = {
        let view = UIButton(type: .system)
        view.layer.cornerRadius = 14
        view.backgroundColor = UIColor(red: 0.827, green: 0.831, blue: 0.929, alpha: 1)
        view.isEnabled = false
        view.setTitle("ЗАПОЛНИТЕ ДЕТАЛИ ИГРЫ", for: .disabled)
        view.setTitleColor(.white, for: .disabled)
        view.setTitle("СОЗДАТЬ ИГРУ", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProRounded-Bold", size: 18)
        view.addTarget(self, action: #selector(createGameButtonPressed), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - UserIneraction Methods
    @objc private func createGameButtonPressed() {
        guard let game = gameData else { return }
        guard let account = UserDefaults.standard.string(forKey: "number") else { errorAlertMessage(message: "account error"); return }
        guard let token = Keychainmanager.shared.getToken(account: account) else { errorAlertMessage(message: "token error"); return }
        
        GameCreateNetworkManager.shared.createGame(game: game, token: token) { (result ) in
            switch result {
            case .failure(let error):
                self.errorAlertMessage(message: "\(error)")
            case .success(let game):
                DispatchQueue.main.async {
                    guard let gameId = game.id else {
                        self.needToShowErrorAlert(message: "gameId")
                        return
                    }
                    guard let gameMemebersCount = game.gamersCount else {
                        self.needToShowErrorAlert(message: "gameGamersCount")
                        return
                    }
                    let vc = EditGameViewController(gameId: gameId, gameMembersCount: gameMemebersCount, game: game)
                    self.navigationController?.pushViewController(vc, animated: true)
                    ///Далее идет код чтобы убрать текущий экран(экран создания) из стека, оставив только Profile и EditGame(vc)
                    guard let navigationController = self.navigationController else { return }
                    var navigationArray = navigationController.viewControllers
                    navigationArray.remove(at: navigationArray.count - 2)
                    self.navigationController?.viewControllers = navigationArray
                }
            }
        }
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Methods
    private func setup() {
        configureNavigationbar()
        manageKeyboardObserver()
        handleTapToHideKeyboard()
        view.backgroundColor = .white
    }
    
    private func configureNavigationbar() {
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "backButton"), style: .done, target: self, action: #selector(backButtonPressed)), animated: true)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "orange")
        let view = UILabel()
        view.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Avenir", size: 15)
        view.text = "НОВАЯ ИГРА"
        navigationItem.titleView = view
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
    
    ///Показывает алерт об успехе
    ///Метод асинхронный.
    private func successAlertMessage(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Успешно", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(creatingView)
        view.addSubview(createGameButton)
        
        let constraints = [
            createGameButton.heightAnchor.constraint(equalToConstant: 48),
            createGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            createGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            createGameButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -15),
            
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: createGameButton.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            creatingView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            creatingView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            creatingView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            creatingView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setup()
    }
    
    //MARK: - Inits
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - GetDataFromGameCreateViewProtocol
extension GameCreateViewController: GetDataFromGameCreateViewProtocol {
    func dataFilled(data: GameCreateModel?) {
        guard let game = data else {
            createGameButton.backgroundColor = UIColor(red: 0.827, green: 0.831, blue: 0.929, alpha: 1)
            createGameButton.isEnabled = false
            return
        }
        gameData = game
        createGameButton.isEnabled = true
        createGameButton.backgroundColor = UIColor(red: 0.11, green: 0.173, blue: 0.306, alpha: 1)
    }
    
    func needToShowErrorAlert(message: String) {
        errorAlertMessage(message: message)
    }
    
    func needToShowSelectClubVC() {
        let vc = SelectClubViewController()
        vc.delegate = creatingView
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Manage keyboard and content move
extension GameCreateViewController {
    ///Добавляет отступы при показе клавиатуры
    @objc private func keyboardWillShow(_ notification: Notification) {
        if !didInset {
            adjustInsetForKeyboardShow(true, notification: notification)
            didInset = true
        }
    }
    
    ///Убирает отступы при показе клавиатуры
    @objc private func keyboardWillHide(_ notification: Notification) {
        if didInset {
            adjustInsetForKeyboardShow(false, notification: notification)
            didInset = false
        }
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
      scrollView.contentInset.bottom += adjustmentHeight
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
