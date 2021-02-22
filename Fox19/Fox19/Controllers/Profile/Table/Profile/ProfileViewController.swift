//
//  ProfileTableViewController.swift
//  Fox19
//
//  Created by Артём Скрипкин on 17.10.2020.
//

import UIKit

class ProfileTableViewController: UIViewController, UIGestureRecognizerDelegate {
    
    ///Модель пользователя из которой получаются данные
    private var user: User?
    
    ///Аватарка пользователя
    private var userImage: UIImage?
    
    ///Чтобы убрать задержку при тапе на изменение аватарки
    private let imagePicker = UIImagePickerController()
    
    private let networkManager = TestUserNetwrokManager()
    
    //MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.backgroundColor = .white
        view.register(ProfileTableViewCell.self,
                      forCellReuseIdentifier: ProfileTableViewCell.reusedId)
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - UserInteraction Methods
    
    ///LogOut с удалением токена из связки
    @objc private func logOutTapped() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        
        if Keychainmanager.shared.deleteToken(account: token)  {
            AppDelegate.shared.rootViewController.showStartScreen()
        }
    }
    
    ///Переход на экран редактированния
    @objc private func editProfileTapped() {
        let vc = ProfileEditViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Methods
    private func setup() {
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        configureNavigationBar()
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        let view = UILabel()
        view.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont.avenir(fontSize: 15)
        view.text = "ПРОФИЛЬ"
        navigationItem.titleView = view
        
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "ChangeProfile"),
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(editProfileTapped)),
                                         animated: true)
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Выйти",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(logOutTapped)),
                                        animated: true)
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "orange")
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "orange")
        
        ///Для работы свайпа назад
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        ///Для явного указания цвета статус бара(тк не используем darkMode)
        navigationController?.navigationBar.barTintColor = .white
    }
    
    ///Обновляет данные по пользователю
    private func updateUser() {
        networkManager.getCurrentUser() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                let user = user.results?.first
                self.user = user
                if let avatar = user?.avatar, let pathToAvatar = avatar.url {
                    self.networkManager.downloadImage(pathToImage: pathToAvatar,
                                                      completion: {
                                                        result in
                                                        switch result {
                                                        case .success(let image):
                                                            self.userImage = image
                                                            DispatchQueue.main.async {
                                                                self.tableView.reloadData()
                                                            }
                                                        case .failure(_):
                                                            //TODO
                                                            return
                                                        }
                                                      })
                }
                DispatchQueue.main.async { self.tableView.reloadData()}
            case .failure(let error):
                self.showAlert(title: "Возникла ошибка", message: "\(error)")
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUser()
    }
}

//MARK: - Table View Data Source
extension ProfileTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ProfileTableViewCell.reusedId,
                for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        cell.setIndexPath(indexPath: indexPath, isEditingVC: false)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ProfileAvatarHeader(reuseIdentifier: ProfileAvatarHeader.reusedId)
        header.setImage(image: userImage)
        header.delegate = self
        return header
    }
}

//MARK: - Table View Delegate
extension ProfileTableViewController: UITableViewDelegate {
    ///Убираем хайлайт с ячеек
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        167
    }
}

//MARK: - Image Picker Delegates
extension ProfileTableViewController: (UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
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
            guard let userId = user?.id else { return }
            networkManager.updateUserAvatar(id: userId, avatar: image, completion: {
                [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.userImage = image
                    DispatchQueue.main.async { self.tableView.reloadData() }
                case .failure(let error):
                    self.showAlert(title: "Dозникла ошибка", message: "\(error)")
                }
                
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - needToUpdateAvatarProtocol
extension ProfileTableViewController: needToUpdateAvatarProtocol {
    func needToUpdate() {
        addPhoto()
    }
}


//MARK: - FillProfileCellProtocol
extension ProfileTableViewController: FillProfileCellProtocol {
    func getDataForCell() -> User? {
        return user
    }
    
    func showMyClubsViewController() {
        let vc = MyClubsViewController()
        vc.delegate = self
    }
}

extension ProfileTableViewController: testProtocol {
    func showDetailVC(club: Club) {
        let vc = ClubDetailViewController()
        vc.setupWithData(club: club, coverImage: #imageLiteral(resourceName: "Avatar"))
        navigationController?.pushViewController(vc, animated: true)
        print("wtf")
    }
}
