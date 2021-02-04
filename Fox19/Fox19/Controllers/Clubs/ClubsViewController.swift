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
    
    enum Section {
        case main
    }
    
    private var clubs: ClubsModel?
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        //TODO: сделать используя это свойство
    //    hidesBottomBarWhenPushed = true
        setupCollectionView()
        checkClubs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    //   UIApplication.shared.statusBarStyle = .lightContent

        setupNavBar()
    }
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.register(ClubsCollectionViewCell.self, forCellWithReuseIdentifier: ClubsCollectionViewCell.reusedID)
        collectionView.register(ClubsSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClubsSectionHeader.reuserID)
        
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        setupSearchBar()
    }
    
    private func setupNavBar() {
        let imagePointerButton = UIImage(named: "Close")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imagePointerButton, style: .plain, target: self, action: #selector(closeSomething))
        
        let imageMenuButton = UIImage(named: "NavBookmark")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageMenuButton, style: .plain, target: self, action: #selector(bookmarSomething))
        
        navigationController?.navigationBar.tintColor = orangeColor
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Гольф - клубы"
        
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
    }
    
    private func checkClubs() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        print("!\(token) !")
        ClubsNetworkManager.shared.getAllClubs(for: number) { (result) in
            switch result {
            case .success(let clubs):
                DispatchQueue.main.async {
                    self.clubs = clubs
                    self.collectionView.reloadData()
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(226))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 15, bottom: 14, trailing: 15)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ПОИСК"
        searchController.searchBar.searchTextField.leftView?.tintColor = orangeColor
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.searchController = searchController
    }
    
    @objc func closeSomething() {
        print("We are closing")
    }
    
    @objc func bookmarSomething() {
        print("Bookmarking")
    }
}
extension ClubsViewController: UICollectionViewDataSource {
    
    func collectionView(_  collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ClubsSectionHeader.reuserID, for: indexPath) as! ClubsSectionHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubs?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClubsCollectionViewCell.reusedID, for: indexPath) as! ClubsCollectionViewCell
        cell.delegate = self
        
        if let clubs = clubs {
            cell.cellSetup(with: clubs.results[indexPath.item])
        }
    //    Если убрать строку, то кнопка не будет работать, не знаю почему так.
         cell.contentView.isUserInteractionEnabled = false
    
        return cell
    }
}

extension ClubsViewController: UICollectionViewDelegate {
}

extension ClubsViewController: CelTapHandlerProtocol {
    func imageButtonTap(clubData: Club, coverImage: UIImage) {
        
            let view = ClubDetailViewController()
            view.setupWithData(club: clubData, coverImage: coverImage)
            navigationController?.pushViewController(view, animated: true)
    }

    func bookmarkButtonPressed(button: UIButton) {
        let checkIt = button.image(for: .normal) == UIImage(named: "Bookmark")
        let image = checkIt ? UIImage(named: "ColorBookmark") : UIImage(named: "Bookmark")
        button.setImage(image, for: .normal)
    }
}

extension ClubsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
