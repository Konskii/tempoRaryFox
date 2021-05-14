//
//  ClubDetailViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 21.10.2020.
//

import UIKit
import SafariServices

protocol ClubDetailDelegate: class {
    func updateClubLike(itemIndex: Int, club: Club)
    func updatrClubRate(with rate: Float, itemIndex: Int)
}

class ClubDetailViewController: UIViewController {
    private let orangeColor = UIColor(red: 242/255, green: 122/255, blue: 42/255, alpha: 1)
    private let separatorColor = UIColor(red: 1, green: 236/255, blue: 249/255, alpha: 1)
    
    //Данные для отображения информации
    private var topImageView = UIImageView()
    private var clubInfo: Club!
    private var itemIndex: Int!
    
    //CollectionView
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    private var collectionView: UICollectionView! = nil
    
    //Events CollectionView
    private var eventsDataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    private var eventsCollectionView: UICollectionView! = nil
    
    var topView = TopView()
    var bottomView = BottoView()

    
    weak var delegate: ClubDetailDelegate?
    
    func setupWithData(club data: Club, coverImage: UIImage, itemIndex: Int) {
        clubInfo = data
        topImageView.image = coverImage
        self.itemIndex = itemIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupElements()
    }
    
    @objc func back() {
     //   tabBarController?.tabBar.isHidden = false
        delegate?.updateClubLike(itemIndex: itemIndex, club: clubInfo)
        delegate?.updatrClubRate(with: clubInfo.rate ?? 0, itemIndex: itemIndex)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupElements() {
    
        
        let topViewHeight = topView.setupTopView(controllerWidth: view.frame.width, club: clubInfo)
        let bottomViewHeight = bottomView.setupBottomView(controllerWidth: view.frame.width, club: clubInfo)
        configureHierarchy()
        eventsCollectionViewConfigurator()

        
        bottomView.didTapSiteButton = { [weak self] url in
            let safariVC = SFSafariViewController(url: url)
            self?.present(safariVC, animated: true)
        }
        
        let scroll = UIScrollView()
        scroll.layer.cornerRadius = 10
        scroll.backgroundColor = .white
        
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: -20),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scroll.addSubview(topView)
        scroll.addSubview(bottomView)
        scroll.addSubview(collectionView)
        scroll.addSubview(eventsCollectionView)

        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIView()
        separator.backgroundColor = .brown
        separator.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(separator)
        
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 0),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topView.heightAnchor.constraint(equalToConstant: topViewHeight)

        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.heightAnchor.constraint(equalToConstant: 110),
            
//            separator.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
//            separator.heightAnchor.constraint(equalToConstant: 100),
//            separator.leadingAnchor.constraint(equalTo: view.trailingAnchor),
//            separator.trailingAnchor.constraint(equalTo: view.leadingAnchor),
//
        eventsCollectionView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
        eventsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        eventsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        eventsCollectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([

            
            bottomView.topAnchor.constraint(equalTo: eventsCollectionView.bottomAnchor, constant: 10),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomView.heightAnchor.constraint(equalToConstant: bottomViewHeight)
            
        ])
        
        
        let contentSize = CGSize(width: self.view.frame.width, height: topViewHeight + bottomViewHeight + 110 + 40 + 160)
        scroll.contentSize = contentSize
        
    }
    
    //MARK: - Setupr NavigationBar
    private func setupNavigationBar() {
        navigationItem.title = "КЛУБЫ"
        let imageBackBarButtonItem = UIImage(named: "BackArrow")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imageBackBarButtonItem, style: .plain, target: self, action: #selector(back))
        
       // tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
        
        let attributesForTitle: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Avenir", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundImage = UIImage()
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.titleTextAttributes = attributesForTitle
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        setupImage()
    }
    
    private func setupImage() {
        topImageView.backgroundColor = .gray
        view.addSubview(topImageView)
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        let height = 249
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.topAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.heightAnchor.constraint(equalToConstant: CGFloat(height))
        ])
    }
}


//MARK:- Coach CollectionView
extension ClubDetailViewController {
    private func createLayout() -> UICollectionViewLayout {
       
        let itemeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90))
        let item = NSCollectionLayoutItem(layoutSize: itemeSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44)),
            elementKind: "Тренеры",
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return  layout
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(CoachCollectionViewCell.self, forCellWithReuseIdentifier: CoachCollectionViewCell.reusedID)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        collectionView.isScrollEnabled = false
        configureDataSource()
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView, cellProvider: { (collection, indexPath, index) -> UICollectionViewCell? in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: CoachCollectionViewCell.reusedID, for: indexPath) as? CoachCollectionViewCell
            return cell
        })
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            let supView = self.collectionView.dequeueReusableSupplementaryView(ofKind: "Header", withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: index) as? TitleSupplementaryView
            supView?.label.text = "Тренеры"
            
            return supView
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems([1, 2, 3, 4, 5])
        dataSource.apply(snapshot)
    }
}

//MARK:- Events Collectionview
extension ClubDetailViewController: UICollectionViewDelegate {
    private func eventsCollectionViewConfigurator() {
        eventsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutForEvents())
        eventsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        eventsCollectionView.backgroundColor = .white
        eventsCollectionView.delegate = self
        eventsCollectionView.register(EventsCollectionViewCell.self, forCellWithReuseIdentifier: EventsCollectionViewCell.reusedID)
        eventsCollectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        eventsCollectionView.isScrollEnabled = false
        eventsDataSourceConfigurator()
        
    }
    
    private func createLayoutForEvents() -> UICollectionViewLayout {
        let itemeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemeSize)
      //  item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(64))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44)),
            elementKind: "Тренеры",
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
      //  section.orthogonalScrollingBehavior = .groupPaging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return  layout
    }
    
    private func eventsDataSourceConfigurator() {
        eventsDataSource = UICollectionViewDiffableDataSource(collectionView: eventsCollectionView, cellProvider: { (collection, indexPath, index) -> UICollectionViewCell? in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: EventsCollectionViewCell.reusedID, for: indexPath) as? EventsCollectionViewCell
            return cell
        })
        
        eventsDataSource.supplementaryViewProvider = { (view, kind, index) in
            let supView = self.collectionView.dequeueReusableSupplementaryView(ofKind: "Header", withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: index) as? TitleSupplementaryView
            supView?.label.text = "Ближайшие события"
            return supView
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems([1, 2])
        eventsDataSource.apply(snapshot, animatingDifferences: true)
    }
}

