////
////  CanAddCell.swift
////  Fox19
////
////  Created by Калинин Артем Валериевич on 18.11.2020.
////
//
//import Foundation
//import UIKit
//
//
//class CanAddCell: UITableViewCell {
//
//
//    var canAddImage = UIImageView()
//    static let identifire = "CanAddCell"
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    
//    func canAdd() {
//        canAddImage.image = UIImage(named: "canAdd")
//        canAddImage.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(canAddImage)
//
//        let constraints = [
//            canAddImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            canAddImage.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor, constant: 0)
//        ]
//
//        NSLayoutConstraint.activate(constraints)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
