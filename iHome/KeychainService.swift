//
//  KeychainService.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-08.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import KeychainSwift

class KeychainService{
    static let keychain = KeychainSwift()
    static let tokenKey = "authenticationToken"
    
    class func storeToken(token: String){
        KeychainService.keychain.set(token, forKey: KeychainService.tokenKey)
    }
    
    class func getToken()->String?{
        return KeychainService.keychain.get(KeychainService.tokenKey)
    }
    
    class func deleteToken(){
        KeychainService.keychain.delete(KeychainService.tokenKey)
    }
    
    class func clearKeychain(){
        KeychainService.keychain.clear()
    }
    
}
