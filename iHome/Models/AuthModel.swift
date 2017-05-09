//
//  AuthModel.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-04.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation

public struct AuthModel {
    let username: String?
    let password: String?
    
    //Not sure if this is the best way to do it but it's clean..
    init(userName:String?, pass: String?){
        username = userName
        password = pass
    }
}

public class Auth {
    static let sharedInstance: Auth = {
        let instance = Auth()
        return instance
    }()
    
    var authModel:AuthModel = AuthModel(userName: nil, pass: nil)
    
    init(){
    }
}
