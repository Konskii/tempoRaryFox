//
//  ChampDetailFooter.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 29.11.2020.
//

import UIKit

class ChampDetailFooter: UIView {
    
    let joinToChampButton = UIButton(type: .system)
    var joinButtonTappedDelegate: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image = UIImage(named: "joinToChamp")?.withRenderingMode(.alwaysOriginal)
        joinToChampButton.setImage(image, for: .normal)
        joinToChampButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        joinToChampButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(joinToChampButton)
        NSLayoutConstraint.activate([
            joinToChampButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            joinToChampButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc func joinButtonTapped() {
        print("JoinButtonTappet")
        joinButtonTappedDelegate?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
