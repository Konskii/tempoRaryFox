//
//  ChatsListViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 08.02.2021.
//

import Foundation
import UIKit

class ChatsListViewController: UIViewController {
    
    private let orangeColor = UIColor(red: 242/255, green: 122/255, blue: 42/255, alpha: 1)
    
    private var chatUsers: [User] = []
    
    private var myChats: [User: Int] = [:]
    
    private var currentUser: User?
    
    private enum Section: Int, CaseIterable {
        case main
    }
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TestUserNetwrokManager().getCurrentUser { (result) in
            switch result {
            case .success(let user):
                self.currentUser = user.results?.first
                self.getChatUsers()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
      //  getChatUsers()
        setupCollectionView()
        createDataSource()
        reloadData()
        setupSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    private func getChatUsers() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        ChatNetworkManager.shared.getAllMyChats(token: token) { (result) in
            switch result {
            case .success(let chats):
                DispatchQueue.main.async {
                    //Разобраться и ненужное удалить
                    guard let myId = self.currentUser?.id else { return }
                    guard let users = chats.results else { return }
                    for chat in users {
                        guard let user = chat.users?.first(where: { (user) -> Bool in
                            return user.id != myId
                        }) else { return }
                        self.chatUsers.append(user)
                        self.myChats[user] = chat.id
                    }
                    self.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Setup NavBar
extension ChatsListViewController {
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = orangeColor
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Мои чаты"
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundImage = UIImage(named: "Rectangle")
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Merriweather-Regular", size: 30) ?? UIFont.systemFont(ofSize: 30, weight: .medium)
        ]
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
            
        ]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        let imageMenuButton = UIImage(named: "ColorMenu")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageMenuButton, style: .plain, target: self, action: #selector(makeReport))
        
    }
    @objc func makeReport() {
        let alert = UIAlertController(title: nil, message: "Сообщить о проблеме", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cansel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Пожаловаться", style: .default, handler: nil)
        let hellAction = UIAlertAction(title: "Заблокировать пользователя", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addAction(hellAction)
        present(alert, animated: true, completion: nil)
        
    }
}

//MARK: - Setup CollectionView and Delegate
extension ChatsListViewController: UICollectionViewDelegate {
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.register(ChatListCell.self, forCellWithReuseIdentifier: ChatListCell.identifire)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentUser = currentUser else { return }
        
        // let chatVC = CleanChatController(currentUser: currentUser, friendUser: chatUsers[indexPath.item])
        let user = chatUsers[indexPath.item]
        let chatId = myChats[user] ?? 0
        
        let chatVC = ChatViewController(currentUser: currentUser, friendUser: user, chatId: chatId)
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

//MARK: - CreateCompositionLayout
extension ChatsListViewController {
    private func createCompositionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnv) in
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unknow section kind") }
            switch section {
            case .main:
                return self.userLayout()
            }
        }
        return layout
    }
    
    private func userLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(71))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
    }
}

//MARK: - CreateDataSource
extension ChatsListViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknow section kind") }
            switch section {
            case .main:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatListCell.identifire, for: indexPath) as? ChatListCell else { fatalError("Cant cast cell")  }
                cell.setupCell(user: self.chatUsers[indexPath.item])
                return cell
            }
        })
    }
    
    private func reloadData(with searchText: String? = nil) {
        
        let filtered = chatUsers.filter { (user) -> Bool in
            user.contains(filter: searchText)
        }
        var snapShot = NSDiffableDataSourceSnapshot<Section, User>()
        snapShot.appendSections([.main])
        snapShot.appendItems(filtered, toSection: .main)
        dataSource?.apply(snapShot,animatingDifferences: true)
    }
}

//MARK: - SearchBar and SearchBarDelegate
extension ChatsListViewController: UISearchBarDelegate {
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ПОИСК"
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.leftView?.tintColor = orangeColor
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.searchController = searchController
        //    navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}


class ChatListCell: UICollectionViewCell {
    
    static let identifire = "ChatListCell"
    private var mainImageView = UIImageView(imageName: nil,
                                            playerGandicap: nil,
                                            image: UIImage(named: "user"),
                                            fogLayer: false)
    
    private let messageImage = UIImageView(image: UIImage(named: "blueMessageIcon"))
    private let myLabel = UILabel(text: "Можно присоединиться",
                                  font: .avenir(fontSize: 12),
                                  textColor: #colorLiteral(red: 0.8274509804, green: 0.831372549, blue: 0.9294117647, alpha: 1))
    private let gandicap = UILabel(text: "0",
                                   font: .avenir(fontSize: 13),
                                   textColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainImageView)
        addSubview(myLabel)
        addSubview(messageImage)
        addSubview(gandicap)
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImage.translatesAutoresizingMaskIntoConstraints = false
        gandicap.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImageView.widthAnchor.constraint(equalToConstant: 41),
            mainImageView.heightAnchor.constraint(equalToConstant: 41),
            
            myLabel.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
            myLabel.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 11),
            
            messageImage.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
            messageImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
            
            gandicap.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            gandicap.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(user: User?) {
        if user?.avatar != nil {
            downloadImageForAvatar(user: user)
        } else {
            mainImageView.image = UIImage(named: "user")
        }
        
        gandicap.text = "\(user?.handicap ?? 0)"
        myLabel.text = user?.name
        myLabel.font = .avenir(fontSize: 15)
        myLabel.textColor = #colorLiteral(red: 0.1764705882, green: 0.2470588235, blue: 0.4, alpha: 1)
    }
    
    private func downloadImageForAvatar(user: User?) {
        guard let account = UserDefaults.standard.string(forKey: "number") else { return }
        ClubsNetworkManager.shared.downloadImageForCover(from: user?.avatar?.url ?? "", account: account) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.mainImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
