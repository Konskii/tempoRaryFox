//
//  ProfileViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 23.04.2021.
//

import UIKit
// MARK: var, let
class ProfileViewController: UIViewController {
    
    private let networkManager = TestUserNetwrokManager()
    
    private let service = ProfileService()
    
    private var cellStringDelegates: [ProfileCellStringDataProtocol]? = [] {
        didSet {
            if cellStringDelegates?.count ?? 0 > 7 {
                cellStringDelegates?.removeLast()
            }
        }
    }
    
    ///Чтобы убрать задержку при тапе на изменение аватарки
    private let imagePicker = UIImagePickerController()
    
    private weak var headerDelegate: ProfileEditHeaderDataProtocol?
    
    ///Чтобы инсеты для скроллвью не увеличивались при каждом нажатии без скрытия клавиатуры
    private var didInset = false
    
    private var user: User? {
        willSet{
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    private var memberedClubs: [MemberedClubModel]? {
        willSet{
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    private var userAvatar: UIImage? {
        willSet{
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    private var isInEditing: Bool = false {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reusedId)
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
}

// MARK: Data Source
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInEditing {
            return 6
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reusedId) as? ProfileCell else { fatalError() }
        guard let user = user else { return cell }
        
        cellStringDelegates?.append(cell)
        if indexPath.row == 0 {
            cell.configureType(user: user, type: .rightArrow)
        } else if indexPath.row == 1 {
            cell.configureType(user: user, type: .downArrow)
        } else {
            cell.configureBase(user: user, indexPath: indexPath, type: ProfileCellStringDataTypes.allCases[indexPath.row - 2])
        }
        cell.delegate = self
        return cell
    }
}

extension ProfileViewController: ProfileCellProtocol {
    func showMemberedClubs() {
        guard let userId = user?.id else { return }
        let vc = MemberedClubsViewController(userId: userId)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func showStatuses() {
        guard let user = user else { return }
        let vc = ProfileStatusesViewController(user: user)
        present(vc, animated: true)
    }
}

extension ProfileViewController: MyClubsProtocol, ProfileStatusesServiceProtocol {
    func reload() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.update()
        }
    }
}

// MARK: Table Delegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backView = UIView(frame: .zero)
        backView.backgroundColor = .white
        switch isInEditing {
        case true:
            guard let user = user else { return  backView }
            let header = ProfileEditHeader(user: user, avatar: userAvatar)
            headerDelegate = header
            header.delegate = self
            return header
        case false:
            guard let user = user else { return  backView }
            guard let memberedClubs = memberedClubs else { return  backView }
            return ProfileHeader(user: user, avatar: userAvatar, memberedClubs: memberedClubs)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch isInEditing {
        case true:
            return 144
        default:
            return 152
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

// MARK: UI
extension ProfileViewController {
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setttingUpNavigationBar() {
        navigationItem.title = "Профиль"
        navigationController?.navigationBar.prefersLargeTitles = true
        let largeTitleAppearance = UINavigationBarAppearance()
        
        largeTitleAppearance.configureWithOpaqueBackground()
        largeTitleAppearance.backgroundImage = UIImage(named: "Rectangle")
        largeTitleAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        largeTitleAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Inter-Regular", size: 33) ?? UIFont.systemFont(ofSize: 30, weight: .light)
        ]
        navigationController?.navigationBar.standardAppearance = largeTitleAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = largeTitleAppearance
        
        navigationItem.setRightBarButton(.init(title: "Изменить",
                                               style: .plain,
                                               target: self,
                                               action: #selector(openEditVC)),
                                         animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
}

//MARK: - Image Picker Delegates
extension ProfileViewController: (UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
    func changeImage() {
        addPhoto()
    }
    
    @objc private func addPhoto() {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated:  true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.userAvatar = image
            guard let userId = user?.id else { return }
            networkManager.updateUserAvatar(id: userId, avatar: image, completion: {
                [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.userAvatar = image
                    DispatchQueue.main.async { self.tableView.reloadData() }
                case .failure(let error):
                    self.showAlert(title: "Возникла ошибка", message: "\(error)")
                }
                
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Service
extension ProfileViewController {
    /**This function updates all info on this screen:
     1.User
     2.Clubs
     3.Avatar
     */
    @objc private func update() {
        networkManager.getCurrentUser() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let user = response.results?.first else { self.showAlert(title: "Results are empty"); return }
                ///setting user
                self.user = user
                ///setting userClubs
                if let id = user.id {
                    self.updateClubs(userId: id)
                }
                ///setting avatar
                if let path = user.avatar?.url {
                    self.updateAvatar(pathToImage: path)
                }
            case .failure(let error):
                self.showAlert(title: "\(error)")
            }
        }
    }
    
    ///This function updates clubs info
    /// - parameter userId: id of user which clubs must be got
    private func updateClubs(userId: Int) {
        networkManager.getMemberedClubs(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.memberedClubs = response.results
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.showAlert(title: "\(error)")
            }
        }
    }
    
    ///This function updates avatar
    /// - parameter pathToImage: url to the avatar
    private func updateAvatar(pathToImage: String) {
        networkManager.downloadImage(pathToImage: pathToImage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.userAvatar = response
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.showAlert(title: "\(error)")
            }
        }
    }
    
    @objc private func openEditVC() {
        if isInEditing {
            isInEditing = false
            let item = UIBarButtonItem(title: "Изменить",
                                       style: .plain,
                                       target: self,
                                       action: #selector(openEditVC))
            item.tintColor = .white
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = item
            
            
        } else {
            isInEditing = true
            let leftItem = UIBarButtonItem(title: "Отмена",
                                           style: .plain,
                                           target: self,
                                           action: #selector(openEditVC))
            leftItem.tintColor = .white
            let rightItem = UIBarButtonItem(title: "Готово",
                                            style: .plain,
                                            target: self,
                                            action: #selector(updateUser))
            rightItem.tintColor = .white
            navigationItem.leftBarButtonItem = leftItem
            navigationItem.rightBarButtonItem = rightItem
        }
    }
    
    @objc private func updateUser() {
        var userToUpdate = user
        guard let cellStringDelegates = cellStringDelegates else { return }
        for (_, delegate) in cellStringDelegates.enumerated() {
            if let golfId = delegate.getData(type: .golfId) {
                userToUpdate?.golfRegistryIdRU = golfId
            }
            if let phone = delegate.getData(type: .phone) {
                userToUpdate?.phone = phone
            }
            if let email = delegate.getData(type: .email) {
                userToUpdate?.email = email
            }
            if let about = delegate.getData(type: .about) {
                userToUpdate?.about = about
            }
        }
        userToUpdate?.name = headerDelegate?.getData().name
        userToUpdate?.lastName = headerDelegate?.getData().lastName
        userToUpdate?.handicap = headerDelegate?.getData().handicap
        guard let userToUpdateUnwrapped = userToUpdate else { return }
        networkManager.updateUser(user: userToUpdateUnwrapped) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.user = response
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.openEditVC()
                }
            case .failure(let error):
                self.showAlert(title: "\(error)")
            }
        }
    }
}

// MARK: Life
extension ProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.extendedLayoutIncludesOpaqueBars = true
        addSubviews()
        setttingUpNavigationBar()
        manageKeyboardObserver()
        handleTapToHideKeyboard()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
}

// MARK: EditHeaderProtocol
extension ProfileViewController: ProfileEditHeaderToControllerProtocol {
    func showImagePicker() {
        addPhoto()
    }
    
    func showAlertFromHeader(text: String) {
        showAlert(title: text)
    }
    
    
}

// MARK: - Keyboard
extension ProfileViewController {
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
