//
//  DemoDelegate.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-09.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation

class DemoDelegate: PersonProtocol {
    
    var delegator: Person!
    
    init() {
        delegator.delegate = self
    }
    
    func getAge() -> Int {
        return 10
    }
    
    func getName() -> String {
        return "John Smith"
    }
}
