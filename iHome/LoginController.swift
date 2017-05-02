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
    @IBOutlet var registerButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "purpleGradient.jpg")!)
        usernameTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func login(_ sender: Any) {
        let username:String? = usernameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let password:String? = passwordTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        let users = fetchUsers()
        var foundUser = false
        
        users.forEach { user in
            let expectedUsername:String = (user as AnyObject).value(forKey: NSLocalizedString("Username", comment: "The username placeholder")) as! String
            let expectedPassword:String = (user as AnyObject).value(forKey: NSLocalizedString("Password", comment: "Password placeholder")) as! String
            if verifyLogin(actualUsername: username, expectedUsername: expectedUsername, actualPassword: password, expectedPassword: expectedPassword){
                foundUser = true
            }
        }
        
        if(foundUser){
            //trigger next page.
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }else{
            alertUser(title: NSLocalizedString("Login Failed", comment: "Login failed title"), message: NSLocalizedString("Invalid Username/Password", comment: "Login failed message"))
        }
    }
    
    @IBAction func registerNewUser(_ sender: Any) {
        let username:String? = usernameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let password:String? = passwordTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        let context = getContext()
        
        if let username = username, let password = password{
            let user = User(context: context)
            user.username = username
            user.password = password
            do{
                try context.save()
                alertUser(title: NSLocalizedString("Registration successful", comment: "Registration successful title"), message: NSLocalizedString("Registration successful!", comment: "Registration successful message"))
            }catch let error as NSError{
                alertUser(title: NSLocalizedString("Registration Failed", comment: "Registration failed title"), message: NSLocalizedString("Please please enter a valid Username and Password", comment: "Please please enter a valid Username and Password"))
                print(error)
            }
        }else{
            alertUser(title: NSLocalizedString("Registration Failed", comment: "Registration failed title"), message: NSLocalizedString("Please please enter a valid Username and Password", comment: "Please please enter a valid Username and Password"))
        }
    }
    
    //verifies that username and password from user is not nil
    //verifies that username and password match up with that is in the db
    //returns bool; true if login successful, false otherwise
    private func verifyLogin(actualUsername: String?, expectedUsername: String, actualPassword: String?, expectedPassword: String) -> Bool{
        return actualUsername != nil && actualPassword != nil && (actualUsername == expectedUsername) && (actualPassword == expectedPassword)
    }
    
    private func fetchUsers() -> [Any]{
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: getContext())
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try getContext().fetch(fetchRequest)
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
    
    private func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func alertUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss"), style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Calls this function when the tap is recognized.
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
