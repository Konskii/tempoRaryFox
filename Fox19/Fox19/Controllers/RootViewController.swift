//
//  RootViewController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 31.10.2020.
//

import UIKit

class RootViewController: UIViewController {
    private var current: UIViewController
    
    init() {
        self.current = UINavigationController(rootViewController: StartViewController())
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func showMainTabBarScreen() {
        let new = MainTabBarController()
        animateTransition(to: new)
    }
    
    func showStartScreen() {
        let new = UINavigationController(rootViewController: StartViewController())
        animateTransition(to: new)
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
             self.current = new
             completion?()
        }
    }
    
    private func animateTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
       new.view.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParent: nil)
        addChild(new)
       transition(from: current, to: new, duration: 0.3, options: [], animations: {
          new.view.frame = self.view.bounds
       }) { completed in
        self.current.removeFromParent()
        new.didMove(toParent: self)
          self.current = new
          completion?()
       }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
