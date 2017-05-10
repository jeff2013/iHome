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
import SnapKit

class LoginController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIView!
    
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "purpleGradient.jpg")!)
        setupTextViews(textFields: [usernameTextField, passwordTextField])
        setupViewConstraints()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    private func setupViewConstraints(){
        view.removeConstraints(view.constraints)
        
        let textBoxSideMargins = CGFloat(26)
        let textBoxHeight = 30
        let titleTopMargin = 60
        let userNameTopMargin = CGFloat(85)
        let usernamePasswordMargin = CGFloat(8)
        
        pageTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(titleTopMargin)
            make.centerX.equalTo(self.view)
        }
        
        usernameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(pageTitleLabel).offset(userNameTopMargin)
            make.leading.equalTo(self.view).offset(textBoxSideMargins)
            make.trailing.equalTo(self.view).offset(-textBoxSideMargins)
            make.height.equalTo(textBoxHeight)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(usernameTextField).offset(usernameTextField.frame.height + usernamePasswordMargin)
            make.leading.equalTo(usernameTextField)
            make.trailing.equalTo(usernameTextField)
            make.height.equalTo(textBoxHeight)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(registerButton).offset(-20)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-25)
        }
    }
    
    @IBAction func login(_ sender: Any) {
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        if !(username?.isEmpty)! && !(password?.isEmpty)! && fetchUsers(username: username!, password: password!) {
            KeychainService.storeToken(token: "tempToken")
            replaceRootController(storyBoard: "Main", storyBoardIdentifier: "SWRevealViewController", duration: 0.3, transition: .transitionFlipFromLeft, completion: {})
        } else {
            alertUser(title: "Login Failed".localized, message: "Invalid Username/Password".localized)
        }
    }
    
    //verifies that username and password from user is not nil
    //verifies that username and password match up with that is in the db
    //returns bool; true if login successful, false otherwise
    //A bit redundant now since we check for nil before this point
    private func verifyLogin(actualUsername: String?, expectedUsername: String, actualPassword: String?, expectedPassword: String) -> Bool {
        return actualUsername != nil && actualPassword != nil && (actualUsername == expectedUsername) && (actualPassword == expectedPassword)
    }
    
    private func fetchUsers(username: String, password: String) -> Bool {
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

    //Calls this function when the tap is recognized.
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("login disappeared")
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    @IBAction func showRegisterPage(_ sender: Any) {
        replaceRootController(storyBoard: "Main", storyBoardIdentifier: "RegisterViewController", duration: 0.3, transition: .transitionCrossDissolve, completion: {})
    }
}

//MARK: - LoginTextFieldDelegate
extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            self.passwordTextField.becomeFirstResponder()
            return true
        }else{
            self.view.endEditing(true)
            return false
        }
    }
}
