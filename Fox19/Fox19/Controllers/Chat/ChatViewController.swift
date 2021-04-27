//
//  ChatViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 28.01.2021.
//

import UIKit
import Foundation
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    private let orangeColor = UIColor(red: 242/255, green: 122/255, blue: 42/255, alpha: 1)
    private let titleColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
    private var messages: [MMessage] = []
    private var currentUser: User
    private var friendUser: User
    private var chatId: Int? = nil
    var session: URLSession!
    var webSocketTask: URLSessionWebSocketTask!
    // let image = UIImageView()
    
    init(currentUser: User, friendUser: User, chatId: Int) {
        self.currentUser = currentUser
        self.friendUser = friendUser
        self.chatId = chatId
        super.init(nibName: nil, bundle: nil)
    }
    
    init(currentUser: User, friendUser: User) {
        self.currentUser = currentUser
        self.friendUser = friendUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webSocketTask.cancel(with: .normalClosure, reason: nil)
        print("Its close")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.titleView = navTitleWithImageAndText(for: friendUser)
//        navigationItem.largeTitleDisplayMode = .never
        
        setupNavBar()
        configureMessageInputBar()
        messageInputBar.delegate = self
        messagesCollectionView.backgroundColor = .white
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        getChatId()
        openSocketConnection()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
    }
    
    private func navTitleWithImageAndText(for friendUser: User) -> UIView {
        
        let titleView = UIView()
        
        let label = UILabel()
        label.text = friendUser.name
        label.sizeToFit()
        label.center = titleView.center
        label.textColor = .white
        label.textAlignment = NSTextAlignment.center
        
        let image = UIImageView()
        image.image = UIImage(named: "Avatar")
        
        guard let account = UserDefaults.standard.string(forKey: "number") else { return titleView}
        ClubsNetworkManager.shared.downloadImageForCover(from: friendUser.avatar?.url ?? "", account: account) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    image.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        let imageAspect = CGFloat(2)
        
        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect - 10
        let imageY = label.frame.origin.y - label.frame.size.height / 2
        
        let imageWidth = label.frame.size.height * imageAspect
        let imageHeight = label.frame.size.height * imageAspect
        
        image.layer.cornerRadius = imageWidth / 2
        image.clipsToBounds = true
        image.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        
        image.contentMode = UIView.ContentMode.scaleAspectFill
        
        titleView.addSubview(label)
        titleView.addSubview(image)
        
        titleView.sizeToFit()
        return titleView
        
    }
    
    private func insertNewMessage(message: MMessage) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        //  messages.sort()
        messagesCollectionView.reloadData()
    }
    
    private func getChatId() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        print("Now chatid is \(chatId)")
        if chatId != nil {
            ChatNetworkManager.shared.getAllMessagesWithFriend(token: token, chatId: chatId!) { (result) in
                switch result {
                case .success(let messages):
                    guard let count = messages.results else { return }
                    
                    for chat in count {
                        print("here mistake?")
                        self.messages.append(MMessage(chat: chat))
                    }
                    DispatchQueue.main.async {
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToBottom(animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
//            ChatNetworkManager.shared.getChatWithFriend(token: token, friendId: self.friendUser.id ?? 0) { (result) in
//                switch result {
//                case .success(let id):
//                    DispatchQueue.main.async {
//                        self.chatId = id
//                        self.messagesCollectionView.reloadData()
//                        self.messagesCollectionView.scrollToBottom(animated: true)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
            ChatNetworkManager.shared.getAllMyChats(token: token) { (result) in
                switch result {
                case .success(let chats):
                    guard let count = chats.results?.count else { return }
                    if count == 0 {
                        self.getChat(token: token)
                    } else {
                        for index in 0...count - 1 {
                            let searchIndex = chats.results?[index].users?.firstIndex(of: self.friendUser)
                            if searchIndex != nil {
                                DispatchQueue.main.async {
                                    self.chatId = chats.results?[index].id
                                    self.getChatId()
                                }
                            } else {
                                ChatNetworkManager.shared.getChatWithFriend(token: token, friendId: self.friendUser.id ?? 0) { (result) in
                                    switch result {
                                    case .success(let id):
                                        DispatchQueue.main.async {
                                            self.chatId = id
                                            self.messagesCollectionView.reloadData()
                                            self.messagesCollectionView.scrollToBottom(animated: true)
                                        }
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }

                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getChat(token: String) {
        ChatNetworkManager.shared.getChatWithFriend(token: token, friendId: self.friendUser.id ?? 0) { (result) in
            switch result {
            case .success(let id):
                DispatchQueue.main.async {
                    self.chatId = id
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom(animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


//MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        MSender(user: currentUser)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.item]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
}

//MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        CGSize(width: 0, height: 8)
    }
}

//MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ?  #colorLiteral(red: 0.1764705882, green: 0.2470588235, blue: 0.4, alpha: 1) : .lightGray
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ?  .white : .black
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        guard let chatId = chatId else { return }
        print("Error here")
        ChatNetworkManager.shared.createNewMessage(token: token,
                                                   chatId: chatId,
                                                   text: text) { (result) in
            switch result {
            
            case .success(let message):
                DispatchQueue.main.async {
                    print("or here mistake?")
                    self.insertNewMessage(message: MMessage(chat: message))
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        inputBar.inputTextView.text = ""
    }
}

//MARK: - configureMessageInputBar
extension ChatViewController {
    func configureMessageInputBar() {
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .lightGray
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textColor = .black
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
        
        
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        
        messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSendButton()
    }
    
    func configureSendButton() {
        
        messageInputBar.sendButton.setImage(UIImage(named: "blueMessageIcon"), for: .normal)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -38
    }
    
}

//MARK: - URLSessionWebSocketDelegate
extension ChatViewController: URLSessionWebSocketDelegate {
    func openSocketConnection() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        let myUrl = "ws://213.159.209.245/ws?access_token=\(token)"
        session = URLSession(configuration: .default,
                             delegate: self,
                             delegateQueue: nil)
        
        webSocketTask = session.webSocketTask(with: URL(string: myUrl)!)
        
        webSocketTask.resume()
        readMessage(webSocketTask: webSocketTask)
    }
    
    func closeSocketConnection() {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Its open")
    }
    
    func readMessage(webSocketTask: URLSessionWebSocketTask)  {
        webSocketTask.receive { result in
            switch result {
            case .failure(let error):
                print("Failed to receive message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    let data = text.data(using: .utf8)
                    guard let jsonData = data else { return }
                    do {
                        let mmessage = try JSONDecoder().decode(ResponseFromServer.self, from: jsonData)
                        if mmessage.data.chatId == self.chatId && mmessage.data.userId == self.friendUser.id {
                            DispatchQueue.main.async {
                                self.insertNewMessage(message: MMessage(message: mmessage, friend: self.friendUser))
                                self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToBottom()
                            }
                        }
                    } catch let error {
                        print(error)
                    }
                    
                case .data(let data):
                    print("Received binary message: \(data)")
                @unknown default:
                    fatalError()
                }
                self.readMessage(webSocketTask: webSocketTask)
            }
        }
    }
}


//MARK: - Setup NavBar
extension ChatViewController {
    private func setupNavBar() {
        navigationItem.titleView = navTitleWithImageAndText(for: friendUser)
        navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.tintColor = orangeColor
        navigationController?.navigationBar.barTintColor = .white
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundImage = UIImage(named: "Rectangle")
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Merriweather-Regular", size: 30) ?? UIFont.systemFont(ofSize: 30, weight: .medium)
        ]
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
            
        ]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        let imageMenuButton = UIImage(named: "ColorMenu")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageMenuButton, style: .plain, target: self, action: #selector(makeReport))
        
    }
    @objc func makeReport() {
        let alert = UIAlertController(title: nil, message: "Сообщить о проблеме", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cansel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Пожаловаться", style: .default, handler: nil)
        let hellAction = UIAlertAction(title: "Заблокировать пользователя", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addAction(hellAction)
        present(alert, animated: true, completion: nil)
    }
}
