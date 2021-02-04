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
    private let titleColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
    private var messages: [MMessage] = []
    private var currentUser: User
    private var friendUser: User
    private var chatId: Int = 0
    
    init(currentUser: User, friendUser: User) {
        self.currentUser = currentUser
        self.friendUser = friendUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributesGray: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "avenir", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        navigationItem.title = currentUser.name?.uppercased()
        navigationController?.navigationBar.titleTextAttributes = attributesGray
       navigationController?.navigationBar.barTintColor =  titleColor
//        navigationController?.navigationBar.shadowImage = UIImage()
    //    navigationController?.navigationBar.backgroundColor = titleColor
        
        configureMessageInputBar()
        messageInputBar.delegate = self
        messagesCollectionView.backgroundColor = .white
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        getChatId()
        openSocketConnection()
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
        ChatNetworkManager.shared.getChatWithFriend(token: token, friendId: friendUser.id ?? 0) { (result) in
            switch result {
            case .success(let id):
             //   print(id)
                self.chatId = id
                ChatNetworkManager.shared.getAllMessagesWithFriend(token: token, chatId: id) { (result) in
                    switch result {
                    case .success(let chats):
                       // print(chats.results.count)
                      //  print(chats.results.first)
                        for chat in chats.results {
                            self.messages.append(MMessage(chat: chat))
                        }
                        DispatchQueue.main.async {
                            self.messagesCollectionView.reloadData()
                            self.messagesCollectionView.scrollToBottom()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
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
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        ChatNetworkManager.shared.createNewMessage(token: token,
                                                   chatId: chatId,
                                                   text: text) { (result) in
            switch result {
            
            case .success(let message):
                DispatchQueue.main.async {
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


extension ChatViewController: URLSessionWebSocketDelegate {
    func openSocketConnection() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        let myUrl = "ws://213.159.209.245/ws?access_token=\(token)"
     //   let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: OperationQueue())
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: nil)
        
      //  session.delegate = self
        let webSocketTask = session.webSocketTask(with: URL(string: myUrl)!)
        webSocketTask.resume()
        readMessage(webSocketTask: webSocketTask)
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
                  //  print("Received text message: \(text)")
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
