//
//  LoginController.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-01.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoginController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "purpleGradient.jpg")!)
        usernameTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderWidth = 1.0
        usernameTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func login(_ sender: Any) {
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if fetchUsers(username: username!, password: password!) {
            //trigger next page.
            performSegue(withIdentifier: "loginSegue", sender: nil)
        } else {
            alertUser(title: NSLocalizedString("Login Failed", comment: "Login failed title"), message: NSLocalizedString("Invalid Username/Password", comment: "Login failed message"))
        }
    }
    
    @IBAction func registerNewUser(_ sender: Any) {
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        
        let context = getContext()
        
        if let username = username, let password = password {
            let user = User(context: context)
            user.username = username
            user.password = password
            do {
                try context.save()
                alertUser(title: NSLocalizedString("Registration successful", comment: "Registration successful title"), message: NSLocalizedString("Registration successful!", comment: "Registration successful message"))
            } catch let error as NSError {
                alertUser(title: NSLocalizedString("Registration Failed", comment: "Registration failed title"), message: NSLocalizedString("Please please enter a valid Username and Password", comment: "Please please enter a valid Username and Password"))
                print(error)
            }
        } else {
            alertUser(title: NSLocalizedString("Registration Failed", comment: "Registration failed title"), message: NSLocalizedString("Please please enter a valid Username and Password", comment: "Please please enter a valid Username and Password"))
        }
    }
    
    //verifies that username and password from user is not nil
    //verifies that username and password match up with that is in the db
    //returns bool; true if login successful, false otherwise
    private func verifyLogin(actualUsername: String?, expectedUsername: String, actualPassword: String?, expectedPassword: String) -> Bool {
        return actualUsername != nil && actualPassword != nil && (actualUsername == expectedUsername) && (actualPassword == expectedPassword)
    }
    
    private func fetchUsers(username: String, password: String) -> Bool{
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: getContext())
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try getContext().fetch(fetchRequest)
            var foundUser = false
            result.forEach { user in
                if let expectedUsername = (user as AnyObject).value(forKey: "username") as? String, let expectedPassword = (user as AnyObject).value(forKey: "password") as? String {
                    foundUser = verifyLogin(actualUsername: username, expectedUsername: expectedUsername, actualPassword: password, expectedPassword: expectedPassword)
                }
            }
            return foundUser
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return false
    }
    
    private func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //Calls this function when the tap is recognized.
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
