//
//  BottoView.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 22.10.2020.
//

import UIKit
import SafariServices

class BottoView: UIView {
    
    private let primeColor = UIColor(red: 28/255, green: 44/255, blue: 78/255, alpha: 1)
    private let textColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    private let buttonHeight: CGFloat = 30
    var contactLabel: UILabel!
    var addressaLabel: UILabel!
    lazy var phoneButton = UIButton(title: "Phone",
                               textColor: textColor,
                               imageName: "phone",
                               buttonImageColor: primeColor)

    lazy var siteButton = UIButton(title: "site",
                              textColor: .blue,
                              imageName: "network",
                              buttonImageColor: primeColor)
    let connectButton = UIButton(type: .system)

    
    var didTapSiteButton: ((URL) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contactLabel = UILabel(text: "Адерс и контакты",
                               font: UIFont(name: "Inter-Medium", size: 13),
                               textColor: .black)
        addressaLabel = UILabel(text: "адресс:",
                               font: UIFont(name: "Inter-Regular", size: 13),
                               textColor: .black)
        addressaLabel.numberOfLines = 0
        
        connectButton.setTitle("Связаться с клубом", for: .normal)
        connectButton.titleLabel?.font = UIFont(name: "Inter-Regular", size: 13)
        connectButton.setTitleColor(.white, for: .normal)
        connectButton.backgroundColor = UIColor(red: 242/255, green: 122/255, blue: 42/255, alpha: 1)
        connectButton.layer.cornerRadius = 14
        
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        addressaLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        siteButton.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        
        siteButton.addTarget(self, action: #selector(openSafari), for: .touchUpInside)
        phoneButton.addTarget(self, action: #selector(callNumber), for: .touchUpInside)
        
        addSubview(contactLabel)
        addSubview(addressaLabel)
        addSubview(phoneButton)
        addSubview(siteButton)
        addSubview(connectButton)
        
        NSLayoutConstraint.activate([
            contactLabel.topAnchor.constraint(equalTo: topAnchor),
            contactLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            addressaLabel.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: 10),
            addressaLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            phoneButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            phoneButton.topAnchor.constraint(equalTo: addressaLabel.bottomAnchor, constant: 10),
            phoneButton.heightAnchor.constraint(equalToConstant: 30),
            phoneButton.widthAnchor.constraint(equalToConstant: 165),
            
            siteButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            siteButton.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 15),
            siteButton.heightAnchor.constraint(equalToConstant: 30),
            siteButton.widthAnchor.constraint(equalToConstant: 165),
            
            connectButton.widthAnchor.constraint(equalToConstant: 279),
            connectButton.heightAnchor.constraint(equalToConstant: 48),
            connectButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            connectButton.topAnchor.constraint(equalTo: siteButton.bottomAnchor, constant: 25)
            
        
        ])
        
    }
    
    @objc private func openSafari() {
        guard let site = siteButton.title(for: .normal), let url = URL(string: site) else { return }
        didTapSiteButton?(url)
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
        
        addressaLabel.text = "\(club.address ?? "")"
        phoneButton.setTitle(club.phone1, for: .normal)
        siteButton.setTitle(club.site, for: .normal)
        
        let widthWithInset = width - 40
        
        let contactLabelHeight = DynamicalLabelSize.height(text: contactLabel.text,
                                          font: contactLabel.font,
                                          width: widthWithInset)
        
        let addressaLabelHeight = DynamicalLabelSize.height(text: addressaLabel.text,
                                          font: addressaLabel.font,
                                          width: widthWithInset)
        
        let height = contactLabelHeight + addressaLabelHeight + buttonHeight + buttonHeight + 60 + 48
        
        return height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
