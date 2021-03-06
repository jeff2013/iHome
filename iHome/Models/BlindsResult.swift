//
//  BlindsResultModel.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-09.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import ObjectMapper

class BlindsResult: Mappable {
    var lightName: String?
    var toggle: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        lightName <- map["lightName"]
        toggle <- map["toggle"]
    }
}
