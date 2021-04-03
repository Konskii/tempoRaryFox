//
//  SmsResponseModel.swift
//  Fox19
//
//  Created by Артём Скрипкин on 07.11.2020.
//

// MARK: - SMSResponse
struct SMSResponse: Codable {
    let user: UserID
}

// MARK: - User
struct UserID: Codable {
    let id: Int
}
