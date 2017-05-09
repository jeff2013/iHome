//
//  DemoDelegator.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-09.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation

//Delegator class
class Person {
    
    weak var delegate: PersonProtocol?
    
    init(withDelegate: PersonProtocol) {
        delegate = withDelegate
    }
    
    func printName() {
        if let del = delegate {
            print(del.getName())
        } else {
            print("error")
        }
    }
    
    func printAge() {
        if let del = delegate {
            print(del.getAge())
        } else {
            print("Error with age")
        }
    }
}
