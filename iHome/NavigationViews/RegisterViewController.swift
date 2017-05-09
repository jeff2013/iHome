//
//  RegisterViewController.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-05.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "purpleGradient.jpg")!)
        setupTextViews(textFields: [lastNameTextField, firstNameTextField, usernameTextField, passwordTextField])
        NotificationService().addObserverFor(name: NotificationModel.LightsNotification.getNotification(), object: nil) { (Notification) in
            print("notified")
        }
    }
     
    override func viewWillAppear(_ animated: Bool) {
        print("register appeared")
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func registerUser(_ sender: Any) {
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces)
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces)
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        
        let context = getContext()
        
        if firstName != "" && lastName != "" && username != "" && password != "" {
            let user = User(context: context)
            user.firstName = firstName
            user.lastName = lastName
            user.username = username
            user.password = password
            do {
                try context.save()
                let alertController = UIAlertController(title: "Registration successful".localized, message: "Registration successful!".localized, preferredStyle: .alert)
                 let okAction = UIAlertAction(title: "Ok".localized, style: .cancel, handler: { (action) in
                    self.performSegue(withIdentifier: "registeredSegue", sender: nil)
                 })
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                alertUser(title: "Registration successful".localized, message: "Registration successful!".localized)
            } catch let error as NSError {
                alertUser(title: "Registration Failed".localized, message: "Please enter a valid Username and Password".localized)
                print(error)
            }
        } else {
            alertUser(title: "Registration Failed".localized, message: "Please enter a valid Username and Password".localized)
        }
    }
    
    @IBAction func cancelRegistration(_ sender: Any) {
        replaceRootController(storyBoard: "Main", storyBoardIdentifier: "LoginViewController", duration: 0.3, transition: .transitionCrossDissolve, completion: {})
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
}

// MARK: - RegisterUITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 4 {
            self.view.endEditing(true)
            return false
        }else{
            if let nextTextField = self.view.viewWithTag(textField.tag+1) as? UITextField{
                nextTextField.becomeFirstResponder()
                return true
            }else{
                return false
            }
        }
    }
}
