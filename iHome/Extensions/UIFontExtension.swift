//
//  UIFontExtension.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-10.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
     convenience init(with style: Styles.FontStyle) {
         self.init(name: style.font, size: style.fontSize)!
    }
}
