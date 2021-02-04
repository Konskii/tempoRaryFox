//
//  ClubDetailViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 21.10.2020.
//

import UIKit

class ClubDetailViewController: UIViewController {
    var imageViews = [UIImageView]()
    
    private var topImageView = UIImageView()
    private var clubInfo: Club!
    var topView = TopView()
    private var scrollView = UIScrollView()
    private var pageControl =  UIPageControl()
    
    func setupWithData(club data: Club, coverImage: UIImage) {
        clubInfo = data
        topImageView.image = coverImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupElements()
    }
    
    @objc func back() {
     //   tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pageControlTapHandler(sender: UIPageControl) {
        scrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
    
    private func setupElements() {
        let topViewHeight = topView.setupTopView(controllerWidth: view.frame.width, club: clubInfo)
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
            scrollView.heightAnchor.constraint(equalToConstant: imageHeight)
        ])
        
        
        let contentSize = CGSize(width: self.view.frame.width, height: topViewHeight + 222 + 40)
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
