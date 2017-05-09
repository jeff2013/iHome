//
//  UIViewControllerExtension.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-03.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss"), style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //Makes assumption the host viewcontroller implements UITextFieldDelegate
    //Specific setup for input textfields. 
    //Can be extended to take in more inputs.
    func setupTextViews(textFields: [UITextField]) {
        for textField in textFields{
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.white.cgColor
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!.localized, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            textField.delegate = self as? UITextFieldDelegate
        }
    }
    
    func replaceRootController(storyBoard: String, storyBoardIdentifier: String, duration: Double, transition: UIViewAnimationOptions, completion: () -> Void) {
        let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
        let window = UIApplication.shared.delegate?.window!
        let rootViewController = window?.rootViewController

        let viewController = storyboard.instantiateViewController(withIdentifier :storyBoardIdentifier)
        viewController.view.frame = (rootViewController?.view.frame)!
        viewController.view.layoutIfNeeded()
        
        UIView.transition(with: window!, duration: duration, options: transition, animations: {
            window?.rootViewController = viewController
        }, completion: { completed in
            
        })
    }
}
