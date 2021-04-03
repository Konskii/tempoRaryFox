//
//  MainTabBarController.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 16.10.2020.
//

import UIKit
import EZYGradientView

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(red: 242/255, green: 122/255, blue: 42/255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = .white

        let gradientView = EZYGradientView()
        gradientView.frame = view.bounds
        gradientView.firstColor = UIColor(named: "gradientFromWhite")!
        gradientView.secondColor =  UIColor(named: "gradientToWhite")!
        gradientView.angleº = 30.0
        gradientView.colorRatio = 0.35
        gradientView.fadeIntensity = 1
        gradientView.isBlur = false

        UITabBar.appearance().insertSubview(gradientView, at: 0)
        UITabBar.appearance().barTintColor = UIColor(named: "backgroundBlue")
        let clubsVC = ClubsViewController()
        let clubsVCNav = UINavigationController(rootViewController: clubsVC)
      //  clubsVCNav.navigationBar.barStyle = .default

        clubsVC.tabBarItem.image = UIImage(named: "Clubs")
        clubsVC.tabBarItem.title = "Клубы"

        let tournamentsVC = TournamentsViewController()
        let tournamentsVCNav = UINavigationController(rootViewController: tournamentsVC)

        tournamentsVC.tabBarItem.image = UIImage(named: "Tournaments")
        tournamentsVC.tabBarItem.title = "Турниры"

        let playersVC = GamesViewControllerTest()

        let playersVCNav = UINavigationController(rootViewController: playersVC)

        playersVC.tabBarItem.image = UIImage(named: "Players")
        playersVC.tabBarItem.title = "Игры"

      //  let rulesVC = RulesViewController()
        let rulesVC = ChatsListViewController()
        let rulesVCNav = UINavigationController(rootViewController: rulesVC)
        
        rulesVC.tabBarItem.image = UIImage(systemName: "message")
        
        rulesVC.tabBarItem.title = "Чат"

        let profileVC = ProfileTableViewController()
        let profileVCNav = UINavigationController(rootViewController: profileVC)

        profileVC.tabBarItem.image = UIImage(named: "Profile")
        profileVC.tabBarItem.title = "Профиль"

    //    viewControllers = [tournamentsVCNav, playersVCNav, rulesVCNav, profileVCNav]
     viewControllers = [clubsVCNav, tournamentsVCNav, playersVCNav, rulesVCNav, profileVCNav]
    }
}
