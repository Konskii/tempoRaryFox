//
//  KeychainManager.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 28.10.2020.
//

import Foundation

class Keychainmanager {
    
    static var shared = Keychainmanager()
    private init() {}
    
    func getToken(account: String) -> String? {
        var query = keychainQuery(account: account)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status != noErr {
            return nil
        }
        
        guard let item = result as? [String : AnyObject],
              let tokenData = item[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: .utf8) else { return nil }
        
        return token
    }
    
    func saveToken(token: String, account: String) -> Bool {
        guard let tokenData = token.data(using: .utf8) else { return false }
        
        if getToken(account: account) != nil {
            var updateFields = [String: AnyObject]()
            updateFields[kSecValueData as String] = tokenData as AnyObject
            let query = keychainQuery(account: account)
            let status = SecItemUpdate(query as CFDictionary, updateFields as CFDictionary)
            return status == noErr
        }
        
        var query = keychainQuery(account: account)
        query[kSecValueData as String] = tokenData as AnyObject
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == noErr
    }
    
    func deleteToken(account: String) -> Bool {
        //Разобраться почему нужно удалять весь аккаунт!!!
    //    let query = keychainQuery(account: account)
        let query = keychainQuery(account: nil)
        let status = SecItemDelete(query as CFDictionary)
        print("deleteToken \(status)")
        return status == noErr
    }
    
    private func keychainQuery(account: String?) ->  [String : AnyObject] {
        
        let service = "Fox19-2020"
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        query[kSecAttrService as String] = service as AnyObject
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject
        }
      //  query[kSecAttrAccount as String] = account as AnyObject
        return query
    }
    
}
