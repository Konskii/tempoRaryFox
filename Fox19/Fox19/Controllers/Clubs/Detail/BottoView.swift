//
//  BottoView.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 22.10.2020.
//

import UIKit
import SafariServices

class BottoView: UIView {
    private let buttonHeight: CGFloat = 30
    var contactLabel: UILabel!
    var addressaLabel: UILabel!
    let phoneButton = UIButton(type: .system)
    let siteButton = UIButton(type: .system)
    
    let stack = UIStackView()
    
    var didTapPhoneButton: ((URL) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contactLabel = UILabel(text: "КОНТАКТЫ",
                               font: .avenir(fontSize: 17),
                               textColor: .black)
        addressaLabel = UILabel(text: "адресс:",
                               font: .avenir(fontSize: 15),
                               textColor: .black)
        addressaLabel.numberOfLines = 0
        

        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        siteButton.translatesAutoresizingMaskIntoConstraints = false
        phoneButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        siteButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        siteButton.addTarget(self, action: #selector(openSafari), for: .touchUpInside)
        phoneButton.addTarget(self, action: #selector(callNumber), for: .touchUpInside)

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        
        stack.axis = .vertical
        stack.spacing = 10
        
        stack.addArrangedSubview(contactLabel)
        stack.addArrangedSubview(addressaLabel)
        stack.addArrangedSubview(phoneButton)
        stack.addArrangedSubview(siteButton)
        
    }
    
    @objc private func openSafari() {
        guard let site = siteButton.title(for: .normal), let url = URL(string: site) else { return }
        didTapPhoneButton?(url)
    }
    
    @objc private func callNumber() {
        guard let phoneNumber = phoneButton.title(for: .normal)?.withoutSpaces() else { return }
        guard let url = URL(string: "tel://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    func setupBottomView(controllerWidth width: CGFloat, club: Club) -> CGFloat {
        
        addressaLabel.text = "Адресс: \(club.address ?? "")"
        phoneButton.setTitle(club.phone1, for: .normal)
        siteButton.setTitle(club.site, for: .normal)
        
        let widthWithInset = width - 40
        
        let contactLabelHeight = DynamicalLabelSize.height(text: contactLabel.text,
                                          font: contactLabel.font,
                                          width: widthWithInset)
        
        let addressaLabelHeight = DynamicalLabelSize.height(text: addressaLabel.text,
                                          font: addressaLabel.font,
                                          width: widthWithInset)
        
        let height = contactLabelHeight + addressaLabelHeight + buttonHeight + buttonHeight + 3*10
        
        return height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
