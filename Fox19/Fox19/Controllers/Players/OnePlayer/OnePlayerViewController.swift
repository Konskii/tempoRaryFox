//
//  OnePlayerViewController.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 17.10.2020.
//

import UIKit
import EZYGradientView

class OnePlayerViewController: UIViewController {
    
    private var newView = UIView()
    private var tableView = UITableView()
    
    private var nameOnDetail = UILabel()
    private var scoreOnDetail = UILabel()
    private var locationOnDetail = UILabel()
    
    private var addFriend = UIImageView()
    private var photoPlayer = UIImageView()
    private var sendMessage = UIImageView()
    
    private var detailView = EZYGradientView()
    private var scoreViewOnDetail = EZYGradientView()
    
    private var stackView = UIStackView()
    private var stackButtons = UIStackView()
    
    var player: UserForExample?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setNewView()
        dismissView()
        setupPlayerLables()
        tableView.register(OnePlayerTableViewCell.self, forCellReuseIdentifier: OnePlayerTableViewCell.tableIdentifire)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
    }
    
    //Тап по Затемненному вью чтобы скрыть Вью
    func dismissView() {
        let touchHeader = UITapGestureRecognizer(target: self, action: #selector(deleteViewController))
        newView.isUserInteractionEnabled = true
        newView.addGestureRecognizer(touchHeader)
    }
    
    @objc func deleteViewController() {
        newView.removeFromSuperview()
        //TODO: - сделать видимым или невидмым таббар
        //tabBarController?.tabBar.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    //Затемненное Вью
    func setNewView() {
        self.newView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6971853596)
        self.tabBarController?.view.addSubview(self.newView)
        self.newView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.newView.contentMode = .scaleAspectFit
        newView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newView)
    }
    
    //Таббар с информацией о пользователе
    func setupTableView() {
        self.tableView = UITableView(frame: detailView.bounds, style: .plain)
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        detailView.addSubview(tableView)
    }
    
    //MARK: - Set Header
    func setupLablesOn(header: UIView) {
        guard let player = player else {return}
        //Фото
        photoPlayer = UIImageView()
        photoPlayer.image = player.userPhoto
        photoPlayer.layer.cornerRadius = 140 / 2
        photoPlayer.contentMode = .scaleAspectFill
        photoPlayer.clipsToBounds = true
        photoPlayer.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(photoPlayer)

        //Имя
        nameOnDetail = UILabel()
        nameOnDetail.text = player.userName
        nameOnDetail.font = UIFont(name: "Avenir-Heavy", size: 17)
        nameOnDetail.font = .systemFont(ofSize: 17.0, weight: .bold)
        nameOnDetail.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nameOnDetail.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(nameOnDetail)

        //Счет
        scoreOnDetail.text = player.score
        scoreOnDetail.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        scoreOnDetail.font = .systemFont(ofSize: 10, weight: .regular)
        scoreOnDetail.font = UIFont(name: "Avenir", size: 10.0)
        scoreOnDetail.textAlignment = .center
        scoreOnDetail.translatesAutoresizingMaskIntoConstraints = false

        //Вью счета
        scoreViewOnDetail = EZYGradientView()
        scoreViewOnDetail.firstColor = UIColor(named: "gradientFromWhite")!
        scoreViewOnDetail.secondColor =  UIColor(named: "gradientToWhite")!
        scoreViewOnDetail.backgroundColor = UIColor(named: "backgroundBlue")
        scoreViewOnDetail.angleº = 30.0
        scoreViewOnDetail.colorRatio = 0.35
        scoreViewOnDetail.fadeIntensity = 1
        scoreViewOnDetail.isBlur = false
        scoreViewOnDetail.layer.cornerRadius = 2
        scoreViewOnDetail.layer.masksToBounds = true
        scoreViewOnDetail.addSubview(scoreOnDetail)
        scoreViewOnDetail.translatesAutoresizingMaskIntoConstraints = false

        //Локация
        locationOnDetail.text = player.location
        locationOnDetail.font = UIFont(name: "OpenSans-Regular", size: 12)
        locationOnDetail.font = .systemFont(ofSize: 17.0, weight: .light)
        locationOnDetail.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        locationOnDetail.translatesAutoresizingMaskIntoConstraints = false

        //Стэк кнопок
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.addArrangedSubview(scoreViewOnDetail)
        stackView.addArrangedSubview(locationOnDetail)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stackView)

        //Добавить друга
        addFriend.image = #imageLiteral(resourceName: "addFriend")
        addFriend.contentMode = .scaleAspectFit
        addFriend.clipsToBounds = true
        addFriend.translatesAutoresizingMaskIntoConstraints = false

        //Послать сообщение
        sendMessage.image = UIImage(named: "sendMessage")
        sendMessage.contentMode = .scaleAspectFill
        sendMessage.clipsToBounds = true
        sendMessage.translatesAutoresizingMaskIntoConstraints = false

        //Стэк кнопок
        stackButtons.axis = .horizontal
        stackButtons.alignment = .fill
        stackButtons.distribution = .fill
        stackButtons.spacing = 25
        stackButtons.addArrangedSubview(addFriend)
        stackButtons.addArrangedSubview(sendMessage)
        stackButtons.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stackButtons)
        
        let constraints = [
            //Констрейнты Фото
            photoPlayer.topAnchor.constraint(equalTo: header.topAnchor, constant: 39),
            photoPlayer.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0),
            photoPlayer.widthAnchor.constraint(equalToConstant: 140),
            photoPlayer.heightAnchor.constraint(equalToConstant: 140),
            
            //Констрейнты Имя
            nameOnDetail.topAnchor.constraint(equalTo: photoPlayer.bottomAnchor, constant: 10),
            nameOnDetail.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0),
            
            //Констрейнты Вью Счетф
            scoreViewOnDetail.widthAnchor.constraint(equalToConstant: 25),
            scoreViewOnDetail.heightAnchor.constraint(equalToConstant: 16),
            
            //Констрейнты Счет
            scoreOnDetail.centerYAnchor.constraint(equalTo: self.scoreViewOnDetail.centerYAnchor),
            scoreOnDetail.centerXAnchor.constraint(equalTo: self.scoreViewOnDetail.centerXAnchor),
            
            //Констрейнты кнопка добавить друга
            addFriend.widthAnchor.constraint(equalToConstant: 12.74),
            addFriend.heightAnchor.constraint(equalToConstant: 14.33),
            
            //Констрейнты кнопка отправить сообщение
            sendMessage.widthAnchor.constraint(equalToConstant: 24),
            sendMessage.heightAnchor.constraint(equalToConstant: 24),
            
            //Стэк счет и локация
            stackView.topAnchor.constraint(equalTo: nameOnDetail.bottomAnchor, constant: 4),
            stackView.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0),
            
            //Стэк кнопок
            stackButtons.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 18),
            stackButtons.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    //MARK: - Set DetailView
    func setupPlayerLables() {
        //Вью игрока
        detailView.firstColor = UIColor(named: "gradientFromWhite")!
        detailView.secondColor =  UIColor(named: "gradientToWhite")!
        detailView.backgroundColor = UIColor(named: "backgroundBlue")
        detailView.angleº = 30.0
        detailView.colorRatio = 0.35
        detailView.fadeIntensity = 1
        detailView.isBlur = false
        detailView.layer.cornerRadius = 8
        detailView.layer.masksToBounds = true
        detailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailView)
        setupTableView()
        
        let constraints = [
            //Constraints View
            detailView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
            detailView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            detailView.widthAnchor.constraint(equalToConstant: 334),
            detailView.heightAnchor.constraint(equalToConstant: 553),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}


extension OnePlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnePlayerTableViewCell.tableIdentifire, for: indexPath) as? OnePlayerTableViewCell else {return UITableViewCell()}
        guard let player = player else {return UITableViewCell()}
        
        if indexPath.row == 0 {
            cell.setupUser(with: "СТАТУС", description: player.status)
        } else if indexPath.row == 1 {
            cell.setupUser(with: "ОБО МНЕ", description: player.aboutPlayer)
        } else if indexPath.row == 2 {
            cell.setupUser(with: "КЛУБЫ", description: player.clubs)
        }
        cell.separatorInset = .init(top: 1, left: 0, bottom: 1, right: 0)
        cell.layoutMargins = .zero
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 287)
        header.backgroundColor = .clear
        setupLablesOn(header: header)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 287
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 0
        } else {
            return 90
        }
    }
}
