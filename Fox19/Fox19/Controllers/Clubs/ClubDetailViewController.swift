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
    
    var imageViews = [UIImageView]()
    
    private var topImageView = UIImageView()
    private var clubInfo: Club!
    private var itemIndex: Int!
    
    var topView = TopView()
    var bottomView = BottoView()
    private var scrollView = UIScrollView()
    private var pageControl =  UIPageControl()
    
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
    
    @objc private func bookmarSomething() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let clubLike = clubInfo.like else { return }
        guard let clubLikeID = clubInfo.likeId else { return }
        guard let clubID = clubInfo.id else { return }
        if clubLike {
            ClubsNetworkManager.shared.deleteClubLike(for: number, likeId: clubLikeID) { (result) in
                switch result {
                case .success(let code):
                    DispatchQueue.main.async {
                        var text = ""
                        if code == 200 {
                            text = "Клуб удален из избранного"
                            self.clubInfo.like = false
                            let image = UIImage(named: "Bookmark")
                            self.navigationItem.rightBarButtonItem?.image = image
                            self.navigationItem.rightBarButtonItem?.tintColor = .lightGray
                        
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
                            self.clubInfo.like = true
                            self.clubInfo.likeId = data.id
                            let image = UIImage(named: "ColorBookmark")
                        self.navigationItem.rightBarButtonItem?.image = image
                        self.navigationItem.rightBarButtonItem?.tintColor = self.orangeColor
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
    
    @objc func pageControlTapHandler(sender: UIPageControl) {
        scrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
    
    private func setupElements() {
        let topViewHeight = topView.setupTopView(controllerWidth: view.frame.width, club: clubInfo)
        let bottomViewHeight = bottomView.setupBottomView(controllerWidth: view.frame.width, club: clubInfo)
        
        topView.didTapMakeReviewButton = { [weak self] in
            let vc = LeaveReviewViewController()
            vc.clubId = self?.clubInfo.id
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.dismissClosure = { review in
                guard let account = UserDefaults.standard.string(forKey: "number") else { return }
                ClubsNetworkManager.shared.getClub(for: account, clubId: self?.clubInfo.id ?? 0) { (result) in
                     switch result {
                     case .success(let result):
                         DispatchQueue.main.async {
                            self?.clubInfo = result
                            self?.topView.updateReviews(with: review, and: result)
                         }
                     case .failure(let error):
                         print(error.localizedDescription)
                     }
                 }
            }
            self?.present(vc, animated: true)
        }
        
        topView.didTapShowReviews = { reviews in
            let vc = ReviewsViewController(with: reviews)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        bottomView.didTapPhoneButton = { [weak self] url in
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
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 0),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topView.heightAnchor.constraint(equalToConstant: topViewHeight)

        ])
        
        let imageView = UIImageView(image: topImageView.image)
        imageView.contentMode = .scaleAspectFit
        let imageView2 = UIImageView(image: topImageView.image)
        imageView2.contentMode = .scaleAspectFit
        let imageView3 = UIImageView(image: topImageView.image)
        imageView3.contentMode = .scaleAspectFit
        imageViews = [imageView, imageView2, imageView3]
        
        scrollView.delegate = self
        scrollView.layer.cornerRadius = 10
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.isPagingEnabled = true
        let inset = CGFloat(40)
        let imageHeight = CGFloat(222)
        scrollView.contentSize = CGSize(width: (view.frame.width - inset) * CGFloat(imageViews.count), height: imageHeight)
        for i in 0..<imageViews.count {
            scrollView.addSubview(imageViews[i])
            imageViews[i].frame = CGRect(x: (view.frame.width - inset) * CGFloat(i), y: 0, width: view.frame.width - inset, height: imageHeight )
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.heightAnchor.constraint(equalToConstant: imageHeight),
            
            
            bottomView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomView.heightAnchor.constraint(equalToConstant: bottomViewHeight)
            
        ])
        
        
        let contentSize = CGSize(width: self.view.frame.width, height: topViewHeight + bottomViewHeight + 222 + 40)
        scroll.contentSize = contentSize
        
        
        pageControl.numberOfPages = imageViews.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        
        scroll.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "КЛУБЫ"
        let imageBackBarButtonItem = UIImage(named: "BackArrow")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imageBackBarButtonItem, style: .plain, target: self, action: #selector(back))
        
        let imageMenuButton =  clubInfo.like ?? false ? UIImage(named: "ColorBookmark") : UIImage(named: "Bookmark")
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageMenuButton, style: .plain, target: self, action: #selector(bookmarSomething))
        if let like = clubInfo.like, like == false {
            navigationItem.rightBarButtonItem?.tintColor = .lightGray
        }
        
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

extension ClubDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
