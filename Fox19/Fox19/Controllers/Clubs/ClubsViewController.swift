//
//  ClubsViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 16.10.2020.
//

import UIKit

class ClubsViewController: UIViewController, UIGestureRecognizerDelegate {

    private let orangeColor = UIColor(red: 242/255, green: 122/255, blue: 42/255, alpha: 1)
    private let titleColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
    private let collectionBGColor = UIColor(red: 251/255, green: 253/255, blue: 253/255, alpha: 1)
    
    enum Section: Int {
        case main
    }
    
    private var clubs: ClubsModel?
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Club>!
    
    private var isKeyboardShow = false
    private var isBookMark = false
    private var likedClubs: [LikedClubsModel.LikedClubs] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        //TODO: сделать используя это свойство
       //hidesBottomBarWhenPushed = true
        setupCollectionView()
        checkClubs()
        createDataSource()
        reloadData()
     //   initializeHideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    //   UIApplication.shared.statusBarStyle = .lightContent
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func showKeyboard() {
        initializeHideKeyboard()
        isKeyboardShow = true
    }
    @objc private func hideKeyboard() {
        isKeyboardShow = false
    }
 
    private func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissMyKeyboard() {
        navigationItem.searchController?.searchBar.endEditing(true) 
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.register(ClubsCollectionViewCell.self, forCellWithReuseIdentifier: ClubsCollectionViewCell.reusedID)
        
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = collectionBGColor
        collectionView.delegate = self
        setupSearchBar()
    }
    
    //MARK:- Navigation Bar
    private func setupNavBar() {
     //   let imagePointerButton = UIImage(named: "Close")
       // navigationItem.leftBarButtonItem = UIBarButtonItem(image: imagePointerButton, style: .plain, target: self, action: #selector(closeSomething))
        
        let imageMenuButton = UIImage(named: "heartButton")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageMenuButton, style: .plain, target: self, action: #selector(bookmarSomething))
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Клубы"
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundImage = UIImage(named: "Rectangle")
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Inter-Regular", size: 33) ?? UIFont.systemFont(ofSize: 33, weight: .medium)
        ]
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func checkClubs() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        ClubsNetworkManager.shared.getAllClubs(for: number) { (result) in
            switch result {
            case .success(let clubs):
                ClubsNetworkManager.shared.getLikedClubs(for: number) { (result) in
                    switch result {
                    case .success(let likedClubs):
                        DispatchQueue.main.async {
                            self.likedClubs = likedClubs.results ?? []
                            self.clubs = clubs
                            for index in 0...clubs.results.count - 1 {
                                var likeId = 0
                             let isLike = likedClubs.results?.contains(where: { (likeClub) -> Bool in
                                if   likeClub.club?.id == self.clubs?.results[index].id {
                                    likeId = likeClub.id ?? 0
                                    return true
                                } else { return false }
                                                              })
                                self.clubs?.results[index].like = isLike
                                self.clubs?.results[index].likeId = likeId
                            }
                            self.reloadData()
                        }
                    case .failure( let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func createCompositionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(190))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 15, bottom: 14, trailing: 15)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknow section kind") }
            switch section {
            case .main:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClubsCollectionViewCell.reusedID, for: indexPath) as? ClubsCollectionViewCell else {
                    fatalError("Cant cast cell")
                }
                cell.delegate = self
                if let clubs = self.clubs {
                    cell.cellSetup(with: clubs.results[indexPath.item], index: indexPath.item)
                }
                cell.contentView.isUserInteractionEnabled = false
                return cell
            }
        })
    }
    
    private func reloadData(with searchText: String? = nil) {
       guard let filtered = (clubs?.results.filter { (club) -> Bool in
            club.contains(filter: searchText)
       }) else { return }
        var snapShot = NSDiffableDataSourceSnapshot<Section, Club>()
        snapShot.appendSections([.main])
        snapShot.appendItems(filtered, toSection: .main)
        dataSource?.apply(snapShot,animatingDifferences: true)
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ПОИСК"
      //  searchController.searchBar.searchTextField.leftView?.tintColor = orangeColor
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.searchController = searchController
    }
    
    @objc func closeSomething() {
        print("We are closing")
    }
    
    @objc func bookmarSomething() {
      guard let filtered = (clubs?.results.filter { (club) -> Bool in
            guard let isLike = club.like, isLike == true else { return false }
            return true
       }) else { return }
        isBookMark.toggle()
        if isBookMark {
            var snapShot = NSDiffableDataSourceSnapshot<Section, Club>()
            snapShot.appendSections([.main])
            snapShot.appendItems(filtered, toSection: .main)
            dataSource?.apply(snapShot,animatingDifferences: true)
        } else {
            reloadData()
        }
     
    }
}


//MARK: - UICollectionViewDelegate
extension ClubsViewController: UICollectionViewDelegate {
}

//MARK: - ClubDetailDelegate
extension ClubsViewController: ClubDetailDelegate {
    func updatrClubRate(with rate: Float, itemIndex: Int) {
        self.clubs?.results[itemIndex].rate = rate
        collectionView.reloadData()
    }
    
    func updateClubLike(itemIndex: Int, club: Club) {
        self.clubs?.results[itemIndex] = club
        collectionView.reloadData()
    }
}

//MARK: - CelTapHandlerProtocol
extension ClubsViewController: CelTapHandlerProtocol {
    
    func imageButtonTap(clubData: Club, coverImage: UIImage, itemIndex: Int) {
        if isKeyboardShow {
            navigationItem.searchController?.searchBar.endEditing(true)
            isKeyboardShow = false
        } else {
            let view = ClubDetailViewController()
            view.setupWithData(club: clubData, coverImage: coverImage, itemIndex: itemIndex)
            view.delegate = self
            navigationController?.pushViewController(view, animated: true)
        }
    }

    func bookmarkButtonPressed(button: UIButton, club: Club, index: Int) {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let clubLike = club.like else { return }
        guard let clubLikeID = club.likeId else { return }
        guard let clubID = club.id else { return }
        if clubLike {
            ClubsNetworkManager.shared.deleteClubLike(for: number, likeId: clubLikeID) { (result) in
                switch result {
                case .success(let code):
                    DispatchQueue.main.async {
                        var text = ""
                        if code == 200 {
                            text = "Клуб удален из избранного"
                            let image = UIImage(named: "heartButton")
                            button.setImage(image, for: .normal)
                            self.clubs?.results[index].like = false
                            self.collectionView.reloadData()
                        } else {
                            text = "Возникла ошибка попробуйте еще раз или позже \(code) no delete"
                        }
                        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            ClubsNetworkManager.shared.addLikeToClub(for: number, clubId: clubID, userId: 244) { (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        var text = ""
                            text = "Клуб добавлен в избранное"
                            let image = UIImage(named: "heartButtonFilled")
                            button.setImage(image, for: .normal)
                            self.clubs?.results[index].like = true
                            self.clubs?.results[index].likeId = data.id
                            self.collectionView.reloadData()
                        
                        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//MARK: - SearchBarDelegate
extension ClubsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}
