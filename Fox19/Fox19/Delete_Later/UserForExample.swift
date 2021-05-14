//
//  UserFoExample.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 13.10.2020.
//

import UIKit

struct UserForExample {
    
    var userPhoto: UIImage
    var userName: String
    var location: String
    var statusOfTeam: String
    var score: String
    var status: String
    var aboutPlayer: String
    var clubs: String
    
}

func setUsers() -> [UserForExample] {
    let userImage = UIImage(named: "UserPhoto")
    let status = "Тренер, Игрок"
    let aboutPlayer = "Жизнь - это игра, но гольф это всерьёз"
    let clubs = "Московский Гольф Клуб"
    
    let man = UserForExample(userPhoto: userImage!, userName: "Алексей Толстой", location: "Москва, Cannes", statusOfTeam: "Собираем команду", score: "68", status: status, aboutPlayer: aboutPlayer, clubs: clubs)
    let man2 = UserForExample(userPhoto: userImage!, userName: "Лев Толстой", location: "Москва, Cannes", statusOfTeam: "Собираем команду", score: "68", status: status, aboutPlayer: aboutPlayer, clubs: clubs)
    let man3 = UserForExample(userPhoto: userImage!, userName: "Алексей Толстой", location: "Москва, Cannes", statusOfTeam: "Собираем команду", score: "68", status: status, aboutPlayer: aboutPlayer, clubs: clubs)
    
    return [man, man2, man3, man, man2, man3, man, man2, man3]
}
