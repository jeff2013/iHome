//
//  DemoDelegator.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-09.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation

//Delegator class
class DemoPerson {
    
    weak var delegate: Person?
    
    init(with delegate: Person) {
        self.delegate = delegate
    }
    
    func printName() {
        if let del = delegate {
            print(del.getName())
        } else {
            print("error")
        }
        print( delegate != nil ? delegate!.getName() : "error" )
    }
    
    func printAge() {
        if let del = delegate {
            print(del.getAge())
        } else {
            print("Error with age")
        }
    }
}
