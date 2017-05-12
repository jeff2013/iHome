//
//  DemoDelegateProtocol.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-09.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation

//class means only classes can adopt this protocol
protocol Person: class {
    func getName() -> String
    func getAge() -> Int
}
