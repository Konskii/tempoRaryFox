//
//  CleanChatController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 14.02.2021.
//

import Foundation
import UIKit

class CleanChatController: UIViewController {
    
    private let tableView = UITableView()
    private let friendUser: User
    private let currentUser: User
    private var chatId: Int = 0
    private var messages: ChatMessage!
    
    init(currentUser: User, friendUser: User) {
        self.currentUser = currentUser
        self.friendUser = friendUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load data
        getChatId()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.backgroundColor = .cyan
    }
}


//MARK: - Getting chat data
extension CleanChatController {
    private func getChatId() {
        guard let number = UserDefaults.standard.string(forKey: "number") else { return }
        guard let token = Keychainmanager.shared.getToken(account: number) else { return }
        ChatNetworkManager.shared.getChatWithFriend(token: token, friendId: friendUser.id ?? 0) { (result) in
            switch result {
            case .success(let id):
                self.chatId = id
                ChatNetworkManager.shared.getAllMessagesWithFriend(token: token, chatId: id) { (result) in
                    switch result {
                    case .success(let chats):
                        self.messages = chats
                        DispatchQueue.main.async {
//                            let indexPath = IndexPath(row: self.messages.results.count - 1, section: 0)
//                            self.tableView.reloadData()
//                            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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




//MARK: - For New file

class MessageTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}









struct Message {
  let message: String
  let senderUsername: String
  let messageSender: MessageSender
  
  init(message: String, messageSender: MessageSender, username: String) {
    self.message = message.withoutWhitespace()
    self.messageSender = messageSender
    self.senderUsername = username
  }
}

enum MessageSender {
  case ourself
  case someoneElse
}

