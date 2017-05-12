//
//  TextStyleModel.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-09.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import UIKit

//Don't actually need this to be a class but in the future when there are more things in here it would be good to have a class
class Styles {
    
    enum FontStyle {
        case buttonLabels
        case pageTitle
        
        var font: String {
            switch self {
            case .buttonLabels, .pageTitle:
                return "emulogic"
            }
        }
        var fontSize: CGFloat {
            switch self {
            case .buttonLabels:
                return 10
            case .pageTitle:
                return 17
                
            }
        }
    }
}
