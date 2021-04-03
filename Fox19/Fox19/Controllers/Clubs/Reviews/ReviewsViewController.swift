//
//  ReviewsViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 15.03.2021.
//

import UIKit

class ReviewsViewController: UIViewController {
    
    private enum Section: Int {
        case main
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Review>!
    private var reviews: [Review] = []
    
    init(with reviews: [Review]) {
        super.init(nibName: nil, bundle: nil)
        self.reviews = reviews
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ОТЗЫВЫ"
        setupCollectionView()
        configureDataSource()
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                navigationItem.rightBarButtonItem?.tintColor = .lightGray
            let attributesForTitle: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont(name: "Avenir-light", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
            ]
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundImage = UIImage()
            navBarAppearance.shadowImage = UIImage()
            navBarAppearance.shadowColor = .clear
            navBarAppearance.backgroundColor = .clear
            navBarAppearance.titleTextAttributes = attributesForTitle
            navigationController?.navigationBar.standardAppearance = navBarAppearance
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundImage = UIImage(named: "Rectangle")
  
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}

//MARK:- Setup CollectionView
extension ReviewsViewController {
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(ReviewsCollectionViewCell.self, forCellWithReuseIdentifier: ReviewsCollectionViewCell.reusedID)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let estimateHeight = CGFloat(100)
        
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .estimated(estimateHeight))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                       subitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

//MARK:- Setup DataSource
extension ReviewsViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionview, indexPath, review) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknow section kind") }
            switch section {
            case .main:
                guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: ReviewsCollectionViewCell.reusedID, for: indexPath) as? ReviewsCollectionViewCell else { fatalError("Cant cast cell") }
                let showsSeparator = indexPath.item != self.reviews.count - 1
                cell.setupCell(with: self.reviews[indexPath.item], showsSeparator: showsSeparator)
                return cell
            }
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Review>()
        snapShot.appendSections([.main])
        snapShot.appendItems(reviews)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}
