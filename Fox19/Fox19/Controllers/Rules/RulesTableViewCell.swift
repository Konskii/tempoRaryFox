//
//  RulesTableViewCell.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 14.10.2020.
//

import UIKit
//MARK: - Протокол для тапа на ячейку
protocol CellDelegate {
    
    func didTapOnQuestion(cell: UITableViewCell, judge: JudgeForExample)
    
}

//MARK: - Экран Судьи
class RulesTableViewCell: UITableViewCell {
    
    static let tableCellID = "RulesViewController"
    
    private var judgePhoto = UIImageView()
    private var judgeName = UILabel()
    private var timeOfActivity = UILabel()
    private var properties = UILabel()
    private var lableQuestionButton = UIImageView()
    private var questionButton = UILabel()
    
    var delegate: CellDelegate?
    var judge: JudgeForExample?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupParametrs()
        setupTapRecognizer()
    }
    
    
    //MARK: - Set Parametrs and Constraints
    
    func setup(judge: JudgeForExample) {
        judgePhoto.image = judge.judgePhoto
        judgeName.text = judge.judgeName
        properties.text = judge.properties
    }
    
    func setupTapRecognizer() {
        let gestureOnlableQuestionButton = UITapGestureRecognizer(target: self, action: #selector(didTapOnQuestion))
        lableQuestionButton.isUserInteractionEnabled = true
        lableQuestionButton.addGestureRecognizer(gestureOnlableQuestionButton)
        
        let gestureOnQuestinButton = UITapGestureRecognizer(target: self, action: #selector(didTapOnQuestion))
        questionButton.isUserInteractionEnabled = true
        questionButton.addGestureRecognizer(gestureOnQuestinButton)
    }
    
    @objc func didTapOnQuestion() {
        print("Ask some question")
        guard let judge = judge else {return}
        let vc = RulesTableViewCell()
        delegate?.didTapOnQuestion(cell: vc, judge: judge)
    }
    
    //Параметры
    func setupParametrs() {
        //Аватарка
        judgePhoto.center = contentView.center
        judgePhoto.layer.cornerRadius = 40 / 2
        judgePhoto.contentMode = .scaleAspectFill
        judgePhoto.clipsToBounds = true
        judgePhoto.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(judgePhoto)
        
        //Имя
        judgeName = UILabel()
        judgeName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        judgeName.font = UIFont(name: "Avenir-Heavy", size: 17)
        judgeName.font = .systemFont(ofSize: 17.0, weight: .bold)
        judgeName.textAlignment = .center
        judgeName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(judgeName)
        
        //Время активности
        timeOfActivity = UILabel()
        timeOfActivity.text = "3 hours ago"
        timeOfActivity.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4024775257)
        timeOfActivity.font = UIFont(name: "Avenir-Book", size: 13)
        timeOfActivity.font = .systemFont(ofSize: 13.0, weight: .light)
        timeOfActivity.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeOfActivity)
        
        //Свойства
        properties = UILabel()
        properties.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        properties.font = UIFont(name: "Avenir-Book", size: 17)
        properties.font = .systemFont(ofSize: 17.0, weight: .light)
        properties.numberOfLines = 2
        properties.sizeToFit()
        properties.lineBreakMode = .byTruncatingTail
        properties.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(properties)
        
        //Лейбл "Спросить"
        lableQuestionButton.image = #imageLiteral(resourceName: "vector")
        lableQuestionButton.tintColor = #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1)
        lableQuestionButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lableQuestionButton)
        
        //Кнопка "Спросить"
        questionButton.text = "Спросить"
        questionButton.textColor = #colorLiteral(red: 1, green: 0.537254902, blue: 0, alpha: 1)
        questionButton.font = .systemFont(ofSize: 15, weight: .medium)
        questionButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(questionButton)
        
        //Констрейнты
        let constraints = [
            // Кострейнты аватарки
            judgePhoto.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            judgePhoto.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 20),
            judgePhoto.widthAnchor.constraint(equalToConstant: 40),
            judgePhoto.heightAnchor.constraint(equalToConstant: 40),
            
            //Кострейнты имени
            judgeName.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 13),
            judgeName.leftAnchor.constraint(equalTo: judgePhoto.rightAnchor, constant: 18),
            
            //Кострейнты Времени активности
            timeOfActivity.topAnchor.constraint(equalTo: judgeName.bottomAnchor, constant: 3),
            timeOfActivity.leftAnchor.constraint(equalTo: judgePhoto.rightAnchor, constant: 16),
            
            //Кострейнты Свойств
            properties.topAnchor.constraint(equalTo: timeOfActivity.bottomAnchor, constant: 1),
            properties.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 75),
            properties.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -32),
            
            //Кострейнты Лейбла "Спросить"
            lableQuestionButton.topAnchor.constraint(equalTo: properties.bottomAnchor, constant: 12.34),
            lableQuestionButton.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 80.67),
            lableQuestionButton.widthAnchor.constraint(equalToConstant: 10.66),
            lableQuestionButton.heightAnchor.constraint(equalToConstant: 10.66),
            
            //Кострейнты Кнопки "Спросить"
            questionButton.topAnchor.constraint(equalTo: properties.bottomAnchor, constant: 10),
            questionButton.leftAnchor.constraint(equalTo: lableQuestionButton.rightAnchor, constant: 16.68)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
