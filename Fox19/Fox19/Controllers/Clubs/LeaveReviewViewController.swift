//
//  LeaveReviewViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 11.03.2021.
//

import UIKit
import Cosmos

class LeaveReviewViewController: UIViewController {
    
    private let textViewLenght = 200
    
    private let bgView = UIView()
    private let mainView = UIView()
    private let countLenghtLable = UILabel()
    private let myTextView = UITextView()
    private let fieldRating = CosmosView()
    private let infraRating = CosmosView()
    private let serviceRating = CosmosView()
    private let sendButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    var clubId: Int!
    var dismissClosure: ((Review) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundVeiw()
        setupMainView()
    }
}

//MARK:- Setupe elements
extension LeaveReviewViewController {
    private func setupBackgroundVeiw() {
        bgView.backgroundColor = .darkGray
        bgView.alpha = 0.5
        view.addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: view.topAnchor),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeTapGesture(_:)))
        bgView.addGestureRecognizer(closeTap)
    }
    
    private func setupMainView() {
        mainView.backgroundColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
        mainView.layer.cornerRadius = 6
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            mainView.widthAnchor.constraint(equalToConstant: 300),
            mainView.heightAnchor.constraint(equalToConstant: 380)
        ])
        setupCountLabel()
        setupTextField()
        setupRatingStars()
        setupButtonStack()
    }
    
    private func setupCountLabel() {
        countLenghtLable.text = "Доступно символов: 0/\(textViewLenght)"
        countLenghtLable.font = UIFont(name: "Avenir-Medium", size: 11)
        countLenghtLable.textColor = .lightGray
        mainView.addSubview(countLenghtLable)
        countLenghtLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLenghtLable.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 5),
            countLenghtLable.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupTextField() {
        myTextView.delegate = self
        myTextView.font = UIFont(name: "Avenir-Light", size: 15)
        myTextView.layer.cornerRadius = 6
        myTextView.layer.borderWidth = 1.5
        myTextView.layer.borderColor = UIColor.lightGray.cgColor
        myTextView.becomeFirstResponder()
        myTextView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(myTextView)
        NSLayoutConstraint.activate([
            myTextView.topAnchor.constraint(equalTo: countLenghtLable.bottomAnchor, constant: 3),
            myTextView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            myTextView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            myTextView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func setupRatingStars() {
        getNeeditStars(starsView: fieldRating,
                       topAnchorEqualTo: myTextView,
                       labelText: "Оценка поля")
        getNeeditStars(starsView: infraRating,
                       topAnchorEqualTo: fieldRating,
                       labelText: "Инфраструктура")
        
        getNeeditStars(starsView: serviceRating,
                       topAnchorEqualTo: infraRating,
                       labelText: "Сервис")
    }
    
    private func getNeeditStars(starsView: CosmosView, topAnchorEqualTo: UIView, labelText: String) {
        let label = UILabel(text: labelText,
                            font: UIFont(name: "Avenir-Light", size: 15),
                            textColor: .gray)
        label.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(label)
        
        starsView.settings.emptyImage = UIImage(named: "emptyStar")
        starsView.settings.filledImage = UIImage(named: "filledStar")
        starsView.settings.starSize = 22
        starsView.settings.fillMode = .full
        starsView.rating = 0
        starsView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(starsView)
        NSLayoutConstraint.activate([
            starsView.topAnchor.constraint(equalTo: topAnchorEqualTo.bottomAnchor, constant: 10),
            starsView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 45),
            label.centerYAnchor.constraint(equalTo: starsView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10)
        ])
    }
    
    private func setupButtonStack() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.addArrangedSubview(sendButton)
        stack.addArrangedSubview(cancelButton)
        stack.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: serviceRating.bottomAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10)
        ])
        setupButtons()
    }
    
    private func setupButtons() {
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.layer.cornerRadius = 6
        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = UIColor.lightGray.cgColor
        sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.layer.cornerRadius = 6
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.lightGray.cgColor
        cancelButton.addTarget(self, action: #selector(canselAction), for: .touchUpInside)
    }
    
    @objc private func closeTapGesture (_ recognizer: UITapGestureRecognizer) {
        myTextView.resignFirstResponder()
    }
    
    @objc private func sendAction() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let id = clubId else { return }
        let review = PostReview(description: myTextView.text,
                                fieldRate: Float(fieldRating.rating),
                                infraRate: Float(infraRating.rating),
                                serviceRate: Float(serviceRating.rating))
        
        ClubsNetworkManager.shared.postReview(for: number, clubId: id, review: review) { (result) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    
                    self.dismiss(animated: true) {
                        self.dismissClosure?(result)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func canselAction() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LeaveReviewViewController: UITextViewDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    func textViewDidChange(_ textView: UITextView) {
        countLenghtLable.text = "Доступно символов: \(textView.text.count)/\(textViewLenght)"
        if textView.text.count == 200 {
            textView.text.removeLast()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        myTextView.resignFirstResponder()
    }
}
