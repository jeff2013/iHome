//
//  StringExtension.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-05.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation

extension String{

    //Get a localized string with explicit comment
    var localized:String{
        //comment can either be self or "" or whatever.
        return NSLocalizedString(self, comment: self)
    }
    
    //Get localized string and put in a comment
    func localized(comment: String) -> String{
        return NSLocalizedString(self, comment: comment)
    }
}
