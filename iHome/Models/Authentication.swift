//
//  Authentication.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-11.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import RealmSwift

class Authentication: Object {
    dynamic var username: String = ""
    dynamic var password: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
}
