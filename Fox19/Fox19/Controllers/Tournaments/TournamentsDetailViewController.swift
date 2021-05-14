//
//  TournamentsDetailViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 22.11.2020.
//

import UIKit

class TournamentsDetailViewController: UIViewController {
    
    private var topImageView = UIImageView()
    private let header = ChampDetailHeader()
    private let tableView = UITableView()
    private var champID: Int = 0
    private var members: ChampioshipmembersModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMembersForChampionship(id: champID)
        view.backgroundColor = .white
        setupNavigationBar()
        view.addSubview(tableView)
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.cellID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let headerHeight = header.getViewHeight(controllerWidth: view.frame.width)
        header.layer.cornerRadius = 10
     //   header.backgroundColor = .gray
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight)
        let footer = ChampDetailFooter()
        footer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        footer.joinButtonTappedDelegate = {
            let alert = UIAlertController(title: nil, message: "Связаться с организатором", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Позвонить", style: .default) { (alert) in
                 
                let number = "+5 555 555-55-55"
                guard let url = URL(string: "tel://\(number.withoutSpaces())"),
                    UIApplication.shared.canOpenURL(url) else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        tableView.tableFooterView = footer
        tableView.tableHeaderView = header
    }
    
    func setupWithData(tournament data: Tournament, coverImage: UIImage) {
        topImageView.image = coverImage
        header.setupVeiwWithData(tournament: data)
        if let id = data.id {
            champID = id
        }
    }
    
    private func getMembersForChampionship(id: Int) {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        
        TournamentsNetworkManager.shared.getChampionshipMembers(for: number, champID: champID) { (result) in
            switch result {
            case .success(let members):
                DispatchQueue.main.async {
                    self.members = members
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "ТУРНИРЫ"
        let imageBackBarButtonItem = UIImage(named: "BackArrow")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imageBackBarButtonItem, style: .plain, target: self, action: #selector(back))
        tabBarController?.tabBar.isHidden = true
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
    
    @objc func back() {
        let titleColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
        let navBarAppearance = UINavigationBarAppearance()
        let attributesForTitle: [NSAttributedString.Key: Any] = [
            .foregroundColor: titleColor,
            .font: UIFont(name: "Avenir", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        navBarAppearance.titleTextAttributes = attributesForTitle
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
}

extension TournamentsDetailViewController: UITableViewDataSource, UITableViewDelegate {

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
//         let title = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 30))
//      //  title.backgroundColor = .cyan
//        title.text = "Учатсники"
//        title.font = UIFont(name: "Avenir", size: 15)
//        title.textColor = .black
//        header.addSubview(title)
//        return header
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tap row")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if members == nil {
//            return 0
//        } else { return members?.results?.count ?? 0 }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.cellID, for: indexPath) as! DetailTableViewCell
        if let id = members?.results?[indexPath.row].user.id {
            cell.cellSetup(userID: id)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
