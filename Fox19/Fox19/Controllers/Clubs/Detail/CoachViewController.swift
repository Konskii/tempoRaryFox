//
//  CoachViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 20.04.2021.
//


//УДАЛИТЬ

import UIKit

class CoachViewController: UIViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    private var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
    }
}

extension CoachViewController {
    private func createLayout() -> UICollectionViewLayout {
       
        let itemeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        let item = NSCollectionLayoutItem(layoutSize: itemeSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44)),
            elementKind: "Тренеры",
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return  layout
        
    }
}

extension CoachViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
    }
}
