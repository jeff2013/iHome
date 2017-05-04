//
//  AuthModel.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-04.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation

public struct AuthModel{
    var authenticate: Bool
    let username: String?
    let password: String?
    let authenticationToken = "placeholder"
    
    //Not sure if this is the best way to do it but it's clean..
    //If authenticate, pass in a valid username/password
    init(userName:String?, pass: String?){
        authenticate = (userName != nil && pass != nil) ? true : false
        username = userName
        password = pass
    }
}
