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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTournamentsList()
        
        let attributesGray: [NSAttributedString.Key: Any] = [
            .foregroundColor: titleColor,
            .font: UIFont(name: "avenir", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        navigationItem.title = "ТУРНИРЫ"
        navigationController?.navigationBar.titleTextAttributes = attributesGray
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(TournamentsCollectionViewCell.self, forCellWithReuseIdentifier: TournamentsCollectionViewCell.reusedID)
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Navigation Bar section
        
        let imagePointerButton = UIImage(named: "ColorPointer")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imagePointerButton, style: .plain, target: self, action: #selector(pointerSearch))
        
        let imageMenuButton = UIImage(named: "ColorMenu")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageMenuButton, style: .plain, target: self, action: #selector(menuButton))
        
        navigationController?.navigationBar.tintColor = orangeColor
        navigationController?.navigationBar.barTintColor = .white
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
        
    }
    
    @objc func pointerSearch() {
        print("We are seraching")
    }
    
    @objc func menuButton() {
        print("Open Menu")
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
