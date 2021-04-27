//
//  TournamentsViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 16.10.2020.
//

import UIKit

class TournamentsViewController: UIViewController {
    
    private let orangeColor = UIColor(red: 242/255, green: 122/255, blue: 42/255, alpha: 1)
    private let titleColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
    
    enum Section {
        case main
    }
    
    private var tournamernts: TournamentsModel?
    private var collectionView: UICollectionView!
    private var isKeyboardShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTournamentsList()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(TournamentsCollectionViewCell.self, forCellWithReuseIdentifier: TournamentsCollectionViewCell.reusedID)
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupNavBarControlles()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func createCompositionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(226))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 15, bottom: 14, trailing: 15)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func getTournamentsList() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        TournamentsNetworkManager.shared.getAllChampionships(for: number) { (result) in
            switch result {
            case .success(let tournamernts):
                DispatchQueue.main.async {
                    self.tournamernts = tournamernts
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupNavBarControlles() {
        navigationItem.title = "Турниры"
        let imagePointerButton = UIImage(named: "ColorPointer")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imagePointerButton, style: .plain, target: self, action: #selector(pointerSearch))
        
        let imageMenuButton = UIImage(named: "ColorMenu")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageMenuButton, style: .plain, target: self, action: #selector(menuButton))
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true

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
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ПОИСК"
       // searchController.searchBar.searchTextField.leftView?.tintColor = orangeColor
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.searchController = searchController
    }
    
    private func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissMyKeyboard() {
        navigationItem.searchController?.searchBar.endEditing(true)
    }
    
    @objc private func showKeyboard() {
        initializeHideKeyboard()
        isKeyboardShow = true
    }
    @objc private func hideKeyboard() {
        isKeyboardShow = false
        view.gestureRecognizers = []
    }
    
    @objc func pointerSearch() {
        print("We are seraching")
    }
    
    @objc func menuButton() {
        print("Open Menu")
    }
}

extension TournamentsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}

extension TournamentsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tournament = tournamernts?.results?[indexPath.item] else { return }
        let vc = TournamentsDetailViewController()
        //TODO: Исправить обложку когда будут исправлены АПИ
        vc.setupWithData(tournament: tournament, coverImage: UIImage(named: "ImageForTest") ?? UIImage())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tournamernts?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TournamentsCollectionViewCell.reusedID, for: indexPath) as! TournamentsCollectionViewCell
        if let tournamernts = tournamernts, let tournamernt = tournamernts.results?[indexPath.item] {
            cell.cellSetup(with: tournamernt)
        }
        return cell
    }
}
