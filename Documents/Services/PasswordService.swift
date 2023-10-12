//
//  PasswordService.swift
//  Documents
//
//  Created by Денис Кузьминов on 09.10.2023.
//

import Foundation
import UIKit
import KeychainSwift

//MARK: - Password service protocol

protocol PasswordServiceProtocol {
    func checkPassword(password: String) -> Bool
    func savePassword(password: String)
    func reloadPassword(password: String)
    func startPassword() -> Bool
}



//MARK: - Password service

final class PasswordService: PasswordServiceProtocol {
    
    let keyChain = KeychainSwift()
    
//MARK: - Check password state
    
    func startPassword() -> Bool {
        if keyChain.get("password") != nil {
            return true
        }
        return false
    }
    
//MARK: - Check user password
    
    func checkPassword(password: String) -> Bool {
        let userPassword = keyChain.get("password")
        if password == userPassword {
            return true
        }
        return false
    }
    
//MARK: - Save password
    
    func savePassword(password: String) {
        keyChain.set(password, forKey: "password")
    }
    
//MARK: - Reload password
    
    func reloadPassword(password: String) {
        keyChain.delete("password")
        keyChain.set(password, forKey: "password")
    }
}
