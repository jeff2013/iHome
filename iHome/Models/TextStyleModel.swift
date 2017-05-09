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
class TextStyleModel {
    
    enum FontStyle {
        case buttonLabels
        case pageTitle
        
        func getFont() -> UIFont {
            switch self {
                case .buttonLabels:
                    return UIFont(name: "emulogic", size: 10)!
                case .pageTitle:
                    return UIFont(name: "emulogic", size: 17)!
            }
        }
    }
}
