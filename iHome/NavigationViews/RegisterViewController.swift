//
//  RegisterViewController.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-05.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import UIKit
import RealmSwift

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
        NotificationService.addObserver(for: NotificationType.lights.name, object: nil) { (Notification) in
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
        
        if containsValues(for: [firstName!, lastName!, username!, password!]) {
            do {
                let realm = try Realm()
                try realm.write {
                    let newUser = Authentication ()
                    newUser.firstName = firstName!
                    newUser.lastName = lastName!
                    newUser.username = username!
                    newUser.password = password!
                    realm.add(newUser)
                    
                    let alertController = UIAlertController(title: "Registration successful".localized, message: "Registration successful!".localized, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok".localized, style: .cancel, handler: { (action) in
                        self.performSegue(withIdentifier: "registeredSegue", sender: nil)
                    })
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            } catch {
                alertUser(title: "Registration Failed".localized, message: "Please enter a valid Username and Password".localized)
                print(error)
            }
        } else {
            alertUser(title: "Registration Failed".localized, message: "Please enter a valid Username and Password".localized)
        }
    }
    
    func containsValues(for strings: [String]) -> Bool {
        return strings.reduce(true, { (isEmpty, string) -> Bool in
            isEmpty && !string.isEmpty
        })
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
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 4 {
            self.view.endEditing(true)
            return false
        } else {
            if let nextTextField = self.view.viewWithTag(textField.tag+1) as? UITextField {
                nextTextField.becomeFirstResponder()
                return true
            } else {
                return false
            }
        }
    }
}
