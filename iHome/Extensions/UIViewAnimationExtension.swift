//
//  UIViewAnimationExtension.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-05.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import UIKit


//(withDuration duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions = [], animations: @escaping () -> Swift.Void, completion: ((Bool) -> Swift.Void)? = nil)
extension UIView{
    func zoomIn(scale: CGFloat, duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions = []){
        UIView.animate(withDuration: duration, delay: delay, options: options, animations:{
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { (completed:Bool) -> Void in
            UIView.animate(withDuration: duration, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
