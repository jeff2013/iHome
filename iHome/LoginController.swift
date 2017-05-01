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
    
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!

    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet var RegisterButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "purpleGradient.jpg")!)
        UsernameTextField.layer.borderColor = UIColor.white.cgColor;
        PasswordTextField.layer.borderColor = UIColor.white.cgColor;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Login(_ sender: Any) {
        let username:String? = UsernameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces);
        let password:String? = PasswordTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces);
        
        let users = fetchUsers();
        var foundUser = false;
        for user in users{
            let expectedUsername:String = (user as AnyObject).value(forKey: "username") as! String;
            let expectedPassword:String = (user as AnyObject).value(forKey: "password") as! String;
            if verifyLogin(actualUsername: username, expectedUsername: expectedUsername, actualPassword: password, expectedPassword: expectedPassword){
                foundUser = true;
            }
        }
        
        if(foundUser){
            //trigger next page.
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }else{
            alertUser(title: "Login Failed", message: "Invalid Username/Password");
        }
    }
    
    @IBAction func RegisterNewUser(_ sender: Any) {
        let username:String? = UsernameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces);
        let password:String? = PasswordTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces);
        
        let context = getContext();
        
        if verifyInput(input: username) && verifyInput(input: password){
            
            let user = User(context: context);
            user.username = username;
            user.password = password;
            
            do{
                try context.save();
                alertUser(title: "Registration Successful", message: "Registration successful!");
            }catch let error as NSError{
                //Registering new users failed
            }
            
        }else{
            alertUser(title: "Registration Failed", message: "Please please enter a valid Username and Password");
            //produce username/password validation message
        }
        
    }
    
    //verifies that username and password from user is not nil
    //verifies that username and password match up with that is in the db
    //returns bool; true if login successful, false otherwise
    func verifyLogin(actualUsername: String?, expectedUsername: String, actualPassword: String?, expectedPassword: String) -> Bool{
        return verifyInput(input: actualUsername) && verifyInput(input: actualPassword) && (actualUsername == expectedUsername) && (actualPassword == expectedPassword);
        
    }
    
    func verifyInput(input:String?)->Bool{
        if let _ = input{
            return true
        }else{
            return false
        }
        
    }
    
    func fetchUsers() -> [Any]{
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: getContext())
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try getContext().fetch(fetchRequest)
            return result;
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return [];
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func alertUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
